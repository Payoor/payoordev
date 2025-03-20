<template>
  <transition name="popup-fade">
    <div v-if="isVisible" class="popup-overlay" @click.self="closePopup">
      <div class="popup-container">
        <div class="popup-content">
          <div class="popup-message">{{ message }}</div>
          <button class="popup-ok-btn" @click="closePopup">
            OK
          </button>
        </div>
      </div>
    </div>
  </transition>
</template>

<script>
export default {
  name: "CenterPopup",
  props: {
    message: {
      type: String,
      required: true,
    },
    autoClose: {
      type: Boolean,
      default: false,
    },
    duration: {
      type: Number,
      default: 3000,
    },
    redirectUrl: {
      type: String,
      default: "https://payoor.store",
    }
  },
  data() {
    return {
      isVisible: false,
    };
  },
  mounted() {
    this.show();
    
    if (this.autoClose) {
      setTimeout(() => {
        this.closePopup();
      }, this.duration);
    }
  },
  methods: {
    show() {
      this.isVisible = true;
    },
    closePopup() {
      this.isVisible = false;
      this.$emit("close");
      window.location.href = this.redirectUrl;
    },
  },
};
</script>

<style scoped lang="scss">

.popup-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
  padding: 15px;
}

.popup-container {
  max-width: 90%;
  width: 400px;
  background-color: white;
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
  overflow: hidden;
}

.popup-content {
  position: relative;
  padding: 30px;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.popup-message {
  color: var(--black);
  font-size: 18px;
  line-height: 1.5;
  text-align: center;
  margin-bottom: 25px;
  word-wrap: break-word;
  width: 100%;
}

.popup-ok-btn {
  background-color: $primary-color;
  color: white;
  border: none;
  border-radius: 8px;
  padding: 10px 40px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
  letter-spacing: 0.5px;
  text-transform: uppercase;
}

.popup-ok-btn:hover {
  background-color: rgba(36, 155, 72, 0.9);
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
}

/* Scale animation */
.popup-fade-enter-active,
.popup-fade-leave-active {
  transition: all 0.3s ease;
}

.popup-fade-enter-from {
  opacity: 0;
  transform: scale(0);
}

.popup-fade-enter-to {
  opacity: 1;
  transform: scale(1);
}

.popup-fade-leave-from {
  opacity: 1;
  transform: scale(1);
}

.popup-fade-leave-to {
  opacity: 0;
  transform: scale(0);
}

/* Responsive adjustments */
@media screen and (max-width: 480px) {
  .popup-container {
    width: 95%;
    max-width: 350px;
  }
  
  .popup-content {
    padding: 25px 20px;
  }
  
  .popup-message {
    font-size: 16px;
    margin-bottom: 20px;
  }
  
  .popup-ok-btn {
    padding: 8px 30px;
    font-size: 15px;
  }
}

@media screen and (max-width: 320px) {
  .popup-container {
    width: 100%;
  }
  
  .popup-content {
    padding: 20px 15px;
  }
  
  .popup-message {
    font-size: 15px;
    margin-bottom: 15px;
  }
  
  .popup-ok-btn {
    padding: 8px 25px;
    font-size: 14px;
  }
}
</style>