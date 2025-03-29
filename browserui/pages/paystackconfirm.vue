<template>
  <div></div>
</template>

<script>
import { url } from "@/api";
import utilsMixin from "@/mixins/utils";

export default {
  mixins: [utilsMixin],
  mounted() {
    window.parent.postMessage("payment_complete", "*");
  },
};
</script>
