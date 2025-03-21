<template>
  <div>
    <div class="paymentconfirm">
      <div class="paymentconfirm__overlay">
        <div class="paymentconfirm__body">
          <h2 class="paymentconfirm__body--h2">Payoor</h2>

          <div class="paymentconfirm__content">
            <h3 class="paymentconfirm__content--h3">Your order is on its way</h3>
            <p class="paymentconfirm__content--prompt">
              You will receive a confirmation email with details of your order
            </p>
            <button class="paymentconfirm__content--btn" @click="gohome">
              <figure>
                <img src="@/assets/imgs/payoorcart.png" />
              </figure>
              <p>Keep shopping</p>
            </button>
          </div>

          <div class="paymentconfirm__indicator">
            <div
              class="paymentconfirm__indicator--line"
              :style="{ width: `${count}%` }"
            ></div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import utilsMixin from "@/mixins/utils";

export default {
  mixins: [utilsMixin],
  data() {
    return {
      count: 0,
    };
  },
  mounted() {
    this.countdowntillclose();
  },
  methods: {
    gohome() {
      const urlParams = new URLSearchParams(window.location.search);
      const affiliateCode = urlParams.get("affiliatecode");

      let redirectUrl = "https://payoor.store/";

      if (affiliateCode) {
        redirectUrl += `?affiliatecode=${encodeURIComponent(affiliateCode)}`;
      }

      window.location.href = redirectUrl;
    },
    countdowntillclose() {
      setInterval(() => {
        const current = this.count + 1;

        this.count = current;

        if (this.count >= 100) {
          return;
        }
      }, 100);
    },
  },
  watch: {
    count(newValue) {
      if (newValue === 100) {
        this.gohome();
      }
    },
  },
};
</script>

<style lang="scss" scoped>
.paymentconfirm {
  &__overlay {
    @include fullscreen-overlay;
  }

  &__body {
    min-height: 3rem;
    width: 50rem;
    background: $white;
    border-radius: 1rem;
    margin: 0 auto;
    margin-top: 20rem;
    overflow: hidden;
    padding: 2rem;
    position: relative;

    animation: moveInUp 0.5s ease forwards;

    @include respond(tab-port) {
      width: 90%;
    }

    &--h2 {
      color: $primary-color;
      font-size: 2.3rem;

      font-weight: 500;
      text-align: center;
      margin-bottom: 2rem;

      @include respond(tab-port) {
        font-size: 4rem;
      }
    }
  }

  &__content {
    display: flex;
    flex-direction: column;
    align-items: center;

    &--h3 {
      font-size: 2rem;
      font-weight: 500;
      opacity: 0.9;

      @include respond(tab-port) {
        font-size: 3rem;
      }
    }

    &--prompt {
      font-size: 1.2rem;
      font-weight: 400;
      text-align: center;
      opacity: 0.6;

      @include respond(tab-port) {
        font-size: 2rem;
        line-height: 2.6rem;
      }
    }

    &--btn {
      display: flex;
      align-items: center;
      border: none;
      outline: none;
      background: none;
      border: 0.4px solid $primary-color;
      border-radius: 3rem;
      cursor: pointer;
      padding: 1rem;
      margin-top: 3rem;

      @include respond(tab-port) {
        border-radius: 10rem;
      }

      & figure {
        background: $primary-color;
        border-radius: 100%;
        height: 2rem;
        width: 2rem;
        display: flex;
        justify-content: center;
        align-items: center;
        margin-right: 0.5rem;
        padding: 0.2rem;

        @include respond(tab-port) {
          height: 3rem;
          width: 3rem;
        }

        & img {
          height: 70%;
          width: 70%;
          object-fit: cover;
        }
      }

      & p {
        color: $primary-color;
        font-weight: 700;

        @include respond(tab-port) {
          font-size: 2.6rem;
          font-weight: 500;
        }
      }
    }
  }

  &__indicator {
    position: absolute;
    width: 100%;
    bottom: 0;
    left: 0;

    &--line {
      width: 100%;
      height: 0.3rem;
      background: $primary-color;
      border-radius: 3rem;

      transition: all 0.5s ease;

      @include respond(tab-port) {
          height: .5rem;
        }
    }
  }
}
</style>
