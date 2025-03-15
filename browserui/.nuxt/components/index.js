export { default as Authenticator } from '../../components/Authenticator.vue'
export { default as Cart } from '../../components/Cart.vue'
export { default as CartItem } from '../../components/CartItem.vue'
export { default as Categories } from '../../components/Categories.vue'
export { default as DeliveryDetails } from '../../components/DeliveryDetails.vue'
export { default as Header } from '../../components/Header.vue'
export { default as HeaderAuthenticated } from '../../components/HeaderAuthenticated.vue'
export { default as Jumbotron } from '../../components/Jumbotron.vue'
export { default as Landing } from '../../components/Landing.vue'
export { default as LandingCopy } from '../../components/LandingCopy.vue'
export { default as LandingFaq } from '../../components/LandingFaq.vue'
export { default as LandingFooter } from '../../components/LandingFooter.vue'
export { default as Locations } from '../../components/Locations.vue'
export { default as Onboarding } from '../../components/Onboarding.vue'
export { default as Order } from '../../components/Order.vue'
export { default as OrderItem } from '../../components/OrderItem.vue'
export { default as Orders } from '../../components/Orders.vue'
export { default as PayPage } from '../../components/PayPage.vue'
export { default as ProductCard } from '../../components/ProductCard.vue'
export { default as ProductOption } from '../../components/ProductOption.vue'
export { default as ProductOptions } from '../../components/ProductOptions.vue'
export { default as RenderCartItems } from '../../components/RenderCartItems.vue'
export { default as ReviewsSlide } from '../../components/ReviewsSlide.vue'
export { default as SearchBody } from '../../components/SearchBody.vue'
export { default as SearchView } from '../../components/SearchView.vue'
export { default as TypeWriterText } from '../../components/TypeWriterText.vue'
export { default as UnHeaderAuthenticated } from '../../components/UnHeaderAuthenticated.vue'

// nuxt/nuxt.js#8607
function wrapFunctional(options) {
  if (!options || !options.functional) {
    return options
  }

  const propKeys = Array.isArray(options.props) ? options.props : Object.keys(options.props || {})

  return {
    render(h) {
      const attrs = {}
      const props = {}

      for (const key in this.$attrs) {
        if (propKeys.includes(key)) {
          props[key] = this.$attrs[key]
        } else {
          attrs[key] = this.$attrs[key]
        }
      }

      return h(options, {
        on: this.$listeners,
        attrs,
        props,
        scopedSlots: this.$scopedSlots,
      }, this.$slots.default)
    }
  }
}
