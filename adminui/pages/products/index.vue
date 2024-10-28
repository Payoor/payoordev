<template>
  <div>
    <div class="container">
      <div class="items">
        <Header :page="'Products'"/>

        <div class="container__categories">
          <button
            class="btn container__categories--btn"
            :class="{ current: visiblecategory === 'all' }"
            @click="setcategory('all')"
          >
            View all
          </button>
          <button
            class="btn container__categories--btn"
            :class="{ current: visiblecategory === 'recipe' }"
            @click="setcategory('recipe')"
          >
            View only recipes
          </button>
          <button
            class="btn container__categories--btn"
            :class="{ current: visiblecategory === 'grocery' }"
            @click="setcategory('grocery')"
          >
            View only groceries
          </button>
        </div>

        <div class="container__content">
          <div class="container__content--left"></div>
          <div class="container__content--right">
            <div class="items__list">
              <div
                class="items__listrow products__listheader"
                :style="{
                  display: 'grid',
                  'grid-template-columns': `repeat(${headers.length}, 15rem)`,
                }"
              >
                <div
                  class="items__listrow--item header"
                  v-for="(header, index) in headers"
                  :key="index"
                >
                  <div>{{ header }}</div>
                </div>
              </div>

              <div class="items__listcontent">
                <div v-for="item in items" :key="item">
                  <Item
                    :item="item"
                    :gridlength="headers.length"
                    :removeitem="removeitem"
                    :callgetitems="callgetitems"
                  />
                </div>

                <div class="items__listcontent--add" @click="addemptyitem">
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
                  <span>New</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapActions, mapState, mapMutations } from "vuex";

export default {
  data() {
    return {
      currentitem: {},
      itemsarr: [],
      visiblecategory: "all",
    };
  },
  computed: {
    headers() {
      return [
        "Aa itemname",
        "description",
        "# price (NGN)",
        "category",
        "# stockQuantity",
        "imageUrl",
        "bestseller",
        "actions",
      ];
    },
    items() {
      return this.itemsarr;
    },
    ...mapState({
      itemslist: (state) => state.item.itemslist,
    }),
  },
  watch: {
    itemslist(newval, oldval) {
      const itemsarr = [...newval];

      this.itemsarr = itemsarr;
    },
  },
  mounted() {
    this.getitems(this.visiblecategory);
  },
  methods: {
    callgetitems() {
      this.getitems(this.visiblecategory);
    },
    ...mapActions("item", ["getitems", "createitem", "deleteitem"]),
    ...mapMutations("item", ["SET_ITEMS"]),
    setcategory(category) {
      this.visiblecategory = category;
      this.getitems(this.visiblecategory);
    },
    async removeitem(itemid) {
      await this.deleteitem(itemid);
      this.getitems(this.visiblecategory);
    },
    async addemptyitem() {
      let category = "";

      if (this.visiblecategory !== "all") {
        category = this.visiblecategory;
      }

      const item = {
        itemname: "",
        description: "",
        price: 0,
        category,
        stockQuantity: 0,
        imageUrl: "",
        bestseller: false,
      };

      const createditem = await this.createitem(item);

      this.itemsarr = [...this.itemsarr, createditem];
      this.SET_ITEMS(this.itemsarr);
    },
  },
};
</script>
