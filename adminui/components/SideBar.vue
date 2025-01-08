<template>
  <div class="admin-sidebar">
    <div class="header">Hi, {{ adminUsername ?? 'Admin' }}</div>

    <nav class="sidebar-items">
      <div class="item">
        <ul>
          <li>
            <NuxtLink to="/dashboard">
              <DashboardIcon />
              <span>Dashboard</span>
            </NuxtLink>
          </li>
          <li>
            <NuxtLink to="/all-products">
              <CartIcon />
              <span>Products</span>
            </NuxtLink>
          </li>

          <li>
            <NuxtLink to="/add-products">
              <AddPackageIcon />
              <span>Add Products</span>
            </NuxtLink>
          </li>

          <li>
            <NuxtLink to="/orders">
              <ContainerIcon />
              <span>Orders</span>
            </NuxtLink>
          </li>

          <li>
            <NuxtLink to="/transactions">
              <CreditCardIcon />
              <span>Transactions</span>
            </NuxtLink>
          </li>

          <li>
            <NuxtLink to="/users">
              <UsersIcon />
              <span>Users</span>
            </NuxtLink>
          </li>

          <li>
            <NuxtLink to="/chat">
              <ChatBubbleIcon />
              <span>Chat Room</span>
            </NuxtLink>
          </li>

          <li>
            <NuxtLink to="/admins">
              <UserCogIcon />
              <span>Admins</span>
            </NuxtLink>
          </li>

          <li>
            <NuxtLink to="/create-admin">
              <UserPlusIcon />
              <span>Create Admin</span>
            </NuxtLink>
          </li>
        </ul>
      </div>
    </nav>
  </div>
</template>

<script>
import DashboardIcon from "./icons/DashboardIcon.vue";
import CartIcon from "./icons/CartIcon.vue";
import ChatBubbleIcon from "./icons/ChatBubbleIcon.vue";
import AddPackageIcon from "./icons/AddPackageIcon.vue";
import UserCogIcon from "./icons/UserCogIcon.vue";
import UserPlusIcon from "./icons/UserPlusIcon.vue";
import ContainerIcon from "./icons/ContainerIcon.vue";
import UsersIcon from "./icons/UsersIcon.vue";
import CreditCardIcon from "./icons/CreditCardIcon.vue";

export default {
  components: {
    DashboardIcon,
    CartIcon,
    ChatBubbleIcon,
    AddPackageIcon,
    UserCogIcon,
    UserPlusIcon,
    ContainerIcon,
    UsersIcon,
    CreditCardIcon,
  },

  data() {
    return {
      adminUsername: ""
    }
  },

  methods: {
    getAdminUsername() {
      this.adminUsername = localStorage.getItem('adminUsername');
    }
  },

  mounted() {
    this.getAdminUsername()
  },
};
</script>

<style lang="scss" scoped>
.admin-sidebar {
  display: flex;
  flex-direction: column;
  height: 100vh;
  background-color: rgb(47, 47, 47);

  .header {
    padding: 1rem;
    text-align: center;
    background-color: $primary-color;
    font-size: 1.2rem;
    font-weight: bold;
    text-transform: capitalize;
  }

  nav {
    flex-grow: 1;
    padding-block: 2rem;
    width: 100%;
    overflow-y: auto;

    .item-category {
      width: 100%;
      color: rgba($white, 0.7);
      font-weight: bold;
      padding: 1rem;
      border-bottom: 1px solid rgb(77, 77, 77);
    }

    ul {
      li {
        list-style: none;
        a {
          display: flex;
          align-items: center;
          gap: 0.25rem;
          color: rgba($white, 0.7);
          text-decoration: none;
          font-size: 0.8rem;
          padding: 1.5rem 1rem;
          border-bottom: 1px solid rgb(77, 77, 77);
          transition: 0.2s;

          svg {
            color: $primary-color;
            width: 1rem;
            height: 1rem;
          }

          &:hover {
            background-color: rgb(77, 77, 77);
          }

          &.nuxt-link-active {
            background-color: rgb(77, 77, 77);
            font-weight: bold;
          }
        }
        &:last-child {
          a {
            border-bottom: none;
          }
        }
      }
    }
  }
}
</style>
