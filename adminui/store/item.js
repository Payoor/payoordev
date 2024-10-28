import API_URL from './APIURL';

export const state = () => ({
    itemslist: [],
    item: null,
})

export const mutations = {
    SET_ITEMS(state, data) {
        state.itemslist = data;
    },
    SET_ITEM(state, data) {
        state.item = data;
    }
}

export const actions = {
    async getitems({ commit }, category) {
        try {
            let response;

            if (category) {
                response = await fetch(`${API_URL}/products/inventory?category=${category}`);
            } else {
                response = await fetch(`${API_URL}/products/inventory/`);
            }

            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            const data = await response.json();

            commit('SET_ITEMS', data.items);

        } catch (error) {
            console.error('There was an error!', error);
        }
    },
    async createitem({ commit, dispatch }, item) {
        try {
            const response = await fetch(`${API_URL}/product/inventory/create`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(item)
            });

            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            if (response.status === 201) {
                const data = await response.json();

                const { item } = data;

                return item;
            }
        } catch (error) {
            console.error('There was an error!', error);
        }
    },
    async updateitem({ commit, dispatch }, { itemid, itemattribute, value }) {
        try {
            const response = await fetch(`${API_URL}/product/inventory/update?productid=${itemid}&&itemattribute=${itemattribute}`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ value })
            });

            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            if (response.status === 200) {
                const data = await response.json();

                const { item } = data;
                //dispatch('getitems');
            }
        } catch (error) {
            console.error('There was an error!', error);
        }
    },
    async updateitemfromstore({ state, commit, dispatch }, { itemid, itemattribute, value }) {
        const itemslist = [...state.itemslist];
        const index = itemslist.findIndex(item => item._id === itemid);
        const item = { ...itemslist[index] };

        item[itemattribute] = value;
        itemslist[index] = item;

        commit('SET_ITEM', item);

        try {
            await dispatch('updateitem', { itemid, itemattribute, value });
        } catch (error) {
            console.error('There was an error!', error);
        }
    },
    async getitem({ commit }) {

    },
    async deleteitem({ commit, dispatch }, itemid) {
        try {
            const response = await fetch(`${API_URL}/product/inventory/delete?productid=${itemid}`, {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json'
                }
            })

            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            if (response.status === 200) {
                return true;
            }
        } catch (error) {
            console.error('There was an error!', error);
        }
    },
    async uploaditemimage({ commit }, { itemid, image }) {
        try {
            const formData = new FormData();

            formData.append('file', image);

            const response = await fetch(`${API_URL}/product/inventory/imageupload?productid=${itemid}`, {
                method: 'POST',
                body: formData
            })

            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            if (response.status === 201) {
                const data = await response.json();

                //console.log(data)
            }
        } catch (error) {
            console.log(error)
        }

    }
}