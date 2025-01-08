<template>
  <div class="page-layout">
    <aside class="sidebar">
      <SideBar />
    </aside>

    <main class="page__container">
      <template v-if="pageText === 'Dashboard'">
        <div class="greeting">
          <h1>Welcome <span>{{ getAdminUsername }}</span></h1>
        </div>
      </template>
      <template v-else>
        <HeaderText :page-text="pageText" />
      </template>
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
  computed: {
    getAdminUsername() {
      return localStorage.getItem('adminUsername');
    }
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

      .greeting h1 {
        color: $primary-color;
        text-transform: capitalize;
      }
      span {
        color: $white;
        font-size: 1.3rem;
        font-weight: 500;
      }
    }
  }
</style>
