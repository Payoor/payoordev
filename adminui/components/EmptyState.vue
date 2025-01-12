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
    border: 2px solid $grey;
    border-radius: 0.5rem;
    background-color: $white;
    padding: 4rem 1rem;
    text-align: center;
    color: $font-color;
  }
</style>
