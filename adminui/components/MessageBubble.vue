<template>
  <div :class="['message-bubble', isSender ? 'sender' : 'receiver']">
    <div class="text">
      <div class="message-content">{{message.text}}</div>
      <p class="timestamp">{{ formatTime(message.clienttimestamp) }}</p>
    </div>
  </div>
</template>

<script>
import { formatTime } from '../helpers';

export default {
  props: {
    viewerType: {
      type: String,
      required: true,
    },
    message: {
      type: Object,
      required: true,
    },
  },

  computed: {
    isSender() {
      // Determine if the message was sent by the current viewer
      return this.message.sender === this.viewerType;
    },
  },

  methods: {
    formatTime
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

      .message-content {
        white-space: pre-wrap;
        word-wrap: break-word;
      }

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
      color: $font-color;
      background-color: rgba($grey-2, .3);

      .message-content {
        white-space: pre-wrap;
        word-wrap: break-word;
      }

      .timestamp {
        font-size: 0.65rem;
        color: rgba($font-color, 0.5);
        margin-top: 0.5rem;
      }
    }
  }
}
</style>
