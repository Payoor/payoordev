<template>
  <DefaultLayout page-text="Transactions">
    <div class="table__container">
      <table>
        <thead>
          <tr>
            <th v-for="header in getTableHeaders" :key="header">{{ header }}</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(transaction, rowIndex) in transactions" :key="transaction._id">
            <td v-for="header in getTableHeaders" :key="header">
              <template v-if="header === 'amount'">
                {{ getObjectValue(transaction[header]) }}
              </template>
              <template v-if="header === 'items'">
                {{ transaction[header].length }} items
              </template>
              <template v-if="isDate(transaction[header])">
                {{ isDate(transaction[header]) ? timestampToDateString(transaction[header]) : "N/A"}}
              </template>
              <template v-if="!isObject(transaction[header]) && !isDate(transaction[header])">
                {{ transaction[header] ?? "N/A" }}
              </template>
            </td>
            <td class="actions-cell">
              <button class="actions-toggle" @click="toggleDropdown(rowIndex)">...</button>
              <div v-if="dropdownIndex === rowIndex" class="transactions-dropdown">
                <!-- <button @click="viewTransactionDetails(transaction._id)">View Transaction Details</button> -->
                <!-- <button @click="openDeleteModal(transaction._id)">Delete Transaction</button> -->
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </DefaultLayout>
</template>

<script>
import { getTransactions } from "../../api";
import { timestampToDateString } from "../../helpers";
import Default from "../../layouts/Default.vue";

export default {
  components: {
    DefaultLayout: Default,
  },

  computed: {
    getTableHeaders() {
      return this.transactions.length
        ? [...Object.keys(this.transactions[0]).filter((key) => key !== "_id")]
        : [];
    },
  },

  data() {
    return {
      transactions: [],
      showDeleteModal: false,
      dropdownIndex: null,
      selectedOrderId: null,
      isLoading: false,
      message: "",
    };
  },

  methods: {
    getTransactions,
    timestampToDateString,
    fetchTransactions() {
      this.getTransactions()
        .then((response) => {
          console.log(response.data)
          this.transactions = response.data.transactions;
          this.transactions = this.transactions.map((transaction, index) => ({
            "S/N": index + 1,
            ...Object.fromEntries(
              Object.entries(transaction).filter(([key]) => key !== "_id")
            ),
            _id: transaction._id, // Keep the _id for sending updates
          }));
        })
        .catch((error) => {
          console.log(error.response.data);
        });
    },
    toggleDropdown(index) {
      this.dropdownIndex = this.dropdownIndex === index ? null : index;
    },
    deleteOrder(transactionId) {
      // delete logic
    },
    // viewTransactionDetails(transactionId) {
    //   this.$router.push(`/transactions/${transactionId}`);
    // },
    isDate(value) {
      if (typeof value !== "string") return false;

      // Check if the string can be converted to a valid Date
      const date = new Date(value);
      return !isNaN(date.getTime());
    },

    isObject(value) {
      return value && typeof value === "object";
    },

    getObjectValue(value) {
      return value?.$numberDecimal || "Unknown";
    },
  },

  mounted() {
    this.fetchTransactions();
  },
};
</script>
