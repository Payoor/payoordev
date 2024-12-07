<template>
  <div class="transactions">
    <h2>Transactions</h2>
    <template v-if="hasTransactions">
      <div 
        v-for="(transactions, index) in userTransactions" 
        :key="index"
        class="transaction-item"
      >
        <div v-for="(value, key) in transactions" :key="key">
          <template v-if="key === 'amount'">
            <p>
              <strong>{{ key }}: </strong>
              {{ getObjectValue(value) }}
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

    <template v-if="!hasTransactions">
      <div class="empty-state">
        <em>No Transactions</em>
      </div>
    </template>
  </div>
</template>

<script>
import axios from "axios";

const serverUrl = "https://server.development.payoor.store/user/get/transactions";

export default {
  data() {
    return {
      userTransactions: null,
      userToken: null,
      hasTransactions: false,
    };
  },

  methods: {
    fetchUserTransactions() {
      axios
        .get(serverUrl, {
          headers: {
            Authorization:
              "Bearer " + localStorage.getItem("payoor_user_token"), // replace with actual token key in local staorage
          },
        })
        .then((res) => {
          this.userTransactions = res.data.transactions;
          this.hasTransactions = this.userTransactions.length > 0 ? true : false;
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
    this.fetchUserTransactions();
  },
};
</script>

<style lang="scss" scoped>
.transactions {
  margin-top: 60px;
  flex-grow: 1;
  overflow-y: auto;
  padding: 1rem;
  color: rgba($white, 0.7);
  font-size: 0.8rem;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;

  .transaction-item {
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
  
      &.verified {
        background-color: rgba($primary-color, 0.3);
        color: $primary-color;
        border: 1px solid $primary-color;
      }
  
      &.pending {
        background-color: rgba(255, 215, 0, 0.3);
        color: gold;
        border: 1px solid gold;
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
