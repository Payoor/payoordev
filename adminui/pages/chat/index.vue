<template>
  <DefaultLayout :page-text="'Chats'">
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

export default {
  components: {
    DefaultLayout: Default,
    SendIcon
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
