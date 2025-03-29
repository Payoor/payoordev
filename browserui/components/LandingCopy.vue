<template>
  <div class="landingcopy">
    <div class="landingcopy__content">
      <div class="landingcopy__mast">
        <figure>
          <img src="@/assets/imgs/copy-mast-img.png" />
        </figure>
      </div>

      <h4 class="landingcopy__header">
        Psst... here is why we are your best buddy for fresh food stuff and quality
        grocery
      </h4>

      <div class="landingcopy__cards">
        <div class="landingcopy__card sample-dish">
          <div class="landingcopy__card--left">
            <h5 class="landingcopy__card--h5">Every meal deserves a great story</h5>

            <p class="landingcopy__card--p">
              We deliver all you need for home-cooked meals, saving you market the hassle
              and stress
            </p>
          </div>

          <div class="landingcopy__card--right">
            <figure class="sample-dish">
              <img src="@/assets/imgs/sample_dish.png" />
            </figure>
          </div>
        </div>

        <div class="landingcopy__card paper-basket">
          <div class="landingcopy__card--left">
            <h5 class="landingcopy__card--h5">Best prices, best quality</h5>

            <p class="landingcopy__card--p">
              We offer unbeatable prices and the best quality you can find anywhere
            </p>
          </div>

          <div class="landingcopy__card--right">
            <figure class="paper-basket">
              <img src="@/assets/imgs/paper_basket.png" />
            </figure>
          </div>
        </div>

        <div class="landingcopy__card paper-box">
          <div class="landingcopy__card--left">
            <h5 class="landingcopy__card--h5">Packaged with love and care</h5>

            <p class="landingcopy__card--p">
              We deliver your order in pristine condition, ensuring it's clean and ready
              to use straight out of the box
            </p>
          </div>

          <div class="landingcopy__card--right">
            <figure class="paper-box">
              <img src="@/assets/imgs/paper_box.png" />
            </figure>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped lang="scss">
$every-meal-deserves-a-great-story: rgba(168, 209, 240, 1); // Color(0xFFA8D1F0)
$best-prices-great-quality: rgba(240, 231, 168, 1); // Color(0xFFF0E7A8)
$packaged-with-love-and-care: rgba(240, 186, 168, 1);

.landingcopy {
  @include section;

  @include section-header;

  //padding-bottom: 3rem;

  &__mast {
    display: flex;
    justify-content: center;

    & figure {
      height: 48rem;
      border-radius: 1rem;
      margin-bottom: 2rem;
      overflow: hidden;

      & img {
        object-fit: cover;
        height: 100%;
        width: 100%;
      }
    }
  }

  &__card {
    border-radius: 1rem;
    margin-bottom: 4rem;
    position: relative;
    display: flex;
    justify-content: space-between;
    background: blue;
    padding: 5rem;
    height: 38rem;

    &.sample-dish {
      background: $every-meal-deserves-a-great-story;
    }

    &.paper-basket {
      background: $best-prices-great-quality;
    }

    &.paper-box {
      background: $packaged-with-love-and-care;
    }

    &--left {
      display: flex;
      justify-content: flex-start;
      align-items: flex-start;
      flex-direction: column;

      z-index: 4;

      & h5 {
        font-size: 3.5rem;
        font-weight: 400;
        margin-bottom: 2rem;
      }

      & p {
        font-size: 2.1rem;
        font-weight: 300;
      }
    }

    &--right {
      position: relative;
      width: 40%;

      @include respond(tab-port) {
        position: absolute;
        top: 5rem;
        right: -4rem;
        z-index: 2;
        height: 76%;
        width: 43%;
      }

      & figure {
        height: 40rem;
        position: absolute;
        top: 0;
        right: 0;

        & img {
          width: 100%;
          height: 100%;
          object-fit: cover;

          @include respond(tab-port) {
            height: 69%;
          }
        }

        &.sample-dish {
          right: -7rem;
          top: -6rem;

          @include respond(tab-port) {
            right: 0;
            top: 0;
          }
        }

        &.paper-basket {
          right: -7rem;
          top: -6rem;

          @include respond(tab-port) {
            right: 0;
            top: 0;
          }
        }

        &.paper-box {
          right: -7rem;
          top: -6rem;
          transform: scale(1.1);

          @include respond(tab-port) {
            right: 0;
            top: 0;
          }
        }
      }
    }
  }
}
</style>
