<template>
  <div class="page__container">
    <div class="page__container-wrapper">
      <HeaderText :pageText="'Products'"/>

      <template v-if="products">
        <div class="table-container">
          <table>
            <thead>
              <tr>
                <th v-for="header, idx in getTableHeaders" :key="idx">{{ header }}</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="data, rowIndex in editableTableData" :key="rowIndex">
                <td>{{ data["S/N"] }}</td>
                <td
                  v-for="(value, key, colIndex) in data"
                  :key="colIndex"
                  v-if="key !== 'S/N' && key !== '_id'"
                  @click="editCell(rowIndex, colIndex)"
                >
                  <div v-if="isEditingCell(rowIndex, colIndex)">
                    <input
                      type="text"
                      v-model="editableTableData[rowIndex][key]"
                      @blur="saveEdit(rowIndex, key)"
                      @keyup.enter="saveEdit(rowIndex, key)"
                    />
                  </div>
                  <div v-else>{{ value }}</div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </template>

      <template v-if="!products">
        <EmptyProduct />
      </template>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';
import axios from 'axios';
import { computed } from 'vue';

const serverUrl = `https://server.development.payoor.store`;

export default {
  setup () {
    
    const products = ref([])
    const editingCell = ref({ row: null, col: null });
    const editableTableData = ref([]);

    const fetchProducts = async () => {
      try {
        const response = await axios.get(`${serverUrl}/admin/get/products`);
        products.value = response.data.products;
        
        editableTableData.value = products.value.map((item, index) => ({
          'S/N': index + 1,
          ...Object.fromEntries(
            Object.entries(item).filter(([key]) => key !== '_id')
          ),
          _id: item._id // Keep the _id for sending updates
        })); 

      } catch (error) {
        console.log(error.response.data.message)
      }
    }

    onMounted(() => {
      fetchProducts()
    })

    const getTableHeaders = computed(() => {
      return products.value.length
        ? ['S/N', ...Object.keys(products.value[0]).filter(key => key !== '_id')]
        : [];
    });

    const editCell = (rowIndex, colIndex) => {
      editingCell.value = { row: rowIndex, col: colIndex };
    };

    const isEditingCell = (row, col) => {
      return editingCell.value.row === row && editingCell.value.col === col;
    };

    const saveEdit = async (rowIndex, colKey) => {
      const editedProduct = { ...editableTableData.value[rowIndex] };
      const productId = editedProduct._id;
      delete editedProduct["S/N"];

      try {
        // Send the update request to the server
        const response = await axios.patch(`${serverUrl}/admin/update/product?id=${productId}`, editedProduct);

        if (response.status == 200){
          fetchProducts()
          console.log(`Successfully updated row ${rowIndex + 1}, column ${colKey}`);
        }

      } catch (error) {
        console.error("Error updating product:", error);
      }

      // Clear the editing cell
      editingCell.value = { row: null, col: null };
    };


    return { 
      products,
      getTableHeaders,
      editCell,
      isEditingCell,
      editableTableData,
      saveEdit
    }
  }
}
</script>

<style lang="scss" scoped>
  .table-container {
    overflow: auto;
    width: 100%;
    margin-top: 2rem;
    color: rgba($white, .7);

    table {
      border-collapse: collapse;
      width: 100%;

      thead {
        background-color: rgb(47, 47, 47);
      }

      td, th {
        border: 1px solid rgb(47, 47, 47);
        text-align: left;
        padding: 0.5rem;
        color: rgba($white, .5)
      }

      input {
        width: 100%;
        background-color: transparent;
        border: none;
        padding: 0.5rem;
        color: rgba($white, .5);
        font-size: 1rem;

        &::placeholder {
          font-size: 1rem;
        }

        &:focus {
          outline: none;
          border: 1px solid rgb(47, 47, 47);
        }
      }
    }
  }
</style>
