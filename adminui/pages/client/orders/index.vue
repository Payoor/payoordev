<template>
  <div class="orders">
    <h2>Orders</h2>
    <template v-if="hasOrders">
      <div
        v-for="(orders, index) in userOrders"
        :key="index"
        class="order-item"
      >
        <div v-for="(value, key) in orders" :key="key">
          <template v-if="key === 'total'">
            <p>
              <strong>{{ key }}: </strong>
              {{ formatAmount(value) }}
            </p>
          </template>
          <template v-else>
            <p v-if="key !== 'status'">
              <strong>{{ key }}:</strong>
              {{ isDate(value) ? timestampToDateString(value) : value }}
            </p>
          </template>
          <template v-if="key === 'status'">
            <div :class="['status', value]">
              <p>{{ value }}</p>
            </div>
          </template>
        </div>
      </div>

      <div
        v-for="(orders, index) in userOrders"
        :key="index"
        class="order-item"
      >
        <div v-for="(value, key) in orders" :key="key">
          <template v-if="key === 'total'">
            <p>
              <strong>{{ key }}: </strong>
              {{ formatAmount(value) }}
            </p>
          </template>
          <template v-else>
            <p v-if="key !== 'status'">
              <strong>{{ key }}:</strong>
              {{ isDate(value) ? timestampToDateString(value) : value }}
            </p>
          </template>
          <template v-if="key === 'status'">
            <div :class="['status', value]">
              <p>{{ value }}</p>
            </div>
          </template>
        </div>
      </div>

      <div
        v-for="(orders, index) in userOrders"
        :key="index"
        class="order-item"
      >
        <div v-for="(value, key) in orders" :key="key">
          <template v-if="key === 'total'">
            <p>
              <strong>{{ key }}: </strong>
              {{ formatAmount(value) }}
            </p>
          </template>
          <template v-else>
            <p v-if="key !== 'status'">
              <strong>{{ key }}:</strong>
              {{ isDate(value) ? timestampToDateString(value) : value }}
            </p>
          </template>
          <template v-if="key === 'status'">
            <div :class="['status', value]">
              <p>{{ value }}</p>
            </div>
          </template>
        </div>
      </div>
    </template>

    <template v-if="!hasOrders">
      <div class="empty-state">
        <em>No Orders</em>
      </div>
    </template>
  </div>
</template>

<script>
import axios from "axios";

const serverUrl = "https://server.development.payoor.store/user/get/orders";

export default {
  data() {
    return {
      userOrders: null,
      userToken: null,
      hasOrders: false,
    };
  },

  methods: {
    fetchUserOrders() {
      axios
        .get(serverUrl, {
          headers: {
            Authorization:
              "Bearer " + localStorage.getItem("payoor_user_token"), // replace with actual token key in local staorage
          },
        })
        .then((res) => {
          this.userOrders = res.data.orders;
          this.hasOrders = this.userOrders.length > 0 ? true : false;
        })
        .catch((error) => console.log(error.response.data));
    },

    formatAmount(amount) {
      const formatter = new Intl.NumberFormat("en-NG", {
        style: "currency",
        currency: "NGN",
        minimumFractionDigits: 0,
      });

      return formatter.format(amount);
    },

    timestampToDateString(timestamp) {
      return new Date(timestamp).toLocaleString('en-gb', {
        weekday: 'long',
        year: 'numeric',
        month: 'long',
        day: 'numeric'
      })
    },

    isDate(value) {
      if (typeof value !== "string") return false;

      // Check if the string can be converted to a valid Date
      const date = new Date(value);
      return !isNaN(date.getTime());
    },

    getObjectValue(value) {
      return this.formatAmount(value?.$numberDecimal) || "Unknown";
    },
  },

  mounted() {
    this.fetchUserOrders();
  },
};
</script>

<style lang="scss" scoped>
.orders {
  margin-top: 60px;
  flex-grow: 1;
  overflow-y: auto;
  padding: 1rem;
  color: rgba($white, 0.7);
  font-size: 0.8rem;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;

  .order-item {
    border: 2px solid rgb(47, 47, 47);
    border-radius: 0.5rem;
    background-color: rgb(32, 32, 32);
    padding: 1rem;
    position: relative;

    .status {
      position: relative;
      right: 0;
      margin-bottom: 0.5rem;
      font-size: 0.7rem;
      font-weight: bold;
      padding: 0.2rem 1rem;
      border-radius: 0.75rem;
      width: fit-content;

      @media screen and (min-width: 768px) {
        position: absolute;
        bottom: 1rem;
        right: 1rem;
        margin: 0;
      }

      &.verified,
      &.completed {
        background-color: rgba($primary-color, 0.3);
        color: $primary-color;
        border: 1px solid $primary-color;
      }

      &.pending {
        background-color: rgba(255, 215, 0, 0.3);
        color: gold;
        border: 1px solid gold;
      }

      &.processing {
        background-color: rgba(138, 43, 226, 0.3);
        color: blueviolet;
        border: 1px solid blueviolet;
      }

      &.cancelled {
        background-color: rgba(128, 128, 128, 0.3);
        color: gray;
        border: 1px solid gray;
      }
    }
  }

  .empty-state {
    border: 2px solid rgb(47, 47, 47);
    border-radius: 0.5rem;
    background-color: rgb(32, 32, 32);
    padding: 2rem 1rem;
    text-align: center;
  }
}
</style>
