<template>
  <div>
    <div class="aboutus">
      <Header />

      <div class="aboutus__content">
        <figure class="aboutus__jumbotron">
          <img src="@/assets/imgs/copy-mast-img.png" />
        </figure>

        <h1 class="aboutus__h1">
          About <span class="name"><span class="name-text">Payoor</span></span>
        </h1>

        <p class="aboutus__content--heading">Our Story</p>
        <p class="aboutus__content--section">
          On May 22nd, 2023, Payoor was born out of a simple but powerful truth, grocery
          shopping can be stressful, and one of our founders "does not like stress". After
          one too many exhausting market runs, the thought became clear: There has to be a
          faster, easier way to get fresh groceries for home-cooked meals.
        </p>
        <p class="aboutus__content--section last">
          That single frustration sparked a journey that took over a year of research,
          development, and fine-tuning to create Payoor; a smart, seamless grocery
          shopping experience designed for people who value their time but still want
          quality, fresh ingredients.
        </p>
        <p class="aboutus__content--heading">Our Mission</p>
        <p class="aboutus__content--section last">
          To make grocery shopping fast, effortless, and stress-free by providing a smart,
          clean, and convenient way to get fresh food straight to your kitchen. We believe
          that every meal shouldn't a stressful and tragic backstory.
        </p>
        <p class="aboutus__content--heading">Our Vision</p>
        <p class="aboutus__content--section">
          To redefine how people shop for groceries by making convenience, freshness, and
          simplicity the new standard one home-cooked meal at a time.
        </p>
      </div>
    </div>
  </div>
</template>

<style scoped lang="scss">
.aboutus {
  min-height: 100vh;
  background: $white;

  &__jumbotron {
    height: 30rem;
    width: 100%;

    overflow: hidden;
    border-radius: 3rem;
    margin-bottom: 3rem;

    & img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }
  }

  &__h1 {
    font-size: 3rem;
    margin-bottom: 4rem;
    font-weight: 400;

    & span {
      color: $primary-color;
      font-size: 4rem;
      position: relative;
      display: inline-block;

      &.name-text {
        animation: moveInUp 0.5s ease forwards;
      }

      &.name {
        &::after {
          content: "";
          position: absolute;
          bottom: -7px;
          left: 0;
          border-radius: 3rem;
          background: $primary-color;
          width: 0%;
          height: 0.3rem;
          animation: growFromLeft 0.5s ease forwards;
        }
      }
    }
  }

  &__content {
    padding: 2rem;
    margin: 0 auto;
    width: 100rem;

    &--heading {
      font-weight: 400;
      font-size: 3rem;

      margin-bottom: 2rem;
    }

    &--section {
      display: block;
      font-size: 1.5rem;
      margin-bottom: 1rem;

      &.last {
        margin-bottom: 3rem;
      }
    }
  }
}
</style>
