<template>
  <div>
    <div class="searchview">
      <Header />

      <div class="searchview__main">
        <div class="searchview__searchinput">
          <div class="jumbotron__searcharea--input search-results" @click="opensearch">
            <input
              class="input search-results"
              placeholder="What would you like to eat..."
            />
            <span class="search-svg">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                width="63"
                height="64"
                viewBox="0 0 63 64"
                fill="none"
              >
                <path
                  fill-rule="evenodd"
                  clip-rule="evenodd"
                  d="M30.0286 0C46.5861 0 60.0541 13.468 60.0541 30.0255C60.0541 37.8373 57.0562 44.962 52.1504 50.3092L61.8036 59.9422C62.707 60.8456 62.7101 62.3071 61.8067 63.2105C61.3565 63.6668 60.7614 63.8919 60.1694 63.8919C59.5805 63.8919 58.9885 63.6668 58.5352 63.2167L48.7656 53.4743C43.6263 57.59 37.11 60.0541 30.0286 60.0541C13.4711 60.0541 0 46.583 0 30.0255C0 13.468 13.4711 0 30.0286 0ZM30.0286 4.625C16.021 4.625 4.625 16.0179 4.625 30.0255C4.625 44.0331 16.021 55.4291 30.0286 55.4291C44.0331 55.4291 55.4291 44.0331 55.4291 30.0255C55.4291 16.0179 44.0331 4.625 30.0286 4.625Z"
                  fill="white"
                ></path>
              </svg>
            </span>
          </div>
        </div>

        <div class="search-body" v-if="searchopen">
          <SearchBody :closesearch="closesearch" />
        </div>

        <div class="searchview__container">
          <div class="searchview__menu">
            <div class="searchview__menu--header">
              <h3>
                <span>Search results for</span>
                <span>{{ searchcontent }}...</span>
              </h3>
            </div>

            <div></div>
          </div>

          <div class="searchview__products">
            <div v-for="(product, index) in products" :key="product.id || index">
              <ProductCard :product="product" />
            </div>
          </div>
          <div class="searchview__getmoretrig" ref="loadMoreTrigger">
            {{ isLoading ? "Loading more products..." : "" }}
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState } from "vuex";

import searchInput from "@/mixins/searchInput";

export default {
  data() {
    return {
      observer: null,
      isLoading: false,
      currentOffset: 0,
      limit: 10,
    };
  },
  mixins: [searchInput],
  computed: {
    ...mapState({
      products: (state) => state.products,
      productstotal: (state) => state.productstotal,
    }),
    user_id() {
      return this.$route.query.user;
    },
    searchcontent() {
      return this.$route.query.searchcontent;
    },
  },
  mounted() {
    this.$store.dispatch("handlesearch", { query: this.searchcontent });
    this.setupIntersectionObserver();
  },
  beforeDestroy() {
    this.destroyIntersectionObserver();
  },
  methods: {
    setupIntersectionObserver() {
      const options = {
        root: null,
        rootMargin: "0px",
        threshold: 0.1,
      };

      this.observer = new IntersectionObserver((entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting && !this.isLoading) {
            this.loadMoreProducts();
          }
        });
      }, options);

      if (this.$refs.loadMoreTrigger) {
        this.observer.observe(this.$refs.loadMoreTrigger);
      }
    },
    async loadMoreProducts() {
      if (this.isLoading) return;

      this.isLoading = true;

      try {
        await this.$store.dispatch("handlegetmore", {
          query: this.searchcontent,
          offset: this.currentOffset,
          limit: this.limit,
        });

        this.currentOffset += this.limit;
      } catch (error) {
        console.error("Error loading more products:", error);
      } finally {
        this.isLoading = false;
      }
    },
    destroyIntersectionObserver() {
      if (this.observer) {
        this.observer.disconnect();
        this.observer = null;
      }
    },
  },
};
</script>

<style scoped lang="scss">
.searchview {
  min-height: 100vh;
  background: $white;

  //development
  //padding: 3rem;

  &__getmoretrig {
    display: flex;
    justify-content: center;
  }

  &__main {
    //background: red;
  }

  &__searchinput {
    margin: 0 auto;
    display: flex;
    justify-content: center;
  }

  &__menu {
    width: 100%;
    max-width: 118rem;
    margin: 0 auto;
    padding: 4rem 2rem;

    &--header {
      & h3 {
        font-size: 2.5rem;
        color: $primary-color;

        & span {
          &:nth-child(1) {
            color: $black;
          }
        }
      }
    }
  }

  &__products {
    display: flex;
    flex-wrap: wrap;
    justify-content: flex-start; /* Keep cards aligned to the start */
    gap: 2rem;

    width: 100%;
    max-width: 118rem;
    margin: 0 auto;

    padding: 20px;
  }
}
</style>
