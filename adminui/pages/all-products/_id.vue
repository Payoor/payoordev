<template>
  <DefaultLayout :page-text="'Product Details'">
    <div class="go-back">
      <button @click="$router.push('/all-products')">
        <ChevronLeftIcon class="arrow-icon" />
        Go back
      </button>
    </div>
    <div class="product-details-container">
      <div class="details-wrapper">
        <div class="">
          <div class="product-image">
            <template v-if="productImages && productImages.length !== 0">
              <img :src="productImages[0].imageUrl" alt="" />
            </template>
            <template v-else>
              <PlaceholderImageIcon class="img-placeholder" />
            </template>
          </div>
        </div>

        <div class="details">
          <h2 class="name">{{ product.NAME }}</h2>
          <p class="price">
            <strong>Price: </strong>{{ formatAmount(product.PRICE) }}
          </p>
          <p class="category">
            <strong>Category: </strong>{{ product.CATEGORY }}
          </p>
          <p class="unit"><strong>Unit: </strong>{{ product.UNIT }}</p>
        </div>
      </div>
    </div>
  </DefaultLayout>
</template>

<script>
import { formatAmount } from "../../helpers";
import ChevronLeftIcon from "../../components/icons/ChevronLeftIcon.vue";
import PlaceholderImageIcon from "../../components/icons/PlaceholderImageIcon.vue";
import Default from "../../layouts/Default.vue";
import { getProductImages, getSingleProduct } from "../../api";

export default {
  components: {
    DefaultLayout: Default,
    ChevronLeftIcon,
    PlaceholderImageIcon,
  },

  data() {
    return {
      product: {},
      productId: undefined,
      productImages: [],
    };
  },

  methods: {
    formatAmount,
    getSingleProduct,
    getProductImages
  },

  mounted() {
    this.productId = this.$route.params.id;

    this.getSingleProduct(this.productId).then((response) => {
      this.product = response.data;
    }).catch((error) => {
      console.log(error.response);
    });

    this.getProductImages(this.productId).then((response) => {
      this.productImages = response.data.images;
    }).catch((error) => {
      console.log(error.response)
    })
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

  .details-wrapper {
    display: grid;
    grid-template-columns: 1fr;
    grid-template-rows: auto;
    color: rgba($white, 0.7);
    gap: 2rem;

    @media screen and (min-width: 1024px) {
      grid-template-columns: 1fr 1fr;
    }

    .product-image {
      width: 100%;
      height: 400px;
      background-color: rgb(47, 47, 47);
      border-radius: 0.5rem;
      display: flex;
      justify-content: center;
      align-items: center;
      overflow: hidden;

      img {
        width: 100%;
        height: 100%;
        object-fit: cover;
      }

      .img-placeholder {
        color: rgb(77, 77, 77);
        width: 10rem;
        height: 10rem;
      }
    }

    .details {
      color: rgba($white, 0.7);
      padding: 1rem 0;
      align-self: center;
      display: grid;
      gap: 1rem;

      p {
        font-size: 0.85rem;
      }
    }
  }
}
</style>
