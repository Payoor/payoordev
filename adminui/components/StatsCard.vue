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
    background-color: $white;
    padding: 2rem 1.5rem;
    border: 1px solid $grey;
    border-radius: 0.5rem;
    box-shadow: 0px 0px 5px -2px #32475c4d;
    transition: 0.2s;

    &:hover {
      transform: scale(1.02);
    }

    p {
      color: $font-color;
      &.count {
        font-size: 1.5rem;
        font-weight: bold;
      }
    }
  }
</style>
