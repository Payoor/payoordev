<template>
  <div>
    <div class="reviewsslide">
      <div class="reviewsslide__slider">
        <div
          v-for="(review, index) in reviews"
          :key="index"
          class="reviewsslide__card"
          :class="{ current: current === index }"
        >
          <figure>
            <img :src="review.imageUrl" alt="Reviewer photo" />
          </figure>

          <h6>{{ review.name }}</h6>
          <p>{{ review.content }}</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      current: 0,
      reviews: [
        {
          imageUrl: "imgs/dude.jpeg",
          name: "Efe Tobore",
          content:
            "Payoor is fast and reliable. The user experience is in a league of its own",
        },
        {
          imageUrl: "imgs/dude2.jpeg",
          name: "Imam Adetona",
          content: "It's seamless and clean",
        },
      ],
    };
  },
  methods: {
    sliderFun() {
      setInterval(() => {
        if (this.current != this.reviews.length - 1) {
          const current = this.current + 1;
          this.current = current;
        } else {
          this.current = 0;
        }
      }, 4000);
    },
  },
  mounted() {
    this.sliderFun();
  },
};
</script>

<style scoped lang="scss">
.reviewsslide {
  &__slider {
    background: $sky-blue;
    position: relative;
    height: 30rem;
  }

  &__card {
    position: absolute;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: $sky-blue;
    transition: all 0.5s ease;
    opacity: 0;

    &.current {
      opacity: 1;
    }

    & figure {
      height: 10rem;
      width: 10rem;
      overflow: hidden;
      border-radius: 100%;

      & img {
        object-fit: cover;
        height: 100%;
        width: 100%;
      }
    }

    & h6 {
      font-size: 3rem;
      font-weight: 500;
      font-style: italic;
      margin-top: 2rem;
    }

    & p {
      font-size: 1.4rem;
      font-style: italic;
    }
  }
}
</style>
