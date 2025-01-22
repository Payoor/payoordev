<template>
  <DefaultLayout :page-text="'Dashboard'" description="View dashboard stats">
    <div class="dashboard-layout">
      <StatsCard
        :label="'Total Available Products'"
        :count="numberOfAvailableProducts"
        :href="'/all-products'"
      >
        <template #icon>
          <CartIcon class="default-color" /> 
        </template>
      </StatsCard>

      <StatsCard
        :label="'Total Pending Orders'"
        :count="numberOfPendingOrders"
        :href="'/orders'"
      >
        <template #icon>
          <ContainerIcon class="pending" /> 
        </template>
      </StatsCard>

      <StatsCard
        :label="'Total Completed Orders'"
        :count="numberOfCompletedOrders"
        :href="'/orders'"
      >
        <template #icon>
          <ContainerIcon class="default-color" /> 
        </template>
      </StatsCard>

      <StatsCard
        :label="'Total Pending Transactions'"
        :count="numberOfPendingTransactions"
        :href="'/transactions'"
      >
        <template #icon>
          <CreditCardIcon class="pending" /> 
        </template>
      </StatsCard>

      <StatsCard
        :label="'Total Verified Transactions'"
        :count="numberOfVerifiedTransactions"
        :href="'/transactions'"
      >
        <template #icon>
          <CreditCardIcon class="default-color" /> 
        </template>
      </StatsCard>

      <StatsCard
        :label="'Total Users'"
        :count="numberOfUsers"
        :href="'/users'"
      >
        <template #icon>
          <UsersIcon class="default-color" /> 
        </template>
      </StatsCard>
    </div>
  </DefaultLayout>
</template>

<script>
import Default from "../../layouts/Default.vue";
import CartIcon from "../../components/icons/CartIcon.vue";
import ContainerIcon from "../../components/icons/ContainerIcon.vue";
import UsersIcon from "../../components/icons/UsersIcon.vue";
import CreditCardIcon from "../../components/icons/CreditCardIcon.vue";
import { getDashboardStats } from "../../api"

export default {
  components: {
    DefaultLayout: Default,
    CartIcon,
    ContainerIcon,
    UsersIcon,
    CreditCardIcon,
  },

  data() {
    return {
      numberOfAvailableProducts: 0,
      numberOfPendingOrders: 0,
      numberOfCompletedOrders: 0,
      numberOfPendingTransactions: 0,
      numberOfVerifiedTransactions: 0,
      numberOfUsers: 0,
    }
  },

  methods: {
    getDashboardStats,
  },

  mounted() {
    this.getDashboardStats().then(res => {
      this.numberOfAvailableProducts = res.data.numberOfAvailableProducts;
      this.numberOfPendingOrders = res.data.numberOfPendingOrders;
      this.numberOfCompletedOrders = res.data.numberOfCompletedOrders;
      this.numberOfPendingTransactions = res.data.numberOfPendingTransactions;
      this.numberOfVerifiedTransactions = res.data.numberOfVerifiedTransactions;
      this.numberOfUsers = res.data.numberOfUsers;
    }).catch(error => {
      console.log(error.response);
      if (error.response.status === 401) {
        localStorage.removeItem('adminToken');
        localStorage.removeItem('adminUsername');
        this.$router.push('/');
      }
    })
  },
}
</script>

<style lang="scss" scoped>
.dashboard-layout {
  display: grid;
  grid-template-columns: 1fr;
  grid-template-rows: auto;
  gap: 1rem;
  padding-block: 2rem;

  @media screen and (min-width: 768px) {
    grid-template-columns: repeat(2, 1fr);
  }

  @media screen and (min-width: 1024px) {
    grid-template-columns: repeat(3, 1fr);
  }

  svg {
    width: 3.5rem;
    height: 3.5rem;
    border-radius: 50%;
    padding: 0.5rem;
    color: $white;

    &.default-color {
      background-color: rgba($primary-color, .4);
    }
    
    &.pending {
      background-color: rgba(gold, .4);
    }
  }

}

</style>

