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
        <h2>Details</h2>
        <section>
          <div v-for="(value, key) in filteredOrderDetails" :key="key">
            <template v-if="key !== 'items' && key !== 'userId' && key !== 'total'">
              <p>
                <strong>{{ key }}:</strong> {{ isDate(value) ? timestampToDateString(value) : value }}
              </p>
            </template>
            <template v-if="key === 'total'">
              <p>
                <strong>{{ key }}:</strong> {{ formatAmount(value) }}
              </p>
            </template>
          </div>
        </section>

        <h2>User Details</h2>
        <section>
          <div v-for="(value, key) in order.userId" :key="key">
            <p>
              <strong>{{ key }}:</strong> {{ value }}
            </p>
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
                <template v-if="itemKey !== 'images' && itemKey !== 'product_units'">
                  <p>
                    <strong>{{ itemKey }}:</strong> {{ itemValue }}
                  </p>
                </template>
                <template v-if="itemKey === 'product_units'">
                  <div class="product-units">
                    <div 
                      v-for="item, key in itemValue"
                      :key="key"
                    >
                      <p><strong>{{ key }}</strong></p>
                      <p>Price: {{ formatAmount(item.price) }}</p>
                      <p>Quantity: {{ item.quantity }}</p>
                    </div>
                  </div>
                </template>
              </div>
            </div>
          </div>
        </section>
      </div>
    </div>
  </DefaultLayout>
</template>

<script>
import { getOrder } from "../../api";
import ChevronLeftIcon from "../../components/icons/ChevronLeftIcon.vue";
import { formatAmount, timestampToDateString } from "../../helpers";
import Default from "../../layouts/Default.vue";

export default {
  components: {
    DefaultLayout: Default,
    ChevronLeftIcon,
  },

  computed: {
    filteredOrderDetails() {
      if (this.order) {
        const { _id, __v, ...rest } = this.order;
        return rest;
      }
      return {};
    },
  },

  data() {
    return {
      order: {},
      orderId: undefined,
    };
  },

  methods: {
    getOrder,
    timestampToDateString,
    formatAmount,
    isDate(value) {
      if (typeof value !== "string") return false;

      // Check if the string can be converted to a valid Date
      const date = new Date(value);
      return !isNaN(date.getTime());
    },
  },

  mounted() {
    this.orderId = this.$route.params.id;

    this.getOrder(this.orderId)
      .then((response) => {
        this.order = response.data.data;
      })
      .catch((error) => {
        console.log(error.response);
        console.log(error.response);
        if (error.response.status === 401) {
          localStorage.removeItem('adminToken');
          localStorage.removeItem('adminUsername');
          this.$router.push('/');
        }
      });
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
    background-color: $white;
    box-shadow: 0px 0px 5px -2px #32475c4d;
    color: $font-color;
    padding: 0.5rem;
    margin-top: 2rem;
  }

  section {
    padding: 1rem;

    p {
      color: $font-color;
    }

    .order-item {
      display: flex;
      align-items: center;
      border-bottom: 1px solid $grey;
      padding-block: 0.5rem;

      .product-image {
        width: 100px;
        height: auto;
        margin-right: 1rem;
      }

      .product-units {
        display: flex;
        gap: 1rem;
        align-items: center;
        margin-block: 1rem;

        div {
          background-color: $white;
          box-shadow: 0px 0px 5px -2px #32475c4d;
          padding: 0.8rem;
          border-radius: 0.25rem;
        }
      }
    }
  }
}
</style>
