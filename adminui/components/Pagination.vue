<template>
  <div class="pagination-container">
    <div class="info">
      <p>Page: <strong>{{ currentPage }} of {{ totalPages }}</strong></p> |
      <div>
        <span>Go to page:</span> 
        <input 
          type="number"
          v-model="goToPageInput"
          min="1"
          :max="totalPages"
          @input="onGoToPage"
        >
      </div>
    </div>
    <ul class="pagination">
      <li class="pagination-item">
        <button
          type="button"
          @click="onClickFirstPage"
          :disabled="isInFirstPage"
        >
          <ChevronsLeftIcon />
        </button>
      </li>

      <li class="pagination-item">
        <button
          type="button"
          @click="onClickPreviousPage"
          :disabled="isInFirstPage"
        >
          <ChevronLeftIcon />
        </button>
      </li>

      <li class="pagination-item">
        <button
          type="button"
          @click="onClickNextPage"
          :disabled="isInLastPage"
        >
          <ChevronLeftIcon class="next-icon" />
        </button>
      </li>

      <li class="pagination-item">
        <button
          type="button"
          @click="onClickLastPage"
          :disabled="isInLastPage"
        >
          <ChevronsLeftIcon class="next-icon" />
        </button>
      </li>
    </ul>
  </div>
</template>

<script>
import ChevronLeftIcon from './icons/ChevronLeftIcon.vue';
import ChevronsLeftIcon from './icons/ChevronsLeftIcon.vue';

export default {
  components: {
    ChevronsLeftIcon,
    ChevronLeftIcon
  },
  props: {
    totalPages: {
      type: Number,
      required: true
    },
    perPage: {
      type: Number,
      required: true
    },
    currentPage: {
      type: Number,
      required: true
    }
  },

  computed: {
    isInFirstPage() {
      return this.currentPage === 1;
    },
    isInLastPage() {
      return this.currentPage === this.totalPages;
    },
  },

  data() {
    return {
      goToPageInput: this.currentPage
    }
  },

  methods: {
    onClickFirstPage() {
      this.$emit('pagechanged', 1);
    },
    onClickPreviousPage() {
      this.$emit('pagechanged', this.currentPage - 1);
    },
    onClickNextPage() {
      this.$emit('pagechanged', this.currentPage + 1);
    },
    onClickLastPage() {
      this.$emit('pagechanged', this.totalPages);
    },
    onGoToPage(e) {
      const inputValue = e.target.value;

      if (inputValue === "") {
        // If input is cleared, navigate to the first page
        this.$emit("pagechanged", 1);
        return;
      }

      const page = Math.min(
        Math.max(1, parseInt(this.goToPageInput, 10) || 1),
        this.totalPages
      );

      this.goToPageInput = page;
      this.$emit('pagechanged', page);
    },
  }
};
</script>

<style lang="scss" scoped>
  .pagination-container {
    margin-top: 1.5rem;
    display: flex;
    align-items: center;
    justify-content: space-between;

    .info {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 0.5rem;
      font-size: 0.9rem;

      input {
        padding: 0.25rem;
        border: none;
        border-radius: 0.25rem;
        width: fit-content;
        &:focus {
          outline: none;
        }
      }
    }

    .pagination {
      list-style-type: none;
      display: flex;
      gap: 0.25rem;
    
      .pagination-item {
        display: inline-block;
    
        button {
          border: none;
          display: flex;
          align-items: center;
          padding: 0.5rem;
          cursor: pointer;
          transition: .2s;
          border-radius: 0.25rem;
          color: $white;
          background-color: $primary-color;
    
          svg {
            height: 15px;
          }
    
          .next-icon {
            rotate: 180deg;
          }
      
          &:disabled {
            background-color: rgb(47, 47, 47);
            cursor: not-allowed;
          }
        }
      }
    }
  }


</style>
