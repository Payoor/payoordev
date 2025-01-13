<template>
  <DefaultLayout page-text="Transactions">
    <div class="search__container">
      <StatusFilter
        :statuses="transactionStatuses" 
        :selectedStatus="selectedStatus" 
        v-on:status-change="handleStatusChange" 
      />

      <div class="search__bar">
        <input 
          type="text"
          placeholder="Search..."
          v-model="search"
          @input="handleSearchInput"
        >
        <button 
          type="button"
          @click="handleSearchInput"
        >
          <SearchIcon />
        </button>
      </div>
    </div>

    <template v-if="transactions && transactions.length !== 0">
      <div class="table__container">
        <table>
          <thead>
            <tr>
              <th>S/N</th>
              <th v-for="header in getTableHeaders" :key="header">
                <template v-if="header === 'initiatorId'">
                  initiator
                </template>
                <template v-else>
                  {{ header }}
                </template>
              </th>
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
                <template v-if="isObject(transaction[header])">
                  {{ transaction[header].name }}
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
      <Pagination
        v-if="totalPages > 1"
        :totalPages="totalPages"
        :perPage="limit"
        :currentPage="currentPage"
        @pagechanged="onPageChange"
      />
    </template>

    <template v-else>
      <EmptyState :empty-text="'No transactions found'" />
    </template>
  </DefaultLayout>
</template>

<script>
import { getTransactions } from "../../api";
import { formatAmount, timestampToDateString, transactionStatuses, isDate } from "../../helpers";
import Default from "../../layouts/Default.vue";
import SearchIcon from "../../components/icons/SearchIcon.vue";
import { useDebounce } from "../../utils";

export default {
  components: {
    DefaultLayout: Default,
    SearchIcon,
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
      limit: 10,
      search: "",
      debouncedSearchTerm: "",
      transactionStatuses,
      selectedStatus: "",
    };
  },

  methods: {
    getTransactions,
    timestampToDateString,
    formatAmount,
    isDate,
    fetchTransactions() {
      this.getTransactions({
        page: this.currentPage, 
        limit: this.limit,
        search: this.debouncedSearchTerm,
        status: this.selectedStatus
      }).then((response) => {
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
        if (error.response.status === 401) {
          localStorage.removeItem('adminToken');
          localStorage.removeItem('adminUsername');
          this.$router.push('/');
        }
      });
    },

    handleSearchInput: useDebounce(function () {
      this.debouncedSearchTerm = this.search;
      this.fetchTransactions();
    }),

    handleStatusChange(value) {
      this.selectedStatus = value;
      this.currentPage = 1;
      this.fetchTransactions();
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

    isObject(value) {
      return value && typeof value === "object";
    },

    getObjectValue(value) {
      return formatAmount(value?.$numberDecimal) || "Unknown";
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
