<template>
  <div></div>
</template>

<script>
import { url } from "@/api";
import utilsMixin from "@/mixins/utils";

export default {
  mixins: [utilsMixin],
  mounted() {
    this.redirectToShop();
  },
  methods: {
    redirectToShop() {
      const urlParams = new URLSearchParams(window.location.search);
      const affiliateCode = urlParams.get("affiliatecode");

      // Build the destination URL
      let destinationUrl = "https://shop.payoor.store/paymentconfirmation";

      // If affiliatecode exists, add it to the destination URL
      if (affiliateCode) {
        destinationUrl += `?affiliatecode=${encodeURIComponent(affiliateCode)}`;
      }

      // Redirect the browser
      window.location.replace(destinationUrl);
    },
  },
};
</script>
