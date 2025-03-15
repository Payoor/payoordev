<template>
  <div class="">
    <div v-for="(units, index) in items" :key="index">
      <div v-for="(cartitem, unitindex) in returnunits(units)" :key="unitindex">
        <CartItem :item="cartitem" :checkout="checkout" />
      </div>
    </div>
  </div>
</template>

<script>
import { mapState } from "vuex";

export default {
  props: ["checkout"],
  data() {
    return {
      items: [],
    };
  },
  computed: {
    ...mapState("cart", {
      cart: (state) => state.items,
    }),
  },
  mounted() {
    this.getitems();
  },
  methods: {
    getitems() {
      const cart = this.cart;
      let items = [];

      Object.keys(cart).forEach((key) => {
        console.log(cart[key].units, "cart[key].units]");
        items = [...items, ...[cart[key].units]];
      });

      console.log(items, "items here");
      this.items = items;
    },
    returnunits(units) {
      const items = [];
      Object.keys(units).forEach((key) => {
        items.push(units[key]);
      });

      console.log(items, "check the items here");

      return items;
    },
  },
};
</script>

<style scoped lang="scss"></style>
