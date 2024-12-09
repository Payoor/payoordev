<template>
  <DefaultLayout page-text="Transactions">
    <div class="table__container">
      <table>
        <thead>
          <tr>
            <th>S/N</th>
            <th v-for="header in getTableHeaders" :key="header">{{ header }}</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(transaction, rowIndex) in transactions" :key="transaction._id">
            <td>{{ getIndex(rowIndex) }}</td>
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
      <Pagination
        :totalPages="totalPages"
        :perPage="limit"
        :currentPage="currentPage"
        @pagechanged="onPageChange"
      />
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
      totalPages: 0,
      currentPage: 1,
      limit: 10
    };
  },

  methods: {
    getTransactions,
    timestampToDateString,
    fetchTransactions() {
      this.getTransactions(this.currentPage, this.limit)
        .then((response) => {
          console.log(response.data)
          this.transactions = response.data.transactions;
          this.currentPage = response.data.page;
          this.totalPages = response.data.totalPages;
          this.transactions = this.transactions.map((transaction, index) => ({
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
    getIndex(index) {
      return this.currentPage * this.limit - this.limit + index + 1;
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
    
    onPageChange(page) {
      this.currentPage = page;
      this.fetchTransactions();
    }
  },

  mounted() {
    this.fetchTransactions();
  },
};
</script>
