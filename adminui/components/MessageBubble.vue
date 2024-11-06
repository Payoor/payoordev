<template>
  <div :class="['message-bubble', senderType == 'admin' ? 'sender' : 'receiver']">
    <div class="text">
      <p>{{message}}</p>
      <p class="timestamp">7:28 am</p>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    senderType: {
      type: String
    },
    message: {
      type: String
    }
  }
}
</script>

<style lang="scss">
.message-bubble {
  display: flex;

  .text {
    padding: 0.5rem;
    max-width: 400px;
  }

  &.sender {
    justify-content: flex-end;

    .text {
      border-radius: 1rem 1rem 0 1rem;
      color: $white;
      background-color: $primary-color;

      .timestamp {
        text-align: right;
        font-size: 0.65rem;
        color: rgba($white, 0.7);
        margin-top: 0.5rem;
      }
    }
  }

  &.receiver {
    justify-content: flex-start;

    .text {
      border-radius: 1rem 1rem 1rem 0;
      background-color: rgb(47, 47, 47);

      .timestamp {
        font-size: 0.65rem;
        color: rgba($white, 0.5);
        margin-top: 0.5rem;
      }
    }
  }
}
</style>
