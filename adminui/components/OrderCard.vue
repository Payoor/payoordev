<template>
  <div class="order-item">
    <div v-for="(value, key) in orders" :key="key">
      <template v-if="key === 'items'">
        <h3>Items</h3>
        <div class="item-list">
          <div 
            v-for="value, key in value.items"
            :key="key"
          >
            <p>
              <strong>{{ key }}: </strong>
              {{ value }}
            </p>
          </div>
        </div>
      </template>

      <template v-if="key === 'total'">
        <h3>Details</h3>
        <p>
          <strong>{{ key }}: </strong>
          {{ formatAmount(value) }}
        </p>
      </template>

      <template v-if="key !== 'total'">
        <p v-if="key !== 'status' && key !== 'items'">
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

<style lang="scss" scoped>
.order-item {
  border: 2px solid rgb(47, 47, 47);
  border-radius: 0.5rem;
  background-color: rgb(32, 32, 32);
  padding: 1rem;
  position: relative;

  .item-list {
    margin-bottom: 1rem;
  }

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

    &.completed {
      background-color: rgba($primary-color, 0.3);
      color: $primary-color;
      border: 1px solid $primary-color;
    }

    &.pending {
      background-color: rgba(255, 215, 0, 0.3);
      color: gold;
      border: 1px solid gold;
    }

    &.processing {
      background-color: rgba(138, 43, 226, 0.3);
      color: blueviolet;
      border: 1px solid blueviolet;
    }

    &.cancelled {
      background-color: rgba(128, 128, 128, 0.3);
      color: gray;
      border: 1px solid gray;
    }
  }
}
</style>
