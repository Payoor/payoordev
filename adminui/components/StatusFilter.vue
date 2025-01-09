<template>
  <div class="filters">
    <p>Filters: </p>

    <!-- "All" Option -->
    <label 
      :class="{ active: localSelectedStatus === '' }" 
      class="filter-label"
    >
      <input
        type="radio"
        value=""
        v-model="localSelectedStatus"
        @change="emitStatusChange"
        class="filter-input"
      />
      All
    </label>

    <!-- Status Options -->
    <label 
      v-for="status in statuses" 
      :key="status.value" 
      :class="{ active: localSelectedStatus === status.value }" 
      class="filter-label"
    >
      <input
        type="radio"
        :value="status.value"
        v-model="localSelectedStatus"
        @change="emitStatusChange"
        class="filter-input"
      />
      {{ status.label }}
    </label>
  </div>
</template>

<script>
export default {
  props: {
    statuses: {
      type: Array,
      required: true,
    },
    selectedStatus: {
      type: String,
      required: false,
      default: "",
    },
  },
  data() {
    return {
      localSelectedStatus: this.selectedStatus,
    };
  },
  watch: {
    selectedStatus(newVal) {
      this.localSelectedStatus = newVal;
    },
  },
  methods: {
    emitStatusChange() {
      this.$emit("status-change", this.localSelectedStatus);
    },
  },
};
</script>
