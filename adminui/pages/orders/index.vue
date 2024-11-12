<template>
  <DefaultLayout page-text="Orders">
    <div class="table__container">
      <table>
        <thead>
          <tr>
            <th v-for="header in tableHeaders" :key="header">{{ header }}</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(order, rowIndex) in orders" :key="order.orderId">
            <td v-for="header in tableHeaders" :key="header">
              <template v-if="header === 'items'">
                {{ order[header].length }} items
              </template>
              <template v-else>
                {{ order[header] || "N/A" }}
              </template>
            </td>
            <td class="actions-cell">
              <button class="actions-toggle" @click="toggleDropdown(rowIndex)">...</button>
              <div v-if="dropdownIndex === rowIndex" class="dropdown">
                <button @click="viewOrderDetails(order)">View Order Details</button>
                <button @click="changeOrderStatus(order.orderId)">
                  Edit Order Status
                </button>
                <button @click="openDeleteModal(order.orderId)">Delete Order</button>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <Transition name="fade">
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
    </Transition>
  </DefaultLayout>
</template>

<script>
import Default from "../../layouts/Default.vue";

export default {
  components: {
    DefaultLayout: Default,
  },

  computed: {
    tableHeaders() {
      // Extract unique keys from the first order to use as table headers, excluding 'items'
      const headers = Object.keys(this.orders[0]).filter(
        (header) => header !== "items"
      );
      headers.push("items"); 
      return headers;
    },
  },

  data() {
    return {
      orders: [
        {
          orderId: "ORD-00123",
          customerName: "John Doe",
          orderDate: "2023-11-12T10:30:00Z",
          deliveryDate: "2023-11-13T15:00:00Z",
          status: "Delivered",
          totalAmount: 45.75,
          paymentMethod: "Credit Card",
          items: [
            {
              productId: "PROD-0001",
              productName: "Organic Apples",
              quantity: 2,
              unitPrice: 3.5,
              totalPrice: 7.0,
            },
            {
              productId: "PROD-0002",
              productName: "Whole Milk",
              quantity: 1,
              unitPrice: 2.5,
              totalPrice: 2.5,
            },
          ],
          deliveryAddress: "123 Main St, Springfield, USA",
          trackingNumber: "TRACK-56789",
        },
        {
          orderId: "ORD-00124",
          customerName: "Jane Smith",
          orderDate: "2023-11-10T08:45:00Z",
          deliveryDate: "2023-11-11T12:30:00Z",
          status: "Pending",
          totalAmount: 89.99,
          paymentMethod: "PayPal",
          items: [
            {
              productId: "PROD-0003",
              productName: "Brown Rice",
              quantity: 1,
              unitPrice: 10.0,
              totalPrice: 10.0,
            },
            {
              productId: "PROD-0004",
              productName: "Chicken Breast",
              quantity: 3,
              unitPrice: 8.99,
              totalPrice: 26.97,
            },
            {
              productId: "PROD-0005",
              productName: "Spinach Bunch",
              quantity: 2,
              unitPrice: 2.5,
              totalPrice: 5.0,
            },
          ],
          deliveryAddress: "456 Oak Ave, Metropolis, USA",
          trackingNumber: null,
        },
        {
          orderId: "ORD-00125",
          customerName: "Emily Johnson",
          orderDate: "2023-11-09T12:20:00Z",
          deliveryDate: null,
          status: "Shipped",
          totalAmount: 30.45,
          paymentMethod: "Debit Card",
          items: [
            {
              productId: "PROD-0006",
              productName: "Bananas",
              quantity: 6,
              unitPrice: 0.75,
              totalPrice: 4.5,
            },
            {
              productId: "PROD-0007",
              productName: "Almond Milk",
              quantity: 1,
              unitPrice: 3.99,
              totalPrice: 3.99,
            },
            {
              productId: "PROD-0008",
              productName: "Bread Loaf",
              quantity: 2,
              unitPrice: 2.99,
              totalPrice: 5.98,
            },
          ],
          deliveryAddress: "789 Pine St, Gotham, USA",
          trackingNumber: "TRACK-54321",
        },
      ],
      showDeleteModal: false,
      dropdownIndex: null,
      selectedOrderId: null,
      isLoading: false,
      message: "",
    };
  },

  methods: {
    toggleDropdown(index) {
      this.dropdownIndex = this.dropdownIndex === index ? null : index;
    },
    openDeleteModal(orderId) {
      this.dropdownIndex = null;
      this.selectedOrderId = orderId;
      this.showDeleteModal = true;
    },
    closeDeleteModal() {
      this.showDeleteModal = false;
      this.message = "";
    },
    deleteOrder(orderId) {
      // delete logic
    },
    viewOrderDetails(order) {
      this.$router.push(`/orders/${order.orderId}`);
    },
    changeOrderStatus(orderId) {
      // status update logic
    },
  },
};
</script>
