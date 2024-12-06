<template>
  <div class="transaction-item">
    <div v-for="(value, key) in transactions" :key="key">
      <template v-if="key === 'amount'">
        <p>
          <strong>{{ key }}: </strong>
          {{ getObjectValue(value) }}
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
    transactions: {
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
