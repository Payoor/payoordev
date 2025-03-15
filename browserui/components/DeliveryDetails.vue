<template>
  <div>
    <div class="deliverydetails">
      <div class="deliverydetails__detail">
        <label class="deliverydetails__detail--label">Reachable Phone Number</label>
        <input class="deliverydetails__detail--input" v-model="phoneNumber" />
      </div>

      <div class="deliverydetails__detail">
        <label class="deliverydetails__detail--label">Your current address</label>
        <input class="deliverydetails__detail--input" v-model="userAddress" />
      </div>

      <div class="deliverydetails__detail">
        <label class="deliverydetails__detail--label">Pick a delivery date</label>
        <div class="deliverydetails__deliverydates">
          <div
            class="deliverydetails__deliverydate"
            :class="{
              choosendate:
                availableDate === choosendate || availableDate === deliveryDate,
            }"
            v-for="(availableDate, index) in availableDates"
            :key="index"
            @click="selectdate(availableDate)"
          >
            <span>{{ availableDate }}</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: [
    "userAddress",
    "phoneNumber",
    "availableDates",
    "selectDeliveryDate",
    "deliveryDate",
  ],
  data() {
    return {
      choosendate: null,
    };
  },
  methods: {
    selectdate(availableDate) {
      this.choosendate = availableDate;
      this.selectDeliveryDate(availableDate);
    },
  },
  mounted() {
    console.log(this.availableDates);
  },
};
</script>

<style scoped lang="scss">
.deliverydetails {
  &__detail {
    display: flex;
    flex-direction: column;
    margin-bottom: 3.5rem;

    &--label {
      font-size: 1.5rem;
      font-weight: 600;
      display: inline-block;
      margin-bottom: 1rem;
      color: rgba($primary-color, 1);
    }

    &--input {
      padding: 1.3rem;
      border-radius: 1.2rem;
      outline: none;
      border: 0.1px solid rgba($black, 0.3);
      font-size: 1.5rem;
    }
  }

  &__deliverydates {
    display: grid;
    grid-template-columns: repeat(5, 1fr);
    grid-gap: 1rem;
  }

  &__deliverydate {
    border: 0.1px solid rgba($black, 0.4);
    border-radius: 0.4rem;
    padding: 1rem;
    cursor: pointer;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    transition: all 0.4s ease;

    &:hover {
      background: rgba($primary-color, 0.4);
      border: 0.1px solid rgba($primary-color, 0.4);
    }

    &.choosendate {
      background: rgba($primary-color, 0.4);
      border: 0.1px solid rgba($primary-color, 0.4);
    }

    & span {
      font-size: 1.3rem;
    }
  }
}
</style>
