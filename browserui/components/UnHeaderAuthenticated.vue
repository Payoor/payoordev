<template>
  <div class="header__menu">
    <div class="header__menu--left" @click="goToHome">
      <figure>
        <img src="@/assets/imgs/payoor-white-logo.png" />
      </figure>
    </div>

    <div class="header__menu--right">
      <div class="header__menu--item">
        <div class="header__menu--itemlabel">
          <span>Need Help?</span>
          <label>{{ helpPhoneNumber }}</label>
        </div>
        <div class="header__menu--itemicon">
          <svg>
            <use v-bind:xlink:href="'/symbol-defs.svg#icon-phone'"></use>
          </svg>
        </div>
      </div>

      <div class="header__menu--item" @click="goToAboutUs">
        <div class="header__menu--itemlabel">
          <label>About Us</label>
        </div>
        <div class="header__menu--itemicon">
          <svg>
            <use v-bind:xlink:href="'/symbol-defs.svg#icon-information'"></use>
          </svg>
        </div>
      </div>

      <div class="header__menu--item" @click="onOpenLocations">
        <div class="header__menu--itemlabel">
          <span></span>
          <label>Locations</label>
        </div>
        <div class="header__menu--itemicon">
          <svg>
            <use v-bind:xlink:href="'/symbol-defs.svg#icon-location'"></use>
          </svg>
        </div>
      </div>

      <div class="header__menu--item" @click="onOpenAuthenticator">
        <div class="header__menu--itemlabel">
          <span></span>
          <label>SignUp/Login</label>
        </div>
        <div class="header__menu--itemicon">
          <svg>
            <use v-bind:xlink:href="'/symbol-defs.svg#icon-user'"></use>
          </svg>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import utilsMixin from "@/mixins/utils";

export default {
  mixins: [utilsMixin],
  name: "HeaderMenu",
  props: {
    helpPhoneNumber: {
      type: String,
      required: true,
    },
    openAvailLocations: {
      type: Function,
      required: true,
    },
    openAuthenticator: {
      type: Function,
      required: true,
    },
  },
  methods: {
    goToHome() {
      //this.$router.push("/");
      this.pageRouter("/", {});
    },
    goToAboutUs() {
      //this.$router.push("/aboutus");
      this.pageRouter("/aboutus", {});
    },
    onOpenLocations() {
      this.openAvailLocations();
    },
    onOpenCart() {
      this.opencart();
    },
    onOpenAuthenticator() {
      this.openAuthenticator();
    },
  },
};
</script>
