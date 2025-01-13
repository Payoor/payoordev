<template>
  <DefaultLayout :page-text="'Add Products'">
    <div class="file-upload">
      <label for="excel-file" class="custom-input">
        <UploadIcon class="upload-icon" />
        <span>Click to upload products list</span>

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
              <div
                :style="{ width: progress + '%' }"
                class="progress-bar-fill"
              ></div>
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
          class="upload-btn submit-btn"
          :class="{ isLoading }"
          :disabled="!selectedFile"
        >
          <span>Upload file</span>
        </button>
      </div>

      <div v-if="uploadMessage">
        <Notification :message="uploadMessage" :isError="hasError" />
      </div>
    </div>
  </DefaultLayout>
</template>

<script>
import Default from "../../layouts/Default.vue";
import UploadIcon from "../../components/icons/UploadIcon.vue";
import CircleXIcon from "../../components/icons/CircleXIcon.vue";
import FileIcon from "../../components/icons/FileIcon.vue";
import { uploadExcelSheet } from "../../api";

export default {
  components: {
    DefaultLayout: Default,
    CircleXIcon: CircleXIcon,
    UploadIcon: UploadIcon,
    FileIcon: FileIcon,
  },

  data() {
    return {
      selectedFile: null,
      isLoading: false,
      isUploading: false,
      fileLoaded: false,
      progress: 0,
      hasError: false,
      uploadMessage: "",
    };
  },

  methods: {
    uploadExcelSheet,
    handleFileSelect(e) {
      const file = e.target.files[0];
      if (file) {
        // Validate file type to accept only Excel files
        const isExcelFile =
          file.type === "application/vnd.ms-excel" ||
          file.type ===
            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";

        if (!isExcelFile) {
          this.hasError = true;
          this.uploadMessage =
            "Please select a valid Excel file (.xls or .xlsx)";
          this.selectedFile = null;
          this.fileLoaded = false;
          return;
        }

        this.selectedFile = file;
        this.hasError = false;
        this.uploadMessage = ""; // Clear any previous messages
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
        this.uploadMessage = "Error loading file";
        this.isUploading = false;
      };

      reader.readAsDataURL(this.selectedFile);
    },

    uploadFile() {
      if (!this.fileLoaded) return;
      this.isLoading = true;

      const formData = new FormData();
      formData.append("file", this.selectedFile);

      this.uploadExcelSheet(formData).then((response) => {
        this.uploadMessage = response.data.message;
        setTimeout(() => {
          this.redirectToProductsPage();
        }, 2000);

      }).catch((error) => {
        this.isLoading = false;
        this.hasError = true;
        this.uploadMessage = "Failed to upload file. Please try again.";
        console.log(error.response);
        if (error.response.status === 401) {
          localStorage.removeItem('adminToken');
          localStorage.removeItem('adminUsername');
          this.$router.push('/');
        }
      })
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
    width: 100%;
    height: auto;
    padding: 1.5rem 2rem;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    border: 2px dashed $primary-color;
    border-radius: 0.25rem;
    gap: 0.5rem;
    color: $font-color;

    span {
      font-size: 1rem;
    }

    @media screen and (min-width: 768px) {
      width: 500px;
    }

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
    width: 100%;
    background-color: $grey;
    box-shadow: 0px 0px 5px -2px #32475c4d;
    padding: 1rem 0.5rem;
    border-radius: 0.25rem;
    color: $font-color;

    @media screen and (min-width: 768px) {
      width: 500px;
    }

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
      color: $font-color;
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
    font-size: 0.8rem !important;
    padding: 0.75rem 1rem;
    border: none;
    border-radius: 0.25rem;
    cursor: pointer;

    &:hover {
      opacity: 0.8;
    }
  }
}
</style>
