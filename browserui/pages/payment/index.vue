<template>
  <div class="payment">
    <Header />
    <div class="payment__container">
      <div v-if="paystackurl">
        <div id="container" class="payment__container--widget" :class="{}">
          <iframe
            ref="paystackIframe"
            :src="paystackurl"
            width="100%"
            height="100%"
            style="border: none"
            @load="checkIframeRedirect"
          ></iframe>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState } from "vuex";
import { url } from "@/api";
import utilsMixin from "@/mixins/utils";

export default {
  data() {
    return {
      orderId: null,
      email: null,
      userId: null,
      paystackurl: null,
    };
  },
  mounted() {
    this.getPaystackLink();

    window.addEventListener("message", (event) => {
      if (event.data === "payment_complete") {
        const affiliateCode = new URLSearchParams(window.location.search).get(
          "affiliatecode"
        );
        window.location.href = `https://payoor.store/paymentconfirmation?affiliatecode=${encodeURIComponent(
          affiliateCode
        )}`;
      }
    });
  },
  /*watch: {
    paystackredirect(newValue) {
      if (newValue) {
        const urlParams = new URLSearchParams(window.location.search);
        const affiliateCode = urlParams.get("affiliatecode");

        window.location.replace(
          `https://payoor.store/paymentconfirmation?affiliatecode=${encodeURIComponent(
            affiliateCode
          )}`
        );
      }
    },
  },
  computed: {
    paystackredirect() {
      return this.$route.query.paymentconfirm;
    },
  },*/
  methods: {
    parseQueryParams() {
      if (typeof window === "undefined") return;

      const queryParams = new URLSearchParams(window.location.search);

      this.orderId = queryParams.get("orderId") || "";

      this.userId = queryParams.get("userId") || "";

      this.email = queryParams.get("email") || "";
    },
    async getPaystackLink() {
      this.parseQueryParams();

      try {
        const response = await fetch(`${url}/v2/paystack/generate-paystack-link`, {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            Accept: "application/json",
          },
          body: JSON.stringify({
            email: this.email,
            orderId: this.orderId,
            userId: this.userId,
          }),
        });

        if (!response.ok) {
          console.log("error paying for order");
        }

        const data = await response.json();

        if (data) {
          // console.log(data.data.authorizationUrl);
          this.paystackurl = data.data.authorizationUrl;
        }
      } catch (error) {
        console.log(error);
      }
    },
    checkIframeRedirect() {
      const iframe = this.$refs.paystackIframe;

      try {
        const currentUrl = iframe.contentWindow.location.href;

        if (currentUrl.includes("https://shop.payoor.store/paystackconfirm")) {
          const affiliateCode = new URLSearchParams(window.location.search).get(
            "affiliatecode"
          );
          window.location.href = `https://payoor.store/paymentconfirmation?affiliatecode=${encodeURIComponent(
            affiliateCode
          )}`;
        }
      } catch (err) {
        console.log(err, "CORS blocks iframe inspection. Use postMessage instead.");
      }
    },
  },
};
</script>

<style scoped lang="scss">
.payment {
  &__container {
    &--widget {
      margin: 0 auto;
      width: 60rem;
      height: 100vh;
      background: transparent;
      padding: 0;
      transform: translateY(-10rem);
      display: flex;
      justify-content: center;
    }
  }
}
</style>
