import Vue from 'vue'
import Router from 'vue-router'
import { normalizeURL, decode } from 'ufo'
import { interopDefault } from './utils'
import scrollBehavior from './router.scrollBehavior.js'

const _8b669e44 = () => interopDefault(import('../pages/aboutus.vue' /* webpackChunkName: "pages/aboutus" */))
const _f6e09692 = () => interopDefault(import('../pages/affiliateprogram/index.vue' /* webpackChunkName: "pages/affiliateprogram/index" */))
const _472e1f63 = () => interopDefault(import('../pages/checkout.vue' /* webpackChunkName: "pages/checkout" */))
const _91ab560a = () => interopDefault(import('../pages/onboarding/index.vue' /* webpackChunkName: "pages/onboarding/index" */))
const _25015d9b = () => interopDefault(import('../pages/pay.vue' /* webpackChunkName: "pages/pay" */))
const _82433b88 = () => interopDefault(import('../pages/payment/index.vue' /* webpackChunkName: "pages/payment/index" */))
const _90160aa4 = () => interopDefault(import('../pages/paymentconfirmation.vue' /* webpackChunkName: "pages/paymentconfirmation" */))
const _dfad5f5a = () => interopDefault(import('../pages/paystackconfirm.vue' /* webpackChunkName: "pages/paystackconfirm" */))
const _92a9d7f6 = () => interopDefault(import('../pages/search.vue' /* webpackChunkName: "pages/search" */))
const _159cad2e = () => interopDefault(import('../pages/try.vue' /* webpackChunkName: "pages/try" */))
const _092333a0 = () => interopDefault(import('../pages/onboarding/address/index.vue' /* webpackChunkName: "pages/onboarding/address/index" */))
const _e0cca016 = () => interopDefault(import('../pages/onboarding/name/index.vue' /* webpackChunkName: "pages/onboarding/name/index" */))
const _034b04ba = () => interopDefault(import('../pages/onboarding/phonenumber/index.vue' /* webpackChunkName: "pages/onboarding/phonenumber/index" */))
const _29a48605 = () => interopDefault(import('../pages/index.vue' /* webpackChunkName: "pages/index" */))

const emptyFn = () => {}

Vue.use(Router)

export const routerOptions = {
  mode: 'history',
  base: '/',
  linkActiveClass: 'nuxt-link-active',
  linkExactActiveClass: 'nuxt-link-exact-active',
  scrollBehavior,

  routes: [{
    path: "/aboutus",
    component: _8b669e44,
    name: "aboutus"
  }, {
    path: "/affiliateprogram",
    component: _f6e09692,
    name: "affiliateprogram"
  }, {
    path: "/checkout",
    component: _472e1f63,
    name: "checkout"
  }, {
    path: "/onboarding",
    component: _91ab560a,
    name: "onboarding"
  }, {
    path: "/pay",
    component: _25015d9b,
    name: "pay"
  }, {
    path: "/payment",
    component: _82433b88,
    name: "payment"
  }, {
    path: "/paymentconfirmation",
    component: _90160aa4,
    name: "paymentconfirmation"
  }, {
    path: "/paystackconfirm",
    component: _dfad5f5a,
    name: "paystackconfirm"
  }, {
    path: "/search",
    component: _92a9d7f6,
    name: "search"
  }, {
    path: "/try",
    component: _159cad2e,
    name: "try"
  }, {
    path: "/onboarding/address",
    component: _092333a0,
    name: "onboarding-address"
  }, {
    path: "/onboarding/name",
    component: _e0cca016,
    name: "onboarding-name"
  }, {
    path: "/onboarding/phonenumber",
    component: _034b04ba,
    name: "onboarding-phonenumber"
  }, {
    path: "/",
    component: _29a48605,
    name: "index"
  }],

  fallback: false
}

export function createRouter (ssrContext, config) {
  const base = (config._app && config._app.basePath) || routerOptions.base
  const router = new Router({ ...routerOptions, base  })

  // TODO: remove in Nuxt 3
  const originalPush = router.push
  router.push = function push (location, onComplete = emptyFn, onAbort) {
    return originalPush.call(this, location, onComplete, onAbort)
  }

  const resolve = router.resolve.bind(router)
  router.resolve = (to, current, append) => {
    if (typeof to === 'string') {
      to = normalizeURL(to)
    }
    return resolve(to, current, append)
  }

  return router
}
