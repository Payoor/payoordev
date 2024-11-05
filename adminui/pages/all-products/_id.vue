<template>
  <div class="page__container">
    <div class="page__container-wrapper">
      <HeaderText :pageText="'Product Details'" />
      <div class="go-back">
        <button @click="$router.push('/all-products')">
          <ChevronLeftIcon class="arrow-icon"/>
          Go back
        </button>
      </div>
      <div class="product-details-container">
        <div class="details-wrapper">
          <div class="">
            <div class="product-image">
              <template v-if="product.images && product.images.length !== 0">
                <img :src="product.images[0]" alt="">
              </template>
              <template v-else>
                <PlaceholderImage class="img-placeholder" />
              </template>
            </div>
          </div>

          <div class="details">
            <h2 class="name">{{ product.NAME }}</h2>
            <p class="price"><strong>Price: </strong>{{ formatAmount(product.PRICE) }}</p>
            <p class="category"><strong>Category: </strong>{{ product.CATEGORY }}</p>
            <p class="unit"><strong>Unit: </strong>{{ product.UNIT }}</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import { formatAmount } from '../../helpers';

const serverUrl = `https://server.development.payoor.store`;

export default {
  data() {
    return {
      product: {},
      productId: undefined,
      productImages: [],
    }
  },

  methods: {
    formatAmount,
    async getProductById () {
      try {
        const response = await axios.get(`${serverUrl}/admin/get/product?id=${this.productId}`);

        this.product = response.data;
        console.log(this.product);

      } catch (error) {
        console.log(error);
      }
    },

    async getProductImages () {
      try {
        const response = await axios.get(`${serverUrl}/admin/product/images?id=${this.productId}`);

        this.productImages = response.data.images;
        console.log(this.productImages);
        

      } catch (error) {
        console.log(error);
      }
    }
  },

  mounted() {
    this.productId = this.$route.params.id;
    this.getProductById();
    this.getProductImages();
  },
}
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
    color: rgba($white, .7);
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
      color: rgba($white, .7);
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
