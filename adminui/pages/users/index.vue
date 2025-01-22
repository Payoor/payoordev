<template>
  <DefaultLayout page-text="Users" description="View all Users">
    <div class="search__container">
      <div></div>
      <div class="search__bar">
        <input 
          type="text"
          placeholder="Search..."
          v-model="search"
          @input="handleSearchInput"
        >
        <button 
          type="button"
          @click="handleSearchInput"
        >
          <SearchIcon />
        </button>
      </div>
    </div>
    <div class="table__container">
      <table>
        <thead>
          <tr>
            <th>S/N</th>
            <th v-for="(header, idx) in getTableHeaders" :key="idx">
              {{ header.toLowerCase() }}
            </th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(data, rowIndex) in users" :key="rowIndex">
            <td>{{ getIndex(rowIndex) }}</td>
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
                <button @click="viewUser(data._id)">View User</button>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <Pagination
      v-if="totalPages > 1"
      :totalPages="totalPages"
      :perPage="limit"
      :currentPage="currentPage"
      @pagechanged="onPageChange"
    />
  </DefaultLayout>
</template>

<script>
import Default from "../../layouts/Default.vue";
import { getUsers } from "../../api";
import SearchIcon from "../../components/icons/SearchIcon.vue";
import { useDebounce } from "../../utils";

export default {
  components: {
    DefaultLayout: Default,
    SearchIcon
  },

  data() {
    return {
      users: [],
      message: "",
      dropdownIndex: null,
      selectedUserId: undefined,
      isLoading: false,
      totalPages: 0,
      currentPage: 1,
      limit: 10, 
      search: "",
      debouncedSearchTerm: "",
    };
  },

  computed: {
    getTableHeaders() {
      return this.users.length
        ? [...Object.keys(this.users[0]).filter((key) => key !== "_id")]
        : [];
    },
  },

  methods: {
    getUsers,
    fetchUsers() {
      this.getUsers({
        page: this.currentPage, 
        limit: this.limit,
        search: this.debouncedSearchTerm,
      }).then((response) => {
        this.users = response.data.users;
        this.currentPage = response.data.page;
        this.totalPages = response.data.totalPages;
        this.users = this.users.map((user, index) => ({
          ...Object.fromEntries(
            Object.entries(user).filter(([key]) => key !== "_id")
          ),
          _id: user._id, // Keep the _id for sending updates
        }));

      }).catch((error) => {
        console.log(error.response.data);
        if (error.response.status === 401) {
          localStorage.removeItem('adminToken');
          localStorage.removeItem('adminUsername');
          this.$router.push('/');
        }
      });
    },

    handleSearchInput: useDebounce(function () {
      this.debouncedSearchTerm = this.search;
      this.fetchUsers();
    }),

    getIndex(index) {
      return this.currentPage * this.limit - this.limit + index + 1;
    },

    toggleDropdown(index) {
      this.dropdownIndex = this.dropdownIndex === index ? null : index;
    },

    viewUser(userId) {
      this.$router.push(`/users/${userId}`);
    },

    onPageChange(page) {
      this.currentPage = page;
      this.fetchUsers();
    }
  },

  mounted() {
    this.fetchUsers();
  },
};
</script>
