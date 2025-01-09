<template>
  <div class="page__container">
    <HeaderText :page-text="'Admin Login'" />
    <div class="form__container">
      <form @submit.prevent="handleSubmit">

        <div class="form__group">
          <label for="username">Username</label>
          <input
            type="text"
            placeholder="Enter username"
            v-model="username"
          >
        </div>

        <div class="form__group">
          <label for="password">Password</label>
          <input
            type="password"
            placeholder="Enter password"
            v-model="password"
          >
        </div>

        <button
          type="submit"
          class="submit-btn"
          :class="{ isLoading }"
        >
          <span>Login</span>
        </button>

        <Notification
          v-if="message"
          :message="message" 
          :isError="hasError"
        />
      </form>
    </div>
  </div>
</template>

<script>
import { adminLogin } from "../api";

export default {
  data() {
    return {
      username: "",
      password: "",
      isLoading: false,
      message: "",
      hasError: false,
    }
  },

  methods: {
    adminLogin,
    handleSubmit() {
      this.isLoading = true;
      this.message = "";
      this.hasError = false;

      this.adminLogin({
        username: this.username,
        password: this.password,
      }).then((res) => {

        localStorage.setItem("adminToken", res.data.token);
        localStorage.setItem("adminUsername", res.data.admin.username);

        this.message = 'Login successful!'
        setTimeout(() => {
          this.redirectToDashboard();
        }, 2000)
        
      }).catch((error) => {
        console.log(error.response);
        this.isLoading = false;
        this.hasError = true;
        this.message = error.response.data.error || "An error occurred during login";
      })
    },

    redirectToDashboard() {
      this.$router.push("/dashboard");
    }
  },
}
</script>
