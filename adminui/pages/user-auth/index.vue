<template>
  <div class="page__container">
    <HeaderText :page-text="'User Sign Up'" />
    <div class="form__container">
      <form @submit.prevent="handleSubmit">

        <div class="form__group">
          <label for="name">Name</label>
          <input
            type="text"
            placeholder="Enter name"
            v-model="name"
          >
        </div>

        <div class="form__group">
          <label for="email">Email</label>
          <input
            type="email"
            placeholder="Enter email"
            v-model="email"
          >
        </div>

        <div class="form__group">
          <label for="phone">Phone</label>
          <input
            type="tel"
            placeholder="Enter phone"
            v-model="phone"
          >
        </div>

        <div class="form__group">
          <label for="location">Location</label>
          <input
            type="text"
            placeholder="Enter location"
            v-model="location"
          >
        </div>

        <div class="form__group">
          <label for="shopping_list">Shopping List</label>
          <input
            type="text"
            placeholder="Enter shopping"
            v-model="shoppingList"
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
  </div>
</template>

<script>
import { generateUserJWT, userSignUp } from "../../api";

export default {
  data() {
    return {
      name: "",
      email: "",
      phone: "",
      location: "",
      shoppingList: "",
      isLoading: false,
      message: "",
      hasError: false,
    }
  },

  methods: {
    userSignUp,
    generateUserJWT,
    handleSubmit() {
      this.isLoading = true;
      this.message = "";
      this.hasError = false;

      this.userSignUp({
        name: this.name,
        email: this.email,
        phone: this.phone,
        location: this.location,
        shoppingList: this.shoppingList,
      }).then((res) => {
        console.log(res.data);
        localStorage.setItem("payoor_user_id", res.data.data.user.id);
        this.generateUserJWT(res.data.data.user.id).then(response => {
          console.log(response.data)
          localStorage.setItem("payoor_user_token", response.data.data.token);
        })

        this.message = 'Sign up successful!'
        setTimeout(() => {
          this.redirectToDashboard();
        }, 2000)
        
      }).catch((error) => {
        console.log(error.response);
        this.isLoading = false;
        this.hasError = true;
        this.message = error.response.data.error || "An error occurred during signup";
      })
    },

    redirectToDashboard() {
      this.$router.push("/user-chat");
    }
  },
}
</script>
