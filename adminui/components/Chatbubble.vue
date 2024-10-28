<template>
  <div>
    <div class="chatbubble">
      <div class="chatbubble__body" :class="{ admin: isAdmin }">
        <div class="chatbubble__content">
          <figure class="chat__right--img">
            <div>{{ capitalizeFirstLetter(isAdmin ? "Payoor Admin" : username) }}</div>
          </figure>

          <div class="chatbubble__chat">
            <div class="chatbubble__chat--bubble" :class="{ admin: isAdmin }">
              <span>{{ message }}</span>
            </div>

            <div class="chatbubble__chat--name">
              <span>{{ isAdmin ? "Payoor Admin" : username }}</span>
              <span></span>
            </div>
          </div>
        </div>

        <div class="chatbubble__whitespace"></div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, reactive, onMounted, computed } from "vue";
import { mapActions, mapState, mapMutations } from "vuex";

export default {
  props: ["isAdmin", "message", "username"],

  setup() {
    const capitalizeFirstLetter = (str) => {
      return str ? str.split("")[0].toUpperCase() : "";
    };

    return {
      capitalizeFirstLetter,
    };
  },
};
</script>

<style lang="scss" scoped>
.chatbubble {
  padding: #{scaleValue(20)};

  &__body {
    display: flex;

    &.admin {
      flex-direction: row-reverse;
    }
  }

  &__content {
    display: flex;
    width: #{scaleValue(500)};
  }

  &__chat {
    flex-shrink: 0;

    &--bubble {
      font-size: #{scaleValue(12)};
      line-height: #{scaleValue(20)};
      width: #{scaleValue(480)};
      font-weight: 300;
      color: $white;
      background: rgba($primary-color, 0.8);
      border-radius: #{scaleValue(10)} #{scaleValue(10)} #{scaleValue(10)} 0;
      padding: #{scaleValue(10)};
      margin-bottom: #{scaleValue(10)};
      border: 1px solid rgba($white, 0.8);

      &.admin {
        border-radius: #{scaleValue(10)} #{scaleValue(10)} 0 #{scaleValue(10)};
        background: $white;
        color: $primary-color;

        border: 1px solid rgba($primary-color, 0.8);
      }
    }

    &--name {
      font-size: #{scaleValue(8)};
      color: $grey-2;
    }
  }
}
</style>
