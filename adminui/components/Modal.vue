<template>
  <div class="modal-wrapper">
    <div class="modal-content-container">
      <div class="modal-content">

        <div class="modal-header">
          <p class="header-text">{{ modalHeader }}</p>
          <button
            @click="closeModal"
            class="cancel-icon"
          >
            <CircleXIcon />
          </button>
        </div>

        <div class="content">
          <slot name="modalContent"></slot>
        </div>

        <div class="modal-btn">
          <button 
            @click="closeModal" 
            class="cancel"
          >
            Cancel
          </button>
          <button
            @click="submitForm" 
            class="confirm submit-btn"
            :class="{ isLoading }"
          >
            <span>
              {{ confirmText }}
            </span>
          </button>
        </div>

      </div>
    </div>
  </div>
</template>

<script>
import CircleXIcon from "./icons/CircleXIcon.vue";

export default {
  components: {
    CircleXIcon
  },

  methods: {
    closeModal() {
      this.$emit('close-modal');
    },

    submitForm() {
      this.$emit('submit-form');
    }
  },

  props: {
    modalHeader: {
      type: String
    },
    confirmText: {
      type: String
    },
    isLoading: {
      type: Boolean,
      default: false
    },
  }
}
</script>

<style lang="scss" scoped>
.modal-wrapper {
  width: 100vw;
  height: 100vh;
  position: fixed;
  top: 0;
  left: 0;
  display: flex;
  justify-content: center;
  z-index: 25;
  background: rgba(0, 0, 0, 0.5);

  .modal-content-container {
    height: auto;
    width: 100%;
    max-width: 700px;
    z-index: 3;
    padding: 1.5rem;
    

    .modal-content {
      transform: translateY(10vh);
      background: $white;
      color: $font-color;
      border-radius: 0.25rem;
      border: 2px solid $grey;
      box-shadow: 0px 0px 5px -2px #32475c4d;
      z-index: 4;

      .modal-header {
        padding: 1.5rem;
        display: flex;
        align-items: center;
        justify-content: space-between;
        border-bottom: 1px solid $grey;

        .header-text {
          font-size: 1.25rem;
          font-weight: bold;
        }

        .cancel-icon {
          cursor: pointer;
          transition: .2s;
          border: none;
          background: transparent;
          color: $grey-2;

          &:hover {
            color: rgba($grey-2, .7);
          }
        }
      }

      .content {
        padding: 1.5rem;
      }

      .modal-btn {
        padding: 1.5rem;
        width: 100%;
        display: flex;
        align-items: center;
        justify-content: flex-end;
        gap: 0.5rem;

        button {
          width: fit-content;
          padding: 0.75rem 1rem;
          cursor: pointer;
          border-radius: 0.25rem;
          transition: .2s;
          opacity: 0.8;

          &.cancel {
            border: 1px solid $grey-2;
            background-color: transparent;
            color: $font-color;
          }

          &.confirm {
            border: 1px solid rgba($primary-color, .7) !important;
            background-color: $primary-color;
            color: $white;
          }

          &:hover {
            opacity: 1;
          }
        }
      }
    }
  }
}
</style>
