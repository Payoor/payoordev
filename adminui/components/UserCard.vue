<template>
  <div class="user-card">
    <div class="avatar">
      <span>A</span>
      <div :class="{isOnline}"></div>
    </div>
    <div class="username">Abiodun</div>
  </div>
</template>

<script>
export default {
  props: {
    isOnline: {
      type: Boolean,
      default: false
    }
  }
}
</script>

<style lang="scss" scoped>
.user-card {
  display: flex;
  gap: 1rem;
  border-bottom: 1px solid rgb(47, 47, 47);
  padding: 1rem 0.5rem;
  align-items: center;
  color: rgba($white, 0.7);
  transition: 0.2s;
  cursor: pointer;

  .avatar {
    width: 35px;
    height: 35px;
    border-radius: 50%;
    background-color: rgb(66, 66, 66);
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

  &:hover {
    background-color: rgb(66, 66, 66);
    border-radius: 0.25rem;

    .avatar {
      background-color: rgb(47, 47, 47);
    }
  }

  &.active {
    background-color: rgb(66, 66, 66);
    border-radius: 0.25rem;

    .avatar {
      background-color: rgb(47, 47, 47);
    }
  }
  
  &.topbar-user-indicator {
    border-bottom: 0;
    padding: 0;
    cursor: default;

    // &.avatar {
    //   background-color: rgb(47, 47, 47);
    // }

    &:hover {
      background-color: transparent;
      border-radius: 0;
    }
  }
}
</style>
