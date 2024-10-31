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
            <FileIcon v-if="!isLoading" class="file-icon" />
            <div class="file-name">
              <p>{{ selectedFile.name }}</p>

              <div v-if="isLoading" class="progress-bar">
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
            class="upload-btn btn"
            :disabled="!selectedFile" 
          >
            Upload file
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
import { ref } from 'vue';

export default {
  setup() {
    const selectedFile = ref(null);
    const isLoading = ref(false);
    const isUploading = ref(false);
    const fileLoaded = ref(false);
    const progress = ref(0);
    const hasError = ref(false);
    const uploadMessage = ref('');

    const handleFileSelect = (e) => {
      const file = e.target.files[0];
      if (file) {
        // validate file type to accept only Excel files
        const isExcelFile = file.type === 'application/vnd.ms-excel' || file.type === 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';

        if (!isExcelFile) {
          hasError.value = true;
          uploadMessage.value = 'Please select a valid Excel file (.xls or .xlsx)';
          selectedFile.value = null;
          fileLoaded.value = false;
          return;
        }

        selectedFile.value = file;
        hasError.value = false;
        uploadMessage.value = ''; // clear any previous messages
        loadFile();
      }
    };

    const handleFileRemoval = () => {
      selectedFile.value = null;
    }

    const loadFile = () => {
      isLoading.value = true;
      fileLoaded.value = false;
      const reader = new FileReader();

      reader.onloadstart = () => {
        progress.value = 0;
      };

      reader.onprogress = (event) => {
        if (event.lengthComputable) {
          progress.value = Math.round((event.loaded / event.total) * 100);
        }
      };

      reader.onloadend = () => {
        progress.value = 100;
        isLoading.value = false;
        fileLoaded.value = true;
        console.log(selectedFile.value)
      };

      reader.onerror = () => {
        hasError.value = true;
        uploadMessage.value = 'Error loading file';
        isLoading.value = false;
      };

      reader.readAsDataURL(selectedFile.value);
    };

    const uploadFile = async () => {
      if (!fileLoaded.value) return;
      isUploading.value = true;
      progress.value = 0;

      try {
        const formData = new FormData();
        formData.append('file', selectedFile.value);

        // simulate file upload
        return new Promise((resolve) => {
          uploadMessage.value = 'File uploaded successfully!';
          setTimeout(() => {
            uploadMessage.value = '';
          }, 2000)
        });
        
      } catch (error) {
        hasError.value = false;
        uploadMessage.value = 'Failed to upload file. Please try again.';

      } finally {
        isUploading.value = false;
        selectedFile.value = null;
      }
    };


    return {
      selectedFile,
      isLoading,
      isUploading,
      fileLoaded,
      progress,
      uploadMessage,
      handleFileSelect,
      uploadFile,
      handleFileRemoval,
      hasError,
    };
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
    padding: 0.5rem 1.5rem;

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
