<template>
  <div>
    <Header />

    <div class="onboarding">
      <div class="onboarding__top">
        <div class="onboarding__top--textarea">
          <span class="onboarding__top--back">
            <svg>
              <use v-bind:xlink:href="'/symbol-defs.svg#icon-arrow_back'"></use>
            </svg>
          </span>
          <TypeWriterText :text="'Please give me your location'" />
        </div>
      </div>

      <div class="onboarding__bottom">
        <div v-if="addressResults.length > 0" class="address-results">
          <div
            v-for="(result, index) in addressResults"
            :key="index"
            class="address-item"
            @click="selectAddress(result.formatted_address)"
          >
            {{ result.formatted_address }}
          </div>
        </div>

        <div class="loading address-loading" v-if="loading">
          <span></span>
        </div>

        <div class="onboarding__bottom--input">
          <input
            class="onboarding__input"
            v-model="address"
            :placeholder="
              signingup
                ? 'Preparing your Payoor account...'
                : 'Please give me your location'
            "
            @input="onAddressInput"
            :class="{ disabled: signingup }"
          />
          <span
            class="send-svg"
            :class="{
              disabled: !address.length || address === null || signingup,
            }"
            @click="signUp"
          >
            <div class="loading address-loading" v-if="signingup">
              <span></span>
            </div>
            <svg>
              <use v-bind:xlink:href="'/symbol-defs.svg#icon-arrow_upward'"></use>
            </svg>
          </span>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import authenticationMixin from "@/mixins/authentication";

import { service_url } from "@/api";

export default {
  mixins: [authenticationMixin],
  data() {
    return {
      address: "",
      addressResults: [],
      searchTimeout: null,
      loading: false,
      signingup: false,
    };
  },
  computed: {
    name() {
      return this.$route.query.name;
    },
    email() {
      return this.$route.query.email;
    },
    phonenumber() {
      return this.$route.query.phonenumber;
    },
  },
  methods: {
    async signUp() {
      if (!this.address.length || this.address === null) {
        return;
      }

      const user = await this.$store.dispatch("handlesignup", {
        name: this.name,
        phone: this.phonenumber,
        location: this.address,
        email: this.email,
      });

      this.getJWTWithUserId(user.id)
    },
    onAddressInput() {
      if (this.searchTimeout) {
        clearTimeout(this.searchTimeout);
      }

      if (this.address.length < 3) {
        this.addressResults = [];
        return;
      }

      this.searchTimeout = setTimeout(() => {
        this.searchAddresses();
      }, 500);
    },
    async searchAddresses() {
      if (!this.address) return;

      try {
        this.addressResults = await this.getAddressesList(this.address);
      } catch (error) {
        console.error("Failed to fetch addresses:", error);
      }
    },
    async getAddressesList() {
      try {
        this.loading = true;
        const searchQuery = this.address;

        const response = await fetch(
          `${service_url}/googleapi/search-places?query=${encodeURIComponent(
            searchQuery
          )}`,
          {
            method: "GET",
            headers: {
              "Content-Type": "application/json",
            },
          }
        );

        const result = await response.json();
        this.loading = false;
        return result.data.placesResponse;
      } catch (error) {
        this.loading = false;
        console.log(error);
      }
    },
    selectAddress(selectedAddress) {
      this.address = selectedAddress;
      this.addressResults = [];
    },
  },
};
</script>

<style scoped lang="scss">
.address-results {
  border-radius: 1rem;
  overflow: hidden;
  max-height: 40rem;
  overflow-y: scroll;
  border: 0.5px solid $white;
}

.address-item {
  background: $white;
  width: 100%;
  border: 0.1px solid $primary-color;
  cursor: pointer;
  padding: 1.3rem 2rem;
  transition: all 0.5s ease;
  font-size: 1.4rem;
  font-weight: 500;

  &:hover {
    background: rgba($primary-color, 0.1);
    color: $white;
    font-weight: 300;
  }

  &:last-child {
    padding-bottom: 3rem;
    border-bottom: none;
  }
}
</style>
