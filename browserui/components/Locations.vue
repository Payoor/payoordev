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
          <div class="locations__listitem">
            <span>Ikeja</span>
          </div>
          <div class="locations__listitem">
            <span>Victoria Island</span>
          </div>
          <div class="locations__listitem">
            <span>Ogudu</span>
          </div>
          <div class="locations__listitem">
            <span>Ikate</span>
          </div>
          <div class="locations__listitem">
            <span>Lekki (Phase 1)</span>
          </div>
          <div class="locations__listitem">
            <span>Lagos Island</span>
          </div>
          <div class="locations__listitem">
            <span>Maryland</span>
          </div>
          <div class="locations__listitem">
            <span>Mushin</span>
          </div>
          <div class="locations__listitem">
            <span>Ogba</span>
          </div>
          <div class="locations__listitem">
            <span>Oshodi</span>
          </div>
          <div class="locations__listitem">
            <span>Opebi/Allen</span>
          </div>
          <div class="locations__listitem">
            <span>Oshodi-Isolo</span>
          </div>
          <div class="locations__listitem">
            <span>Omole</span>
          </div>
          <div class="locations__listitem">
            <span>Shomolu</span>
          </div>
          <div class="locations__listitem">
            <span>Surulere</span>
          </div>
          <div class="locations__listitem">
            <span>Yaba</span>
          </div>
          <div class="locations__listitem">
            <span>Berger</span>
          </div>
          <div class="locations__listitem">
            <span>Ojota</span>
          </div>
          <div class="locations__listitem">
            <span>Ketu</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: ["closeAvailLocations"],
  data() {
    return {};
  },
};
</script>

<style scoped lang="scss">
.locations {
  @include fullscreen-overlay();

  &__content {
    @include modal-container();
    padding: 3rem;
    height: 55rem;
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
    height: 40rem;
    overflow-x: hidden;
    overflow-y: scroll;
    padding-bottom: 4rem;

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
    color: rgba($black, 0.8);
  }
}
</style>
