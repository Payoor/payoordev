<template>
  <div>
    <div class="container">
      <div class="container__content">
        <div class="auth">
          <h1 class="items__h1 margin-bottom-30">
            <span>Payoor</span> <span>Products</span>
          </h1>

          <form class="auth__form">
            <div class="auth__form-group">
              <label for="username" class="auth__label">Username:</label>
              <input
                type="text"
                id="username"
                class="auth__input auth__input--username"
                placeholder="Enter your username"
                v-model="username"
              />
            </div>
            <div class="auth__form-group">
              <label for="password" class="auth__label">Password:</label>
              <input
                type="password"
                id="password"
                class="auth__input auth__input--password"
                placeholder="Enter your password"
                v-model="password"
              />
            </div>
            <button
              type="submit"
              class="auth__submit-btn btn primary"
              :class="{ showAuthBtn, isLoading }"
              @click.prevent="login"
            >
              <span>Log In</span>
            </button>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
const serverUrl = `https://chat.payoor.shop`;

export default {
  data() {
    return {
      username: "",
      password: "",
      isLoading: false,
      errorMessage: "",
    };
  },
  computed: {
    showAuthBtn() {
      const { username, password } = this;
      if (username.length && password.length === 10) {
        return true;
      } else {
        return false;
      }
    },
  },
  methods: {
    async login() {
      const { username, password, showAuthBtn } = this;

      if (showAuthBtn) {
        this.isLoading = true;
        this.errorMessage = "";

        try {
          const response = await fetch(`${serverUrl}/admin/authenticate`, {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
            },
            body: JSON.stringify({ username, password }),
          });

          if (!response.ok) {
            throw new Error("Login failed");
          }

          const data = await response.json();
          console.log("Login successful:", data);

          if (data.token) {
            localStorage.setItem("adminToken", data.token);
            localStorage.setItem("adminUsername", data.admin.username);
            this.redirectToDashboard();
          } else {
            throw new Error("No token received from server");
          }
        } catch (error) {
          console.error("Login error:", error);
          this.errorMessage = error.message || "An error occurred during login";
        } finally {
          this.isLoading = false;
        }
      }
    },
    redirectToDashboard() {
      this.$router.push("/chat");
    },
  },
  logout() {
    localStorage.removeItem("adminToken");
    localStorage.removeItem("adminUsername");
    this.router.push("/");
  },
};
</script>
