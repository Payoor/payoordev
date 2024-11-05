<template>
  <p :class="['submission-message' , isError ? 'error' : 'success']">{{ message }}</p>
</template>

<script>
export default {
  props: {
    isError: {
      type: Boolean,
      default: false
    },
    message: {
      type: String,
      default: false
    }
  }
}
</script>

<style lang="scss" scoped>
  .submission-message {
    width: fit-content;
    font-size: 0.75rem;
    padding: 0.25rem 1rem;
    border-radius: 0.25rem;

    &.error {
      color: #d82b2b;
      background-color: rgba(255, 0, 0, 0.2);
      border: 1px solid #d82b2b;
    }

    &.success {
      color: $primary-color;
      background-color: rgba($primary-color, 0.2);
      border: 1px solid $primary-color;
    }
  }
</style>
