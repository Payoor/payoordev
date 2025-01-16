<template>
  <div class="user-card" @click="$emit('selectuser', user)">
    <div class="avatar">
      <span>{{ getInitial }}</span>
      <div :class="{isOnline}"></div>
    </div>
    <div class="username">{{ user.name }}</div>
  </div>
</template>

<script>
export default {
  props: {
    user: {
      type: Object
    },
    isOnline: {
      type: Boolean,
      default: false
    }
  },

  computed: {
    getInitial() {
      const fullName = this.user.name;
      return fullName.charAt(0).toUpperCase();
    }
  }
}
</script>

<style lang="scss">
.user-card {
  display: flex;
  gap: 0.5rem;
  border-bottom: 1px solid $grey;
  padding: 1rem 0.5rem;
  align-items: center;
  color: $font-color;
  transition: 0.2s;
  cursor: pointer;

  .username {
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    font-size: 0.8rem;
  }

  .avatar {
    width: 35px;
    height: 35px;
    border-radius: 50%;
    background-color: $grey;
    box-shadow: 0px 0px 5px -2px #32475c4d;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: bold;
    position: relative;

    .isOnline {
      width: 8px;
      height: 8px;
      border-radius: 50%;
      position: absolute;
      background-color: $primary-color;
      bottom: 2px;
      right: 0;
    }
  }

  &:hover, &.active {
    background-color: $grey;
    border-radius: 0.25rem;

    .avatar {
      background-color: $white;
    }
  }
  
  &.topbar-user-indicator {
    border-bottom: 0;
    padding: 0;
    cursor: default;

    &:hover {
      background-color: transparent;
      border-radius: 0;
    }
  }
}
</style>
