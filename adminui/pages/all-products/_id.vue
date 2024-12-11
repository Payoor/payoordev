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
        <h2>Images</h2>
        <div class="image-list">
          <template v-if="productImages && productImages.length">
            <div 
              v-for="image, index in productImages"
              :key="index"
              class="product-image"
            >
              <button
                @click="openDeleteModal(image._id)"
                class="delete-btn"
              >
                <TrashIcon />
              </button>
              <img :src="image.imageUrl" alt="" />
            </div>
          </template>

          <template v-else>
            <div class="product-image-container">
              <PlaceholderImageIcon class="img-placeholder" />
            </div>
          </template>
        </div>

        <h2>Details</h2>
        <div class="details">
          <div class="table__container">
            <table>
              <thead>
                <tr>
                  <th v-for="value, key in tableHeaders" :key="key">
                    {{ key }}
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(value, key) in filteredProductDetails" :key="key">
                  <td v-for="(item, key) in value">
                    <template v-if="key === 'price'">
                      {{ formatAmount(item) }}
                    </template>
                    <template v-else>
                      {{ item }}
                    </template>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>

    <Transition name="fade">
      <Modal
        v-if="showDeleteModal"
        v-on:close-modal="closeDeleteModal"
        v-on:submit-form="deleteImage"
        :modal-header="'Delete Image'"
        :confirm-text="'Yes, proceed'"
        :is-loading="isLoading"
      >
        <template #modalContent>
          <p>Are you sure you want to delete this image?</p>
          <div v-if="message" class="notification">
            <Notification :message="message" :isError="hasError" />
          </div>
        </template>
      </Modal>
    </Transition>

  </DefaultLayout>
</template>

<script>
import { formatAmount } from "../../helpers";
import ChevronLeftIcon from "../../components/icons/ChevronLeftIcon.vue";
import PlaceholderImageIcon from "../../components/icons/PlaceholderImageIcon.vue";
import TrashIcon from "../../components/icons/TrashIcon.vue";
import Default from "../../layouts/Default.vue";
import { getProductImages, getSingleProduct, removeProductImage } from "../../api";

export default {
  components: {
    DefaultLayout: Default,
    ChevronLeftIcon,
    PlaceholderImageIcon,
    TrashIcon,
  },

  computed: {
    filteredProductDetails() {
      if (this.product) {
        const { _id, images, ...rest } = this.product;
        this.tableHeaders = rest[0];
        return rest;
      }
      return {};
    },
  },

  data() {
    return {
      product: {},
      tableHeaders: [],
      productId: undefined,
      productImages: [],
      isLoading: false,
      hasError: false,
      showDeleteModal: false,
      selectedImageId: null,
      message: "",
    };
  },

  methods: {
    formatAmount,
    getSingleProduct,
    getProductImages,
    removeProductImage,

    getImages() {
      this.getProductImages(this.productId)
      .then((response) => {
        this.productImages = response.data.images;
      })
      .catch((error) => {
        console.log(error.response);
      });
    },

    openDeleteModal(imageId) {
      this.selectedImageId = imageId;
      this.showDeleteModal = true;
    },

    closeDeleteModal() {
      this.showDeleteModal = false;
      this.message = "";
    },

    deleteImage() {
      this.hasError = false;
      this.isLoading = true;
      this.message = "";
      
      this.removeProductImage(this.selectedImageId).then((response) => {
        this.message = response.data.message;

        setTimeout(() => {
          this.isLoading = false;
          this.message = "";
          this.getImages();
          this.closeDeleteModal();
        }, 2000);

      }).catch((error) => {
        this.isLoading = false;
        this.hasError = true;
        this.message = "Failed to delete product. Please try again.";
        console.log(error.response.data);
      })
    }
  },

  mounted() {
    this.productId = this.$route.params.id;
    this.isLoading = true;
    this.getSingleProduct(this.productId)
      .then((response) => {
        this.isLoading = false;
        this.product = response.data;
      })
      .catch((error) => {
        console.log(error.response);
      });

    this.getImages()
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
      background-color: rgb(47, 47, 47);
      padding: 0.5rem;
    }

    // @media screen and (min-width: 1024px) {
    //   grid-template-columns: 1fr 1fr;
    // }

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
      padding: 0 1rem;

      p {
        font-size: 0.85rem;
      }

      .table__container {
        margin-top: 0 !important;
      }
    }
  }
}
</style>
