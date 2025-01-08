<template>
  <div class="empty-state">
    <em>{{ emptyText }}</em>
  </div>
</template>

<script>
import CartIcon from './icons/CartIcon.vue';

export default {
  components: {
    CartIcon
  },

  props: {
    emptyText: {
      type: String,
      default: "Empty"
    }
  }
}
</script>

<style lang="scss" scoped>
  .empty-state {
    border: 2px solid rgb(47, 47, 47);
    border-radius: 0.5rem;
    background-color: rgb(32, 32, 32);
    padding: 4rem 1rem;
    text-align: center;
  }
</style>
