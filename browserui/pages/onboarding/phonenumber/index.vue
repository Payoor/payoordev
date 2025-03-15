<template>
  <div>
    <Header />

    <div class="onboarding">
      <div class="onboarding__top">
        <div class="onboarding__top--textarea">
          <span class="onboarding__top--back">
            <svg>
              <use v-bind:xlink:href="'/symbol-defs.svg#icon-arrow_back'"></use>
            </svg>
          </span>
          <TypeWriterText :text="'Please give me your phone number'" />
        </div>
      </div>

      <div class="onboarding__bottom">
        <div class="onboarding__bottom--input">
          <input
            class="onboarding__input"
            v-model="phonenumber"
            placeholder="Valid phone number"
          />
          <span
            class="send-svg"
            :class="{
              disabled: !phonenumber.length || phonenumber === null,
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
      phonenumber: "",
    };
  },
  computed: {
    name() {
      return this.$route.query.name;
    },
    email() {
      return this.$route.query.email;
    },
  },
  methods: {
    moveToNext() {
      if (!this.phonenumber.length || this.phonenumber === null) {
        return;
      }

      this.$router.push({
        path: "/onboarding/address",
        query: {
          email: this.email,
          name: this.name,
          phonenumber: this.phonenumber,
        },
      });
    },
  },
};
</script>
