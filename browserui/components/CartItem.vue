<template>
  <div>
    <div class="cartitem box-shadow" v-if="amount > 0">
      <div class="cartitem__left">
        <div class="cartitem__left--imgarea">
          <figure class="cartitem__left--figure">
            <img
              src="@/assets/imgs/a5048d7f-3eb1-4291-80dd-772b9618b3aa-removebg-preview.png"
            />
          </figure>

          <div class="cartitem__left--namearea">
            <p class="name">{{ item.name }}</p>
            <p class="unit">(Unit: {{ item.unit }}) You've picked {{ amount }} of this</p>
          </div>

          <div class="cartitem__left--price">
            <p
              class="price"
              :class="{
                grey: checkout,
              }"
            >
              {{ checkout ? `₦${total} total for ${amount}` : `One is ₦${price}` }}
            </p>
          </div>
        </div>
      </div>

      <div class="cartitem__right">
        <div class="cartitem__right--addremovebtns">
          <div class="cartitem__right--addremove">
            <button
              @click="reduceamount"
              :disabled="checkout"
              :class="{
                invisible: checkout,
              }"
            >
              <span>
                <svg>
                  <use v-bind:xlink:href="'/symbol-defs.svg#icon-minus1'"></use>
                </svg>
              </span>
            </button>
            <p class="amount">{{ checkout ? "Selected" : "" }} {{ amount }}</p>
            <button
              @click="increaseamount"
              :disabled="checkout"
              :class="{
                invisible: checkout,
              }"
            >
              <span>
                <svg>
                  <use v-bind:xlink:href="'/symbol-defs.svg#icon-plus'"></use>
                </svg>
              </span>
            </button>
          </div>
        </div>
      </div>

      <div class="cartitem__right--delete" @click="trashItem">
        <span class="total"></span>
        <span class="svg">
          <svg>
            <use v-bind:xlink:href="'/symbol-defs.svg#icon-trash-o'"></use>
          </svg>
        </span>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState } from "vuex";

export default {
  props: ["checkout", "item"],
  data() {
    return {
      amount: 0,
      price: 0,
      productoption: {},
      productid: null,
    };
  },
  mounted() {
    this.amount = this.item.quantity;
    this.price = this.item.price;
    this.productoption = this.item;
    this.productid = this.item.id;
  },
  computed: {
    total() {
      return this.price * this.amount;
    },
    ...mapState("cart", {
      cart: (state) => state.items,
      cartTotal: (state) => state.total,
      cartSubtotal: (state) => state.subtotal,
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
      const { item } = this;

      const cartitem = {
        id: item.id,
        name: item.name,
        price: item.price,
        quantity: this.amount,
        unit: item.unit,
      };

      this.$store.dispatch("cart/addItem", cartitem);
    },
    removeItem() {
      const { item } = this;

      const cartitem = {
        id: item.id,
        name: item.name,
        price: item.price,
        quantity: this.amount,
        unit: item.unit,
      };

      this.$store.dispatch("cart/removeItem", cartitem);
    },
    trashItem() {
      if (this.amount !== 0) {
        const deductFromCartTotal = this.cartTotal - this.amount;
        const minusAmount = this.amount * this.item.price;

        const { item } = this;

        const cartitem = {
          id: item.id,
          name: item.name,
          price: minusAmount,
          quantity: 0,
          unit: item.unit,
        };

        this.$store.dispatch("cart/removeItem", cartitem);

        this.$store.dispatch("cart/updateTotal", deductFromCartTotal);

        this.amount = 0;
      }
    },
  },
};
</script>

<style scoped lang="scss">
.cartitem {
  position: relative;
  border-radius: 1rem;
  padding: 2rem;
  margin-bottom: 2rem;
  display: flex;
  justify-content: space-between;
  padding-bottom: 6rem;

  &__h3 {
    margin-bottom: 3rem;
  }

  &__left {
    &--figure {
      height: 10rem;
      width: 10rem;
      overflow: hidden;
      border-radius: 1rem;

      & img {
        object-fit: cover;
        height: 100%;
        width: 100%;
      }
    }

    &--namearea {
      color: $black;
      font-weight: 500;

      display: flex;
      flex-direction: column;

      & p {
        &.name {
          font-size: 1.4rem;
        }

        &.unit {
          margin-top: 1rem;
          font-size: 1.15rem;
        }
      }
    }

    &--price {
      margin-top: 1rem;
      & p {
        &.price {
          font-size: 1.3rem;
          font-weight: 500;
          color: $primary-color;
        }

        &.grey {
          color: rgba($black, 0.5);
          font-weight: 400;
          font-size: 1.2rem;
        }
      }
    }
  }

  &__right {
    position: relative;
    background: red;

    &--addremovebtns {
      position: absolute;
      right: 0;
      bottom: 0;
    }

    &--addremove {
      display: flex;
      flex-direction: column;
      align-items: center;
      padding-right: 2rem;
      padding-bottom: 2rem;

      & p {
        &.amount {
          font-size: 1.4rem;
          padding: 1rem 0;
          font-weight: 600;
          color: rgba($primary-color, 1);
          display: flex;
        }
      }

      & button {
        height: 3.3rem;
        width: 3.3rem;
        border-radius: 100%;
        cursor: pointer;
        outline: none;
        border: none;
        font-size: 2rem;
        display: flex;
        justify-content: center;
        align-items: center;
        font-weight: 100;
        transition: all 0.5s ease;
        background: $primary-color;
        color: $white;

        &:nth-child(1) {
          //transform: translateY(-2rem);
        }

        & span {
          & svg {
            height: 1.4rem;
            width: 1.4rem;
            fill: $white;
            color: $white;
          }
        }
      }
    }

    &--delete {
      position: absolute;
      right: 0;
      bottom: 0;
      width: 100%;
      display: flex;
      justify-content: space-between;
      padding: 2rem 4.5rem;

      & span {
        cursor: pointer;

        &.total {
          font-size: 1.2rem;
          color: rgba($black, 0.5);
        }

        &.svg {
          & svg {
            height: 2rem;
            width: 2rem;
            fill: rgba($black, 0.5);
            color: rgba($black, 0.5);
            transition: all 0.5s;

            &:hover {
              fill: rgba($primary-color, 0.5);
              color: rgba($primary-color, 0.5);
            }
          }
        }
      }
    }
  }
}
</style>
