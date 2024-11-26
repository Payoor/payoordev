<template>
  <DefaultLayout page-text="Payment">
    <div class="link">
      <a v-if="link" :href="link">payment link</a>
      <p v-if="isPaymentVerified">{{ message }}</p>
    </div>
  </DefaultLayout>
</template>

<script>
import Default from '../../layouts/Default.vue';
import { generatePaymentLink, verifyPayment } from "../../api";


export default {
  components: {
    DefaultLayout: Default
  },

  data() {
    return {
      link: "",
      total: 300000,
      email: 'a@b.com',
      items: 'tomato',
      transactionRef: '',
      isPaymentVerified: false,
      message: '',
    }
  },

  methods: {
    generatePaymentLink,
    verifyPayment
  },

  mounted() {
    this.transactionRef = this.$route.query.reference
    
    if (this.transactionRef) {
      this.verifyPayment({
        transactionReference: this.transactionRef
      }).then((res) => {
        console.log(res.data)
        this.isPaymentVerified = res.data.success;
        this.message = res.data.data.message;
      })
    } else {
      this.generatePaymentLink({
        email: this.email,
        total: this.total,
        adminId: '673c5f594425ae3a9605f230'
      }).then((res) => {
        console.log(res.data)
        this.link = res.data.data.authorization_url;
      })
    }
  },
}
</script>

<style lang="scss">
  .link {
    color: $white;
  }
</style>
