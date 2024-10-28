<template>
  <div>
    <div
      class="items__listrow"
      :style="{
        display: 'grid',
        'grid-template-columns': `repeat(${gridlength}, 15rem)`,
      }"
    >
      <ListRowItem
        :passedvalue="itemname"
        :inputtype="'text'"
        :itemid="item._id"
        :itemattribute="'itemname'"
        :deleteicon="true"
        :removeitem="removeitem"
        :updatecategory="category"
        :callgetitems="callgetitems"
      />
      <ListRowItem
        :passedvalue="description"
        :inputtype="'textarea'"
        :itemattribute="'description'"
        :itemid="item._id"
        :updatecategory="category"
        :callgetitems="callgetitems"
      />
      <ListRowItem
        :passedvalue="price"
        :inputtype="'number'"
        :itemattribute="'price'"
        :itemid="item._id"
        :updatecategory="category"
        :callgetitems="callgetitems"
      />
      <ListRowItem
        :passedvalue="category"
        :inputtype="'text'"
        :itemattribute="'category'"
        :itemid="item._id"
        :updatecategory="category"
        :callgetitems="callgetitems"
      />
      <ListRowItem
        :passedvalue="stockQuantity"
        :inputtype="'number'"
        :itemattribute="'stockQuantity'"
        :itemid="item._id"
        :updatecategory="category"
        :callgetitems="callgetitems"
      />

      <div class="items__listrow--item link">
        <div class="editable">
          <a :href="item.imageUrl" target="_blank">{{ imageUrl }}</a>
        </div>
        <div class="items__listrow--imagearea">
          <span @click="openimage(item.imageUrl)" class="blackbackground margin-left-5">
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
          <span @click="openFileDialog" class="blackbackground">
            <p v-if="!uploading">upload</p>
            <span class="loading-spinner" v-if="uploading"></span>
          </span>
          <span class="blackbackground preview" v-if="item.imageUrl.length">Preview</span>
          <input
            type="file"
            accept="image/*"
            ref="fileInput"
            style="display: none"
            @change="handleFileUpload"
          />
          <span class="uploadpreview" v-if="item.imageUrl.length || selectedFile">
            <img :src="item.imageUrl" />
          </span>
        </div>
      </div>
      <ListRowItem
        :passedvalue="bestseller"
        :inputtype="'text'"
        :itemattribute="'bestseller'"
        :itemid="item._id"
        :updatecategory="category"
        :callgetitems="callgetitems"
      />
      <div class="flex align-center">
        <span
          class="pill margin-left-5"
          @click="itemviewtoggle('steps')"
          v-if="item.category === 'recipe' && itemview !== 'steps'"
          >Steps</span
        >
        <span
          class="pill margin-left-5"
          @click="itemviewtoggle('ingredients')"
          v-if="item.category === 'recipe' && itemview !== 'ingredients'"
          >Ingredients</span
        >

        <span
          class="pill red-color margin-left-5"
          @click="itemviewtoggle(null)"
          v-if="
            (item.category === 'recipe' && itemview === 'ingredients') ||
            (item.category === 'recipe' && itemview === 'steps')
          "
          >Close</span
        >
      </div>
    </div>

    <div
      class="items__ingredientsview"
      v-if="itemview === 'ingredients' && item.category === 'recipe'"
    >
      <div class="items__ingredientsview--input">
        <input placeholder="Find an ingredient to add" />
      </div>

      <div class="items__ingredientsview--content">
        <div class="items__ingredientsview--products">
          <div class="items__ingredientsview--product" v-for="grocery in grocerieslist">
            <figure>
              <img :src="grocery.imageUrl" />
              <span class="ingredient-add" @click="addtoingredients(grocery._id)">+</span>
            </figure>
            <div class="items__ingredientsview--productstock">
              <span>Stock:</span>
              <span>{{ grocery.stockQuantity }} items left</span>
            </div>
            <label>{{ grocery.itemname }}</label>
          </div>
        </div>
        <div class="items__ingredientsview--ingredients">
          <div class="items__ingredientsview--product" v-for="ingredient in ingredients">
            <figure>
              <img :src="ingredient.imageUrl" />
              <span class="ingredient-add" @click="removefromingredients(ingredient._id)"
                >-</span
              >
            </figure>
            <div class="items__ingredientsview--productstock">
              <span>Stock:</span>
              <span>{{ ingredient.stockQuantity }} items left</span>
            </div>
            <label>{{ ingredient.itemname }}</label>
          </div>
        </div>
      </div>
    </div>

    <div
      class="items__ingredientsview items__stepsview"
      v-if="itemview === 'steps' && item.category === 'recipe'"
    >
      <div class="items__stepsview--steps">
        <div class="flex align-center">
          <h4 class="items__stepsview--h4">{{ item.itemname }} Recipe Steps</h4>
          <div @click="createstep" class="items__listcontent--add margin-left-5">
            <span>
              <svg
                role="graphics-symbol"
                viewBox="0 0 16 16"
                class="plus"
                style="
                  width: 14px;
                  height: 14px;
                  display: block;
                  fill: rgba(255, 255, 255, 0.282);
                  flex-shrink: 0;
                  margin-left: -1px;
                  margin-right: 6px;
                "
              >
                <path
                  d="M7.977 14.963c.407 0 .747-.324.747-.723V8.72h5.362c.399 0 .74-.34.74-.747a.746.746 0 00-.74-.738H8.724V1.706c0-.398-.34-.722-.747-.722a.732.732 0 00-.739.722v5.529h-5.37a.746.746 0 00-.74.738c0 .407.341.747.74.747h5.37v5.52c0 .399.332.723.739.723z"
                ></path>
              </svg>
            </span>
            <span>New Step</span>
          </div>
        </div>
        <div v-for="recipestep in recipesteps">
          <RecipeStep :getsteps="getsteps" :recipestep="recipestep" :recipe="item._id" />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapActions, mapState, mapMutations } from "vuex";
import API_URL from "@/store/APIURL";

export default {
  data() {
    return {
      itemname: "",
      description: "",
      price: "",
      category: "",
      stockQuantity: "",
      imageUrl: "",
      bestseller: "",
      selectedFile: null,
      itemview: null,
      openonmount: false,
      uploading: false,
      ingredients: [],
      ingredientsids: [],
      groceries: [],
      recipesteps: [],
    };
  },
  props: ["item", "gridlength", "removeitem", "callgetitems"],
  computed: {
    grocerieslist() {
      const { groceries, ingredientsids } = this;

      const grocs = groceries.filter((grocery) => !ingredientsids.includes(grocery._id));

      return grocs;
    },
  },
  methods: {
    ...mapActions("item", ["uploaditemimage"]),
    async createstep() {
      try {
        const recipe = this.item._id;

        const response = await fetch(
          `${API_URL}/product/inventory/create/ingredientstep?recipe=${recipe}`,
          {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
            },
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
    async getsteps() {
      const recipe = this.item._id;

      try {
        const response = await fetch(
          `${API_URL}/product/inventory/get/ingredientsteps?recipe=${recipe}`
        );

        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }

        const data = await response.json();

        this.recipesteps = data.item;
      } catch (error) {
        console.error("There was an error!", error);
      }
    },
    async addtoingredients(_id) {
      try {
        const ingredient = _id;
        const recipe = this.item._id;

        const response = await fetch(
          `${API_URL}/product/inventory/addingredient?ingredient=${ingredient}&recipe=${recipe}`,
          {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
            },
          }
        );

        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }

        const data = await response.json();

        this.groceries = await this.getproducts();

        const ingredients = await this.getingredients();

        this.ingredients = ingredients.item;
        this.ingredientsids = ingredients.ingredientsids;
      } catch (error) {
        console.error("There was an error!", error);
      }
    },
    async removefromingredients(_id) {
      try {
        const ingredient = _id;
        const recipe = this.item._id;

        const response = await fetch(
          `${API_URL}/product/inventory/removeingredient?ingredient=${ingredient}&recipe=${recipe}`,
          {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
            },
          }
        );

        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }

        const data = await response.json();

        this.groceries = await this.getproducts();

        const ingredients = await this.getingredients();

        this.ingredients = ingredients.item;
        this.ingredientsids = ingredients.ingredientsids;
      } catch (error) {
        console.error("There was an error!", error);
      }
    },
    async getproducts() {
      try {
        const category = "grocery";

        const response = await fetch(
          `${API_URL}/products/inventory?category=${category}`
        );

        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }

        const data = await response.json();

        return data.items;
      } catch (error) {
        console.error("There was an error!", error);
      }
    },
    async getingredients() {
      try {
        const recipe = this.item._id;

        const response = await fetch(
          `${API_URL}/product/inventory/ingredients?recipe=${recipe}`
        );

        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }

        const data = await response.json();

        return data;
      } catch (error) {
        console.error("There was an error!", error);
      }
    },
    initializevalues() {
      const {
        itemname,
        description,
        price,
        category,
        stockQuantity,
        imageUrl,
        bestseller,
      } = this.item;

      if (!itemname.length) {
        //this.triggeropenonmount();
      }

      this.itemname = itemname.includes("payoor_id") ? "" : itemname;
      this.description = description;
      this.price = price;
      this.category = category;
      this.stockQuantity = stockQuantity;
      this.imageUrl = imageUrl;
      this.bestseller = bestseller;
    },
    triggeropenonmount() {
      this.openonmount = true;

      console.log(this.openonmount, "openonmount");
    },
    openimageUrlinput() {},
    openimage(url) {
      const newWindow = window.open(url, "_blank");
      if (newWindow) {
        newWindow.opener = null;
      }
    },
    openFileDialog() {
      this.$refs.fileInput.click();
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

        await this.uploaditemimage({ image: this.selectedFile, itemid: this.item._id });

        this.uploading = false;
        this.callgetitems();
      }
    },
    async itemviewtoggle(view) {
      this.itemview = view;

      if (this.itemview === "ingredients") {
        this.groceries = await this.getproducts();

        const ingredients = await this.getingredients();

        this.ingredients = ingredients.item;
        this.ingredientsids = ingredients.ingredientsids;
      }

      if (this.itemview === "steps") {
        this.getsteps();
      }
    },
  },
  watch: {
    item() {
      this.initializevalues();
    },
  },
  mounted() {
    this.initializevalues();
  },
};
</script>
