<template>
  <div class="admin-sidebar">
    <div class="header">Payoor Admin</div>

    <nav class="sidebar-items">
      <div class="item">
        <div class="item-category">Products</div>
        <ul>
          <li>
            <NuxtLink to="/all-products">
              <CartIcon />
              <span>All Products</span>
            </NuxtLink>
          </li>

          <li>
            <NuxtLink to="/add-products">
              <AddPackageIcon />
              <span>Add Products</span>
            </NuxtLink>
          </li>
        </ul>
      </div>

      <div class="item">
        <div class="item-category">Chat</div>
        <ul>
          <li>
            <NuxtLink to="/chat">
              <ChatBubbleIcon />
              <span>Chat Room</span>
            </NuxtLink>
          </li>
        </ul>
      </div>
    </nav>
  </div>
</template>

<script>
import CartIcon from "./icons/CartIcon.vue";
import ChatBubbleIcon from "./icons/ChatBubbleIcon.vue";
import AddPackageIcon from "./icons/AddPackageIcon.vue";

export default {
  components: {
    CartIcon: CartIcon,
    ChatBubbleIcon: ChatBubbleIcon,
    AddPackageIcon: AddPackageIcon,
  },
};
</script>

<style lang="scss" scoped>
.admin-sidebar {
  display: flex;
  flex-direction: column;

  .header {
    padding: 1rem;
    text-align: center;
    background-color: $primary-color;
    font-size: 1.2rem;
    font-weight: bold;
  }

  nav {
    flex-grow: 1;
    padding-block: 3rem;
    width: 100%;
    height: 100vh;
    background-color: rgb(47, 47, 47);

    .item-category {
      width: 100%;
      color: rgba($white, 0.7);
      font-weight: bold;
      padding: 1rem;
      border-bottom: 1px solid rgb(77, 77, 77);
    }

    ul {
      padding: 1rem;
      li {
        list-style: none;
        a {
          display: flex;
          align-items: center;
          gap: 0.25rem;
          color: rgba($white, 0.7);
          text-decoration: none;
          font-size: 0.8rem;
          padding: 1rem 0.5rem;
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
          }
        }
      }
    }
  }
}
</style>
