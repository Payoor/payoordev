<template>
  <DefaultLayout :page-text="'Order Details'" description="View single order">
    <div class="go-back">
      <button @click="$router.push('/orders')">
        <ChevronLeftIcon class="arrow-icon" />
        Back
      </button>
    </div>
    <div class="product-details-container">
      <div>
        <div class="tabs-list">
          <a
            href="#"
            v-for="tab in ['Details', 'UserInfo', 'Items']"
            :class="{ active: activeTab === tab }"
            @click="switchTab(tab)"
          >
            {{ tab }}
            <div></div>
          </a>
        </div>

        <section>
          <Transition name="slide-fade-two">
            <div  v-if="activeTab === 'Details'">
              <div 
                v-for="(value, key) in filteredOrderDetails" :key="key"
                class="section"
              >
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
            </div>
          </Transition>
          
          <Transition name="slide-fade-two">
            <div v-if="activeTab === 'UserInfo'">
              <div v-for="(value, key) in order.userId" :key="key">
                <p>
                  <strong>{{ key }}:</strong> {{ value }}
                </p>
              </div>              
            </div>
          </Transition>

          <Transition name="slide-fade-two">
            <div v-if="activeTab === 'Items'">
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
            </div>
          </Transition>
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
      activeTab: "Details"
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

    switchTab(tab) {
      this.activeTab = tab;
    }
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

  @media screen and (min-width: 768px) {
    grid-template-columns: 1fr 1fr;
  }

  .tabs-list {
    margin-block: 1rem;
    padding-block: 0.5rem;
    border-bottom: 1px solid $grey-2;
    display: flex;
    gap: 2rem;
    align-items: center;

    a {
      width: fit-content;
      position: relative;
      text-decoration: none;
      color: rgba($font-color, .5);

      & div {
        position: absolute;
        display: none;
        width: 65px;
        height: 0.2rem;
        bottom: -0.55rem;
        background-color: $primary-color;
      }

      &.active {
        color: $primary-color;

        & div {
          display: block;
        }
      }

    }
  }

  section {
    padding: 1rem;
    background-color: $white;
    border-radius: 0.5rem;
    box-shadow: 0px 0px 5px -2px #32475c4d;
    min-height: 200px;
    max-height: calc(70vh - 6rem);
    overflow: auto;
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
