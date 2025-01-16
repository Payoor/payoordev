<template>
  <DefaultLayout :page-text="'User Details'">
    <div class="go-back">
      <button @click="$router.push('/users')">
        <ChevronLeftIcon class="arrow-icon" />
        Go back
      </button>
    </div>
    <div class="product-details-container">
      <div class="details-wrapper">
        <h2>Details</h2>
        <div class="details">
          <div v-for="(value, key) in user" :key="key">
            <p>
              <strong>{{ key }}:</strong> {{ value }}
            </p>
          </div>
        </div>
      </div>
    </div>
  </DefaultLayout>
</template>

<script>
import { formatAmount } from "../../helpers";
import ChevronLeftIcon from "../../components/icons/ChevronLeftIcon.vue";
import PlaceholderImageIcon from "../../components/icons/PlaceholderImageIcon.vue";
import TrashIcon from "../../components/icons/TrashIcon.vue";
import Default from "../../layouts/Default.vue";
import { getProductImages, getSingleProduct, removeProductImage, getUser } from "../../api";

export default {
  components: {
    DefaultLayout: Default,
    ChevronLeftIcon,
    PlaceholderImageIcon,
    TrashIcon,
  },

  data() {
    return {
      user: {},
      userId: undefined,
      isLoading: false,
      hasError: false,
    };
  },

  methods: {
    formatAmount,
    getSingleProduct,
    getProductImages,
    removeProductImage,
    getUser,

    fetchUser() {
      this.getUser(this.userId)
      .then((response) => {
        this.user = response.data.data.user;
        console.log(response.data)
      })
      .catch((error) => {
        console.log(error.response);
        if (error.response.status === 401) {
          localStorage.removeItem('adminToken');
          localStorage.removeItem('adminUsername');
          this.$router.push('/');
        }
      });
    },
  },

  mounted() {
    this.userId = this.$route.params.id;
    this.fetchUser()
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

    h2 {
      background-color: $white;
      box-shadow: 0px 0px 5px -2px #32475c4d;
      color: $font-color;
      padding: 0.5rem;
    }

    .image-list {
      width: 100%;
      display: flex;
      justify-content: space-between;
      overflow-x: auto;
      overflow-y: hidden;
      gap: 1rem;
      white-space: nowrap;

      .product-image {
        min-width: 400px;
        max-width: 400px;
        height: 400px;
        display: inline-block;
        position: relative;

        img {
          width: 100%;
          height: 100%;
          object-fit: cover;
          border-radius: 0.5rem;
        }

        button {
          position: absolute;
          top: 0.5rem;
          right: 0.5rem;
          padding: 0.5rem;
          border: none;
          background-color: rgb(47, 47, 47);
          color: rgba($white, 0.7);
          border-radius: 0.25rem;
          cursor: pointer;
        }
      }

      .product-image-container {
        width: 400px;
        height: 400px;
        background-color: rgb(47, 47, 47);
        border-radius: 0.5rem;
        display: flex;
        justify-content: center;
        align-items: center;
        overflow: hidden;

        .img-placeholder {
          color: rgb(77, 77, 77);
          width: 10rem;
          height: 10rem;
        }
      }
    }

    .details {
      color: rgba($white, 0.7);
      align-self: center;
      display: grid;
      gap: 1rem;

      p {
        font-size: 0.85rem;
        color: $font-color;
      }
    }
  }
}
</style>
