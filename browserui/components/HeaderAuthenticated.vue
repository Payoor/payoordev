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

      <div class="header__menu--item" @click="onOpenOrders">
        <div class="header__menu--itemlabel">
          <span></span>
          <label>My Orders</label>
        </div>
        <div class="header__menu--itemicon">
          <svg>
            <use v-bind:xlink:href="'/symbol-defs.svg#icon-shopping-bag'"></use>
          </svg>
        </div>
      </div>

      <div class="header__menu--item" @click="onOpenCart">
        <span class="header__menu--carttotal" v-if="cartTotal && cartTotal > 0">{{
          cartTotal
        }}</span>
        <div class="header__menu--itemlabel">
          <span></span>
          <label>My Cart</label>
        </div>
        <div class="header__menu--itemicon">
          <figure>
            <img src="@/assets/imgs/payoorcart.png" />
          </figure>
        </div>
      </div>

      <div class="header__menu--item">
        <div class="header__menu--itemlabel">
          <span></span>
          <label>{{ user.name }}</label>
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
import { mapState } from "vuex";

export default {
  props: {
    helpPhoneNumber: {
      type: String,
      required: true,
    },
    openAvailLocations: {
      type: Function,
      required: true,
    },
    opencart: {
      type: Function,
      required: true,
    },
    openorders: {
      type: Function,
      required: true,
    },
  },
  computed: {
    ...mapState({
      jwt: (state) => state.jwt,
      user: (state) => state.user,
    }),
    ...mapState("cart", {
      cartTotal: (state) => state.total,
    }),
  },
  methods: {
    goToHome() {
      this.$router.push("/");
    },
    goToAboutUs() {
      this.$router.push("/aboutus");
    },
    onOpenLocations() {
      this.openAvailLocations();
    },
    onOpenCart() {
      this.opencart();
    },
    onOpenOrders() {
      this.openorders();
    },
  },
};
</script>
