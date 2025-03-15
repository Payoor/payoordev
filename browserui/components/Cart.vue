<template>
  <div>
    <div class="cart">
      <div class="cart__overlay" @click="closecart"></div>
      <div class="cart__container">
        <div class="navigation__top">
          <span class="svg" @click="closecart">
            <svg>
              <use v-bind:xlink:href="'/symbol-defs.svg#icon-arrow_back'"></use>
            </svg>
          </span>
          <h3 class="navigation__h3">Your Cart</h3>
        </div>

        <div class="cart__content">
          <RenderCartItems />
        </div>

        <div class="cart__checkout">
          <button
            class="cart__checkout--button btn btn-checkout-button"
            :disabled="cartTotal === 0"
            :class="{
              disabled: cartTotal === 0,
            }"
            @click="checkoutOrder"
          >
            Checkout
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState } from "vuex";

export default {
  props: ["closecart"],
  computed: {
    ...mapState("cart", {
      cartTotal: (state) => state.total,
    }),
  },
  methods: {
    checkoutOrder() {
      this.$router.push("/checkout");
    },
  },
};
</script>

<style scoped lang="scss">
.cart {
  @include sideviewright;

  &__content {
    height: 100%;
    overflow-x: hidden;
    overflow-y: scroll;
    padding-bottom: 10rem;
  }

  &__checkout {
    position: absolute;
    bottom: 0;
    left: 0;
    width: 100%;
    padding: 2rem;
    background: $white;
  }
}
</style>
