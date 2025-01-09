<template>
  <NuxtLink 
    class="stats-card" 
    :to="href"
  >
    <slot name="icon" />
    <p class="label">{{ label }}</p>
    <p class="count">{{ count }}</p>
  </NuxtLink>
</template>

<script>
export default { 
  props: {
    label: {
      type: String,
      require: true
    },
    count: {
      type: Number,
      require: true
    },
    href: {
      type: String,
      require: true
    }
  }
}
</script>
<style lang="scss" scoped>
  .stats-card {
    text-decoration: none;
    display: grid;
    grid-template-rows: auto;
    gap: 1rem;
    align-items: center;
    background-color: rgb(47, 47, 47);
    padding: 2rem 1.5rem;
    border-radius: 0.5rem;
    transition: 0.2s;

    &:hover {
      background-color: rgb(77, 77, 77);
      transform: scale(1.02);
    }

    p {
      color: rgba($white, 0.7);
      &.count {
        font-weight: bold;
      }
    }
  }
</style>
