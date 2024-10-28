<template>
  <div>
    <div class="container__header items__header">
      <h1 class="items__h1">
        <span>Payoor</span> <span>{{ page }}</span>
      </h1>
      <h2 class="items__h2">{{ page }} management</h2>

      <div class="items__search">
        <input placeholder="find an item" />
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: ["page"],
};
</script>

<style lang="scss" scoped>
.header {
}
</style>
