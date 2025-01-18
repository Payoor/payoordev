<template>
  <DefaultLayout :page-text="'Products'">
    <div class="search__container">
      <div></div>
      <div class="search__bar">
        <input 
          type="text"
          placeholder="Search..."
          v-model="search"
          @input="handleSearchInput"
        >
        <button 
          type="button"
          @click="handleSearchInput"
        >
          <SearchIcon />
        </button>
      </div>
    </div>

    <template v-if="products && products.length !== 0">
      <div class="table__container">
        <table>
          <thead>
            <tr>
              <th>S/N</th>
              <th>Image</th>
              <th v-for="(header, idx) in getTableHeaders" :key="idx">
                {{ header }}
              </th>
              <th>CreatedAt</th>
              <th>UpdatedAt</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr 
              v-for="(data, rowIndex) in editableTableData" 
              :key="rowIndex"
            >
              <td>{{ getIndex(rowIndex) }}</td>
              <td>
                <div class="image">
                  <img v-if="data.images" :src="data.images[0]" alt="">
                  <PlaceholderImageIcon v-else />
                </div>
              </td>
              <td
                v-for="(value, key, colIndex) in data"
                :key="colIndex"
                v-if="key !== '_id' && key !== 'updatedAt' && key !== 'createdAt' && key !== 'images'"
                @click="editCell(rowIndex, colIndex)"
              >
                <template v-if="key !== 'variants' && key !== 'createdAt' && key !== 'updatedAt' && key !== 'images'">
                  <div>
                    <input
                      v-if="isEditingCell(rowIndex, colIndex)"
                      type="text"
                      v-model="editableTableData[rowIndex][key]"
                      @blur="saveEdit(rowIndex)"
                      @keyup.enter="saveEdit(rowIndex)"
                      ref="editInput"
                    />
                    <div v-else>{{ value }}</div>
                  </div>
                </template>

                <template v-if="key === 'variants'">
                  <div class="add-variants" v-if="data.variants.length == 0">
                    <NuxtLink :to="{name: 'add-products', query: { productId: data._id, formStep: 2 }}">Add variants</NuxtLink>
                  </div>
                  <table v-else class="embedded-table">
                    <thead>
                      <tr>
                        <th>Image</th>
                        <th 
                          v-for="header in getEmbeddedTableHeaders(data.variants)" :key="header"
                          v-if="header !== '_id' && header !== 'productId' && header !== 'image'"
                        >
                          {{ header.toLowerCase() }}
                        </th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr
                        v-for="(row, subRowIndex) in data.variants" 
                        :key="subRowIndex"
                      >
                        <td>
                          <div class="image">
                            <img v-if="row.image" :src="row.image" alt="">
                            <PlaceholderImageIcon v-else />
                          </div>
                        </td>
                        <td
                          v-for="(cellValue, cellKey, cellIndex) in row"
                          v-if="cellKey !== '_id' && cellKey !== 'productId' && cellKey !== 'image'"
                          :key="cellIndex"
                          @click="editEmbeddedCell(rowIndex, subRowIndex, cellKey)"
                        >
                          <template v-if="cellKey !== '_id' && cellKey !== 'productId' && cellKey !== 'image'">
                            <div v-if="isEditingEmbeddedCell(rowIndex, subRowIndex, cellKey)">
                              <input
                                type="text"
                                v-model="editableTableData[rowIndex].variants[subRowIndex][cellKey]"
                                @blur="saveEdit(rowIndex)"
                                @keyup.enter="saveEdit(rowIndex)"
                                ref="editEmbeddedInput"
                              />
                            </div>
                            <div v-else>{{ cellValue }}</div>
                          </template>

                        </td>
                      </tr>
                    </tbody>
                  </table>
                </template>
              </td>

              <td>
                {{ data.createdAt ? timestampToDateString(data.createdAt) : "N/A" }}
              </td>
              
              <td>
                {{ data.updatedAt ? timestampToDateString(data.updatedAt) : "N/A" }}
              </td>

              <td>
                <div class="actions-cell">
                  <button
                    class="actions-toggle"
                    @click="toggleDropdown(rowIndex)"
                  >
                    ...
                  </button>
                  <div v-if="dropdownIndex === rowIndex" class="dropdown">
                    <button @click="viewProduct(data._id)">View Product</button>
                    <button @click="addVariant(data._id)">Add Product Variant</button>
                    <button @click="openImageModal(data._id)">Add Image</button>
                    <button @click="openDeleteModal(data._id)">
                      Delete Product
                    </button>
                  </div>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <Pagination
        v-if="totalPages > 1"
        :totalPages="totalPages"
        :perPage="limit"
        :currentPage="currentPage"
        @pagechanged="onPageChange"
      />
    </template>

    <template v-else>
      <EmptyState />
    </template>

    <Transition name="fade">
      <Modal
        v-if="showImageModal"
        v-on:close-modal="closeImageModal"
        v-on:submit-form="uploadImage"
        :modal-header="'Upload Product Image'"
        :confirm-text="'Upload'"
        :is-loading="isLoading"
      >
        <template #modalContent>
          <div class="upload-img">
            <label for="product-img">
              {{ selectedImage ? "Choose another image" : "Choose image" }}
              <input
                type="file"
                accept="image/*"
                id="product-img"
                @change="handleImageSelect"
                hidden
              />
            </label>

            <div v-if="imagePreview" class="preview">
              <img :src="imagePreview" alt="preview of selected image" />

              <span>{{ selectedImage.name }}</span>
            </div>

            <div v-if="message" class="notification">
              <Notification :message="message" :isError="hasError" />
            </div>
          </div>
        </template>
      </Modal>
    </Transition>

    <Transition name="fade">
      <Modal
        v-if="showDeleteModal"
        v-on:close-modal="closeDeleteModal"
        v-on:submit-form="deleteProduct"
        :modal-header="'Delete Product'"
        :confirm-text="'Yes, proceed'"
        :is-loading="isLoading"
      >
        <template #modalContent>
          <p>Are you sure you want to delete this product?</p>
          <div v-if="message" class="notification">
            <Notification :message="message" :isError="hasError" />
          </div>
        </template>
      </Modal>
    </Transition>
  </DefaultLayout>
</template>

<script>
import Default from "../../layouts/Default.vue";

import { 
  getAllProducts,
  updateProductDetails,
  uploadProductImage,
  removeProduct 
} from "../../api";
import SearchIcon from "../../components/icons/SearchIcon.vue";
import PlaceholderImageIcon from "../../components/icons/PlaceholderImageIcon.vue";
import { useDebounce } from "../../utils";
import { isDate, timestampToDateString } from "../../helpers";

export default {
  components: {
    DefaultLayout: Default,
    SearchIcon,
    PlaceholderImageIcon
  },

  computed: {
    getTableHeaders() {
      return this.products.length
        ? [
            ...Object.keys(this.products[0]).filter((key) => key !== "_id" && key !== "updatedAt" && key !== "createdAt" && key !== "images"),
          ]
        : [];
    },
  },

  data() {
    return {
      products: [],
      editableTableData: [],
      editingCell: { row: null, col: null },
      editingEmbeddedCell: { parentRow: null, row: null, key: null },
      dropdownIndex: null,
      showImageModal: false,
      showDeleteModal: false,
      selectedProductId: null,
      selectedImage: null,
      imagePreview: null,
      isLoading: false,
      message: "",
      hasError: false,
      totalPages: 0,
      currentPage: 1,
      limit: 10,
      search: "",
      debouncedSearchTerm: "",
    };
  },

  methods: {
    getAllProducts,
    updateProductDetails,
    removeProduct,
    uploadProductImage,
    isDate,
    timestampToDateString,
    fetchProducts() {
      this.getAllProducts({
        page: this.currentPage, 
        limit: this.limit,
        search: this.debouncedSearchTerm,
      }).then((response) => {
        this.products = response.data.products;
        this.currentPage = response.data.page;
        this.totalPages = response.data.totalPages;
  
        this.editableTableData = this.products.map((item, index) => ({
          ...Object.fromEntries(
            Object.entries(item).filter(([key]) => key !== "_id")
          ),
          _id: item._id, // Keep the _id for sending updates
        }));

      }).catch((error) => {
        console.log(error.response.data);
        if (error.response.status === 401) {
          localStorage.removeItem('adminToken');
          localStorage.removeItem('adminUsername');
          this.$router.push('/');
        }
      })
    },

    handleSearchInput: useDebounce(function () {
      this.debouncedSearchTerm = this.search;
      this.fetchProducts();
    }),

    getIndex(index) {
      return this.currentPage * this.limit - this.limit + index + 1;
    },

    editCell(rowIndex, colIndex) {
      if (this.isEditingCell(rowIndex, colIndex)) return; 
      
      this.editingCell = { row: rowIndex, col: colIndex };
      this.$nextTick(() => {
        const input = this.$refs.editInput;
        if (input && input[0]) input[0].focus();
      });
    },

    isEditingCell(row, col) {
      return this.editingCell.row === row && this.editingCell.col === col;
    },

    getEmbeddedTableHeaders(data) {
      return data.length ? Object.keys(data[0]) : [];
    },

    editEmbeddedCell(parentRowIndex, subRowIndex, key) {
      if (this.isEditingEmbeddedCell(parentRowIndex, subRowIndex, key)) return; 

      this.editingCell = { row: parentRowIndex, col: null };
      this.editingEmbeddedCell = { parentRow: parentRowIndex, row: subRowIndex, key };

      this.$nextTick(() => {
        const input = this.$refs.editEmbeddedInput;
        if (input && input[0]) input[0].focus();
      });
    },

    isEditingEmbeddedCell(parentRowIndex, subRowIndex, key) {
      return (
        this.editingEmbeddedCell &&
        this.editingEmbeddedCell.parentRow === parentRowIndex &&
        this.editingEmbeddedCell.row === subRowIndex &&
        this.editingEmbeddedCell.key === key
      );
    },

    saveEdit(rowIndex) {
      const editedProduct = { ...this.editableTableData[rowIndex] };
      const productId = editedProduct._id;
      delete editedProduct["S/N"];

      this.updateProductDetails(productId, editedProduct).then((res) => {
        this.fetchProducts();
        this.editingCell = { row: null, col: null };
      }).catch((error) => {
        console.error("Error updating product:", error);
      })
    },

    viewProduct(productId) {
      this.$router.push(`/all-products/${productId}`);
    },

    addVariant(productId) {
      this.$router.push(`/add-products?productId=${productId}&formStep=${2}`);
    },

    toggleDropdown(index) {
      this.dropdownIndex = this.dropdownIndex === index ? null : index;
    },

    openImageModal(productId) {
      this.dropdownIndex = null;
      this.selectedProductId = productId;
      this.showImageModal = true;
    },

    closeImageModal() {
      this.showImageModal = false;
      this.selectedImage = null;
      this.message = "";
    },

    handleImageSelect(e) {
      const file = e.target.files[0];
      this.selectedImage = file;
      if (file) {
        this.imagePreview = URL.createObjectURL(file);
      }
    },

    uploadImage() {
      this.hasError = false;
      this.isLoading = true;
      this.message = "";

      const formData = new FormData();
      formData.append("file", this.selectedImage);
      
      this.uploadProductImage(this.selectedProductId, formData).then((response) => {
        
        this.message = response.data.message;
        
        setTimeout(() => {
          this.selectedImage = null;
          this.imagePreview = null;
          this.isLoading = false;
          this.message = "";
          this.closeImageModal();
        }, 2000);

      }).catch((error) => {
        this.isLoading = false;
        this.hasError = true;
        this.message = "Failed to upload product image. Please try again.";
        console.log(error.response.data);
      });
    },

    openDeleteModal(productId) {
      this.dropdownIndex = null;
      this.selectedProductId = productId;
      this.showDeleteModal = true;
    },

    closeDeleteModal() {
      this.showDeleteModal = false;
      this.message = "";
    },

    deleteProduct() {
      this.hasError = false;
      this.isLoading = true;
      this.message = "";

      this.removeProduct(this.selectedProductId).then((response) => {
        this.message = response.data.message;

        setTimeout(() => {
          this.isLoading = false;
          this.message = "";
          this.fetchProducts();
          this.closeDeleteModal();
        }, 2000);

      }).catch((error) => {
        this.isLoading = false;
        this.hasError = true;
        this.message = "Failed to delete product. Please try again.";
        console.log(error.response.data);
      });
    },

    onPageChange(page) {
      this.currentPage = page;
      this.fetchProducts();
    }
  },

  mounted() {
    this.fetchProducts();
  },
};
</script>

<style lang="scss" scoped>
td {
  .add-variants {
    display: flex;
    justify-content: center;
    a {
      background-color: $primary-color;
      padding: 0.5rem 1rem;
      color: $white;
      font-size: 0.8rem;
      text-decoration: none;
      border-radius: 0.25rem;
      transition: .2s;

      &:hover {
        background-color: rgba($primary-color, .7);
      }
    }
  }

  input {
    width: 100%;
    background-color: transparent;
    border: none;
    padding: 0.5rem;
    color: $font-color;
    font-size: 1rem;
  
    &::placeholder {
      font-size: 1rem;
    }
  
    &:focus {
      outline: 1px solid $primary-color;
    }
  }

  .image {
    display: flex;
    justify-content: center;
    width: 4rem;
    height: 4rem;

    img {
      width: 100%;
      height: 100%;
      border-radius: 0.25rem;
      border: 1px solid $grey;
      box-shadow: 0px 0px 5px -2px #32475c4d;
    }

    svg {
      color: $grey-2;
      width: 100%;
      height: 100%;
    }
  }
}

.upload-img {
  width: 100%;
  display: grid;
  gap: 1rem;

  label {
    width: 100%;
    border: 2px dashed $white;
    border-radius: 0.25rem;
    padding: 0.5rem 1rem;
    color: $white;
    cursor: pointer;
    transition: 0.2s;
    opacity: 0.5;

    &:hover {
      opacity: 0.8;
    }
  }

  .preview {
    width: 100%;
    height: 300px;
    border-radius: 0.5rem;

    @media screen and (min-width: 768px) {
      height: 400px;
    }

    img {
      width: 100%;
      height: 90%;
      background-color: rgba(0, 0, 0, 0.39);
      object-fit: contain;
      border-radius: 0.5rem;
    }

    span {
      color: rgba($white, 0.5);
      font-size: 0.75rem;
      padding: 0.2rem 0;
    }
  }
}

.notification {
  width: 100%;
  display: flex;
  justify-content: center;
  margin-top: 0.5rem;
}
</style>
