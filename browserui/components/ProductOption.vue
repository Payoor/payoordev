<template>
  <div>
    <div class="productcard__options--item">
      <div class="productcard__options--itemleft">
        <span class="name">{{ productoption.unit }}</span>
        <span class="price">${{ productoption.price }}</span>
      </div>

      <div class="productcard__options--itemright">
        <button @click="reduceamount">
          <span>
            <svg>
              <use v-bind:xlink:href="'/symbol-defs.svg#icon-minus1'"></use>
            </svg>
          </span>
        </button>

        <span class="amount">{{ amount }}</span>

        <button @click="increaseamount">
          <span>
            <svg>
              <use v-bind:xlink:href="'/symbol-defs.svg#icon-plus'"></use>
            </svg>
          </span>
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState } from "vuex";

export default {
  props: ["productoption", "productname", "productid"],
  data() {
    return {
      amount: 0,
    };
  },
  computed: {
    ...mapState("cart", {
      cart: (state) => state.items,
      cartTotal: (state) => state.total,
    }),
  },
  watch: {
    cart: {
      handler(newValue) {
        const { productoption, productid } = this;
        const existingItem = newValue[productid];
        const unit = productoption.unit;

        if (existingItem) {
          const existingUnit = existingItem.units[unit];

          if (existingUnit) {
            this.amount = existingUnit.quantity;
          } else {
            if (this.amount !== 0) {
              this.amount = 0;
            }
          }
        } else {
          if (this.amount !== 0) {
            this.amount = 0;
          }
        }
      },
      deep: true,
    },
  },
  methods: {
    increaseamount() {
      this.amount = this.amount + 1;

      this.addItem();

      const cartTotal = this.cartTotal + 1;

      this.$store.dispatch("cart/updateTotal", cartTotal);
    },
    reduceamount() {
      if (this.amount === 0) return;

      if (this.amount != 0) {
        this.amount = this.amount - 1;

        this.removeItem();

        const cartTotal = this.cartTotal - 1;

        this.$store.dispatch("cart/updateTotal", cartTotal);
      }
    },
    addItem() {
      const cartitem = {
        id: this.productid,
        name: this.productname,
        unit: this.productoption.unit,
        price: this.productoption.price,
        quantity: this.amount,
      };

      this.$store.dispatch("cart/addItem", cartitem);
    },
    removeItem() {
      const cartitem = {
        id: this.productid,
        name: this.productname,
        unit: this.productoption.unit,
        price: this.productoption.price,
        quantity: this.amount,
      };

      this.$store.dispatch("cart/removeItem", cartitem);
    },
  },
};
</script>
