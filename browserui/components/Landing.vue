<template>
  <div class="landingpage">
    <div id="header">
      <Header />
    </div>

    <div id="jumbotron">
      <Jumbotron />
    </div>

    <div class="landingpage__content" v-if="!user">
      <div id="reviews">
        <ReviewsSlide />
      </div>

      <div id="categories">
        <Categories />
      </div>

      <div id="landingcopy">
        <LandingCopy />
      </div>

      <div id="landingfaq">
        <LandingFaq />
      </div>

      <div id="landingfooter">
        <LandingFooter />
      </div>
    </div>
  </div>
</template>

<script>
import { mapState, mapGetters, mapMutations, mapActions } from "vuex";

export default {
  computed: {
    ...mapState({
      user: (state) => state.user,
    }),
  },
};
</script>

<style scoped lang="scss">
.landingpage {
  &__content {
    background: $primary-color;
  }
}
</style>
