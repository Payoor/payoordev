<template>
  <div>
    <div class="authenticator" @click.stop="close">
      <div class="authenticator__content animate-up">
        <div class="authenticator__body">
          <div class="authenticator__section formarea" @click.stop="() => {}">
            <div class="authenticator__header">
              <h3>
                <span>Payoor</span>
                <span></span>
              </h3>

              <div></div>
            </div>

            <div class="authenticator__sub" :class="{ error }" v-if="!displayMsg.length">
              <h4>{{ isAffiliateCodeView ? "Your new affiliate code" : heading }}</h4>
            </div>

            <p
              v-if="displayMsg.length"
              class="authenticator__displaymsg"
              :class="{ error }"
            >
              {{
                isAffiliateCodeView
                  ? "Your affiliate application has been received! You'll be receiving email updates on your application"
                  : displayMsg
              }}
            </p>

            <div class="authenticator__form">
              <div class="authenticator__form--email" v-if="isEmailView">
                <span>
                  <input
                    type="email"
                    placeholder="Enter your email"
                    v-model="email"
                    :disabled="isLoading"
                  />
                </span>

                <div v-if="affiliatesignup && affiliateAuth">
                  <span>
                    <input
                      type="text"
                      placeholder="Enter your name"
                      v-model="name"
                      :disabled="isLoading"
                    />
                  </span>

                  <span>
                    <input
                      type="text"
                      placeholder="Enter your phonenumber"
                      v-model="phonenumber"
                      :disabled="isLoading"
                    />
                  </span>

                  <span>
                    <input
                      type="text"
                      placeholder="Enter your social media link if any"
                      v-model="socialmedialink"
                      :disabled="isLoading"
                    />
                  </span>
                </div>

                <span v-if="!affiliateAuth">
                  <button v-if="!isValidEmail || isLoading" class="disabled-btn" disabled>
                    <span v-if="isLoading" class="loader"></span>
                    <span v-else>Continue</span>
                  </button>
                  <button v-else @click="triggerotp">Continue</button>
                </span>

                <span v-if="affiliatesignup && affiliateAuth">
                  <button
                    v-if="
                      !isValidEmail || !isValidName || !isValidPhoneNumber || isLoading
                    "
                    class="disabled-btn"
                    disabled
                  >
                    <span v-if="isLoading" class="loader"></span>
                    <span v-else>Continue</span>
                  </button>
                  <button v-else @click="triggerotp">Continue</button>
                </span>

                <span v-if="!affiliatesignup && affiliateAuth">
                  <button v-if="!isValidEmail || isLoading" class="disabled-btn" disabled>
                    <span v-if="isLoading" class="loader"></span>
                    <span v-else>Continue</span>
                  </button>
                  <button v-else @click="triggerotp">Continue</button>
                </span>

                <!--<div
                  class="authenticator__form--btmbtns"
                  v-if="affiliatesignup && affiliateAuth"
                >
                  <span class="">Already an affiliate?</span>
                  <span class="link" @click="toggleaffiliatesignup"
                    >Simply generate coupon</span
                  >
                </div>-->

                <div
                  class="authenticator__form--btmbtns"
                  v-if="!affiliatesignup && affiliateAuth"
                >
                  <span class="">Not an affiliate?</span>
                  <span class="link" @click="toggleaffiliatesignup">Sign up</span>
                </div>
              </div>

              <div class="authenticator__otp" v-if="isOtpView">
                <input
                  v-for="(digit, index) in otpArray"
                  :key="index"
                  :ref="`otp${index + 1}`"
                  v-model="otpDigits[index]"
                  type="text"
                  maxlength="1"
                  @input="handleInput(index)"
                  @keydown="handleKeydown($event, index)"
                  @paste="handlePaste($event)"
                  :disabled="isVerifying"
                  :class="{
                    occupied: otpDigits[index] !== null && otpDigits[index] !== '',
                  }"
                />
              </div>

              <div v-if="isOtpView && isVerifying" class="authenticator__verifying">
                <div class="loader"></div>
                <p>Verifying...</p>
              </div>

              <!--<div class="authenticator__form--or">
                <span>OR</span>
              </div>

              <div class="authenticator__socials">
                <span>
                  <button>Google</button>
                </span>
              </div>-->

              <div v-if="isAffiliateCodeView && affiliateCode !== null">
                <div class="authenticator__coupon">
                  <TypeWriterText :text="affiliateCode" :color="'rgba(36, 155, 72, 1)'" />
                </div>
              </div>
            </div>
          </div>

          <div class="authenticator__section bike">
            <figure>
              <img src="@/assets/imgs/bike-desktop.png" />
            </figure>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import authenticationMixin from "@/mixins/authentication";
import utilsMixin from "@/mixins/utils";

export default {
  mixins: [authenticationMixin, utilsMixin],
  props: ["closeAuthenticator", "heading", "affiliateAuth"],
  data() {
    return {
      otpArray: [1, 2, 3, 4, 5, 6],
      email: null,
      name: null,
      phonenumber: null,
      socialmedialink: null,
      otpDigits: [null, null, null, null, null, null],
      isEmailView: true,
      isOtpView: false,
      isAffiliateCodeView: false,
      affiliateCode: null,
      displayMsg: "",
      isLoading: false,
      isVerifying: false,
      affiliatesignup: true,
      affiliatesignin: false,
      error: false,
    };
  },
  computed: {
    isValidEmail() {
      const email = this.email;
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

      return typeof email === "string" && emailRegex.test(email);
    },
    isValidName() {
      const { name } = this;

      return name && name.length;
    },
    isValidPhoneNumber() {
      const { phonenumber } = this;

      return phonenumber && phonenumber.length;
    },
    isOtpFilled() {
      const { otpDigits } = this;

      const findEmpty = otpDigits.find((item) => item === "" || item === null);

      if (findEmpty !== undefined) {
        return false;
      } else {
        return true;
      }
    },
  },
  watch: {
    async otpDigits(newValue) {
      if (this.isOtpFilled && !this.isVerifying) {
        this.isVerifying = true;
        const otpValue = this.getOtpValue();

        try {
          if (this.affiliateAuth) {
            const success = await this.$store.dispatch("verifyaffiliateotp", {
              otp: otpValue,
              email: this.email,
            });

            console.log(success);

            if (success && success.message) {
              // Handle error cases
              this.error = true;
              this.displayMsg = success.message;
              return;
            }

            // Handle 200 success responses
            if (success && success.data) {
              if (success.data.message === "Your new affiliate coupon code") {
                const affiliateCode = success.data.coupon.code;
                this.affiliateCode = affiliateCode;
                this.isOtpView = false;
                this.isAffiliateCodeView = true;
                return;
              }

              if (success.data.message === "Your aplication has been created") {
                //const affiliateCode = success.data.coupon.code;
                //this.affiliateCode = affiliateCode;
                this.isOtpView = false;
                this.isAffiliateCodeView = true;
                this.displayMsg = "Your application has been created successfully!";
                return;
              }
            }

            // Fallback for unexpected success response format
            this.error = true;
            this.displayMsg = "Something went wrong. Please try again.";
            return;
          } else {
            const success = await this.$store.dispatch("verifyotp", {
              otp: otpValue,
              email: this.email,
            });

            if (success && success.data) {
              if (!success.data.userExists) {
                this.pageRouter("/onboarding/name", {
                  email: this.email,
                });

                /*this.$router.push({
                  path: "/onboarding/name",
                  query: {
                    email: this.email,
                  },
                });*/
              } else {
                this.closeAuthenticator();

                const userid = success.data.id;

                this.getJWTWithUserId(userid);
              }
            }
          }
        } catch (error) {
          console.error("Error verifying OTP:", error);
          this.displayMsg = "Error verifying OTP. Please try again.";
          // Reset OTP fields on error
          this.otpDigits = [null, null, null, null, null, null];
          // Focus on first OTP input after error
          this.$nextTick(() => {
            if (this.$refs.otp1 && this.$refs.otp1[0]) {
              this.$refs.otp1[0].focus();
            }
          });
        } finally {
          this.isVerifying = false;
        }
      }
    },
    email() {
      this.error = false;
      this.displayMsg = "";
    },
    name() {
      this.error = false;
      this.displayMsg = "";
    },
  },
  methods: {
    toggleaffiliatesignup() {
      this.affiliatesignup = !this.affiliatesignup;
      this.affiliatesignin = !this.affiliatesignin;
    },
    async triggerotp() {
      if (this.isLoading) return;

      this.isLoading = true;
      this.displayMsg = "";

      try {
        let success;

        if (
          (this.affiliatesignup && this.affiliateAuth) ||
          (this.affiliatesignin && this.affiliateAuth)
        ) {
          success = await this.$store.dispatch("authenticate", {
            email: this.email,
            name: this.name,
            phonenumber: this.phonenumber,
            socialmedialink: this.socialmedialink,
            affiliatesignup: this.affiliatesignup,
            affiliatesignin: this.affiliatesignin,
            isAffiliateLink: this.affiliateAuth,
          });
        } else {
          success = await this.$store.dispatch("authenticate", {
            email: this.email,
          });
        }

        if (success) {
          if (success && success.message === "affiliate already exists") {
            this.error = true;
            this.displayMsg = "affiliate already exists";
            return;
          }

          if (
            success &&
            success.message === "Your OTP has expired. Please request a new one."
          ) {
            this.error = true;
            this.displayMsg = "Your OTP has expired. Please request a new one.";
            return;
          }

          if (
            success &&
            success.message === "Affiliate account not found. Please sign up first."
          ) {
            this.error = true;
            this.displayMsg = "Affiliate account not found. Please sign up first.";
            return;
          }

          if (
            success &&
            success.message ===
              "Your affiliate account has been deactivated. Please contact support."
          ) {
            this.error = true;
            this.displayMsg =
              "Your affiliate account has been deactivated or is inactive. Please contact support.";
            return;
          }

          if (
            success &&
            success.message ===
              "The OTP you entered is invalid. Please check and try again."
          ) {
            this.error = true;
            this.displayMsg =
              "The OTP you entered is invalid. Please check and try again.";
            return;
          }

          if (
            success &&
            success.message ===
              "Failed to create your affiliate coupon. Please try again later."
          ) {
            this.error = true;
            this.displayMsg =
              "Failed to create your affiliate coupon. Please try again later.";
            return;
          }

          this.displayMsg = "We sent an OTP to your email";
          this.isEmailView = false;
          this.isOtpView = true;

          this.$nextTick(() => {
            if (this.$refs.otp1 && this.$refs.otp1[0]) {
              this.$refs.otp1[0].focus();
            }
          });
        }
      } catch (error) {
        console.error("Error triggering OTP:", error);
        this.displayMsg = "Error sending OTP. Please try again.";
      } finally {
        this.isLoading = false;
      }
    },
    handleInput(index) {
      if (index < 5 && this.otpDigits[index] !== null && this.otpDigits[index] !== "") {
        const nextIndex = index + 1;
        const nextRef = `otp${nextIndex + 1}`;
        if (this.$refs[nextRef] && this.$refs[nextRef][0]) {
          this.$refs[nextRef][0].focus();
        }
      }
    },
    handleKeydown(event, index) {
      if (
        event.key === "Backspace" &&
        (!this.otpDigits[index] || this.otpDigits[index] === "") &&
        index > 0
      ) {
        const prevRef = `otp${index}`;
        if (this.$refs[prevRef] && this.$refs[prevRef][0]) {
          this.$refs[prevRef][0].focus();
        }
      }
    },
    getOtpValue() {
      return this.otpDigits.join("");
    },
    handlePaste(event) {
      event.preventDefault();
      const pastedData = (event.clipboardData || window.clipboardData).getData("text");

      const numericValue = pastedData.replace(/\D/g, "");
      const digits = [...this.otpDigits]; // Create a copy to avoid mutation issues

      for (let i = 0; i < this.otpDigits.length && i < numericValue.length; i++) {
        digits[i] = numericValue[i];
      }

      this.otpDigits = digits;

      // Focus on the last field or the appropriate field based on paste length
      const lastFilledIndex = Math.min(numericValue.length, this.otpDigits.length);
      const focusRef = `otp${lastFilledIndex}`;
      if (this.$refs[focusRef] && this.$refs[focusRef][0]) {
        this.$refs[focusRef][0].focus();
      }
    },
    close() {
      if (this.closeAuthenticator) {
        this.closeAuthenticator();
      }
    },
  },
};
</script>

<style scoped lang="scss">
.authenticator {
  @include fullscreen-overlay();

  overflow: scroll;

  &__content {
    @include modal-container();

    @include respond(tab-port) {
      height: 100vh;
      width: 100vw;
      overflow-x: hidden;
      overflow-y: scroll;

      margin-top: 0;
    }
  }

  &__body {
    height: 100%;
    min-width: 100%;
    border: 0.2px solid $primary-color;
    border-radius: inherit;

    display: flex;
    justify-content: space-between;
    overflow: hidden;

    @include respond(tab-port) {
      width: 100vw;
      min-width: 100vw;
      justify-content: center;
    }
  }

  &__header {
    & h3 {
      color: $primary-color;
      font-size: 3rem;
      font-weight: 500;

      @include respond(tab-port) {
        font-size: 4rem;
      }

      & span {
      }
    }
  }

  &__sub {
    margin-top: 1rem;
    color: rgba($black, 0.6);
    margin-bottom: 3rem;

    & h4 {
      font-weight: 400;
      font-size: 1.5rem;

      @include respond(tab-port) {
        font-size: 3rem;
      }
    }
  }

  &__section {
    &.formarea {
      padding: 3rem;
      display: flex;
      flex-direction: column;
      align-items: center;
      padding-top: 15rem;

      @include respond(tab-port) {
        padding: 0 1.5rem;
        padding-top: 10rem;
      }
    }

    &.bike {
      background: $primary-color;
      width: 62rem;

      @include respond(tab-port) {
        display: none;
      }
    }

    & figure {
      height: 100%;
      width: 100%;

      overflow: hidden;

      & img {
        object-fit: cover;
        height: auto;
        width: 100%;
        transform: scale(1.5) translateY(28rem);
      }
    }
  }

  &__otp {
    display: flex;
    justify-content: space-between;

    & input {
      border: 1px solid rgba($black, 0.3);
      outline: none;
      height: 8rem;
      width: 5rem;
      border-radius: 0.5rem;
      padding: 1rem;
      font-size: 1.8rem;
      text-align: center;
      color: rgba($primary-color, 1);

      @include respond(tab-port) {
        height: 17rem;
        width: 8rem;
        border-radius: 0.5rem;
        padding: 1rem;
        font-size: 3rem;
        margin: 0 1rem;
      }

      &.occupied {
        border: 1px solid rgba($primary-color, 0.8);
      }

      &:disabled {
        background-color: rgba($black, 0.05);
        cursor: not-allowed;
      }
    }
  }

  &__coupon {
    text-align: center;

    & p {
      &:nth-child(1) {
        font-size: 2.5rem;
        color: rgba($primary-color, 0.8);
        font-weight: 500;
        text-align: center;
        letter-spacing: 1rem;
      }
    }
  }

  &__verifying {
    display: flex;
    flex-direction: column;
    align-items: center;
    margin-top: 2rem;

    p {
      margin-top: 1rem;
      color: $primary-color;
      font-size: 1.4rem;
    }
  }

  &__form {
    width: 50rem;

    @include respond(tab-port) {
      width: auto;
    }

    &--email {
      display: flex;
      flex-direction: column;

      & input {
        width: 50rem;
        border: none;
        outline: none;
        border-radius: 0.5rem;
        border: 0.5px solid rgba($black, 0.3);
        padding: 1.3rem 1rem;
        margin-bottom: 2rem;
        font-size: 1.5rem;

        @include respond(tab-port) {
          width: 100%;
          //height: 7rem;
          font-size: 2.2rem;
          padding: 2.3rem 2rem;
          margin-bottom: 3rem;
        }

        &:disabled {
          background-color: rgba($black, 0.05);
          cursor: not-allowed;
        }
      }

      & button {
        width: 100%;
        border: none;
        outline: none;
        background: $primary-color;
        color: $white;
        font-size: 1.5rem;
        font-weight: 500;
        padding: 1.3rem 1rem;
        border-radius: 0.5rem;
        cursor: pointer;

        &.disabled-btn {
          background: rgba($primary-color, 0.5);
          cursor: not-allowed;
        }

        display: flex;
        justify-content: center;
        align-items: center;

        @include respond(tab-port) {
          padding: 3rem;
          font-size: 3rem;
        }
      }
    }

    &--btmbtns {
      margin-top: 3rem;

      & span {
        font-size: 1.3rem;

        &.link {
          color: rgba($primary-color, 0.8);
          cursor: pointer;
        }
      }
    }

    &--or {
      display: flex;
      justify-content: center;
      align-items: center;
      width: 100%;
      height: 4rem;
      position: relative;

      & span {
        position: relative;
        background: $white;
        display: inline-block;
        padding: 1rem;

        color: rgba($black, 0.6);
        font-weight: 500;
      }

      &::before {
        content: "";
        position: absolute;
        top: 2rem;
        left: 0;
        width: 100%;
        height: 0.1rem;
        background: rgba($black, 0.1);
      }
    }
  }

  &__socials {
    display: flex;
    flex-direction: column;
  }

  &__displaymsg {
    color: $primary-color;
    font-size: 1.4rem;
    font-weight: 500;
    text-align: center;

    margin-top: 1rem;
    margin-bottom: 3rem;

    @include respond(tab-port) {
      font-size: 2.4rem;
      margin-top: 5rem;
    }
  }
}

.loader {
  display: inline-block;
  width: 1.6rem;
  height: 1.6rem;
  border-radius: 50%;
  border: 2px solid rgba($white, 0.3);
  border-top-color: $white;
  animation: spin 1s infinite linear;
}

.authenticator__verifying .loader {
  width: 2.4rem;
  height: 2.4rem;
  border: 2px solid rgba($primary-color, 0.3);
  border-top-color: $primary-color;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}
</style>
