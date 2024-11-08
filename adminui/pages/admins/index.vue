<template>
  <DefaultLayout page-text="Admins">
    <div class="table__container">
      <table>
        <thead>
          <tr>
            <th v-for="(header, idx) in getTableHeaders" :key="idx">
              {{ header.toLowerCase() }}
            </th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(data, rowIndex) in admins" :key="rowIndex">
            <td
              v-for="(value, key, colIndex) in data"
              :key="colIndex"
              v-if="key !== '_id'"
            >
              {{ value }}
            </td>

            <td class="actions-cell">
              <button class="actions-toggle" @click="toggleDropdown(rowIndex)">
                ...
              </button>
              <div v-if="dropdownIndex === rowIndex" class="dropdown">
                <button @click="openDeleteModal(data._id)">Delete Admin</button>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <Transition name="fade">
      <Modal
        v-if="showDeleteModal"
        v-on:close-modal="closeDeleteModal"
        v-on:submit-form="deleteAdmin"
        :modal-header="'Delete Admin'"
        :confirm-text="'Yes, proceed'"
        :is-loading="isLoading"
      >
        <template #modalContent>
          <p>Are you sure you want to delete this admin?</p>
          <div v-if="message" class="notification">
            <Notification :message="message" :isError="hasError" />
          </div>
        </template>
      </Modal>
    </Transition>
  </DefaultLayout>
</template>

<script>
import Default from "../../layouts/Default.vue";
import { getAllAdmins, removeAdmin } from "../../api";

export default {
  components: {
    DefaultLayout: Default,
  },

  data() {
    return {
      admins: [],
      message: "",
      dropdownIndex: null,
      selectedAdminId: undefined,
      isLoading: false,
      hasError: false,
      showDeleteModal: false,
    };
  },

  computed: {
    getTableHeaders() {
      return this.admins.length
        ? [...Object.keys(this.admins[0]).filter((key) => key !== "_id")]
        : [];
    },
  },

  methods: {
    getAllAdmins,
    removeAdmin,

    fetchAdmins() {
      this.getAllAdmins()
        .then((response) => {
          this.admins = response.data;
          this.admins = this.admins.map((admin, index) => ({
            "S/N": index + 1,
            ...Object.fromEntries(
              Object.entries(admin).filter(([key]) => key !== "_id")
            ),
            _id: admin._id, // Keep the _id for sending updates
          }));
        })
        .catch((error) => {
          console.log(error.response.data);
        });
    },

    toggleDropdown(index) {
      this.dropdownIndex = this.dropdownIndex === index ? null : index;
    },

    openDeleteModal(adminId) {
      this.dropdownIndex = null;
      this.selectedAdminId = adminId;
      this.showDeleteModal = true;
    },

    closeDeleteModal() {
      this.showDeleteModal = false;
      this.message = "";
    },

    deleteAdmin() {
      this.hasError = false;
      this.isLoading = true;
      this.message = "";

      this.removeAdmin(this.selectedAdminId).then((response) => {
        this.message = response.data.message;

        setTimeout(() => {
          this.isLoading = false;
          this.message = "";
          this.fetchAdmins();
          this.closeDeleteModal();
        }, 2000);

      }).catch((error) => {
        this.isLoading = false;
        this.hasError = true;
        this.message = error.response.data.error || "Failed to admin. Please try again.";
        console.log(error.response.data.error);
      });
    }
  },

  mounted() {
    this.fetchAdmins();
  },
};
</script>

<style lang="scss" scoped>
.notification {
  width: 100%;
  display: flex;
  justify-content: center;
  margin-top: 0.5rem;
}
</style>
