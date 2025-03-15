<template>
  <div>
    <div class="landingfooter">
      <div class="landingfooter__email">
        <p>Get in touch at contact@payoor.store</p>
      </div>

      <div class="landingfooter__social">
        <figure class="xlogo" @click="openInNewTab('https://x.com/Mypayoor')">
          <img src="@/assets/imgs/xlogo.png" />
        </figure>
        <figure @click="openInNewTab('https://www.instagram.com/mypayoor/')">
          <img src="@/assets/imgs/instagramlogo.png" />
        </figure>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  methods: {
    openInNewTab(url) {
      const newWindow = window.open(url, "_blank");
      newWindow.focus();
    },
  },
};
</script>

<style scoped lang="scss">
.landingfooter {
  background: $grey;
  padding: 10rem 0;
  display: flex;
  justify-content: center;
  padding-top: 2rem;
  margin-top: 6rem;
  flex-direction: column;
  align-items: center;

  &__email {
    color: $black;
    font-weight: 300;
    font-size: 2rem;
  }

  &__social {
    display: flex;
    justify-content: center;
    align-items: center;

    & figure {
      display: inline-block;
      height: 4rem;
      width: 4rem;
      margin: 1rem;
      cursor: pointer;
      transition: transform 0.2s ease;

      &:hover {
        transform: scale(1.1);
      }

      &.xlogo {
        padding: 0.6rem;
      }

      & img {
        object-fit: cover;
        height: 100%;
        width: 100%;
      }
    }
  }
}
</style>
