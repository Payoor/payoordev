<template>
  <DefaultLayout :page-text="'Order Details'">
    <div class="go-back">
      <button @click="$router.push('/orders')">
        <ChevronLeftIcon class="arrow-icon" />
        Go back
      </button>
    </div>
    <div class="product-details-container">
      <div>
        <h2>Order Summary</h2>
        <section>
          <div v-for="(value, key) in order" :key="key">
            <template v-if="key !== 'items'">
              <p>
                <strong>{{ key }}:</strong> {{ value }}
              </p>
            </template>
          </div>
        </section>

        <h2>Items</h2>
        <section v-if="order.items && order.items.length">
          <div
            class="order-item"
            v-for="(item, index) in order.items"
            :key="index"
          >
            <div v-for="(itemValue, itemKey) in item" :key="itemKey">
              <template v-if="itemKey === 'images'">
                <figure v-for="(image, imgIndex) in itemValue" :key="imgIndex">
                  <img :src="image" alt="Product Image" class="product-image" />
                </figure>
              </template>
            </div>
            <div>
              <div v-for="(itemValue, itemKey) in item" :key="itemKey">
                <template v-if="itemKey !== 'images'">
                  <p>
                    <strong>{{ itemKey }}:</strong> {{ itemValue }}
                  </p>
                </template>
              </div>
            </div>
          </div>
        </section>

        <h2>Conversations</h2>
        <!-- Render chat between admin and customer  -->
        <section>
          <p>No available conversations</p>
        </section>
      </div>
    </div>
  </DefaultLayout>
</template>

<script>
import ChevronLeftIcon from "../../components/icons/ChevronLeftIcon.vue";
import Default from "../../layouts/Default.vue";

export default {
  components: {
    DefaultLayout: Default,
    ChevronLeftIcon,
  },

  data() {
    return {
      order: {
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
            images: [
              "https://res.cloudinary.com/dxiprgbcc/image/upload/v1731384424/pexels-pixabay-533280_e6wj1f.jpg",
            ],
          },
          {
            productId: "PROD-0002",
            productName: "Whole Milk",
            quantity: 1,
            unitPrice: 2.5,
            totalPrice: 2.5,
            images: [
              "https://res.cloudinary.com/dxiprgbcc/image/upload/v1731384424/pexels-pixabay-533280_e6wj1f.jpg",
            ],
          },
        ],
        deliveryAddress: "123 Main St, Springfield, USA",
        trackingNumber: "TRACK-56789",
      },
      // orderId: undefined,
    };
  },

  mounted() {
    // this.orderId = this.$route.params.id;
  },
};
</script>

<style lang="scss" scoped>
.go-back {
  button {
    border: 1px solid $primary-color;
    border-radius: 0.25rem;
    background-color: transparent;
    color: $primary-color;
    font-size: 0.85rem;
    display: flex;
    align-items: center;
    padding: 0.25rem 0.5rem;
    margin-top: 1rem;
    transition: 0.2s;
    opacity: 0.8;
    cursor: pointer;

    &:hover {
      opacity: 1;
    }

    .arrow-icon {
      width: 20px;
      height: 20px;
    }
  }
}
.product-details-container {
  padding: 2rem 0 3rem;
  display: grid;
  grid-template-columns: 1fr;
  grid-template-rows: auto;
  color: rgba($white, 0.7);

  @media screen and (min-width: 768px) {
    grid-template-columns: 1fr 1fr;
  }

  h2 {
    background: rgb(47, 47, 47);
    padding: 0.5rem;
    margin-top: 2rem;
  }

  section {
    padding: 1rem;

    .order-item {
      display: flex;
      align-items: center;
      border-bottom: 1px solid rgb(47, 47, 47);
      padding-block: 0.5rem;

      .product-image {
        width: 100px;
        height: auto;
        margin-right: 1rem;
      }
    }
  }
}
</style>
