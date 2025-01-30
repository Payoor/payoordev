<template>
  <DefaultLayout page-text="Transaction Details">
    <div class="trans-details">
      <template v-if="isLoading">
        <div>Loading...</div>
      </template>
      
      <template v-if="!isLoading && details">
        <br>
        <h3>Transaction status: <span>{{ details.status }}</span></h3>
        <br>

        <h3>Items</h3>
        <div v-for="item in details.orderId.items">
          <p><strong>Product name: </strong>{{ item.product_name }}</p>
          <p><strong>Unit: </strong>{{ item.product_units[0] }}</p>
        </div>

        <br>
        <p>
          <strong>Order address: </strong>
          {{ details.orderId.order_address }}
        </p>
      </template>
    </div>
  </DefaultLayout>
</template>

<script>
import Default from '../../layouts/Default.vue';
import { getTransactionandOrderDetails } from "../../api";
import { formatAmount } from '../../helpers';


export default {
  components: {
    DefaultLayout: Default
  },

  data() {
    return {
      details: null,
      isLoading: false
    }
  },

  methods: {
    getTransactionandOrderDetails
  },

  mounted() {
    this.isLoading = true;
    setTimeout(() => {
      this.getTransactionandOrderDetails(this.$route.query.tx_ref).then(res => {
        this.isLoading = false;
        console.log(res.data.data.transaction)
        this.details = res.data.data.transaction;
      }).catch(error => console.log(error.response.data));
    }, 2000)
  }
}
</script>

<style lang="scss">
  .trans-details {
    color: $font-color;
  }
</style>
