<template>
  <div>
    <div class="searchbody fade-element" @click.stop="closesearch">
      <textarea
        ref="searchTextarea"
        class="searchbody__textarea"
        v-model="content"
        @click.stop="() => {}"
        @keydown="handleKeyDown"
      ></textarea>
    </div>
  </div>
</template>

<script>
import utilsMixin from "@/mixins/utils";

export default {
  mixins: [utilsMixin],
  props: ["closesearch"],
  data() {
    return {
      content: "",
    };
  },
  computed: {
    user_id() {
      return this.$route.query.user;
    },
  },
  methods: {
    handleKeyDown(event) {
      if (event.key === "Enter" && !event.shiftKey && !event.ctrlKey && !event.metaKey) {
        event.preventDefault();
        this.handleEnterKey();
      }
    },
    handleEnterKey() {
      /*this.$router.push({
        path: "/search",
        query: {
          user: this.user_id,
          searchcontent: this.content,
        },
      });*/

      this.pageRouter("/search", {
        user: this.user_id,
        searchcontent: this.content,
      });

      this.closesearch();

      this.$store.dispatch("handlesearch", { query: this.content });
    },
  },
  mounted() {
    this.$refs.searchTextarea.focus();
  },
};
</script>

<style scoped lang="scss">
.searchbody {
  position: fixed;
  top: 0;
  left: 0;
  height: 100vh;
  width: 100vw;
  z-index: 6;
  background: rgba($primary-color, 0.9);

  transition: all 0.1s ease;
  display: flex;
  justify-content: center;
  align-items: center;

  &__textarea {
    outline: none;
    background: rgba($primary-color, 1);
    border: 1px solid $white;
    border-radius: 1rem;
    width: 100rem;
    height: 20rem;
    padding: 3rem;
    color: $white;
    font-size: 2rem;
    resize: none;
  }
}
</style>
