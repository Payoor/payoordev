<template>
  <div class="empty-state">
    <CartIcon class="cart-icon" />

    <span>There are no products yet</span>

    <NuxtLink class="link" to="/add-products">Create products</NuxtLink>
  </div>
</template>

<script>
import CartIcon from './icons/CartIcon.vue';

export default {
  components: {
    CartIcon
  }
}
</script>

<style lang="scss" scoped>
  .empty-state {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 5rem 0;
    gap: 1rem;

    .cart-icon {
      color: #2f2f2f;
      width: 100px;
      height: 100px;
    }

    span {
      color: rgba($white, .7);
    }

    a {
      background-color: $primary-color;
      color: $white;
      font-size: 0.8rem;
      text-decoration: none;
      padding: 0.75rem 1rem;
      border-radius: 0.5rem;
      transition: all .2s ease;

      &:hover {
        opacity: .7;
      }
    }
  }
</style>
