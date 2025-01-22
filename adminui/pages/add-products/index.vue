<template>
  <DefaultLayout 
    :page-text="$route.query.productId 
      ? 'Add Product Variant' 
      : 'Add Products'" 
    :description="$route.query.productId
      ? 'Add a new product variant'
      : 'Add a new product'"
  >
    <div class="form__container">
      <div class="header">
        <template v-if="!$route.query.productId">
          <p class="step"><strong>Step {{ step }}</strong></p>
          <p class="step-desc" v-if="step === 1">Create a product by inputting the name of the product</p>
          <p class="step-desc" v-if="step === 2">Add a variant of <strong>{{ product.name }}</strong></p>
        </template>

        <template v-else>
          <p>Add a variant of <strong>{{ product.name }}</strong></p>
        </template>  
      </div>

      <form v-if="step === 1" @submit.prevent="handleCreateProduct">
        <div class="form__group">
          <label for="productNname">Product Name</label>
          <input
            type="text"
            placeholder="Enter product name"
            v-model="productName"
          >
        </div>

        <button
          type="submit"
          class="submit-btn"
          :class="{ isLoading }"
        >
          <span>Next</span>
        </button>

        <Notification
          v-if="message"
          :message="message" 
          :isError="hasError"
        />
      </form>

      <Transition name="slide-fade">
        <form v-if="step === 2" @submit.prevent="handleAddVariant">
          <div class="form__group">
            <label for="unit">Unit</label>
            <input
              type="text"
              placeholder="Eg: De rica"
              v-model="unit"
            >
          </div>

          <div class="form__group">
            <label for="unit">Price</label>
            <input
              type="number"
              placeholder="0"
              v-model="price"
              min="0"
            >
          </div>

          <div class="checkbox">
            <input
              type="checkbox"
              v-model="isAvailable"
            >
            <label for="isAvailable">Variant is available</label>
          </div>

          <button
            type="submit"
            class="submit-btn"
            :class="{ isLoading }"
          >
            <span>Submit</span>
          </button>

          <Notification
            v-if="message"
            :message="message" 
            :isError="hasError"
          />

        </form>
      </Transition>
    </div>
  </DefaultLayout>
</template>

<script>
import Default from "../../layouts/Default.vue";
import { addProduct, addProductVariant, getSingleProduct } from "../../api";

export default {
  components: {
    DefaultLayout: Default,
  },

  data() {
    return {
      step: 1,
      isLoading: false,
      progress: 0,
      hasError: false,
      message: "",
      product: {},
      productId: undefined,
      productName: "",
      unit: "",
      price: 0,
      isAvailable: false,
    };
  },

  methods: {
    addProduct,
    addProductVariant,
    getSingleProduct,
    handleCreateProduct() {
      this.isLoading = true;
      this.addProduct({ productName: this.productName }).then(res => {
        console.log(res.data);
        this.product = res.data.product;
        this.message = res.data.message || 'Product created!';

        setTimeout(() => {
          this.isLoading = false;
          this.step = 2; 
          this.message = "";
        }, 2000);

      }).catch(error => {
        console.log(error.response.data);
        this.isLoading = false;
        this.hasError = true;
        this.message = error.response.data.message || 'Failed to create product';
      })
    },

    handleAddVariant() {
      this.isLoading = true;
      this.addProductVariant(this.productId ? this.productId : this.product._id, {
        unit: this.unit,
        price: this.price,
        isAvailable: this.isAvailable ? "YES" : "NO",
      }).then(res => {
        console.log(res.data);
        this.message = res.data.message || 'Product variant added!';

        setTimeout(() => {
          this.isLoading = false;
          this.redirectToProductsPage();
        }, 2000);

      }).catch(error => {
        console.log(error.response.data);
        this.isLoading = false;
        this.hasError = true;
        this.message = error.response.data.message || 'Failed to add product variant';
      })
    },

    redirectToProductsPage() {
      this.$router.push("/all-products");
    },
  },

  mounted() {
    if (this.$route.query.productId && this.$route.query.formStep) {
      this.productId = this.$route.query.productId;
      this.step = parseInt(this.$route.query.formStep);
    }

    if (this.productId) {
      this.getSingleProduct(this.productId)
        .then((response) => {
          this.product = response.data;
        })
        .catch((error) => {
          console.log(error.response);
          if (error.response.status === 401) {
            localStorage.removeItem('adminToken');
            localStorage.removeItem('adminUsername');
            this.$router.push('/');
          }
        });
    }
  }
};
</script>

<style lang="scss" scoped>
.header {
  color: $font-color;
  margin-top: 2rem;

  .step-desc {
    font-size: 0.9rem;
    opacity: 60%;
  }
}
form {
  .checkbox {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    color: $font-color;
    margin-bottom: 2rem;

    input[type="checkbox"] {
      cursor: pointer;
    }

    label {
      font-size: 0.9rem;
    }
  }
}
</style>
