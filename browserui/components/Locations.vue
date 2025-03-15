<template>
  <div class="locations" @click.stop="closeAvailLocations">
    <div class="locations__content animate-up box-shadow">
      <div class="locations__body" @click.stop="() => {}">
        <div class="locations__header">
          <h3>
            <span>Payoor</span>
            <span></span>
          </h3>
        </div>

        <div class="locations__list">
          <h3 class="locations__list--h3">
            We're currently available in the following locations
          </h3>
          <div class="locations__listitem">
            <span>Magodo</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
    props: ['closeAvailLocations'],
    data() {
        return {

        }
    }
}
</script>


<style scoped lang="scss">
.locations {
  @include fullscreen-overlay();

  &__content {
    @include modal-container();
    padding: 3rem;
  }

  &__header {
    & h3 {
      color: $primary-color;
      font-size: 3rem;
      font-weight: 500;

      & span {
      }
    }
  }

  &__list {
    margin-top: 2.3rem;
    height: 66rem;
    overflow-x: hidden;
    overflow-y: scroll;

    &--h3 {
      font-size: 1.5rem;
      color: rgba($black, 0.8);
      font-weight: 400;
      margin-bottom: 1rem;
    }
  }

  &__listitem {
    border-radius: 1rem;
    border: 0.1px solid rgba($black, 0.1);
    font-size: 1.7rem;
    padding: 2rem;
    margin-bottom: 1rem;
    color: rgba($black, 0.8)
  }
}
</style>
