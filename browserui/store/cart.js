import { url, search_url } from "@/api";

export const state = () => ({
    items: {},
    total: 0,
    subtotal: 0,
    coupon: null
})

export const mutations = {
    ADD_ITEM(state, item) {
        const existingItem = state.items[item.id];

        if (existingItem) {
            if (existingItem.units.hasOwnProperty(item.unit)) {
                existingItem.units[item.unit].quantity = item.quantity;
            } else {
                existingItem.units[item.unit] = {
                    id: item.id,
                    name: item.name,
                    price: item.price,
                    quantity: item.quantity,
                    unit: item.unit
                }
            }

            state.items = { ...state.items }
        } else {
            state.items[item.id] = {
                id: item.id,
                name: item.name,
                units: {
                    [item.unit]: {
                        id: item.id,
                        name: item.name,
                        price: item.price,
                        quantity: item.quantity,
                        unit: item.unit
                    }
                }
            }

            state.items = { ...state.items }
        }

        console.log(state.items)
    },

    REMOVE_ITEM(state, item) {
        const existingItem = state.items[item.id];

        if (existingItem) {
            if (existingItem.units.hasOwnProperty(item.unit)) {
                if (item.quantity && item.quantity > 0) {
                    existingItem.units[item.unit].quantity = item.quantity;
                } else {
                    delete existingItem.units[item.unit];

                    if (Object.keys(existingItem.units).length === 0) {
                        delete state.items[item.id];
                    }
                }
            }
        }

        state.items = { ...state.items }

        console.log(state.items);
    },

    UPDATE_TOTAL(state, amount) {
        state.total = amount;
    },

    INCREASE_SUBTOTAL(state, price) {
        state.subtotal = state.subtotal + price;
    },

    REDUCE_SUBTOTAL(state, price) {
        state.subtotal = state.subtotal - price;
    }
}

export const actions = {
    addItem({ commit }, { id, name, unit, price, quantity }) {
        commit('ADD_ITEM', { id, name, unit, price, quantity });
        commit('INCREASE_SUBTOTAL', price)
    },
    removeItem({ commit }, { id, name, unit, price, quantity }) {
        commit('REMOVE_ITEM', { id, name, unit, price, quantity });
        commit('REDUCE_SUBTOTAL', price)
    },
    updateTotal({ commit }, amount) {
        commit('UPDATE_TOTAL', amount)
    },
}