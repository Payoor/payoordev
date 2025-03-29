<template>
  <div>
    <div class="landingfaq">
      <div class="landingfaq__content">
        <h4>FAQ</h4>

        <div class="landingfaq__faqs">
          <div class="landingfaq__faq" v-for="(faq, index) in faqs" :key="index">
            <h5 class="landingfaq__faq--header">{{ faq.title }}</h5>

            <p
              class="landingfaq__faq--description"
              v-for="(content, contentIndex) in faq.content"
              :key="contentIndex"
            >
              {{ content }}
            </p>

            <div v-if="faq.locations">
              <p
                v-for="(location, locationIndex) in faq.locations"
                :key="locationIndex"
                class="landingfaq__faq--description location"
              >
                {{ location }}{{ locationIndex < faq.locations.length - 1 ? "," : "" }}
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      faqs: [
        {
          title: "What is Payoor?",
          content: [
            "Payoor is an online grocery assistant that helps you with your all your grocery and market needs.",
          ],
        },
        {
          title: "How long do deliveries take?",
          content: [
            "Deliveries take 48hours from checkout and you can set future delivery day.",
          ],
        },
        {
          title: "Which locations do we currently service?",
          content: [
            "Currently, we only deliver to some parts of Lagos, although we expanding rapidly across Nigeria,",
          ],
          locations: [
            "Magodo",
            "Ikeja",
            "Victoria Island",
            "Ogudu",
            "Ikate",
            "Lekki (Phase 1)",
            "Lagos Island",
            "Maryland",
            "Mushin",
            "Ogba",
            "Oshodi",
            "Opebi/Allen",
            "Oshodi-Isolo",
            "Omole",
            "Shomolu",
            "Surulere",
            "Victoria Island",
            "Yaba",
            "Berger",
            "Ojota",
            "Ketu",
          ],
        },
        {
          title: "What is Service charge?",
          content: [
            "The service fee is a consumer fee that appears on the price breakdown at checkout on the payoor app. Unlike other consumer fees, the service fee depends on your order's subtotal, that is, a very small percentage of your bill excluding the delivery fee. It also does not apply to all restaurants on our platform.",
          ],
        },
        {
          title: "What is Shop by Recipe?",
          content: [
            "The service fee is a consumer fee that appears on the price breakdown at checkout on the payoor app. Unlike other consumer fees, the service fee depends on your order's subtotal, that is, a very small percentage of your bill excluding the delivery fee. It also does not apply to all restaurants on our platform.",
          ],
        },
      ],
    };
  },
};
</script>

<style scoped lang="scss">
.landingfaq {
  @include section;
  padding-top: 0;

  @include respond(tab-port) {
    padding: 0
  }

  &__content {
    background: $white;
    padding: 3rem;
    border-radius: 1rem;

    & h4 {
      text-align: center;
      font-size: 4rem;
      font-weight: 500;
      margin-top: 4rem;
    }
  }

  &__faqs {
    margin-top: 2rem;
  }

  &__faq {
    border: 1px solid $black;
    border-radius: 1rem;
    padding: 2rem;

    margin-bottom: 3rem;

    &--header {
      font-size: 2rem;
      font-weight: 500;
      margin-bottom: 2rem;
    }

    &--description {
      font-size: 1.5rem;
      font-weight: 300;
      line-height: 3rem;

      &.location {
        display: inline-block;
        color: $primary-color;
        font-weight: 600;
        margin-right: .5rem;
      }
    }
  }
}
</style>
