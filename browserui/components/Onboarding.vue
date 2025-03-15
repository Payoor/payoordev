<template>
  <div class="onboarding">
    <div class="onboarding__top">
      <div v-if="currentview === 'name'" class="onboarding__top--textarea">
        <span class="onboarding__top--back" @click.prevent="moveToPrevious">
          <svg>
            <use v-bind:xlink:href="'/symbol-defs.svg#icon-arrow_back'"></use>
          </svg>
        </span>
        <TypeWriterText :text="'Please tell me your name'" />
      </div>

      <div v-if="currentview === 'phonenumber'" class="onboarding__top--textarea">
        <span class="onboarding__top--back" @click.prevent="moveToPrevious">
          <svg>
            <use v-bind:xlink:href="'/symbol-defs.svg#icon-arrow_back'"></use>
          </svg>
        </span>
        <TypeWriterText :text="'Please give me a reachable phone number'" />
      </div>

      <div v-if="currentview === 'location'" class="onboarding__top--textarea">
        <span class="onboarding__top--back" @click.prevent="moveToPrevious">
          <svg>
            <use v-bind:xlink:href="'/symbol-defs.svg#icon-arrow_back'"></use>
          </svg>
        </span>
        <TypeWriterText :text="'Please give me your location'" />
      </div>
    </div>

    <div class="onboarding__bottom">
      <div class="onboarding__bottom--input" v-if="currentview === 'name'">
        <input
          class="onboarding__input"
          v-model="name"
          placeholder="tell me your name"
          @keyup.enter="movetoNext('name')"
        />
        <span
          class="send-svg"
          @click.stop.prevent="movetoNext('name')"
        >
          <svg>
            <use v-bind:xlink:href="'/symbol-defs.svg#icon-arrow_upward'"></use>
          </svg>
        </span>
      </div>

      <div class="onboarding__bottom--input" v-if="currentview === 'phonenumber'">
        <input
          class="onboarding__input"
          v-model="phonenumber"
          placeholder="enter your phone number"
          @keyup.enter="movetoNext('phonenumber')"
        />
        <span
          class="send-svg"
          @click.stop.prevent="movetoNext('phonenumber')"
        >
          <svg>
            <use v-bind:xlink:href="'/symbol-defs.svg#icon-arrow_upward'"></use>
          </svg>
        </span>
      </div>

      <div class="onboarding__bottom--input" v-if="currentview === 'location'">
        <input
          class="onboarding__input"
          v-model="location"
          placeholder="enter your location"
          @keyup.enter="movetoNext('location')"
        />
        <span
          class="send-svg"
          @click.stop.prevent="movetoNext('location')"
        >
          <svg>
            <use v-bind:xlink:href="'/symbol-defs.svg#icon-arrow_upward'"></use>
          </svg>
        </span>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      name: "",
      email: "",
      phonenumber: "",
      location: "",
      shoppingList: "",
      currentview: "phonenumber",
    };
  },
  methods: {
    movetoNext(currentview) {
      console.log("Current view:", currentview);

      if (currentview === "name" && this.name.length) {
        this.currentview = "phonenumber";
        console.log("Changed to:", this.currentview);
      } else if (currentview === "phonenumber" && this.phonenumber.length) {
        this.currentview = "location";
        console.log("Changed to:", this.currentview);
      } else if (currentview === "location" && this.location.length) {
        // Handle completion of the form
        console.log("Form completed with:", {
          name: this.name,
          phonenumber: this.phonenumber,
          location: this.location,
        });
        // You might want to emit an event or call another method here
      }
    },
    moveToPrevious() {
      console.log("Moving back from:", this.currentview);

      if (this.currentview === "name") {
        // Already at the first view, do nothing or handle as needed
        return;
      } else if (this.currentview === "phonenumber") {
        this.currentview = "name";
      } else if (this.currentview === "location") {
        this.currentview = "phonenumber";
      }

      console.log("Changed to:", this.currentview);
    },
  },
};
</script>

<style scoped lang="scss">

</style>
