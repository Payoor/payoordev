<template>
  <DefaultLayout page-text="Orders" description="View all Orders">
    <div class="search__container">
      <StatusFilter
        :statuses="orderStatuses" 
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

    <template v-if="orders && orders.length !== 0">
      <div class="table__container">
        <table>
          <thead>
            <tr>
              <th>S/N</th>
              <th v-for="header in getTableHeaders" :key="header">
                <template v-if="header === 'userId'">
                  user
                </template>
                <template v-else>
                  {{ header }}
                </template>
              </th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(order, rowIndex) in orders" :key="order.orderId">
              <td>{{ getIndex(rowIndex) }}</td>
              <td v-for="header in getTableHeaders" :key="header">
                <template v-if="header === 'total'">
                  {{ formatAmount(order[header]) }}
                </template>
                <template v-if="header === 'items'">
                  {{ order[header].length }} {{ order[header].length > 1 ? 'items' : 'item' }}
                </template>
                <template v-if="header === 'userId'">
                  {{ order[header].name }}
                </template>
                <template v-if="header !== 'total' && header !== 'items' && header !== 'userId'">
                  {{ isDate(order[header]) ? timestampToDateString(order[header]) : order[header] || "N/A" }}
                </template>
              </td>
              <td class="actions-cell">
                <button class="actions-toggle" @click="toggleDropdown(rowIndex)">...</button>
                <div v-if="dropdownIndex === rowIndex" class="orders-dropdown">
                  <button @click="viewOrderDetails(order._id)">View Order Details</button>
                  <!-- <button @click="openDeleteModal(order._id)">Delete Order</button> -->
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
      <EmptyState :empty-text="'No orders found'" />
    </template>


    <!-- <Transition name="fade">
      <Modal
        v-if="showDeleteModal"
        v-on:close-modal="closeDeleteModal"
        v-on:submit-form="deleteOrder"
        :modal-header="'Delete Order'"
        :confirm-text="'Yes, proceed'"
        :is-loading="isLoading"
      >
        <template #modalContent>
          <p>Are you sure you want to delete this order?</p>
          <div v-if="message" class="notification">
            <Notification :message="message" :isError="hasError" />
          </div>
        </template>
      </Modal>
    </Transition> -->
  </DefaultLayout>
</template>

<script>
import { getOrders } from "../../api";
import { formatAmount, orderStatuses, timestampToDateString } from "../../helpers";
import Default from "../../layouts/Default.vue";
import SearchIcon from "../../components/icons/SearchIcon.vue";
import { useDebounce } from "../../utils";

export default {
  components: {
    DefaultLayout: Default,
    SearchIcon
  },

  computed: {
    getTableHeaders() {
      return this.orders.length
        ? [...Object.keys(this.orders[0]).filter((key) => key !== "_id")]
        : [];
    },
  },

  data() {
    return {
      orders: [],
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
      orderStatuses,
      selectedStatus: "",
    };
  },

  methods: {
    getOrders,
    timestampToDateString,
    formatAmount,
    fetchOrders() {
      this.getOrders({
        page: this.currentPage, 
        limit: this.limit,
        search: this.debouncedSearchTerm,
        status: this.selectedStatus
      }).then((response) => {
        this.orders = response.data.orders;
        this.totalPages = response.data.totalPages;
        this.currentPage = response.data.page;
        this.orders = this.orders.map((order, index) => ({
          ...Object.fromEntries(
            Object.entries(order).filter(([key]) => key !== "_id")
          ),
          _id: order._id, // Keep the _id for sending updates
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
      this.fetchOrders();
    }),

    handleStatusChange(value) {
      this.selectedStatus = value;
      this.currentPage = 1;
      this.fetchOrders();
    },

    getIndex(index) {
      return this.currentPage * this.limit - this.limit + index + 1;
    },
    toggleDropdown(index) {
      this.dropdownIndex = this.dropdownIndex === index ? null : index;
    },
    // openDeleteModal(orderId) {
    //   this.dropdownIndex = null;
    //   this.selectedOrderId = orderId;
    //   this.showDeleteModal = true;
    // },
    // closeDeleteModal() {
    //   this.showDeleteModal = false;
    //   this.message = "";
    // },
    deleteOrder(orderId) {
      // delete logic
    },
    viewOrderDetails(orderId) {
      this.$router.push(`/orders/${orderId}`);
    },
    isDate(value) {
      if (typeof value !== "string") return false;

      // Check if the string can be converted to a valid Date
      const date = new Date(value);
      return !isNaN(date.getTime());
    },
    onPageChange(page) {
      this.currentPage = page;
      this.fetchOrders();
    }
  },

  mounted() {
    this.fetchOrders();
  },
};
</script>
