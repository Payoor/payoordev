<template>
  <div>
    <div class="checkout">
      <Header />

      <div class="checkout__container">
        <div class="checkout__bottom">
          <div class="checkout__orderdetails">
            <div class="checkout__orderdetailsbody">
              <div>
                <div class="checkout__orderdetails--item">
                  <span>
                    Sub-total
                    {{
                      cartTotal > 0
                        ? `(${cartTotal} ${cartTotal > 1 ? "items" : "item"})`
                        : ""
                    }}
                  </span>
                  <span>₦{{ order ? order.cart_total : cartSubtotal }}</span>
                </div>

                <div class="checkout__orderdetails--item">
                  <span>Delivery Fee</span>
                  <span>₦{{ order ? order.delivery_fee : 0 }}</span>
                </div>

                <div class="checkout__orderdetails--item">
                  <span>Service Fee</span>
                  <span>₦{{ order ? order.service_charge : 0 }}</span>
                </div>

                <div class="checkout__orderdetails--item">
                  <span class="total">Total</span>
                  <span>₦{{ order ? order.total : 0 }}</span>
                </div>
              </div>

              <div v-if="currentview === 'deliverydetails'">
                <div class="checkout__bottom--btnarea">
                  <button
                    class="btn btn-checkout-button"
                    :disabled="!deliveryDate || deliveryDate.length == 0"
                    :class="{
                      disabled: !deliveryDate || deliveryDate.length == 0,
                    }"
                    @click="updateDeliveryDateandAddress"
                  >
                    Make Payment
                  </button>
                </div>
              </div>

              <div v-if="currentview === 'orderitems'">
                <div class="checkout__bottom--btnarea">
                  <button
                    class="btn btn-checkout-button"
                    :disabled="cartTotal === 0"
                    :class="{
                      disabled: cartTotal === 0,
                    }"
                    @click="toggleview('deliverydetails')"
                  >
                    Confirm Delivery Details
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="navigation__top">
          <span class="svg">
            <svg>
              <use v-bind:xlink:href="'/symbol-defs.svg#icon-arrow_back'"></use>
            </svg>
          </span>
          <h3 class="navigation__h3">Checkout</h3>
        </div>

        <div class="checkout__navtab">
          <div
            class="checkout__navtab--yourorder checkout__navtab--tab"
            @click="toggleview('orderitems')"
          >
            <span class="label">Your Order</span>
            <span
              class="color"
              :class="{
                current: currentview === 'orderitems',
              }"
            ></span>
          </div>

          <div
            class="checkout__navtab--deliverypayment checkout__navtab--tab"
            @click="toggleview('deliverydetails')"
          >
            <span class="label">Delivery and Payment Details</span>
            <span
              class="color"
              :class="{
                current: currentview === 'deliverydetails',
              }"
            ></span>
          </div>
        </div>

        <div class="checkout__main">
          <div class="checkout__yourorder" v-if="currentview === 'orderitems'">
            <h3 class="checkout__h3">Order Summary</h3>

            <div class="checkout__orderitems checkout__section">
              <RenderCartItems :checkout="true" />
            </div>
          </div>

          <div
            class="checkout__deliveryandpayment checkout__section"
            v-if="currentview === 'deliverydetails'"
          >
            <h3 class="checkout__h3">Delivery Details</h3>

            <div>
              <DeliveryDetails
                :userAddress="userAddress"
                @update:userAddress="userAddress = $event"
                :phoneNumber="userPhoneNumber"
                @update:phoneNumber="userPhoneNumber = $event"
                :availableDates="availableDates"
                :selectDeliveryDate="selectDeliveryDate"
                :deliveryDate="deliveryDate"
                :affiliateCode="affiliateCode"
                @update:affiliateCode="affiliateCode = $event"
              />
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState } from "vuex";
import { url } from "@/api";
import utilsMixin from "@/mixins/utils";

export default {
  mixins: [utilsMixin],
  data() {
    return {
      userAddress: "",
      userPhoneNumber: "",
      currentview: "orderitems", //or deliverydetails //orderitems
      deliveryDate: null,
      affiliateCode: "",
      order: null,
    };
  },
  mounted() {
    if (this.agentCode) {
      this.affiliateCode = this.agentCode;
    }
  },
  watch: {
    user: {
      handler(newValue) {
        if (newValue) {
          if (newValue.userAddress) {
            this.userAddress = newValue.userAddress;
            this.userPhoneNumber = newValue.phoneNumber;
          }
        }
      },
    },
  },
  computed: {
    agentCode() {
      return this.$route.query.affiliatecode;
    },
    ...mapState("cart", {
      cart: (state) => state.items,
      cartTotal: (state) => state.total,
      cartSubtotal: (state) => state.subtotal,
    }),
    ...mapState({
      USERJWT: (state) => state.jwt,
      user: (state) => state.user,
    }),
    cartPayload() {
      const { cart, cartSubtotal } = this;
      const cartPayload = {
        items: Object.fromEntries(
          Object.entries(cart).map(([id, item]) => [
            id,
            {
              name: item.name,
              units: Object.fromEntries(
                Object.entries(item.units).map(([unit, details]) => [
                  unit,
                  { price: details.price, quantity: details.quantity },
                ])
              ),
            },
          ])
        ),
        totalAmount: cartSubtotal,
      };

      return cartPayload;
    },
    availableDates() {
      const startDate = new Date();
      const formattedDates = [];
      const currentDate = new Date(startDate);

      const monthNames = [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December",
      ];

      for (let i = 0; i < 6; i++) {
        // Format the date as "DD Month YYYY"
        const day = currentDate.getDate();
        const month = monthNames[currentDate.getMonth()];
        const year = currentDate.getFullYear();

        formattedDates.push(`${day} ${month} ${year}`);

        currentDate.setTime(currentDate.getTime() + 48 * 60 * 60 * 1000);
      }

      return formattedDates;
    },
  },
  methods: {
    selectDeliveryDate(availableDate) {
      this.deliveryDate = availableDate;
    },
    toggleview(currentview) {
      if (this.cartTotal === 0) {
        return;
      }

      if (currentview === "deliverydetails") {
        this.createOrder();
      }

      this.currentview = currentview;
    },
    async createOrder() {
      const { cartPayload } = this;
      try {
        const response = await fetch(`${url}/user/create/order`, {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            Accept: "application/json",
            Authorization: `Bearer ${this.USERJWT}`,
          },
          body: JSON.stringify({
            order: cartPayload,
            order_address: this.userAddress,
          }),
        });

        if (!response.ok) {
          console.log("error creating order");
        }

        const data = await response.json();

        if (data) {
          const order = data.data.chatresponse.payload;
          this.order = order;
        }
      } catch (error) {
        console.error("Error creating order:", error);
      }
    },
    async updateDeliveryDateandAddress() {
      try {
        const response = await fetch(`${url}/user/update/order/delivery-date-address`, {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            Accept: "application/json",
            Authorization: `Bearer ${this.USERJWT}`,
          },
          body: JSON.stringify({
            order_id: this.order._id,
            delivery_date: this.deliveryDate,
            delivery_address: this.userAddress,
            couponcode: this.affiliateCode
          }),
        });

        if (!response.ok) {
          console.log("error creating order");
        }

        const data = await response.json();

        if (data) {
          const order = data.data.order;

          this.pageRouter("/pay", {
            userId: this.user._id,
            email: this.user.email,
            name: this.user.name,
            phoneNumber: this.userPhoneNumber,
            userAddress: this.userAddress,
            orderId: order._id,
            total: order.total,
          });
        }
      } catch (error) {
        console.error("Error creating order:", error);
      }
    },
  },
};
</script>

<style scoped lang="scss">
.checkout {
  background: $white;

  &__container {
    position: relative;
    height: 90rem;
    margin: 0 auto;
    width: 130rem;
    padding-top: 3rem;
    padding-bottom: 5rem;
    overflow-x: hidden;
    overflow-y: scroll;
  }

  &__section {
    position: relative;
    width: 60rem;
    padding-bottom: 7rem;
  }

  &__main {
    display: flex;
    margin-top: 4rem;
    padding-bottom: 11rem;
  }

  &__h3 {
    font-size: 1.5rem;
    font-weight: 500;
    margin-bottom: 3rem;
  }

  &__navtab {
    display: flex;
    margin-top: 2rem;

    &--tab {
      margin-right: 3rem;
      display: flex;
      flex-direction: column;
      cursor: pointer;

      & span {
        &.label {
          font-size: 1.5rem;
        }

        &.color {
          background: rgba($black, 0.1);
          border-radius: 3rem;
          display: inline-block;
          overflow: hidden;
          width: 100%;
          height: 0.5rem;
          position: relative;

          &::after {
            content: "";
            background: $primary-color;
            height: 100%;
            width: 0;
            position: absolute;
            left: 0;
            top: 0;
            transition: all 0.5s ease;
          }

          &.current {
            &::after {
              content: "";
              background: $primary-color;
              height: 100%;
              width: 100%;
              position: absolute;
              left: 0;
              top: 0;
            }
          }
        }
      }
    }
  }

  &__yourorder {
    margin-right: 3rem;
  }

  &__orderdetails {
    width: 61rem;
    width: 130rem;
    margin: 0 auto;

    &--item {
      margin-bottom: 1.4rem;
      display: flex;
      justify-content: space-between;

      & span {
        font-size: 1.4rem;

        &.total {
          font-weight: 600;
        }
      }
    }
  }

  &__orderdetailsbody {
    width: 60rem;
  }

  &__bottom {
    position: fixed;
    bottom: 0;
    left: 0;
    width: 100%;
    background: $white;
    padding-bottom: 3rem;
    z-index: 3;
    background: $white;
  }
}
</style>