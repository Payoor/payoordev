<template>
  <div class="productcard__options animate-up">
    <h5 class="productcard__options--h5">Product Name Options</h5>

    <div class="productcard__options--list">
      <div
        v-for="(productoption, index) in productoptions"
        :key="productoption.id || index"
      >
        <ProductOption
          :productoption="productoption"
          :productname="productname"
          :productid="productid"
        />
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: ["productoptions", "productname", "productid"],
};
</script>
