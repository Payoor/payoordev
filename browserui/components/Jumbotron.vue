<template>
  <div>
    <div class="jumbotron">
      <div class="jumbotron__searcharea">
        <h1 class="jumbotron__searcharea--header">
          <span>Hi, {{ user ? user.name : "I'm Payoor" }}</span>
          <span>What will you like to eat?</span>
          <!-- <span>Make a grocery list</span>
          <span>and leave the rest to me</span>-->
        </h1>

        <div class="jumbotron__searcharea--input" @click="opensearch">
          <input class="input" />
          <span class="search-svg">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              width="63"
              height="64"
              viewBox="0 0 63 64"
              fill="none"
            >
              <path
                fill-rule="evenodd"
                clip-rule="evenodd"
                d="M30.0286 0C46.5861 0 60.0541 13.468 60.0541 30.0255C60.0541 37.8373 57.0562 44.962 52.1504 50.3092L61.8036 59.9422C62.707 60.8456 62.7101 62.3071 61.8067 63.2105C61.3565 63.6668 60.7614 63.8919 60.1694 63.8919C59.5805 63.8919 58.9885 63.6668 58.5352 63.2167L48.7656 53.4743C43.6263 57.59 37.11 60.0541 30.0286 60.0541C13.4711 60.0541 0 46.583 0 30.0255C0 13.468 13.4711 0 30.0286 0ZM30.0286 4.625C16.021 4.625 4.625 16.0179 4.625 30.0255C4.625 44.0331 16.021 55.4291 30.0286 55.4291C44.0331 55.4291 55.4291 44.0331 55.4291 30.0255C55.4291 16.0179 44.0331 4.625 30.0286 4.625Z"
                fill="white"
              ></path>
            </svg>
          </span>
        </div>
      </div>

      <div class="jumbotron__image">
        <figure>
          <img src="@/assets/imgs/bike-desktop.png" />
        </figure>
      </div>

      <div class="search-body" v-if="searchopen">
        <SearchBody :closesearch="closesearch" />
      </div>
    </div>
  </div>
</template>

<script>
import { mapState, mapGetters, mapMutations, mapActions } from "vuex";

import searchInput from "@/mixins/searchInput";

export default {
  mixins: [searchInput],
  computed: {
    ...mapState({
      user: (state) => state.user,
    }),
  },
};
</script>

<style scoped lang="scss">
.jumbotron {
  position: relative;
  background: $primary-color;
  height: 83rem;

  &__image {
    position: absolute;
    bottom: 0;
    left: 0;
    display: flex;
    justify-content: center;
    width: 100%;

    & figure {
      height: 40rem;

      & img {
        height: 100%;
        width: 100%;
        object-fit: cover;
      }
    }
  }
}
</style>
