<template>
  <DefaultLayout page-text="Orders">
    <div class="table__container">
      <table>
        <thead>
          <tr>
            <th v-for="header in getTableHeaders" :key="header">{{ header }}</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(order, rowIndex) in orders" :key="order.orderId">
            <td v-for="header in getTableHeaders" :key="header">
              <template v-if="header === 'items'">
                {{ order[header].length }} items
              </template>
              <template v-else>
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
import { timestampToDateString } from "../../helpers";
import Default from "../../layouts/Default.vue";

export default {
  components: {
    DefaultLayout: Default,
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
    };
  },

  methods: {
    getOrders,
    timestampToDateString,
    fetchOrders() {
      this.getOrders()
        .then((response) => {
          this.orders = response.data.orders;
          this.orders = this.orders.map((order, index) => ({
            "S/N": index + 1,
            ...Object.fromEntries(
              Object.entries(order).filter(([key]) => key !== "_id")
            ),
            _id: order._id, // Keep the _id for sending updates
          }));
        })
        .catch((error) => {
          console.log(error.response.data);
        });
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
  },

  mounted() {
    this.fetchOrders();
  },
};
</script>
