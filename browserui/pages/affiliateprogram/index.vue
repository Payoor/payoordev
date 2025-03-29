<template>
  <div>
    <div class="affiliate">
      <div class="affiliate__mobilemenu" v-if="showmobilemenu">
        <div class="affiliate__mobilemenu--overlay" @click="toggleMobileMenu">
          <div class="affiliate__mobilemenu--close">
            <svg>
              <use v-bind:xlink:href="'/symbol-defs.svg#icon-plus'"></use>
            </svg>
          </div>
        </div>
        <div class="affiliate__mobilemenu--content">
          <!--<div class="affiliate__mobilemenu--btn">Sign up/Sign in</div>-->
          <div class="affiliate__mobilemenu--btn">Join Affiliate Program</div>
        </div>
      </div>

      <div class="affiliate__form" v-if="showform">
        <div>
          <Authenticator
            :heading="'Join our affiiate program'"
            :affiliateAuth="true"
            :closeAuthenticator="toggleShowForm"
          />
        </div>
      </div>

      <div class="affiliate__content">
        <div class="affiliate__content--header">
          <div></div>

          <h2 class="affiliate__content--h2">
            <span>Payoor</span>
            <span>affiliates</span>
          </h2>

          <div class="affiliate__content--auth">
            <span><!--Sign up/Sign in--></span>
          </div>

          <div class="affiliate__content--burger" @click="toggleMobileMenu">
            <span></span>
            <span></span>
            <span></span>
          </div>
        </div>

        <div class="affiliate__jumbotron">
          <figure class="affiliate__jumbotron--fig">
            <img src="@/assets/imgs/copy-mast-img.png" />
          </figure>

          <div class="affiliate__jumbotron--text">
            <h3>
              Earn Instantly with <span class="green-logo">Payoor's</span> Affiliate
              Program!
            </h3>
            <button @click="toggleShowForm">Join</button>
          </div>
        </div>

        <div class="affiliate__section">
          <h3 class="affiliate__section--h3">
            What is <span class="green-logo">Payoor</span>?
          </h3>

          <p class="affiliate__section--p">
            Imagine your local market , but cheaper, fresher, and hassle-free right from
            your phone! With <span class="green-logo">Payoor</span>, you can shop for
            groceries conveniently and get them delivered straight to your doorstep.
          </p>
        </div>

        <div class="affiliate__section">
          <h3 class="affiliate__section--h3">How You Can Earn</h3>

          <p class="affiliate__section--p2">Getting started is simple:</p>

          <div class="affiliate__section--grid">
            <div class="affiliate__section--griditem">
              <p class="affiliate__section--griditemnumber">1</p>
              <p class="affiliate__section--griditemheader">Refer</p>
              <p class="affiliate__section--griditemcopy">
                Refer new users to sign up and place an order.
              </p>
            </div>

            <div class="affiliate__section--griditem">
              <p class="affiliate__section--griditemnumber">2</p>
              <p class="affiliate__section--griditemheader">Earn</p>
              <p class="affiliate__section--griditemcopy">
                Earn 11% commission instantly on every successful order.
              </p>
            </div>

            <div class="affiliate__section--griditem">
              <p class="affiliate__section--griditemnumber">3</p>
              <p class="affiliate__section--griditemheader">Earn an Extra ₦10,000!</p>
              <p class="affiliate__section--griditemcopy">
                Refer new users to sign up and place an order.
              </p>
            </div>
          </div>
        </div>

        <div class="affiliate__section">
          <h3 class="affiliate__section--h3">What we did to make it easy for you:</h3>

          <p class="affiliate__section--p3">
            - First-time users get free delivery, making it easier to convince them to try
            <span class="green-logo">Payoor</span>.
          </p>

          <p class="affiliate__section--p3">
            - No delays — your commission is paid instantly.
          </p>

          <p class="affiliate__section--p3">
            - The more people you refer, the more you earn!
          </p>

          <p class="affiliate__section--p4">Start earning today!</p>
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
      showform: false,
      showmobilemenu: false,
    };
  },
  methods: {
    async createAffiliate() {},
    toggleShowForm() {
      this.showform = !this.showform;
    },
    toggleMobileMenu() {
      this.showmobilemenu = !this.showmobilemenu;
    },
  },
};
</script>

<style scoped lang="scss">
.affiliate {
  &__header {
  }

  &__form {
    position: fixed;
    top: 0;
    left: 0;
    width: 100vw;
    min-height: 100vh;
    z-index: 4;
  }

  &__content {
    min-height: 100vh;
    background: $white;
    position: relative;
    padding: 0 30rem;
    padding-bottom: 10rem;

    @include respond(tab-port) {
      padding: 0;
      padding-bottom: 10rem;
    }

    &--header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 4rem;
      padding-top: 3rem;

      @include respond(tab-port) {
        padding: 3rem 2rem;
        margin-bottom: 0;
      }
    }

    &--auth {
      font-size: 1.4rem;
      cursor: pointer;

      @include respond(tab-port) {
        font-size: 2.4rem;
        display: none;
      }
    }

    &--burger {
      display: none;

      @include respond(tab-port) {
        display: flex;
        flex-direction: column;

        & span {
          display: inline-block;
          margin: 0.4rem;
          border-radius: 3rem;
          background: $primary-color;
          height: 0.5rem;
          width: 4rem;
        }
      }
    }

    &--h2 {
      text-align: center;

      & span {
        &:nth-child(1) {
          color: $primary-color;
          font-size: 2.5rem;
          font-weight: 500;

          @include respond(tab-port) {
            font-size: 3.4rem;
          }
        }

        &:nth-child(2) {
          font-size: 2rem;
          font-weight: 300;

          @include respond(tab-port) {
            font-size: 3rem;
          }
        }
      }
    }
  }

  &__jumbotron {
    width: 100%;
    position: relative;

    &::before {
      content: "";
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: rgba($black, 0.8);
      z-index: 2;
    }

    &--fig {
      position: relative;
      width: 100%;
      height: 30rem;
      border-radius: 0.3rem;
      overflow: hidden;

      @include respond(tab-port) {
        height: 50rem;
      }

      & img {
        object-fit: cover;
        height: 100%;
        width: 100%;
        position: absolute;
        top: 0;
        left: 0;
        z-index: 1;
      }
    }

    &--text {
      position: absolute;
      top: 0;
      left: 0;
      height: 100%;
      width: 100%;
      z-index: 3;
      display: flex;
      justify-content: center;
      align-items: center;
      flex-direction: column;

      & h3 {
        font-weight: 500;
        font-size: 3rem;
        color: $white;
        margin-bottom: 2rem;
        text-align: center;

        @include respond(tab-port) {
          font-size: 3.5rem;
          margin-bottom: 4rem;
        }
      }

      & button {
        background: $primary-color;
        color: $black;
        border-radius: 3rem;
        padding: 1rem 4rem;
        border: none;
        outline: none;
        cursor: pointer;
        font-size: 1.5rem;

        font-weight: 700;

        @include respond(tab-port) {
          font-size: 3rem;
          padding: 2rem 8rem;
          border-radius: 6rem;
        }
      }
    }
  }

  &__section {
    margin-bottom: 6rem;

    @include respond(tab-port) {
      padding: 2rem;
      margin-bottom: 1rem;
    }

    &--grid {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      grid-gap: 5rem;

      @include respond(tab-port) {
        grid-template-columns: repeat(1, 1fr);
      }
    }

    &--griditem {
      display: flex;
      flex-direction: column;
      margin-top: 5rem;
      align-items: center;

      @include respond(tab-port) {
        align-items: flex-start;
      }
    }

    &--griditemnumber {
      border-radius: 100%;
      background: $primary-color;
      height: 3rem;
      width: 3rem;
      display: flex;
      justify-content: center;
      align-items: center;
      color: $white;
      font-size: 1.3rem;
      font-weight: 500;

      @include respond(tab-port) {
        font-size: 2rem;
        height: 4rem;
        width: 4rem;
      }
    }

    &--griditemheader {
      margin-top: 1rem;
      font-size: 1.9rem;
      margin-bottom: 1.2rem;

      @include respond(tab-port) {
        font-size: 2.9rem;
      }
    }

    &--griditemcopy {
      font-size: 1.7rem;
      font-weight: 500;
      text-align: center;

      @include respond(tab-port) {
        font-size: 2.5rem;
        text-align: left;
      }
    }

    &--h3 {
      font-size: 2.3rem;
      font-weight: 500;
      margin: 3rem 0;

      @include respond(tab-port) {
        font-size: 3rem;
      }
    }

    &--p {
      font-size: 1.8rem;
      font-weight: 400;

      @include respond(tab-port) {
        font-size: 2.5rem;
        line-height: 5.5rem;
      }
    }

    &--p2 {
      font-size: 1.5rem;

      @include respond(tab-port) {
        font-size: 2.5rem;
      }
    }

    &--p3 {
      font-size: 2rem;
      margin-bottom: 4rem;

      @include respond(tab-port) {
        font-size: 2.5rem;
      }
    }

    &--p4 {
      font-size: 2rem;
      font-weight: 600;

      @include respond(tab-port) {
        font-size: 2.5rem;
      }
    }
  }

  &__mobilemenu {
    position: fixed;
    z-index: 4;
    height: 100vh;
    width: 100vw;
    top: 0;
    left: 0;
    display: flex;

    display: none;

    @include respond(tab-port) {
      display: flex;
    }

    &--content {
      background: #fff;
      height: 100%;
      width: 80%;
    }

    &--overlay {
      position: relative;
      background: rgba($black, 0.8);
      height: 100%;
      width: 20%;
    }

    &--close {
      position: absolute;
      top: 2rem;
      left: 2rem;

      & svg {
        color: $white;
        fill: $white;
        height: 4.5rem;
        width: 4.5rem;
        transform: rotate(45deg);
      }
    }

    &--btn {
      font-size: 2.5rem;
      padding: 4rem;
      border-bottom: 0.1rem solid rgba($black, 0.8);
    }
  }
}
</style>
