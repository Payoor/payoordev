<template>
  <div class="user-card">
    <div class="avatar"><span>A</span></div>
    <div class="username">Abiodun</div>
  </div>
</template>

<script></script>

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
    width: 50px;
    height: 50px;
    border-radius: 50%;
    background-color: $primary-color;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: bold;
  }

  &:hover {
    background-color: rgb(66, 66, 66);
    border-radius: 0.25rem;
  }

  &.active {
    background-color: rgb(66, 66, 66);
    border-radius: 0.25rem;
  }
}
</style>
