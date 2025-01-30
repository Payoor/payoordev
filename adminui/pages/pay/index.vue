<template>
  <DefaultLayout page-text="Payment">
    <div class="link">
      <div class="page">
        <template v-if="step === 1">
          <div class="form__container">
            <form @submit.prevent="handleProceedToCheckout">
              <div
                v-for="(item, id) in order.items"
                :key="id"
                class="item-group"
              >
                <h2>Item {{ id }}</h2>
                <div class="form__group">
                  <label>Item Name:</label>
                  <input v-model="item.name" type="text" required />
                </div>

                <div class="form__group">
                  <label>Units:</label>
                  <input v-model="item.units[0]" type="text" required />
                </div>
              </div>

              <h2>Summary</h2>
              <div class="form__group">
                <label>Total Amount:</label>
                <input
                  v-model.number="order.totalAmount"
                  type="number"
                  required
                />
              </div>

              <div class="form__group">
                <label>Order Address:</label>
                <input v-model="orderAddress" type="text" required />
              </div>

              <div class="form__group">
                <label>Delivery Fee:</label>
                <input v-model.number="deliveryFee" type="number" required />
              </div>

              <div class="form__group">
                <label>Service Charge:</label>
                <input v-model.number="serviceCharge" type="number" required />
              </div>

              <button type="submit" class="submit-btn" :class="{ isLoading }">
                <span>Proceed to checkout</span>
              </button>
            </form>
          </div>
        </template>
        <template v-if="step === 2">
          <div class="payment-btns">
            <button type="button" @click="payWithPaystack">
              {{ isPaystackLoading ? 'Loading...' : 'Pay with Paystack' }}
            </button>

            <button type="button" @click="payWithFlutterwave">
              {{ isFlutterLoading ? 'Loading...' : 'Pay with Flutterwave' }}
            </button>
          </div>
          
          <div></div>

          <div v-if="showBankDetails" class="bank_details">
            <h3>Make your transfer of {{ formatAmount(order.totalAmount) }}</h3>
            <p><strong>Bank Name: </strong> {{ bankDetails.bank }}</p>
            <p>
              <strong>Account Number: </strong>
              {{ bankDetails.account_number }}
            </p>

            <div class="view-trx">
              <button
                type="button"
                class="submit-btn"
                :class="{ isLoading }"
                @click="viewTransaction(bankDetails.transaction_reference)"
              >View transaction details</button>
            </div>
          </div>
        </template>
      </div>
    </div>
  </DefaultLayout>
</template>

<script>
import Default from "../../layouts/Default.vue";
import {
  generateBankTransferDetails,
  generatePaymentLink,
  verifyPayment,
} from "../../api";
import { formatAmount } from "../../helpers";

export default {
  components: {
    DefaultLayout: Default,
  },

  data() {
    return {
      step: 1,
      isPaystackLoading: false,
      isFlutterLoading: false,
      link: "",
      email: "a@b.com",
      transactionRef: "",
      isPaymentVerified: false,
      message: "",
      orderAddress: "Somewhere on earth",
      deliveryFee: 2500,
      serviceCharge: 500,
      order: {
        items: {
          1459: { name: "Garri", units: ["half paint"] },
          1357: { name: "flour", units: ["De rica"] },
        },
        totalAmount: 15000,
      },
      showBankDetails: false,
      showLink: false,
      bankDetails: {},
    };
  },

  methods: {
    generatePaymentLink,
    verifyPayment,
    generateBankTransferDetails,
    formatAmount,
    handleProceedToCheckout() {
      this.isLoading = true;
      setTimeout(() => {
        this.isLoading = false;
        this.step = 2;
      }, 2000);
    },

    addItem() {
      const newId = crypto.randomUUID();
      this.order.items = {
        ...this.order.items,
        [newId]: { name: "", units: [""] },
      };
    },

    removeItem(id) {
      delete this.order.items[id];
    },

    viewTransaction(trxRef) {
      this.$router.push(`/transaction-details?tx_ref=${trxRef}`);
    },

    payWithPaystack() {
      this.isPaystackLoading = true;
      this.generatePaymentLink({
        order: this.order,
        order_address: this.orderAddress,
        delivery_fee: this.deliveryFee,
        service_charge: this.serviceCharge,
      }).then((res) => {
        console.log(res.data);
        window.open(res.data.data.authorization_url, '_blank');
        this.isPaystackLoading = false;
      });
    },

    payWithFlutterwave() {
      this.isFlutterLoading = true;
      this.generateBankTransferDetails({
        order: this.order,
        order_address: this.orderAddress,
        delivery_fee: this.deliveryFee,
        service_charge: this.serviceCharge,
      })
        .then((res) => {
          this.isFlutterLoading = false;
          console.log(res.data);
          this.showBankDetails = true;
          this.bankDetails = res.data.data;
        })
        .catch((error) => console.log(error.response.data));
    },
  },
};
</script>

<style lang="scss">
.link {
  color: $font-color;
  margin-top: 5rem;

  .page {
    display: grid;
    grid-template-columns: 1fr 1fr;

    h2 {
      color: $font-color;
    }

    button {
      &[type="submit"] {
        width: fit-content;
      }
    }

    .payment-btns {
      width: 100%;
      display: grid;
      grid-template-columns: 1fr 1fr;
      align-items: center;
      gap: 2rem;

      button {
        width: 100%;
        &[type="button"] {
          padding: 3rem;
          border: none;
          border-radius: 0.25rem;
          font-size: 1.5rem;
          color: $font-color;
        }
      }
    }

    .bank_details {
      background-color: $white;
      color: $font-color;
      padding: 1rem;
      border-radius: 0.5rem;
      margin-top: 2rem;
      width: 100%;
      height: auto;
      box-shadow: 0px 0px 5px -2px #32475c4d;
      border: 1px solid $grey;

      h3 {
        text-align: center;
        margin-bottom: 1rem;
      }

      .view-trx {
        display: flex;
        margin-block: 1rem;
        button {
          width: fit-content;
          border: none;
          border-radius: 0.25rem;
          color: $white;
          font-size: 0.8rem;
          background: $primary-color;
          padding: 0.5rem 1rem;
          transition: 0.2s;

          &:hover {
            background-color: rgba($primary-color, 0.7);
          }
        }
      }
    }
  }
}
</style>
