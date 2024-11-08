<template>
  <DefaultLayout page-text="Create Admin">
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
          <span>Submit</span>
        </button>

        <Notification
          v-if="message"
          :message="message" 
          :isError="hasError"
        />
      </form>
    </div>
  </DefaultLayout>
</template>

<script>
import Default from "../../layouts/Default.vue";
import { createAdmin } from "../../api"

export default {
  components: {
    DefaultLayout: Default,
  },

  data() {
    return {
      username: "",
      password: "",
      message: "",
      hasError: false,
      isLoading: false,
    }
  },

  methods: {
    createAdmin,
    handleSubmit() {
      this.isLoading = true;
      this.message = "";
      this.hasError = false;

      this.createAdmin({
        username: this.username,
        password: this.password,
      }).then((res) => {

        this.message = 'Admin Created!';
        setTimeout(() => {
          this.redirectToAdminsPage();
        }, 2000)
        
      }).catch((error) => {
        console.log(error.response);
        this.isLoading = false;
        this.hasError = true;
        this.message = error.response.data.error || "An error occurred during login";
      })
    },

    redirectToAdminsPage() {
      this.$router.push('/admins');
    }
  },
};
</script>
