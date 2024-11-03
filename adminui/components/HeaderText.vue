<template>
  <div class="header-container">
    <h1>Payoor <span>{{ pageText }}</span></h1>
  </div>
</template>

<script>
  export default {
    props: {
      pageText: String
    }
  }
</script>

<style lang="scss" scoped>
.header-container h1 {
  color: $primary-color;
}
span {
  color: $white;
  font-size: 1.3rem;
  font-weight: 500;
}
</style>
