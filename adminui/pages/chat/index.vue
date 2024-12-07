<template>
  <DefaultLayout :page-text="'Chats'">
    <div class="chat__container">
      <div class="chat__sidebar">
        <div class="sidebar__header">
          <h2>Messages</h2>
        </div>

        <div class="users__list">
          <UserCard 
            v-for="user in users"
            :user="user"
            :key="user._id"
            :class="{ active: activeUser && activeUser._id === user._id }"
            @selectuser="selectUser(user)"
          />
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
          <div class="chats" v-if="activeUser">
            <MessageBubble 
              :sender-type="senderType.ADMIN" 
              :message="'Lorem ipsum dolor sit amet consectetur adipisicing elit. Minus eligendi fugiat possimus asperiores eveniet sed dolorem commodi excepturi'"
            />

            <MessageBubble 
              :sender-type="senderType.USER" 
              :message="'veniam alias consectetur incidunt corrupti voluptates, culpa iure, quam exercitationem, vero maxime.'"
            />
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
              v-model="state.textareaMsg"
              placeholder="Start typing..."
            ></textarea>

            <button>
              <SendIcon />
            </button>
          </div>
        </div>
      </div>
    </div>
  </DefaultLayout>
</template>

<script>
import { reactive, ref } from "vue";
import Default from "../../layouts/Default.vue";
import SendIcon from "../../components/icons/SendIcon.vue";
import { getUsers, getUserTransactions, getUserOrders } from "../../api";

export default {
  components: {
    DefaultLayout: Default,
    SendIcon,
  },

  data() {
    return {
      users: [],
      selectedUserId: undefined,
      activeTab: 'Chats',
      activeUser: null,
      userTransactions: null,
      userOrders: null,
      hasOrders: false,
      hasTransactions: false,
    }
  },

  methods: {
    getUsers,
    getUserTransactions,
    getUserOrders,
    fetchUsers() {
      this.getUsers()
        .then((response) => {
          this.users = response.data.users;
          // console.log(this.users);
        })
        .catch((error) => {
          console.log(error.response.data);
        });
    },

    fetchUserTransactions() {
      this.getUserTransactions(this.activeUser._id).then((res) => {
        this.userTransactions = res.data.transactions;
        this.hasTransactions = this.userTransactions.length > 0 ? true : false;
      }).catch(error => console.log(error.response.data))
    },

    fetchUserOrders() {
      this.getUserOrders(this.activeUser._id).then((res) => {
        this.userOrders = res.data.orders;
        this.hasOrders = this.userOrders.length > 0 ? true : false;
      }).catch(error => console.log(error.response.data))
    },

    selectUser(user) {
      this.activeUser = user;
      this.switchTab(this.activeTab ?? "Chats");
    },

    switchTab(tab) {
      this.activeTab = tab;
      switch (this.activeTab) {
        case "Chats":
          return;
      
        case "Orders":
          return this.fetchUserOrders();

        case "Transactions":
          return this.fetchUserTransactions();
        
        default:
          return;
      }
    },
  },

  mounted() {
    this.fetchUsers();
  },

  setup() {
    const textarea = ref(null);
    const state = reactive({
      maxHeight: 200,
      textareaMsg: "",
      clickedUser: {},
      users: [],
      messages: [], // Stores messages
      isTyping: false, // Tracks typing status
      typingUser: "", // Tracks who is typing
      // token: null,
      // socket: null,
    });

    const senderType = {
      USER: "user",
      ADMIN: "admin",
    };

    const autoGrow = () => {
      const el = textarea.value;
      el.style.height = "auto";
      el.style.height = el.scrollHeight + "px";

      if (el.scrollHeight > 200) {
        el.style.height = "200px";
        el.style.overflowY = "auto";
      } else {
        el.style.overflowY = "scroll";
      }
    };

    return {
      textarea,
      state,
      autoGrow,
      senderType,
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

  .transactions, .orders {
    margin-top: 60px;
    flex-grow: 1;
    overflow-y: auto;
    padding: 1rem;
    color: rgba($white, 0.7);
    font-size: 0.8rem;
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
    
    .empty-state {
      border: 2px solid rgb(47, 47, 47);
      border-radius: 0.5rem;
      background-color: rgb(32, 32, 32);
      padding: 2rem 1rem;
      text-align: center;
    }
  }
</style>
