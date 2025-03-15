<template>
  <div>
    <div class="authenticator" @click.stop="closeAuthenticator">
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

            <div class="authenticator__sub" v-if="!displayMsg.length">
              <h4>Please enter your details</h4>
            </div>

            <p v-if="displayMsg.length" class="authenticator__displaymsg">
              {{ displayMsg }}
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

                <span>
                  <button v-if="!isValidEmail || isLoading" class="disabled-btn" disabled>
                    <span v-if="isLoading" class="loader"></span>
                    <span v-else>Continue</span>
                  </button>
                  <button v-else @click="triggerotp">Continue</button>
                </span>
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

export default {
  mixins: [authenticationMixin],
  props: ["closeAuthenticator"],
  data() {
    return {
      otpArray: [1, 2, 3, 4, 5, 6],
      email: null,
      otpDigits: [null, null, null, null, null, null],
      isEmailView: true,
      isOtpView: false,
      displayMsg: "",
      isLoading: false,
      isVerifying: false,
    };
  },
  computed: {
    isValidEmail() {
      const email = this.email;
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

      return typeof email === "string" && emailRegex.test(email);
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
        try {
          const otpValue = this.getOtpValue();

          const success = await this.$store.dispatch("verifyotp", {
            otp: otpValue,
            email: this.email,
          });

          if (success && success.data) {
            if (!success.data.userExists) {
              this.$router.push({
                path: "/onboarding/name",
                query: {
                  email: this.email,
                },
              });
            } else {
              this.closeAuthenticator();

              const userid = success.data.id;

              this.getJWTWithUserId(userid);

              /*this.$store.dispatch("genJWT", { userid });

              this.$router.push({
                path: "/",
                query: {
                  user: userid,
                },
              });*/
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
  },
  methods: {
    async triggerotp() {
      if (this.isLoading) return;

      this.isLoading = true;
      this.displayMsg = "";

      try {
        const success = await this.$store.dispatch("authenticate", { email: this.email });

        if (success) {
          this.displayMsg = "We sent an OTP to your email";
          this.isEmailView = false;
          this.isOtpView = true;

          // Focus on first OTP input after view changes
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
  },
};
</script>

<style scoped lang="scss">
.authenticator {
  @include fullscreen-overlay();

  &__content {
    @include modal-container();
  }

  &__body {
    height: 100%;
    min-width: 100%;
    border: 0.2px solid $primary-color;
    border-radius: inherit;

    display: flex;
    justify-content: space-between;
    overflow: hidden;
  }

  &__header {
    & h3 {
      color: $primary-color;
      font-size: 3rem;
      font-weight: 500;

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
    }
  }

  &__section {
    &.formarea {
      padding: 3rem;
      display: flex;
      flex-direction: column;
      align-items: center;
      padding-top: 15rem;
    }

    &.bike {
      background: $primary-color;
      width: 62rem;
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

      &.occupied {
        border: 1px solid rgba($primary-color, 0.8);
      }

      &:disabled {
        background-color: rgba($black, 0.05);
        cursor: not-allowed;
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
