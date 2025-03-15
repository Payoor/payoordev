<template>
  <div>
    <div class="orders">
      <div class="orders__overlay" @click.stop="callCloseorders"></div>
      <div class="orders__container">
        <div class="orders__content">
          <div class="orders__header">
            <div class="navigation__top">
              <span class="svg" @click="callCloseorders">
                <svg>
                  <use v-bind:xlink:href="'/symbol-defs.svg#icon-arrow_back'"></use>
                </svg>
              </span>
              <h3 class="navigation__h3">Your Orders</h3>
            </div>

            <div class="orders__navigation">
              <span>
                <button
                  class="orders__button orders__button--pending"
                  @click="getOrders('pending')"
                >
                  Pending
                </button>
              </span>
              <span>
                <button
                  class="orders__button orders__button--processing"
                  @click="getOrders('processing')"
                >
                  Processing
                </button>
              </span>
              <span>
                <button
                  class="orders__button orders__button--completed"
                  @click="getOrders('completed')"
                >
                  Completed
                </button>
              </span>
            </div>
          </div>

          <div class="orders__items">
            <div v-if="orders && orders.length > 0">
              <div
                v-for="(order, index) in orders"
                :key="order._id || index"
                class="orders__item"
              >
                <Order :order="order" />
              </div>
            </div>
            <div v-else-if="isLoading" class="orders__loading">
              <p>Loading your orders...</p>
            </div>
            <div v-else class="orders__empty">
              <p>No orders found.</p>
              <button
                class="orders__button orders__button--primary"
                @click.stop="callCloseorders"
              >
                Keep Shopping
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState } from "vuex";
import { url } from "@/api";

export default {
  props: ["closeorders"],
  data() {
    return {
      isLoading: false,
      orders: [],
    };
  },
  mounted() {
    this.getOrders();
  },
  computed: {
    ...mapState({
      USERJWT: (state) => state.jwt,
      user: (state) => state.user,
    }),
  },
  methods: {
    callCloseorders() {
      this.closeorders();
    },
    async getOrders(status) {
      // Call the /user/get/orders endpoint
      try {
        const page = this.page || 1;
        const limit = this.limit || 10;

        const statusParam = status ? status : "processing";

        const response = await fetch(
          `${url}/user/get/orders?page=${page}&limit=${limit}&status=${statusParam}`,
          {
            method: "GET",
            headers: {
              "Content-Type": "application/json",
              Accept: "application/json",
              Authorization: `Bearer ${this.USERJWT}`,
            },
          }
        );

        if (!response.ok) {
          console.log("Error fetching orders:", response.status);
          this.orderError = "Failed to fetch orders. Please try again.";
          return;
        }

        const data = await response.json();

        if (data && data.success) {
          this.orders = data.data.orders;
          this.totalPages = data.data.totalPages;
          this.totalCount = data.data.totalCount;
          this.currentPage = data.data.page;

          // Update loading state if you're using one
          this.isLoading = false;

          console.log(this.orders, "this.orders");
        } else {
          console.log("Invalid response format:", data);
          this.orderError = "Something went wrong. Please try again.";
        }
      } catch (error) {
        console.log("Error fetching orders:", error);
        this.orderError = "Network error. Please check your connection and try again.";
        // Update loading state if you're using one
        this.isLoading = false;
      }
    },
  },
};
</script>

<style scoped lang="scss">
.orders {
  @include sideviewright;

  &__content {
    height: 100%;
    overflow-x: hidden;
    overflow-y: scroll;
    padding-bottom: 4rem;
  }

  &__header {
    margin-bottom: 2rem;

    margin-bottom: 2rem;
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    padding: 1rem;
    padding-left: 5rem;
    background: $white;
  }

  &__navigation {
    display: flex;
    gap: 1rem;
    margin: 2rem 0;
    border-bottom: 1px solid #eaeaea;
    padding-bottom: 1rem;
  }

  &__button {
    padding: 0.75rem 1.5rem;
    border-radius: 8px;
    font-weight: 500;
    border: none;
    cursor: pointer;
    transition: all 0.2s ease;
    font-size: 0.9rem;

    &--pending {
      background-color: #fff8e1;
      color: #ffa000;

      &:hover,
      &.active {
        background-color: #ffa000;
        color: white;
      }
    }

    &--processing {
      background-color: #e3f2fd;
      color: #1976d2;

      &:hover,
      &.active {
        background-color: #1976d2;
        color: white;
      }
    }

    &--completed {
      background-color: #e8f5e9;
      color: #388e3c;

      &:hover,
      &.active {
        background-color: #388e3c;
        color: white;
      }
    }
  }

  &__items {
    padding: 1rem;
    margin-top: 8rem
  }

  &__item {
    margin-bottom: 1rem;
  }
}

.navigation {
  &__top {
    display: flex;
    align-items: center;
    gap: 1rem;
  }

  &__h3 {
    font-size: 1.3rem;
    font-weight: 600;
    margin: 0;
  }
}

.svg {
  display: flex;
  align-items: center;
  cursor: pointer;

  svg {
    width: 24px;
    height: 24px;
    fill: currentColor;
  }
}
</style>
