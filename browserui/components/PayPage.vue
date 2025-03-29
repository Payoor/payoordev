<template>
  <div>
    <form id="paymentForm">
      <div>Loading payment view...</div>
      <div class="form-group">
        <input type="tel" id="phone-number" :value="userData.phoneNumber || ''" />
        <input type="email" id="email" :value="userData.email || ''" />
        <input type="number" id="amount" :value="orderData.total || '200'" />
        <input type="text" id="first-name" :value="userData.name || ''" />
        <input
          type="text"
          id="last-name"
          :value="userData.name ? userData.name + userData.name : ''"
        />
      </div>
    </form>
  </div>
</template>

<script>
export default {
  name: "BaniPayment",
  data() {
    return {
      userData: {
        userId: "",
        email: "",
        name: "",
        phoneNumber: "",
        userAddress: "",
      },
      orderData: {
        _id: "",
        total: 0,
      },
    };
  },
  created() {
    if (typeof window !== "undefined") {
      this.parseQueryParams();
    }
  },
  mounted() {
    this.parseQueryParams();
    this.loadBaniScript();
  },
  methods: {
    parseQueryParams() {
      if (typeof window === "undefined") return;

      const queryParams = new URLSearchParams(window.location.search);

      this.userData.userId = queryParams.get("userId") || "";
      this.userData.email = queryParams.get("email") || "";
      this.userData.name = queryParams.get("name") || "";
      this.userData.phoneNumber = queryParams.get("phoneNumber") || "";
      this.userData.userAddress = queryParams.get("userAddress") || "";

      this.orderData._id = queryParams.get("orderId") || "";
      this.orderData.total = queryParams.get("total") || "200";
    },
    loadBaniScript() {
      if (typeof window === "undefined") return;

      const script = document.createElement("script");
      script.src =
        "https://bani-assets.s3.eu-west-2.amazonaws.com/static/widget/js/window.js";
      script.onload = this.initializeBani;
      document.head.appendChild(script);
    },
    initializeBani() {
      if (typeof window === "undefined") return;

      const phoneElement = document.getElementById("phone-number");
      if (!phoneElement) return;

      const phoneNumber = phoneElement.value;
      const formattedPhone = "+234" + phoneNumber.replace(/^0+/, "");

      if (typeof BaniPopUp === "undefined") {
        console.error("BaniPopUp not loaded");
        return;
      }

      let handler = BaniPopUp({
        amount: document.getElementById("amount")?.value || this.orderData.total,
        phoneNumber: formattedPhone,
        email: document.getElementById("email")?.value || this.userData.email,
        firstName: document.getElementById("first-name")?.value || this.userData.name,
        lastName:
          document.getElementById("last-name")?.value ||
          this.userData.name + this.userData.name,
        merchantKey: "pub_prod_5AXXSMJ492485SQ4BTEPSY3EQPYTKD",
        bankTransferOnly: true,
        metadata: {
          order_ref: this.orderData._id,
        },
        merchantRef: "ref-" + Math.random().toString(36).substr(2, 9),
        onClose: (response) => {
          //console.log("Bani Close Event:", response);
          window.parent.postMessage({ type: "onClose", data: response }, "*");
        },
        callback: (response) => {
          console.log("Bani Success Event:", response);
          const message = { type: "onSuccess", data: response };
          //console.log("Sending message to parent:", message);
          window.parent.postMessage(message, "*");
          //console.log("Message sent to parent");

          const urlParams = new URLSearchParams(window.location.search);
          const affiliateCode = urlParams.get("affiliatecode");

          let redirectUrl = "https://payoor.store/paymentconfirmation";

          if (affiliateCode) {
            redirectUrl += `?affiliatecode=${encodeURIComponent(affiliateCode)}`;
          }

          // Redirect
          window.location.href = redirectUrl;
        },
      });
      handler;
    },
  },
};
</script>

<style scoped>
body {
  font-family: Arial, sans-serif;
  padding: 16px;
  background-color: transparent;
}

.form-group {
  display: none;
}
</style>
