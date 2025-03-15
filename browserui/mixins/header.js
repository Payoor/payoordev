import { mapState, mapGetters, mapMutations, mapActions } from "vuex";

export default {
  props: ["closecartprop"],
  data() {
    return {
      cartopen: false,
      authenticator_open: false,
      available_locations: false,
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
      console.log("JWT changed from:", oldValue, "to:", newValue);
      if (newValue) {
      }
    },
    user(newValue, oldValue) {
      if (newValue) {
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
  },
  mounted() {
    this.$store.dispatch("getvaliduser");
    console.log(";hello hereader");
  },
}