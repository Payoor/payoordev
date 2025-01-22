<template>
  <div class="page-layout">
    <aside class="sidebar">
      <SideBar />
    </aside>

    <div class="main">
      <div class="top-nav">
        <div>
          <p class="header"><strong>{{ pageText }}</strong></p>
          <p class="desc">{{ description ?? 'view your dashoard' }}</p>
        </div>

        <div class="admin">
          <div class="avatar"><UserIcon /></div>
          <p>{{ adminName }}</p>
        </div>
      </div>
      <main class="page__container">
        <slot />
      </main>
    </div>
  </div>
</template>

<script>
import UserIcon from '../components/icons/UserIcon.vue';

export default {
  components: {
    UserIcon,
  },

  data() {
    return {
      adminName: ""
    }
  },

  methods: {
    getAdminUsername() {
      this.adminName = localStorage.getItem('adminUsername');
    }
  },

  mounted() {
    this.getAdminUsername();
  },

  props: {
    pageText: {
      type: String,
      default: 'New Page'
    },
    description: {
      type: String,
      default: ''
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
      width: 13rem;
      height: 100%;
    }

    .main {
      position: relative;
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
        color: $font-color;
        font-size: 1.3rem;
        font-weight: 500;
      }

      .top-nav {
        position: fixed;
        top: 0;
        z-index: 20;
        height: 75px;
        border-bottom: 1px solid $grey;
        box-shadow: 0px 0px 5px -2px #32475c4d;
        background-color: $white;
        padding-inline: 2rem;
        width: calc(100% - 13rem);
        color: $font-color;
        display: flex;
        justify-content: space-between;
        align-items: center;

        .desc {
          font-size: 0.8rem;
          opacity: 60%;
          margin: 0;
        }

        .admin {
          display: flex;
          align-items: center;
          gap: 0.25rem;

          .avatar {
            width: 40px;
            height: 40px;
            background-color: $grey;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;

            svg {
              color: rgba($font-color, .7);
            }
          }
        }
      }
    }
  }
</style>
