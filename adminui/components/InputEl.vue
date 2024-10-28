<template>
  <div class="items__listrow--textinput">
    <input
      :type="inputtype"
      class="text"
      v-model="value"
      ref="input"
      v-if="inputtype === 'text' || inputtype === 'number'"
      @keyup.enter="handleEnterKeyPress"
      :placeholder="`${itemattribute}`"
    />

    <textarea v-model="value" ref="input" v-if="inputtype === 'textarea'"></textarea>
  </div>
</template>

<script>
import { mapActions, mapState, mapMutations } from "vuex";

export default {
  props: [
    "inputvalue",
    "blurfunction",
    "inputtype",
    "setvaluechange",
    "itemattribute",
    "itemid",
    "updatecategory",
    "callgetitems"
  ],
  data() {
    return {
      value: "",
      oldvalue: null,
    };
  },
  watch: {
    value(newval, oldval) {
      this.setvaluechange(newval);
    },
  },
  mounted() {
    this.value = this.inputvalue;

    if (this.$refs.input) {
      this.$refs.input.addEventListener("focus", this.focusfunction);
      this.$refs.input.focus();
      this.$refs.input.addEventListener("blur", this.callblurfunction);
    }
  },
  methods: {
    ...mapActions("item", ["updateitemfromstore", "getitems"]),
    async updateitem() {
      const itemattribute = `${this.itemattribute}`;
      await this.updateitemfromstore({ itemid: this.itemid, itemattribute, value: this.value });
      this.callgetitems();
    },
    async callblurfunction() {
      if (!this.value || !this.value.trim().length) {
        this.value = this.oldvalue;

        await this.setvaluechange(this.value);

        this.blurfunction();
        return;
      }

      if (this.itemattribute === "category") {
        await this.updateitem();
      }

      if (this.value !== this.oldvalue) {
        await this.updateitem();
      }

      this.blurfunction();
    },
    handleEnterKeyPress() {
      this.blurfunction();
    },
    focusfunction() {
      this.oldvalue = this.value;
    },
  },
};
</script>
