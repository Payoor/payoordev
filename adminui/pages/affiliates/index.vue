<template>
  <DefaultLayout page-text="Affiliates" description="View all Affiliates">
    <div class="affiliates">
      <div class="affiliates__header">
        <h2>Affiliate Partners</h2>
      </div>

      <div v-if="loading" class="affiliates__loading">
        <div class="spinner"></div>
        <p>Loading affiliates...</p>
      </div>

      <div v-else-if="error" class="affiliates__error">
        <p>{{ error }}</p>
        <button @click="callGetAffiliates" class="btn btn-secondary">Try Again</button>
      </div>

      <div v-else-if="affiliates.length === 0" class="affiliates__empty">
        <p>No affiliates found. Add your first affiliate partner.</p>
      </div>

      <div v-else class="affiliates__table-container">
        <table class="affiliates__table">
          <thead>
            <tr>
              <th>Name</th>
              <th>Email</th>
              <th>Phone Number</th>
              <th>Code</th>
              <th>Social Media</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="affiliate in affiliates" :key="affiliate._id">
              <td>{{ affiliate.name }}</td>
              <td>{{ affiliate.email }}</td>
              <td>{{ affiliate.phonenumber || "N/A" }}</td>
              <td>{{ affiliate.coupon || "N/A" }}</td>
              <td>{{ affiliate.socialmedia || "N/A" }}</td>
              <td class="affiliates__actions-cell">
                <div class="toggle-switch">
                  <input
                    type="checkbox"
                    :id="'toggle-' + affiliate._id"
                    class="toggle-switch__checkbox"
                    :checked="affiliate.isActive"
                    @change="toggleAffiliateStatus(affiliate._id, $event.target.checked, affiliate.email)"
                  />
                  <label :for="'toggle-' + affiliate._id" class="toggle-switch__label">
                    <span class="toggle-switch__inner"></span>
                    <span class="toggle-switch__switch"></span>
                  </label>
                  <span class="toggle-switch__status">{{
                    affiliate.isActive ? "Active" : "Inactive"
                  }}</span>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </DefaultLayout>
</template>

<script>
import Default from "../../layouts/Default.vue";
import { getAffiliates, toggleAffiliateActiveState } from "../../api";

export default {
  components: {
    DefaultLayout: Default,
  },
  data() {
    return {
      affiliates: [],
      loading: true,
      error: null,
    };
  },
  methods: {
    async callGetAffiliates() {
      this.loading = true;
      this.error = null;

      try {
        const response = await getAffiliates();
        this.affiliates = response.data.affiliates;
      } catch (err) {
        console.error("Failed to fetch affiliates:", err);
        this.error = "Failed to load affiliates. Please try again.";
      } finally {
        this.loading = false;
      }
    },
    async toggleAffiliateStatus(id, isActive, email) {
      try {
        const affiliate = this.affiliates.find((a) => a._id === id);
        if (affiliate) {
          affiliate.active = isActive;
          await toggleAffiliateActiveState(id, isActive, email);
          const response = await getAffiliates();
          this.affiliates = response.data.affiliates;
        }
      } catch (err) {
        console.error("Failed to update affiliate status:", err);
        // Revert the toggle if the API call fails
        const affiliate = this.affiliates.find((a) => a._id === id);
        if (affiliate) {
          affiliate.active = !isActive;
        }
      }
    },
  },
  mounted() {
    this.callGetAffiliates();
  },
};
</script>

<style lang="scss" scoped>
.affiliates {
  padding: 20px;
  color: $black;

  &__header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;

    h2 {
      margin: 0;
      font-size: 24px;
    }
  }

  &__loading,
  &__error,
  &__empty {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 40px;
    text-align: center;
  }

  &__table-container {
    width: 100%;
    overflow-x: auto;
  }

  &__table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 10px;

    color: $black;

    th,
    td {
      padding: 12px 15px;
      text-align: left;
      border-bottom: 1px solid #e0e0e0;
    }

    th {
      background-color: #f5f5f5;
      font-weight: 600;
    }

    tr:hover {
      background-color: #f9f9f9;
    }
  }

  &__actions-cell {
    display: flex;
    gap: 8px;
  }

  .btn {
    padding: 8px 12px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-weight: 500;

    &-primary {
      background-color: $primary-color;
      color: $black;
    }

    &-secondary {
      background-color: #f1f3f4;
      color: $black;
    }

    &-edit {
      background-color: darken($primary-color, 10%);
      color: $black;
    }

    &-delete {
      background-color: #ea4335;
      color: $black;
    }
  }

  .spinner {
    border: 4px solid rgba(0, 0, 0, 0.1);
    width: 36px;
    height: 36px;
    border-radius: 50%;
    border-left-color: $primary-color;
    animation: spin 1s linear infinite;
    margin-bottom: 10px;
  }

  @keyframes spin {
    0% {
      transform: rotate(0deg);
    }
    100% {
      transform: rotate(360deg);
    }
  }
}

/* Add these styles to your <style> section */

.toggle-switch {
  display: flex;
  align-items: center;
  gap: 10px;

  &__checkbox {
    height: 0;
    width: 0;
    visibility: hidden;
    position: absolute;
  }

  &__label {
    display: flex;
    align-items: center;
    justify-content: space-between;
    cursor: pointer;
    width: 50px;
    height: 24px;
    background: #e0e0e0; /* grey for OFF state */
    border-radius: 24px;
    position: relative;
    transition: background-color 0.2s;
  }

  &__label .toggle-switch__switch {
    position: absolute;
    top: 2px;
    left: 2px;
    width: 20px;
    height: 20px;
    border-radius: 20px;
    transition: 0.2s;
    background: #fff;
    box-shadow: 0 0 2px 0 rgba(10, 10, 10, 0.29);
  }

  &__checkbox:checked + &__label {
    background: $primary-color; /* primary color for ON state */
  }

  &__checkbox:checked + &__label .toggle-switch__switch {
    left: calc(100% - 2px);
    transform: translateX(-100%);
  }

  &__status {
    font-size: 14px;
    font-weight: 500;
  }
}
</style>
