<template>
  <div>
    <div class="container">
      <div class="items container__header">
        <h1 class="items__h1">
          <span>Upload Products File</span>
        </h1>
      </div>
      
      <div class="file-upload container__header">
        <label for="excel-file" class="custom-input">
          <UploadIcon class="upload-icon" />
          <span>Click to upload</span>

          <input 
            ref="fileInput" 
            type="file"
            accept=".xls, .xlsx"
            id="excel-file" 
            @change="handleFileSelect" 
            hidden
          />
        </label>

        <div>
          <div v-if="selectedFile" class="selected-file">
            <FileIcon v-if="!isUploading" class="file-icon" />
            <div class="file-name">
              <p>{{ selectedFile.name }}</p>

              <div v-if="isUploading" class="progress-bar">
                <div :style="{ width: progress + '%' }" class="progress-bar-fill"></div>
              </div>
            </div>

            <button @click="handleFileRemoval">
              <CircleXIcon />
            </button>
          </div>
        </div>

        <div>
          <button 
            @click="uploadFile"
            class="upload-btn btn auth__submit-btn"
            :class="{isLoading, showAuthBtn}"
            :disabled="!selectedFile" 
          >
            <span>Upload file</span> 
          </button>
        </div>

        <div v-if="uploadMessage">
          <p :class="['upload-message' , hasError ? 'error' : 'success']">{{ uploadMessage }}</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
const serverUrl = `https://server.development.payoor.store`;

export default {
  data() {
    return {
      selectedFile: null,
      isLoading: false,
      isUploading: false,
      fileLoaded: false,
      progress: 0,
      hasError: false,
      uploadMessage: '',
    };
  },
  computed: {
    showAuthBtn() {
      return this.selectedFile !== null;
    },
  },
  methods: {
    handleFileSelect(e) {
      const file = e.target.files[0];
      if (file) {
        // Validate file type to accept only Excel files
        const isExcelFile = file.type === 'application/vnd.ms-excel' || file.type === 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';

        if (!isExcelFile) {
          this.hasError = true;
          this.uploadMessage = 'Please select a valid Excel file (.xls or .xlsx)';
          this.selectedFile = null;
          this.fileLoaded = false;
          return;
        }

        this.selectedFile = file;
        this.hasError = false;
        this.uploadMessage = ''; // Clear any previous messages
        console.log(this.selectedFile);

        this.loadFile();
      }
    },

    handleFileRemoval() {
      this.selectedFile = null;
    },

    loadFile() {
      this.isUploading = true;
      this.fileLoaded = false;
      const reader = new FileReader();

      reader.onloadstart = () => {
        this.progress = 0;
      };

      reader.onprogress = (event) => {
        if (event.lengthComputable) {
          this.progress = Math.round((event.loaded / event.total) * 100);
        }
      };

      reader.onloadend = () => {
        this.progress = 100;
        this.isUploading = false;
        this.fileLoaded = true;
      };

      reader.onerror = () => {
        this.hasError = true;
        this.uploadMessage = 'Error loading file';
        this.isUploading = false;
      };

      reader.readAsDataURL(this.selectedFile);
    },

    async uploadFile() {
      if (!this.fileLoaded) return;
      this.isLoading = true;

      try {
        const formData = new FormData();
        formData.append('file', this.selectedFile);

        const response = await axios.post(`${serverUrl}/admin/upload/products/excel`, formData, {
          headers: {
            "Content-Type": "multipart/form-data",
          },
        });
        
        const { message } = response.data;
        this.uploadMessage = message;

        setTimeout(() => {
          this.redirectToProductsPage()
        }, 2000)

      } catch (error) {
        this.hasError = true;
        this.uploadMessage = 'Failed to upload file. Please try again.';
        console.log(error.response);
        

      } finally {
        this.isLoading = false;
        this.selectedFile = null;
      }
    },

    redirectToProductsPage() {
      this.$router.push("/all-products");
    },
  },
};
</script>

<style lang="scss" scoped>
.file-upload {
  width: auto;
  display: flex;
  flex-direction: column;
  gap: 1rem;
  margin-top: 2rem;

  .custom-input {
    width: #{scaleValue(500)};
    height: auto;
    padding: 1.5rem 2rem;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    border: 2px dashed $primary-color;
    border-radius: 0.5rem;
    gap: 0.5rem;
    color: rgba($white, 0.7);

    &:hover {
      opacity: 70%;
      cursor: pointer;
    }

    .upload-icon {
      width: 2rem;
      height: 2rem;
    }
  }

  .selected-file {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    width: #{scaleValue(500)};
    background-color: $grey-3;
    padding: 1rem 0.5rem;
    border-radius: 0.5rem;
    color: rgba($white, 0.7);

    .file-icon {
      color: $primary-color;
    }

    .file-name {
      flex-grow: 1;
      p {
        font-size: 0.85rem;
      }
    }

    button {
      background-color: transparent;
      border: none;
      color: rgba($white, 0.7);
      cursor: pointer;

      &:hover {
        opacity: 70%;
      }
    }

    .progress-bar {
      width: 90%;
      background-color: rgba($white, 0.7);
      height: 0.2rem;
      border-radius: 3px;

      &-fill {
        height: 100%;
        background-color: $primary-color;
        transition: width 0.5s;
        border-radius: 3px;
      }
    }
  }

  .upload-btn {
    background-color: $primary-color;
    font-size: 0.8rem;

    &:disabled {
      opacity: 50%;
      cursor: not-allowed;
    }
  }

  .upload-message {
    width: fit-content;
    font-size: 0.75rem;
    padding: 0.25rem 1rem;
    border-radius: 0.25rem;

    &.error {
      color: #d82b2b;
      background-color: rgba(255, 0, 0, 0.2);
      border: 1px solid #d82b2b;
    }

    &.success {
      color: $primary-color;
      background-color: rgba($primary-color, 0.2);
      border: 1px solid $primary-color;
    }
  }
}
</style>
