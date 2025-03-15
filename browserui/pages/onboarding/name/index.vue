<template>
  <div>
    <Header />

    <div class="onboarding">
      <div class="onboarding__top">
        <div class="onboarding__top--textarea">
          <TypeWriterText :text="'Hello, please let me know your name'" />
        </div>
      </div>

      <div class="onboarding__bottom">
        <div class="onboarding__bottom--input">
          <input class="onboarding__input" v-model="name" placeholder="Your name" />
          <span
            class="send-svg"
            :class="{
              disabled: !name.length || name === null,
            }"
            @click="moveToNext"
          >
            <svg>
              <use v-bind:xlink:href="'/symbol-defs.svg#icon-arrow_upward'"></use>
            </svg>
          </span>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      name: "",
    };
  },
  computed: {
    email() {
      return this.$route.query.email;
    },
  },
  methods: {
    moveToNext() {
      if (!this.name.length || this.name === null) {
        return;
      }

      this.$router.push({
        path: "/onboarding/phonenumber",
        query: {
          email: this.email,
          name: this.name,
        },
      });
    },
  },
};
</script>
