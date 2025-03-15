<template>
  <div class="productcard">
    <div class="productcard__content">
      <div class="productcard__details--toparea">
        <button class="productcard__details--optionsbtn">
          <span v-if="product.variantCount >= 1">{{ product.variantCount }}</span>
          <span v-if="product.variantCount >= 1">{{
            product.variantCount > 1 ? "Options" : "Option"
          }}</span>
          <span v-if="product.variantCount == 0">1 Option</span>
          <span class="dropdown" v-if="product.variantCount >= 1">
            <svg>
              <use v-bind:xlink:href="'/symbol-defs.svg#icon-keyboard_arrow_down'"></use>
            </svg>
          </span>
        </button>

        <div class="productcard__optiondiv">
          <ProductOptions
            :productoptions="productoptions"
            :productname="product.name"
            :productid="product._id"
          />
        </div>

        <button class="productcard__details--bookmarkbtn">
          <svg>
            <use v-bind:xlink:href="'/symbol-defs.svg#icon-heart2'"></use>
          </svg>
        </button>
      </div>

      <div class="productcard__details--imgarea">
        <div class="productcard__details--tags">
          <span
            v-for="(tag, index) in tags"
            :key="index"
            class="tag"
            @click="searchtag(tag)"
          >
            {{ tag }}
          </span>
        </div>
        <figure class="productcard__details--img">
          <img
            :src="
              productdata.image
                ? productdata.image
                : '@/assets/imgs/a5048d7f-3eb1-4291-80dd-772b9618b3aa-removebg-preview.png'
            "
          />
        </figure>
      </div>

      <div class="productcard__name">
        <p class="productcard__name--p">
          {{ product.name }}
        </p>
      </div>

      <div class="productcard__details">
        <div class="productcard__details--top">
          <div
            class="productcard__details--price"
            v-if="priceRange.min != priceRange.max"
          >
            <p>₦{{ priceRange.min }} - ₦{{ priceRange.max }}</p>
          </div>

          <div
            class="productcard__details--price"
            v-if="priceRange.min == priceRange.max"
          >
            <p>₦{{ priceRange.min }}</p>
          </div>

          <!--<div class="productcard__details--addremovebtns">
            <div class="productcard__details--addremove">
              <button>
                <span>
                  <svg>
                    <use v-bind:xlink:href="'/symbol-defs.svg#icon-minus1'"></use>
                  </svg>
                </span>
              </button>
              <p class="amount">{{ amount }}</p>
              <button>
                <span>
                  <svg>
                    <use v-bind:xlink:href="'/symbol-defs.svg#icon-plus'"></use>
                  </svg>
                </span>
              </button>
            </div>
          </div>-->
        </div>

        <div class="productcard__details--bottom"></div>
      </div>
    </div>
  </div>
</template>

<script>
import { search_url } from "@/api";

export default {
  props: ["product"],
  data() {
    return {
      amount: 0,
      productdata: {},
      productoptions: [],
      priceRange: {},
    };
  },
  computed: {
    tags() {
      return this.product.metadata && this.product.metadata.length
        ? this.product.metadata.split(",")
        : [];
    },
    searchcontent() {
      return this.$route.query.searchcontent;
    },
  },
  watch: {
    productdata(newValue) {
      if (newValue) {
        this.getProductOptions();
      }
    },
    productoptions(newValue) {
      if (newValue) {
        const priceRange = this.calculatePriceRange(newValue);
        this.priceRange = priceRange;
        console.log(priceRange, "priceRange");
      }
    },
  },
  mounted() {
    this.getProductData();
  },
  methods: {
    async searchtag(tag) {
      try {
        this.$router.push({
          path: "/search",
          query: {
            user: this.user_id,
            searchcontent: `${tag}, ${this.searchcontent}`,
          },
        });

        this.$store.dispatch("handlesearch", { query: tag });
      } catch (error) {
        console.log(error);
      }
    },
    async toggleBookMark() {
      try {
      } catch (error) {
        console.log(error);
      }
    },
    async getProductOptions() {
      try {
        const encodedProductId = encodeURIComponent(this.product._id);

        const response = await fetch(
          `${search_url}/product/variants?product_id=${encodedProductId}`,
          {
            method: "GET",
            headers: {
              "Content-Type": "application/json",
              Origin: search_url,
            },
          }
        );

        if (!response.ok) {
          const errorData = await response.json();
          throw new Error(errorData.error || "Failed to fetch product");
        }

        const data = await response.json();
        const productoptions = data.data.product_variants;
        this.productoptions = productoptions;

        console.log(productoptions, "data here");
      } catch (error) {
        console.log(error);
      }
    },
    async getProductData() {
      try {
        const encodedProductId = encodeURIComponent(this.product._id);

        const response = await fetch(
          `${search_url}/product/get/byid?product_id=${encodedProductId}`,
          {
            method: "GET",
            headers: {
              "Content-Type": "application/json",
              Origin: search_url,
            },
          }
        );

        if (!response.ok) {
          const errorData = await response.json();
          throw new Error(errorData.error || "Failed to fetch product");
        }

        const data = await response.json();
        //console.log(data);
        const productdata = data.data.product_data;
        console.log(productdata, "productdata");
        this.productdata = productdata;
        return data;
      } catch (error) {
        console.log(error);
      }
    },
    calculatePriceRange(items) {
      if (!items || items.length === 0) {
        return { min: 0, max: 0, formattedRange: "0" };
      }

      const prices = items
        .map((item) => item.price)
        .filter((price) => price !== undefined && price !== null && !isNaN(price));

      if (prices.length === 0) {
        return { min: 0, max: 0, formattedRange: "0" };
      }

      const minPrice = Math.min(...prices);
      const maxPrice = Math.max(...prices);

      let formattedRange;
      if (minPrice === maxPrice) {
        formattedRange = `${minPrice}`;
      } else {
        formattedRange = `${minPrice} - ${maxPrice}`;
      }

      return {
        min: minPrice,
        max: maxPrice,
        formattedRange,
      };
    },
  },
};
</script>

<style lang="scss" scoped></style>
