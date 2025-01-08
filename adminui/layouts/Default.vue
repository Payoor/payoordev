<template>
  <div class="page-layout">
    <aside class="sidebar">
      <SideBar />
    </aside>

    <main class="page__container">
      <HeaderText :page-text="pageText" />
      <slot />
    </main>
  </div>
</template>

<script>
import ChatBubbleIcon from '../components/icons/ChatBubbleIcon.vue';
import AddPackageIcon from '../components/icons/AddPackageIcon.vue';
export default {
  components: {
    'ChatBubbleIcon': ChatBubbleIcon,
    'AddPackageIcon': AddPackageIcon,
  },
  props: {
    pageText: {
      type: String,
      default: 'New Page'
    }
  },
}
</script>

<style lang="scss" scoped>
  .page-layout {
    color: $white;
    display: flex;
    height: 100vh;
    overflow: hidden;

    aside {
      width: 16rem;
      height: 100%;
    }

    main {
      flex-grow: 1;
      display: flex;
      flex-direction: column;
      overflow-y: auto;
      // height: 100vh;
    }
  }
</style>
