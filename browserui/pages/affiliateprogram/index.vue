<template>
  <div>
    <div class="affiliate">
      <div class="affiliate__header"></div>

      <div class="affiliate__form">
        <div>
          <Authenticator :heading="'Join our affiiate program'" :affiliateAuth="true" />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      email: null,
    };
  },
  methods: {
    async createAffiliate() {},
  },
};
</script>

<style scoped lang="scss">
.affiliate {
  &__header {
  }

  &__form {
  }
}
</style>
