<template>
  <div class="order-item">
    <div v-for="(value, key) in orders" :key="key">
      <template v-if="key === 'total'">
        <p>
          <strong>{{ key }}: </strong>
          {{ formatAmount(value) }}
        </p>
      </template>
      <template v-else>
        <p v-if="key !== 'status'">
          <strong>{{ key }}:</strong>
          {{ isDate(value) ? timestampToDateString(value) : value }}
        </p>
      </template>
      <template v-if="key === 'status'">
        <div :class="['status', value]">
          <p>{{ value }}</p>
        </div>
      </template>
    </div>
  </div>
</template>

<script>
import { formatAmount, isDate, timestampToDateString } from '../helpers';
export default {
  props: {
    orders: {
      type: Object
    }
  },

  methods: {
    formatAmount,
    timestampToDateString,
    isDate,
    getObjectValue(value) {
      return this.formatAmount(value?.$numberDecimal) || "Unknown";
    },
  }
}
</script>
