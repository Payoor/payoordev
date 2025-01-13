<template>
  <DefaultLayout :page-text="'Chats'">
    <div class="chat__container">
      <div class="chat__sidebar">
        <div class="sidebar__header">
          <h2>Messages</h2>
        </div>

        <div class="users__list">
          <template v-if="state.users.length !== 0">
            <UserCard 
              v-for="user, index in state.users"
              :user="user.user"
              :key="index"
              :is-online="user.isOnline"
              :class="{ active: activeUser && activeUser._id === user.user._id }"
              @selectuser="selectUser(user.user)"
            />
          </template>
        </div>
      </div>

      <div class="chat__box">
        <div class="topbar">
          <button
            v-for="tab in ['Chats', 'Orders', 'Transactions']"
            :key="tab"
            :class="{ active: activeTab === tab }"
            :disabled="!activeUser"
            @click="switchTab(tab)"
          >
            {{ tab }}
          </button>
        </div>

        <!-- Chats Tab -->
        <template v-if="activeTab === 'Chats'">
          <!-- conversation box -->
          <div class="chats" v-if="activeUser" ref="chatContainer">
            <div v-for="(msg, index) in state.messages" :key="index">
              <template v-if="shouldDisplayDate(index)">
                <div class="message-date">
                  <p>{{ formatDate(msg.clienttimestamp) }}</p>
                </div> 
              </template>
                      
              <MessageBubble
                v-if="msg._id"
                :viewer-type="'admin'"
                :message="msg"
              />
            </div>
            <div v-if="state.isUserTyping" class="typing-indicator">
              <em>isTyping...</em>
            </div>
          </div>
        </template>

        <!-- Orders Tab -->
        <template v-if="activeTab === 'Orders'">
          <div class="orders">
            <h2>Orders</h2>
            <template v-if="userOrders">
              <OrderCard 
                v-for="(orders, index) in userOrders" 
                :key="index"
                :orders="orders"
              />
            </template>

            <template v-if="!hasOrders">
              <div class="empty-state">
                <em>No Orders</em>
              </div>
            </template>
          </div>
        </template>

        <!-- Transactions Tab -->
        <template v-if="activeTab === 'Transactions'">
          <div class="transactions">
            <h2>Transactions</h2>
            <template v-if="hasTransactions">
              <TransactionCard 
                v-for="(transactions, index) in userTransactions" 
                :key="index"
                :transactions="transactions"
              />
            </template>

            <template v-if="!hasTransactions">
              <div class="empty-state">
                <em>No Transactions</em>
              </div>
            </template>
          </div>
        </template>

        <div class="chat__input" v-if="activeTab === 'Chats' && activeUser">
          <div class="message__box">
            <textarea
              ref="textarea"
              @input="autoGrow"
              @keydown="handleTyping"
              @keydown.enter="handleKeyDown"
              @blur="handleStopTyping"
              v-model="state.textareaMsg"
              :style="{ maxHeight: state.maxHeight + 'px' }"
              placeholder="Start typing..."
              rows="1"
            ></textarea>

            <button @click="sendMessage">
              <SendIcon />
            </button>
          </div>
        </div>
      </div>
    </div>
  </DefaultLayout>
</template>

<script>
import { reactive, ref, onMounted, onUnmounted, computed } from "vue";
import Default from "../../layouts/Default.vue";
import SendIcon from "../../components/icons/SendIcon.vue";
import { getUserTransactions, getUserOrders, getConversation } from "../../api";
import io from "socket.io-client";
import { onUpdated } from "vue";
import { serverUrl } from "../../api/config";

export default {
  components: {
    DefaultLayout: Default,
    SendIcon,
  },

  setup() {
    const textarea = ref(null);
    const chatContainer = ref(null);
    const activeTab = ref('Chats');
    const activeUser = ref(null);
    const userTransactions = ref(null);
    const userOrders = ref(null);
    const hasOrders = ref(false);
    const hasTransactions = ref(false);
    const state = reactive({
      maxHeight: 150,
      textareaMsg: "",
      users: [],
      messages: [], // Stores messages
      isUserTyping: false, // Tracks typing status
      typingUser: "", // Tracks who is typing
      token: null,
      socket: null,
      currentRoom: null,
    });

    const prevMessageDate = computed(() => {
      let prevDate = null;
      if (state.messages.length > 0) {
        for (let i = state.messages.length - 1; i >= 0; i--) {
          if (state.messages[i].clienttimestamp) {
            prevDate = state.messages[i].clienttimestamp;
            break;
          }
        }
      }
      return prevDate;
    })

    const shouldDisplayDate = (index) => {
      if (index === 0) {
        return true; // Always show the date for the first message
      }
      const currentDate = new Date(state.messages[index].clienttimestamp).toDateString();
      const previousDate = new Date(state.messages[index - 1].clienttimestamp).toDateString();
      return currentDate !== previousDate; // Show the date if it is different from the previous message's date
    };

    const formatDate = (date) => {
      const messageDate = new Date(date);
      const now = new Date();

      const isToday = messageDate.toDateString() === now.toDateString();
      const yesterday = new Date(now);
      yesterday.setDate(now.getDate() - 1);
      const isYesterday = messageDate.toDateString() === yesterday.toDateString();

      if (isToday) {
        return "Today";
      } else if (isYesterday) {
        return "Yesterday";
      } else {
        return messageDate.toLocaleDateString();
      }
    }

    const autoGrow = () => {
      const el = textarea.value;
      el.style.height = "auto";
      el.style.height = el.scrollHeight + "px";

      if (el.scrollHeight > 150) {
        el.style.height = "150px";
        el.style.overflowY = "auto";
      } else {
        el.style.overflowY = "scroll";
      }

      if (state.textareaMsg.length < 1) {
        handleStopTyping()
      }
    };

    const scrollToBottom = () => {
      if (chatContainer.value) {
        chatContainer.value.scrollTop = chatContainer.value.scrollHeight;
      }
    };

    const fetchUserTransactions = () => {
      if (activeUser.value) {
        getUserTransactions(activeUser.value._id)
          .then((res) => {
            userTransactions.value = res.data.transactions;
            hasTransactions.value = userTransactions.value.length > 0;
          })
          .catch((error) => {
            console.log(error.response);
            if (error.response.status === 401) {
              localStorage.removeItem('adminToken');
              localStorage.removeItem('adminUsername');
              this.$router.push('/');
            }
          });
      }
    };

    const fetchUserOrders = () => {
      if (activeUser.value) {
        getUserOrders(activeUser.value._id)
          .then((res) => {
            userOrders.value = res.data.orders;
            hasOrders.value = userOrders.value.length > 0;
          })
          .catch((error) => {
            console.log(error.response);
            if (error.response.status === 401) {
              localStorage.removeItem('adminToken');
              localStorage.removeItem('adminUsername');
              this.$router.push('/');
            }
          });
      }
    };

    const selectUser = async(user) => {
      if (state.currentRoom) {
        // Leave the previous room
        state.socket.emit("leaveRoom", state.currentRoom);
        console.log('Admin left room: ' + state.currentRoom)
      }
      activeUser.value = user;
      state.currentRoom = `${user._id}`;

      const conversation = await getConversation(user._id);
      state.messages = conversation.data.data.messages;

      state.socket.emit("joinRoom", {userId: user._id});

      switchTab(activeTab.value || 'Chats');
    };

    const switchTab = (tab) => {
      activeTab.value = tab;
      switch (activeTab.value) {
        case 'Chats':
          return;
        case 'Orders':
          return fetchUserOrders();
        case 'Transactions':
          return fetchUserTransactions();
        default:
          return;
      }
    };

    const sendMessage = () => {
      if (state.textareaMsg.trim() === "") return;

      const message = {
        text: state.textareaMsg,
        clienttimestamp: new Date().toISOString(),
        sender: "admin",
        userId: activeUser.value._id
      };

      state.socket.emit("sendMessage", message);
      state.messages.push(message);

      scrollToBottom();

      //reset the textarea field
      const textAreaEl = textarea.value;
      textAreaEl.style.height = 'auto';
      state.textareaMsg = ""; // Clear the input
      handleStopTyping();
    };

    const handleKeyDown = (e) => {
      if (e.key === "Enter" && !e.shiftKey) {
        e.preventDefault();
        sendMessage();
      }
    };

    const handleTyping = () => {
      state.socket.emit("adminTyping", state.currentRoom);
    };

    const handleStopTyping = () => {
      state.socket.emit("adminStopTyping", state.currentRoom);
    };

    onMounted(() => {
      state.token = localStorage.getItem("adminToken");

      state.socket = io(serverUrl, {
        transports: ["websocket"],
        extraHeaders: { Authorization: `Bearer ${state.token}` },
        auth: { token: state.token, admin: true },
        autoConnect: true,
        reconnection: true,
        reconnectionAttempts: Infinity,
        reconnectionDelay: 1000,
        timeout: 10000,
      });

      state.socket.connect();

      // Listen for change in user list 
      state.socket.on("updateUserList", (data) => {
        state.users = data;
      });

      // Listen for incoming messages
      state.socket.on("receiveMessage", (message) => {
        if (state.currentRoom) {
          state.messages.push(message);
        }
        scrollToBottom();
      });

      // Listen for typing events
      state.socket.on("userTyping", () => {
        state.isUserTyping = true;
      });

      state.socket.on("userStopTyping", () => {
        state.isUserTyping = false;
      });

      scrollToBottom();
    });

    onUpdated(() => {
      scrollToBottom();
    });

    onUnmounted(() => {
      if (state.socket) {
        state.socket.disconnect();
      }
    });

    return {
      state,
      textarea,
      chatContainer,
      activeTab,
      activeUser,
      userTransactions,
      userOrders,
      hasOrders,
      hasTransactions,
      prevMessageDate,
      shouldDisplayDate,
      formatDate,
      autoGrow,
      fetchUserTransactions,
      fetchUserOrders,
      selectUser,
      switchTab,
      sendMessage,
      handleKeyDown,
      handleTyping,
      handleStopTyping,
    };
  },
};
</script>

<style lang="scss" scoped>
  .topbar {
    display: flex;
    gap: 0.25rem;

    button {
      padding: 0.5rem;
      border: none;
      border-radius: 0.25rem;
      background-color: rgb(66, 66, 66);
      color: rgba($white, 0.7);
      font-family: 'Poppins';
      font-size: 0.8rem;
      cursor: pointer;
      transition: .2s;

      &.active {
        background-color: $primary-color;
        color: $white;
      }
    }
  }

  .chats{
    .message-date {
      display: flex;
      justify-content: center;
      margin-block: 1rem; 
      p {
        text-align: center;
        color: rgba($font-color, 0.5);
        font-size: 12px;
        background-color: $grey;
        padding: 0.5rem;
        border-radius: 0.25rem;
      }
    }

    .typing-indicator {
      color: $font-color;
    }
  }

  .transactions, .orders {
    margin-top: 60px;
    flex-grow: 1;
    overflow-y: auto;
    padding: 1rem;
    color: $font-color;
    font-size: 0.8rem;
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
    
    .empty-state {
      border: 2px solid $grey;
      border-radius: 0.5rem;
      box-shadow: 0px 0px 5px -2px #32475c4d;
      background-color: $white;
      padding: 2rem 1rem;
      text-align: center;
    }
  }
</style>
