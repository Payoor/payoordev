<template>
  <div>
    <div class="container">
      <Header :page="'Users'" />
      <div class="container__content">
        <div class="chat">
          <!-- Chat users list -->
          <div class="chat__left chat__section">
            <div class="chat__left--header">Messages</div>
            <div
              v-for="(user, index) in state.users"
              :key="index"
              class="chat__usercard"
              @click="selectUser(user._id)"
            >
              <figure class="chat__right--img userchatcard">
                <div>{{ capitalizeFirstLetter(user.username) }}</div>
              </figure>
              <div class="chat__usercard--right">
                <div class="chat__usercard--username">
                  <span>{{ user.username }}</span>
                </div>
                <div class="chat__usercard--details">
                  <span class="unread" v-if="user.unreadMessages.length"
                    >{{ user.unreadMessages.length }}
                    {{
                      user.unreadMessages.length > 1
                        ? "unread Messages"
                        : "unread Message"
                    }}</span
                  >
                </div>
              </div>
            </div>
          </div>

          <!-- Chat conversation -->
          <div class="chat__right chat__section" v-if="state.clickedUser">
            <div class="chat__right--header">
              <figure class="chat__right--img" v-if="state.clickedUser.username">
                <div>{{ capitalizeFirstLetter(state.clickedUser.username) }}</div>
              </figure>
              <div class="chat__right--user" v-if="state.clickedUser.username">
                <div class="chat__right--name">
                  <span>{{ state.clickedUser.username }}</span>
                  <span>{{ state.clickedUser.phoneNumber }}</span>
                  <span class="chat__right--onlinestate"></span>
                </div>
                <div class="chat__right--typing" v-if="state.isTyping">
                  <span>{{ typingUser }} is typing...</span>
                </div>
              </div>
            </div>

            <div class="chat__right--body" ref="chatContainer">
              <div v-for="(msg, index) in state.messages" :key="index">
                <Chatbubble
                  :key="index"
                  :username="msg.user.username"
                  :isAdmin="msg.isAdmin"
                  :message="msg.content"
                />
              </div>
            </div>

            <div class="chat__messagebox">
              <div class="chat__messagebox--msg">
                <textarea
                  ref="textarea"
                  @input="autoGrow"
                  v-model="state.textareaMsg"
                  :style="{ maxHeight: state.maxHeight + 'px' }"
                  @keydown="handleTyping"
                  placeholder="Start typing..."
                ></textarea>

                <button class="chat__messagebox--send" @click="sendMessage">Send</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, reactive, onMounted, computed, onUpdated } from "vue";
import io from "socket.io-client"; // Ensure correct import

const serverUrl = `https://chat.payoor.shop`;

export default {
  setup() {
    const textarea = ref(null);
    const chatContainer = ref(null);

    const content = ref("");

    const state = reactive({
      maxHeight: 300,
      textareaMsg: "",
      clickedUser: {},
      users: [],
      messages: [], // Stores messages
      isTyping: false, // Tracks typing status
      typingUser: "", // Tracks who is typing
      token: null,
      socket: null,
    });

    const currentConversation = computed(() => {
      return state.messages.length;
    });

    const autoGrow = () => {
      const el = textarea.value;
      el.style.height = "auto";
      el.style.height = el.scrollHeight + "px";

      if (el.scrollHeight > 300) {
        el.style.height = "300px";
        el.style.overflowY = "auto";
      } else {
        el.style.overflowY = "scroll";
      }
    };

    const sendMessage = () => {
      const token = localStorage.getItem("adminToken");

      const msgVal = {
        content: state.textareaMsg,
        isUser: false,
        isAdmin: true,
        isLoggedIn: true,
        timestamp: new Date().toISOString(),
        userid: state.clickedUser._id,
        user: {
          username: "Payoor Admin",
        },
      };

      if (msgVal.content.trim() !== "") {
        state.messages.push({
          content: msgVal.content,
          isAdmin: msgVal.isAdmin,
          user: {
            username: msgVal.user.username,
          },
        });

        fetch(`${serverUrl}/admin/message`, {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "x-auth": token, // This is where we include the token for adminAuth middleware
          },
          body: JSON.stringify(msgVal),
        })
          .then((response) => response.json())
          .then((data) => {
            console.log("Success:", data);
          })
          .catch((error) => {
            console.error("Error:", error);
          });

        scrollToBottom();

        state.textareaMsg = "";
      }
    };

    const receiveMessage = (msg) => {
      const msgVal = {
        content: msg.content,
        isUser: true,
        isAdmin: false,
        isLoggedIn: true,
        timestamp: new Date().toISOString(),
        current_userid: msg.userid,
        user: {
          username: msg.username,
        },
      };

      state.messages.push({
        content: msgVal.content,
        isAdmin: msgVal.isAdmin,
        user: {
          username: msgVal.user.username,
        },
      });

      scrollToBottom();
    };

    const capitalizeFirstLetter = (str) => {
      return str ? str.split("")[0].toUpperCase() : "";
    };

    const scrollToBottom = () => {
      if (chatContainer.value) {
        chatContainer.value.scrollTop = chatContainer.value.scrollHeight;
      }
    };

    const getUsers = async () => {
      const token = localStorage.getItem("adminToken");

      fetch(`${serverUrl}/admin/getusers`, {
        method: "GET", // or 'POST', 'PUT', etc. depending on your needs
        headers: {
          "Content-Type": "application/json",
          "x-auth": token, // This is where we include the token for adminAuth middleware
        },
      })
        .then((response) => response.json()) // assuming the server responds with JSON
        .then((data) => {
          //console.log(data);
          state.users = [...state.users, ...data];

          //console.log(state.users, "yello");

          //state.clickedUser = state.users[0];

          console.log(state.users, state.clickedUser);
        })
        .catch((error) => console.error("Error:", error));
    };

    const getUserUnreadState = async (userid) => {
      const token = localStorage.getItem("adminToken");

      fetch(`${serverUrl}/admin/getuserunreadstate?userid=${userid}`, {
        method: "GET", // or 'POST', 'PUT', etc. depending on your needs
        headers: {
          "Content-Type": "application/json",
          "x-auth": token, // This is where we include the token for adminAuth middleware
        },
      })
        .then((response) => response.json())
        .then((data) => {
          const { unreadMessages, userid } = data;

          setUserUnreadState(unreadMessages, userid);
        })
        .catch((error) => console.error("Error:", error));
    };

    const setUserUnreadState = (unreadMessages, userid) => {
      const userIndex = state.users.findIndex((user) => `${user._id}` === `${userid}`);

      const updatedUser = {
        ...state.users[userIndex],
        unreadMessages: Array.isArray(unreadMessages) ? unreadMessages : [],
      };

      const updatedUsers = [
        ...state.users.slice(0, userIndex),
        updatedUser,
        ...state.users.slice(userIndex + 1),
      ];

      state.users = updatedUsers;
    };

    const selectUser = (id) => {
      state.clickedUser = state.users.find((user) => user._id === id);

      setMessagesRead(id);

      getConversation(id);
    };

    const setMessagesRead = async (id) => {
      const token = localStorage.getItem("adminToken");

      setUserUnreadState([], id);

      fetch(`${serverUrl}/admin/setmessagesread?userid=${id}`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "x-auth": token, // This is where we include the token for adminAuth middleware
        },
      })
        .then((response) => response.json())
        .then((data) => {})
        .catch((error) => console.error("Error:", error));
    };

    const sanitizeId = (id) => {
      return id.replace(/[^\w\s]/gi, ""); // Example: removes special characters
    };

    const getConversation = (id) => {
      const token = localStorage.getItem("adminToken");

      fetch(`${serverUrl}/admin/getconversation?id=${id}`, {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
          "x-auth": token, // This is where we include the token for adminAuth middleware
        },
      })
        .then((response) => response.json())
        .then((data) => {
          state.messages = data.conversation;
        })
        .catch((error) => console.error("Error:", error));
    };

    // Emit typing event to the server
    const handleTyping = () => {
      state.socket.emit("typing");
    };

    // Listen for events from the server
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

      state.socket.on("newmessage", (data) => {
        const { content, isUser, timestamp, username, userid } = data.msg;

        //console.log(content, isUser, timestamp, username, userid);

        if (state.clickedUser._id && `${state.clickedUser._id}` === `${userid}`) {
          receiveMessage({ content, username, userid });

          setMessagesRead(`${userid}`);
        }
      });

      state.socket.on("updateunread", (data) => {
        const { userid } = data;

        getUserUnreadState(userid);
      });

      state.socket.on("user_typing", (data) => {
        state.isTyping = true;
        state.typingUser = data.user;

        setTimeout(() => {
          state.isTyping = false;
        }, 3000);
      });

      state.socket.emit("isAdminOnline");

      getUsers();

      scrollToBottom();
    });

    onUpdated(() => {
      scrollToBottom();
    });

    return {
      textarea,
      content,
      autoGrow,
      sendMessage,
      handleTyping,
      selectUser,
      capitalizeFirstLetter,
      chatContainer,
      state,
    };
  },
};
</script>
