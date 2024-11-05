<template>
  <div class="page__container">
    <div class="page__container-wrapper">
      <HeaderText :pageText="'Users'" />
    </div>

    <div class="chat__container">
      <div class="chat__sidebar">
        <div class="sidebar__header">
          <h2>Messages</h2>
        </div>

        <div class="users__list">
          <UserCard />
          <UserCard class="active" />
          <UserCard />
          <UserCard />
          <UserCard />
        </div>
      </div>

      <div class="chat__box">
        <div class="topbar"></div>

        <!-- conversation box -->
        <div class="chats"></div>
        <!--  -->

        <div class="chat__input">
          <div class="message__box">
            <textarea
              ref="textarea"
              @input="autoGrow"
              v-model="state.textareaMsg"
              @keydown="handleTyping"
              placeholder="Start typing..."
            ></textarea>

            <button>
              <SendIcon />
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { reactive, ref } from "vue";

export default {
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
    };
  },
};
</script>
