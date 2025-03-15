<template>
  <div class="order">
    <div class="order__header">
      <h2>Order Details</h2>
      <span class="order__status" :class="`order__status--${order.status}`">
        {{ order.status }}
      </span>
    </div>

    <div class="order__info">
      <div class="order__info-item">
        <span class="order__label">Order ID:</span>
        <span class="order__value">{{ formatOrderId(order._id) }}</span>
      </div>

      <div class="order__info-item">
        <span class="order__label">Delivery Date:</span>
        <span class="order__value">{{ order.delivery_date }}</span>
      </div>

      <div class="order__info-item">
        <span class="order__label">Delivery Address:</span>
        <span class="order__value">{{ order.order_address }}</span>
      </div>
    </div>

    <div class="order__items">
      <h3>Items ({{ order.items.length }})</h3>
      <div class="order__item" v-for="(item, index) in order.items" :key="index">
        <div class="order__item-name">{{ item.product_name }}</div>
        <div class="order__item-id">ID: {{ item.product_id.slice(0, 8) }}...</div>
      </div>
    </div>

    <div class="order__summary">
      <div class="order__summary-row">
        <span>Cart Total:</span>
        <span>₦{{ formatPrice(order.cart_total) }}</span>
      </div>
      <div class="order__summary-row">
        <span>Service Charge:</span>
        <span>₦{{ formatPrice(order.service_charge) }}</span>
      </div>
      <div class="order__summary-row">
        <span>Delivery Fee:</span>
        <span>₦{{ formatPrice(order.delivery_fee) }}</span>
      </div>
      <div class="order__summary-row order__summary-row--total">
        <span>Total:</span>
        <span>₦{{ formatPrice(order.total) }}</span>
      </div>
    </div>

    <div class="order__actions">
      <!--<button class="order__button order__button--primary">Track Order</button>-->
      <button class="order__button order__button--secondary">Contact Support</button>
    </div>
  </div>
</template>

<script>
export default {
  name: "OrderComponent",
  props: {
    order: {
      type: Object,
      required: true,
      default: () => ({
        _id: "b4691546-9ae8-48b1-a729-abced70627a3",
        userId: "67d212a5ad74c13201c4196d",
        items: [],
        order_address: "",
        cart_total: 0,
        delivery_fee: 0,
        service_charge: 0,
        total: 0,
        status: "pending",
        createdAt: 0,
        delivery_date: "",
        reference: "",
      }),
    },
  },
  methods: {
    formatPrice(price) {
      return (price / 100).toLocaleString("en-NG");
    },
    formatOrderId(id) {
      return id.slice(0, 8).toUpperCase();
    },
    formatDate(timestamp) {
      return new Date(timestamp).toLocaleDateString("en-NG", {
        year: "numeric",
        month: "long",
        day: "numeric",
      });
    },
  },
};
</script>

<style lang="scss" scoped>
.order {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  padding: 2rem;
  max-width: 800px;
  margin: 0 auto;

  &__header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 1.5rem;
    padding-bottom: 1rem;
    border-bottom: 1px solid #eaeaea;

    h2 {
      font-size: 1.5rem;
      font-weight: 600;
      margin: 0;
      color: $primary-color;
    }
  }

  &__status {
    padding: 0.4rem 1rem;
    border-radius: 50px;
    font-size: 0.85rem;
    font-weight: 500;
    text-transform: capitalize;

    &--pending {
      background-color: rgba($primary-color, 0.1);
      color: $primary-color;
    }

    &--processing {
      background-color: #e3f2fd;
      color: #1976d2;
    }

    &--delivered {
      background-color: #e8f5e9;
      color: #388e3c;
    }

    &--cancelled {
      background-color: #ffebee;
      color: #d32f2f;
    }
  }

  &__info {
    margin-bottom: 2rem;
  }

  &__info-item {
    margin-bottom: 0.75rem;

    &:last-child {
      margin-bottom: 0;
    }
  }

  &__label {
    font-weight: 500;
    color: #757575;
    margin-right: 0.5rem;
  }

  &__value {
    color: #212121;
  }

  &__items {
    margin-bottom: 2rem;

    h3 {
      font-size: 1.1rem;
      font-weight: 600;
      margin-bottom: 1rem;
      color: $primary-color;
    }
  }

  &__item {
    padding: 1rem;
    border-radius: 8px;
    background-color: #f9f9f9;
    margin-bottom: 0.75rem;
    border-left: 3px solid $primary-color;

    &:last-child {
      margin-bottom: 0;
    }
  }

  &__item-name {
    font-weight: 500;
    margin-bottom: 0.25rem;
    text-transform: capitalize;
  }

  &__item-id {
    font-size: 0.85rem;
    color: #757575;
  }

  &__summary {
    margin-bottom: 2rem;
  }

  &__summary-row {
    display: flex;
    justify-content: space-between;
    padding: 0.75rem 0;
    border-bottom: 1px solid #eaeaea;

    &:first-child {
      border-top: 1px solid #eaeaea;
    }

    &--total {
      font-weight: 700;
      font-size: 1.1rem;
      padding-top: 1rem;
      color: $primary-color;
    }
  }

  &__actions {
    display: flex;
    gap: 1rem;
  }

  &__button {
    padding: 0.75rem 1.5rem;
    border-radius: 8px;
    font-weight: 500;
    border: none;
    cursor: pointer;
    transition: background-color 0.2s ease;

    &--primary {
      background-color: $primary-color;
      color: white;

      &:hover {
        background-color: darken($primary-color, 10%);
      }
    }

    &--secondary {
      background-color: #f0f0f0;
      color: #424242;
      border: 1px solid lighten($primary-color, 30%);

      &:hover {
        background-color: lighten($primary-color, 40%);
      }
    }
  }
}
</style>
