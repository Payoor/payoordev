<template>
  <div>
    <div class="searchview__cart" v-if="cartopen">
      <Cart :closecart="closecart" />
    </div>

    <div class="searchview__orders" v-if="ordersopen">
      <Orders :closeorders="closeorders" />
    </div>

    <div class="" v-if="authenticator_open">
      <Authenticator :closeAuthenticator="closeAuthenticator" />
    </div>

    <div v-if="available_locations">
      <Locations :closeAvailLocations="closeAvailLocations" />
    </div>

    <div class="header landing">
      <div v-if="!user">
        <UnHeaderAuthenticated
          :help-phone-number="phoneNumber"
          :open-avail-locations="openAvailLocations"
          :open-authenticator="openAuthenticator"
        />
      </div>

      <div v-if="user">
        <HeaderAuthenticated
          :help-phone-number="phoneNumber"
          :open-avail-locations="openAvailLocations"
          :opencart="opencart"
          :openorders="openorders"
        />
      </div>
    </div>
  </div>
</template>

<script>
import { mapState, mapGetters, mapMutations, mapActions } from "vuex";

export default {
  props: ["closecartprop"],
  data() {
    return {
      cartopen: false,
      ordersopen: false,
      authenticator_open: false,
      available_locations: false,
      phoneNumber: "08121249923",
    };
  },
  computed: {
    ...mapState({
      jwt: (state) => state.jwt,
      user: (state) => state.user,
    }),
  },
  watch: {
    jwt(newValue, oldValue) {
      //console.log("JWT changed from:", oldValue, "to:", newValue);
      if (newValue) {
        this.$store.dispatch("getvaliduser");
      }
    },
  },
  methods: {
    closeAvailLocations() {
      this.available_locations = false;
    },
    openAvailLocations() {
      this.available_locations = true;
    },
    closeAuthenticator() {
      this.authenticator_open = false;
    },
    openAuthenticator() {
      this.authenticator_open = true;
    },
    opencart() {
      this.cartopen = true;
    },
    closecart() {
      this.cartopen = false;
    },
    openorders() {
      this.ordersopen = true;
    },
    closeorders() {
      this.ordersopen = false;
    },
  },
  mounted() {
    this.$store.dispatch("getvaliduser");
  },
};
</script>

<style scoped lang="scss"></style>
