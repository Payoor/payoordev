export default {
  data() {
    return {
      searchopen: false,
    };
  },
  methods: {
    opensearch() {
      this.searchopen = true;
    },
    closesearch() {
      this.searchopen = false;
    }
  },
};