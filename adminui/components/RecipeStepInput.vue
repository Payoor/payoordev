<template>
  <div class="recipestepinput">
    <input
      :type="inputtype"
      v-model="value"
      ref="input"
      v-if="inputtype === 'text' || inputtype === 'number'"
      :placeholder="`${itemattribute}`"
      @keyup.enter="handleEnterKeyPress"
    />

    <textarea v-model="value" ref="input" v-if="inputtype === 'textarea'"></textarea>
  </div>
</template>

<script>
import API_URL from "@/store/APIURL";

export default {
  props: [
    "inputvalue",
    "blurfunction",
    "setvaluechange",
    "inputtype",
    "itemattribute",
    "itemid",
    "getsteps"
  ],
  data() {
    return {
      value: "",
      oldvalue: null,
    };
  },
  mounted() {
    this.value = this.inputvalue;

    if (this.$refs.input) {
      this.$refs.input.addEventListener("focus", this.focusfunction);
      this.$refs.input.focus();
      this.$refs.input.addEventListener("blur", this.callblurfunction);
    }
  },
  watch: {
    value(newval, oldval) {
      this.setvaluechange({ attribute: this.itemattribute, value: newval });
    },
  },
  methods: {
    async updateitem() {
      try {
        const response = await fetch(
          `${API_URL}/product/inventory/update/ingredientstep?recipestep=${this.itemid}`,
          {
            method: "PUT",
            headers: {
              "Content-Type": "application/json",
            },
            body: JSON.stringify({ [this.itemattribute]: this.value }),
          }
        );

        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }

        const data = await response.json();

        this.getsteps()
      } catch (error) {
        console.error("There was an error!", error.message);
      }
    },
    async callblurfunction() {
      if (!this.value || !this.value.trim().length) {
        this.value = this.oldvalue;

        await this.setvaluechange({ attribute: this.itemattribute, value: this.value });

        this.blurfunction();
        return;
      }

      if (this.value !== this.oldvalue) {
        this.updateitem();
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

<style lang="scss" scoped>
.recipestepinput {
  & input {
    @include inputbase;
    position: absolute;
    left: 0;
    top: 0;
    width: #{scaleValue(350)};
    height: 100%;
    margin-bottom: #{scaleValue(14)};
    z-index: 3;
  }

  & textarea {
    @include inputbase;
    width: #{scaleValue(400)};
    height: #{scaleValue(200)};
    font-size: #{scaleValue(13)};

    position: absolute;
    left: 0;
    top: 0;
  }
}
</style>
