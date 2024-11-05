<template>
  <div class="page__container">
    <div class="page__container-wrapper">
      <HeaderText :pageText="'Products'" />

      <template v-if="products">
        <div class="table__container">
          <table>
            <thead>
              <tr>
                <th v-for="header, idx in getTableHeaders" :key="idx">{{ header.toLowerCase() }}</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="data, rowIndex in editableTableData" :key="rowIndex">
                <td>{{ data["S/N"] }}</td>
                <td
                  v-for="(value, key, colIndex) in data"
                  :key="colIndex"
                  v-if="key !== 'S/N' && key !== '_id'"
                  @click="editCell(rowIndex, colIndex)"
                >
                  <div v-if="isEditingCell(rowIndex, colIndex)">
                    <input
                      type="text"
                      v-model="editableTableData[rowIndex][key]"
                      @blur="saveEdit(rowIndex, key)"
                      @keyup.enter="saveEdit(rowIndex, key)"
                    />
                  </div>
                  <div v-else>{{ value }}</div>
                </td>

                <td class="actions-cell">
                  <button class="actions-toggle" @click="toggleDropdown(rowIndex)">...</button>
                  <div v-if="dropdownIndex === rowIndex" class="dropdown">
                    <button @click="viewProduct(data._id)">View Product</button>
                    <button @click="openImageModal(data._id)">Add Image</button>
                    <button @click="openDeleteModal(data._id)">Delete Product</button>
                  </div>
                </td>

              </tr>
            </tbody>
          </table>
        </div>
      </template>

      <template v-if="!products">
        <EmptyProduct />
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
                {{ selectedImage ? 'Choose another image' : 'Choose image' }}
                <input 
                  type="file" 
                  accept="image/*" 
                  id="product-img"
                  @change="handleImageSelect"
                  hidden
                >
              </label>

              <div v-if="imagePreview" class="preview">
                <img :src="imagePreview" alt="preview of selected image">

                <span>{{ selectedImage.name }}</span>
              </div>
              
              <div v-if="message" class="notification">
                <Notification 
                  :message="message"
                  :isError="hasError"
                />
              </div>
            </div>
          </template>
        </Modal>
      </Transition>

      <Transition name="fade">
        <Modal 
          v-if="showDeleteModal"
          v-on:close-modal="showDeleteModal = false"
          v-on:submit-form="deleteProduct"
          :modal-header="'Delete Product'"
          :confirm-text="'Yes, proceed'"
          :is-loading="isLoading"
        >
          <template #modalContent>
            <p>Are you sure you want to delete this product?</p>
            <div v-if="message" class="notification">
              <Notification 
                :message="message"
                :isError="hasError"
              />
            </div>
          </template>
        </Modal>
      </Transition>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

const serverUrl = `https://server.development.payoor.store`;

export default {
  data () {
    return {
      products: [],
      editableTableData: [],
      editingCell: { row: null, col: null },
      dropdownIndex: null,
      showImageModal: false,
      showDeleteModal: false,
      selectedProductId: null,
      selectedImage: null,
      imagePreview: null,
      isLoading: false,
      message: "",
      hasError: false,
    }
  },
  computed: {
    getTableHeaders () {
      return this.products.length
        ? ['S/N', ...Object.keys(this.products[0]).filter(key => key !== '_id')]
        : [];
    },
  },

  methods: {
    async fetchProducts() {
      try {
        const response = await axios.get(`${serverUrl}/admin/get/products`);
        this.products = response.data.products;
        
        this.editableTableData = this.products.map((item, index) => ({
          'S/N': index + 1,
          ...Object.fromEntries(
            Object.entries(item).filter(([key]) => key !== '_id')
          ),
          _id: item._id // Keep the _id for sending updates
        })); 

      } catch (error) {
        console.log(error.response.data.message)
      }
    },

    editCell (rowIndex, colIndex) {
      this.editingCell = { row: rowIndex, col: colIndex };
    },

    isEditingCell (row, col) {
      return this.editingCell.row === row && this.editingCell.col === col;
    },

    async saveEdit (rowIndex, colKey) {
      const editedProduct = { ...this.editableTableData[rowIndex] };
      const productId = editedProduct._id;
      delete editedProduct["S/N"];

      try {
        // Send the update request to the server
        const response = await axios.patch(`${serverUrl}/admin/update/product?id=${productId}`, editedProduct);

        if (response.status == 200){
          this.fetchProducts();
          console.log(`Successfully updated row ${rowIndex + 1}, column ${colKey}`);
        }

      } catch (error) {
        console.error("Error updating product:", error);
      }

      // Clear the editing cell
      this.editingCell = { row: null, col: null };
    },

    viewProduct (productId) {
      this.$router.push(`/all-products/${productId}`);
    },

    toggleDropdown (index) {
      this.dropdownIndex = this.dropdownIndex === index ? null : index;
    },

    openImageModal (productId) {
      this.dropdownIndex = null;
      this.selectedProductId = productId;
      this.showImageModal = true;
    },

    closeImageModal () {
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

    async uploadImage() {
      this.hasError = false;
      this.isLoading = true;
      this.message = "";

      try {
        const formData = new FormData();
        formData.append("file", this.selectedImage);

        const response = await axios.post(`${serverUrl}/admin/upload/product/image?id=${this.selectedProductId}/image`, formData);
        
        this.selectedImage = null;
        this.imagePreview = null;

        const { message } = response.data;
        this.message = message;

        console.log("Image uploaded successfully");

        setTimeout(() => {
          this.isLoading = false;
          this.message = "";
          this.closeImageModal();
        }, 2000)

      } catch (error) {
        this.isLoading = false;
        this.hasError = true;
        this.message = 'Failed to upload product image. Please try again.';
        console.error("Error uploading image:", error.response);
      }
    },

    openDeleteModal (productId) {
      this.dropdownIndex = null;
      this.selectedProductId = productId;
      this.showDeleteModal = true;
    },

    closeDeleteModal () {
      this.showDeleteModal = false;
      this.message = "";
    },

    async deleteProduct () {

      this.hasError = false;
      this.isLoading = true;
      this.message = "";

      try {
        const response = await axios.delete(`${serverUrl}/admin/delete/product?id=${this.selectedProductId}`);
        console.log("Product deleted successfully");

        const { message } = response.data;
        this.message = message;

        setTimeout(() => {
          this.isLoading = false;
          this.message = "";
          this.fetchProducts();
          this.closeDeleteModal();
        }, 2000)

      } catch (error) {
        this.isLoading = false;
        this.hasError = true;
        this.message = 'Failed to delete product. Please try again.';
        console.error("Error deleting product:", error.response);
      }
    }
  },

  mounted() {
    this.fetchProducts();
  }
}
</script>

<style lang="scss" scoped>
  input {
    width: 100%;
    background-color: transparent;
    border: none;
    padding: 0.5rem;
    color: rgba($white, .5);
    font-size: 1rem;

    &::placeholder {
      font-size: 1rem;
    }

    &:focus {
      outline: none;
      border: 1px solid rgb(47, 47, 47);
    }
  }

  .actions-cell {
    position: relative;

    .actions-toggle {
      padding-inline: 1rem;
      background-color: transparent;
      color: rgba($white, .5);
      border: none;
      font-size: 1.5rem;
      font-weight: bold;
      cursor: pointer;
    }

    .dropdown {
      position: absolute;
      width: 150px;
      height: auto;
      display: grid;
      background-color: rgb(47, 47, 47);
      z-index: 1;
      left: -100%;
      top: 100%;
      border-radius: 0.25rem;

      @media screen and (min-width: 768px) {
        left: -50%;
      }

      @media screen and (min-width: 1024px) {
        left: -30%;
      }
      
      button {
        background-color: transparent;
        color: rgba($white, .5);
        border: none;
        font-size: 0.8rem;
        padding: 1rem;
        text-align: left;
        transition: 0.2s;
        cursor: pointer;

        &:hover {
          opacity: 0.7;
        }
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
      transition: .2s;
      opacity: 0.5;

      &:hover {
        opacity: .8;
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
        color: rgba($white, .5);
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
