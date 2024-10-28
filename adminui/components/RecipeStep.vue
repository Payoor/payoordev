<template>
  <div class="recipestep">
    <div class="recipestep__grid">
      <div class="recipestep__area">
        <div v-if="titleinputvisible">
          <RecipeStepInput
            :inputtype="'text'"
            :itemattribute="'title'"
            :blurfunction="blurfunction"
            :setvaluechange="setvaluechange"
            :inputvalue="title"
            :itemid="recipestep._id"
            :getsteps="getsteps"
          />
        </div>
        <span @click="deleteitem" class="margin-right-30">
          <svg
            role="graphics-symbol"
            viewBox="0 0 16 16"
            class="trash"
            style="width: 14px; height: 100%; display: block; fill: red; flex-shrink: 0"
          >
            <path
              d="M4.8623 15.4287H11.1445C12.1904 15.4287 12.8672 14.793 12.915 13.7402L13.3799 3.88965H14.1318C14.4736 3.88965 14.7402 3.62988 14.7402 3.28809C14.7402 2.95312 14.4736 2.69336 14.1318 2.69336H11.0898V1.66797C11.0898 0.62207 10.4268 0 9.29199 0H6.69434C5.56641 0 4.89648 0.62207 4.89648 1.66797V2.69336H1.86133C1.5332 2.69336 1.25977 2.95312 1.25977 3.28809C1.25977 3.62988 1.5332 3.88965 1.86133 3.88965H2.62012L3.08496 13.7471C3.13281 14.7998 3.80273 15.4287 4.8623 15.4287ZM6.1543 1.72949C6.1543 1.37402 6.40039 1.14844 6.7832 1.14844H9.20312C9.58594 1.14844 9.83203 1.37402 9.83203 1.72949V2.69336H6.1543V1.72949ZM4.99219 14.2188C4.61621 14.2188 4.34277 13.9453 4.32227 13.542L3.86426 3.88965H12.1152L11.6709 13.542C11.6572 13.9453 11.3838 14.2188 10.9941 14.2188H4.99219ZM5.9834 13.1182C6.27051 13.1182 6.45508 12.9336 6.44824 12.667L6.24316 5.50293C6.23633 5.22949 6.04492 5.05176 5.77148 5.05176C5.48438 5.05176 5.2998 5.23633 5.30664 5.50293L5.51172 12.667C5.51855 12.9404 5.70996 13.1182 5.9834 13.1182ZM8 13.1182C8.28711 13.1182 8.47852 12.9336 8.47852 12.667V5.50293C8.47852 5.23633 8.28711 5.05176 8 5.05176C7.71289 5.05176 7.52148 5.23633 7.52148 5.50293V12.667C7.52148 12.9336 7.71289 13.1182 8 13.1182ZM10.0166 13.1182C10.29 13.1182 10.4746 12.9404 10.4814 12.667L10.6934 5.50293C10.7002 5.23633 10.5088 5.05176 10.2285 5.05176C9.95508 5.05176 9.76367 5.22949 9.75684 5.50293L9.54492 12.667C9.53809 12.9336 9.72949 13.1182 10.0166 13.1182Z"
            ></path>
          </svg>
        </span>
        <p class="recipestep__area--editable" @click="toggleTitleInputVisibility">
          {{ title ? title : "" }}
        </p>
      </div>

      <div class="recipestep__area">
        <div v-if="stepinputvisible">
          <RecipeStepInput
            :inputtype="'number'"
            :itemattribute="'step'"
            :blurfunction="blurfunction"
            :setvaluechange="setvaluechange"
            :inputvalue="step"
            :itemid="recipestep._id"
            :getsteps="getsteps"
          />
        </div>
        <p class="recipestep__area--editable" @click="toggleStepInputVisibility">
          {{ step ? step : "" }}
        </p>
      </div>

      <div class="recipestep__image recipestep__area">
        <div class="editable recipestep__area--editable">
          <a :href="imageUrl" target="_blank" class="faintwhite-color">{{ imageUrl }}</a>
        </div>
        <div class="items__listrow--imagearea">
          <span
            class="pill margin-right-5 margin-left-5"
            @click="openimage(imageUrl)"
            v-if="imageUrl.length"
          >
            <svg
              role="graphics-symbol"
              viewBox="0 0 16 16"
              class="typesUrl"
              style="
                width: 14px;
                height: 14px;
                display: block;
                fill: rgb(211, 211, 211);
                flex-shrink: 0;
                margin-right: 6px;
              "
            >
              <path
                d="M7.69922 10.8945L8.73828 9.84863C7.91797 9.77344 7.34375 9.51367 6.91992 9.08984C5.76465 7.93457 5.76465 6.29395 6.91309 5.14551L9.18262 2.87598C10.3379 1.7207 11.9717 1.7207 13.127 2.87598C14.2891 4.04492 14.2822 5.67188 13.1338 6.82031L11.958 7.99609C12.1768 8.49512 12.2451 9.10352 12.1289 9.62988L14.0908 7.6748C15.7725 6 15.7793 3.62109 14.084 1.92578C12.3887 0.223633 10.0098 0.237305 8.33496 1.91211L5.95605 4.29785C4.28125 5.97266 4.26758 8.35156 5.96289 10.0469C6.36621 10.4434 6.90625 10.7441 7.69922 10.8945ZM8.30078 5.13184L7.26855 6.17773C8.08203 6.25293 8.66309 6.51953 9.08008 6.93652C10.2422 8.09863 10.2422 9.73242 9.08691 10.8809L6.81738 13.1504C5.66211 14.3057 4.03516 14.3057 2.87305 13.1504C1.71094 11.9883 1.71777 10.3545 2.87305 9.20605L4.04199 8.03027C3.83008 7.53125 3.75488 6.92969 3.87109 6.39648L1.91602 8.35156C0.234375 10.0264 0.227539 12.4121 1.92285 14.1074C3.61816 15.8027 5.99707 15.7891 7.67188 14.1143L10.0439 11.7354C11.7256 10.0537 11.7324 7.6748 10.0371 5.98633C9.64062 5.58301 9.10059 5.28223 8.30078 5.13184Z"
              ></path>
            </svg>
          </span>
          <span @click="openFileDialog" class="pill relative-positioning margin-right-5">
            <p v-if="!uploading">upload</p>
            <span class="loading-spinner" v-if="uploading"></span>
          </span>
          <span class="pill margin-right-5" v-if="imageUrl.length">preview</span>
          <input
            type="file"
            accept="image/*"
            ref="fileInput"
            style="display: none"
            @change="handleFileUpload"
          />
        </div>
      </div>
      <div class="recipestep__description recipestep__area">
        <div v-if="descriptioninputvisible">
          <RecipeStepInput
            :inputtype="'textarea'"
            :itemattribute="'description'"
            :blurfunction="blurfunction"
            :setvaluechange="setvaluechange"
            :inputvalue="description"
            :itemid="recipestep._id"
            :getsteps="getsteps"
          />
        </div>
        <p class="recipestep__area--editable" @click="toggleDescriptionInputVisibility">
          {{ description ? description : "" }}
        </p>
      </div>
    </div>
  </div>
</template>

<script>
import API_URL from "@/store/APIURL";

export default {
  props: ["recipestep", "recipestepnumber", "getsteps", "recipe"],
  data() {
    return {
      imageUrl: "",
      description: "",
      selectedFile: null,
      title: "",
      step: 0,
      uploading: false,
      stepinputvisible: false,
      titleinputvisible: false,
      descriptioninputvisible: false,
    };
  },
  mounted() {
    this.title = this.recipestep.title ? this.recipestep.title : "";
    this.description = this.recipestep.description ? this.recipestep.description : "";
    this.imageUrl = this.recipestep.imageUrl ? this.recipestep.imageUrl : "";
    this.step = this.recipestep.step ? this.recipestep.step : "";
  },
  methods: {
    openimage(url) {
      const newWindow = window.open(url, "_blank");
      if (newWindow) {
        newWindow.opener = null;
      }
    },
    blurfunction() {
      this.stepinputvisible = false;
      this.titleinputvisible = false;
      this.descriptioninputvisible = false;
    },
    setvaluechange({ attribute, value }) {
      console.log(attribute, value, "check here");
      this[`${attribute}`] = value;
    },
    openFileDialog() {
      this.$refs.fileInput.click();
    },
    toggleStepInputVisibility() {
      this.stepinputvisible = !this.stepinputvisible;
    },
    toggleTitleInputVisibility() {
      this.titleinputvisible = !this.titleinputvisible;
    },
    toggleDescriptionInputVisibility() {
      this.descriptioninputvisible = !this.descriptioninputvisible;
    },
    async deleteitem() {
      try {
        const recipestep = this.recipestep._id;
        const recipe = this.recipe;

        const response = await fetch(
          `${API_URL}/product/inventory/delete/ingredientstep?recipestep=${recipestep}&recipe=${recipe}`,
          {
            method: "DELETE",
          }
        );

        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }

        const data = await response.json();

        this.getsteps();
      } catch (error) {
        console.error("There was an error!", error);
      }
    },
    async handleFileUpload(event) {
      const file = event.target.files[0];

      if (file) {
        if (!file.type.match("image.*")) {
          alert("Please select an image file.");
          return;
        }

        this.selectedFile = file;
        this.uploading = true;

        try {
          const formData = new FormData();

          formData.append("file", this.selectedFile);

          const response = await fetch(
            `${API_URL}/product/inventory/imageupload/ingredientstep?recipestep=${this.recipestep._id}`,
            {
              method: "POST",
              body: formData,
            }
          );

          if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
          }

          if (response.status === 201) {
            const data = await response.json();

            this.uploading = false;
            this.getsteps();
          }
        } catch (error) {
          console.log(error);
        }
      }
    },
  },
};
</script>

<style lang="scss" scoped>
.recipestep {
  &__grid {
    display: grid;
    grid-template-columns: repeat(4, #{scaleValue(300)});
    height: #{scaleValue(40)};
    margin-bottom: #{scaleValue(14)};
    border-bottom: 1px solid rgb(47, 47, 47);
    border-top: 1px solid rgb(47, 47, 47);
  }

  &__header {
    margin-bottom: #{scaleValue(14)};
  }

  &__h3 {
    font-size: #{scaleValue(14)};
    font-weight: 500;
    margin-left: #{scaleValue(10)};
  }

  &__h4 {
    font-size: #{scaleValue(12)};
    font-weight: 500;
    margin-bottom: #{scaleValue(14)};
  }

  &__image {
    display: flex;
    align-items: center;
  }

  &__area {
    position: relative;
    border-right: 1px solid rgb(47, 47, 47);
    height: 100%;
    display: flex;
    align-items: center;
    padding-left: #{scaleValue(6)};

    &--editable {
      position: relative;
      cursor: pointer;
      color: rgba(255, 255, 255, 0.7);
      white-space: nowrap;
      overflow-x: auto;
      min-width: 100%;
      height: 100%;

      display: flex;
      align-items: center;
    }
  }
}
</style>
