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

<style lang="scss" scoped>
.transaction-item {
  border: 2px solid rgb(47, 47, 47);
  border-radius: 0.5rem;
  background-color: rgb(32, 32, 32);
  padding: 1rem;
  position: relative;

  .status {
    position: relative;
    right: 0;
    margin-bottom: 0.5rem;
    font-size: 0.7rem;
    font-weight: bold;
    padding: 0.2rem 1rem;
    border-radius: 0.75rem;
    width: fit-content;

    @media screen and (min-width: 768px) {
      position: absolute;
      bottom: 1rem;
      right: 1rem;
      margin: 0;
    }

    &.verified {
      background-color: rgba($primary-color, 0.3);
      color: $primary-color;
      border: 1px solid $primary-color;
    }

    &.pending {
      background-color: rgba(255, 215, 0, 0.3);
      color: gold;
      border: 1px solid gold;
    }
  }
}
</style>
