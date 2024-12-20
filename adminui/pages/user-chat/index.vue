<template>
  <div class="page__container">
    <HeaderText :page-text="'User Chat'" />
    <div>
      <h3>Welcome {{ user?.name ?? '' }}</h3>
    </div>

    <div v-if="isConnected" class="chat__container">
      <div class="chat__box">
        <!-- <div class="topbar"></div> -->
        <div class="chats" ref="chatContainer">
          <div v-for="message, index in messages" :key="index">
            <MessageBubble
              v-if="message._id"
              :viewer-type="'user'" 
              :message="message"
            />
          </div>
          <div v-if="isAdminTyping" class="typing-indicator">
            <em>agent is typing...</em>
          </div>
        </div>

        <div class="chat__input">
          <div class="message__box">
            <textarea
              ref="textarea"
              @input="autoGrow"
              @keydown="handleTyping"
              @keydown.enter="handleKeyDown"
              @blur="handleStopTyping"
              v-model="userMessage"
              :style="{ maxHeight: maxHeight + 'px' }"
              placeholder="Type your message..."
              rows="1"
            ></textarea>
            <button @click="sendMessage">
              <SendIcon />
            </button>
          </div>
        </div>
      </div>
    </div>

  </div>
</template>

<script>
import { ref, onUnmounted, onMounted } from "vue";
import { io } from "socket.io-client";
import SendIcon from "../../components/icons/SendIcon.vue";
import { getUserDetails } from "../../api";
import { onUpdated } from "vue";
import { serverUrl } from "../../api/config";

export default {
  components: {
    SendIcon
  },

  setup() {
    const socket = ref(null);
    const textarea = ref(null);
    const chatContainer = ref(null);
    const maxHeight = ref(150);
    const isConnected = ref(false);
    const messages = ref([]);
    const userMessage = ref("");
    const user = ref(null);
    const isAdminTyping = ref(false);

    const startChat = () => {
      const token = localStorage.getItem("payoor_user_token");
      if (!token) {
        alert("Please log in to start a chat.");
        return;
      }

      socket.value = io(serverUrl, {
        transports: ["websocket"],
        extraHeaders: { Authorization: `Bearer ${token}` },
        auth: { token },
        autoConnect: true,
        reconnection: true,
        reconnectionAttempts: Infinity,
        reconnectionDelay: 1000,
        timeout: 10000,
      });

      socket.value.on("connect", () => {
        isConnected.value = true;
        socket.value.emit("createRoom");
        console.log("Connected to chat server.");
      });

      socket.value.on("receiveMessage", (message) => {
        messages.value.push(message);
        scrollToBottom();
      });

      socket.value.on("adminTyping", () => {
        isAdminTyping.value = true;
      });

      socket.value.on("adminStopTyping", () => {
        isAdminTyping.value = false;
      });

      socket.value.on("disconnect", () => {
        isConnected.value = false;
        console.log("Disconnected from chat server.");
      });
    };

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

      if (userMessage.value.length < 1) {
        handleStopTyping()
      }
    };

    const handleTyping = () => {
      socket.value.emit("userTyping", user.value._id);
    };

    const handleStopTyping = () => {
      socket.value.emit("userStopTyping", user.value._id);
    };

    const handleKeyDown = (e) => {
      if (e.key === "Enter" && !e.shiftKey) {
        e.preventDefault();
        sendMessage();
      }
    };

    const sendMessage = () => {
      if (userMessage.value.trim() === "") return;

      const message = {
        text: userMessage.value,
        clienttimestamp: new Date().toISOString(),
        sender: "user",
        userId: user.value._id
      };
      socket.value.emit("sendMessage", message);
      messages.value.push(message);

      scrollToBottom();

      const textAreaEl = textarea.value;
      textAreaEl.style.height = 'auto';
      userMessage.value = "";
      handleStopTyping();
    };

    const scrollToBottom = () => {
      if (chatContainer.value) {
        chatContainer.value.scrollTop = chatContainer.value.scrollHeight;
      }
    };

    onMounted(() => {
      startChat();
      getUserDetails().then((response) => {
        user.value = response.data.data.user;
      }).catch((error) => console.log(error.response.data));
    });

    onUpdated(() => {
      scrollToBottom();
    });

    onUnmounted(() => {
      if (socket.value) {
        socket.value.disconnect();
      }
    });

    return {
      textarea,
      chatContainer,
      maxHeight,
      isConnected,
      messages,
      userMessage,
      user,
      isAdminTyping,
      startChat,
      autoGrow,
      sendMessage,
      handleTyping,
      handleStopTyping,
      handleKeyDown
    };
  },
}
</script>

<style lang="scss">
  h3, .typing-indicator {
    color: $white;
  }
</style>
