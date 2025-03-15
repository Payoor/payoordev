import { url, search_url } from "@/api";

export const state = () => ({
    user: null,
    orders: [],
    jwt: null,
    products: [],
    productstotal: 0,
});

export const mutations = {
    SET_USER(state, user) {
        state.user = user
    },

    CLEAR_USER(state) {
        state.user = null
    },

    SET_JWT(state, token) {
        state.jwt = token
    },

    CLEAR_JWT(state) {
        state.jwt = null
    },

    SET_SEARCH_RESULTS(state, results) {
        state.products = results;
    },

    CLEAR_SEARCH_RESULTS(state, results) {
        state.products = results;
    },

    UPDATE_CART(state, cart) {
        state.cart = cart
    },

    SET_SEARCH_RESULTS_TOTAL(state, total) {
        state.productstotal = total;
    }
}

export const actions = {
    async authenticate({ commit }, credentials) {
        try {
            const { email } = credentials;

            const response = await fetch(`${url}/auth/email/otp`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    email
                })
            })

            if (!response.ok) {
                throw new Error(`HTTP error! Status: ${response.status}`);
            }

            const data = await response.json();
            console.log('Success:', data.data);
            return data;

        } catch (error) {
            console.log(error)
        }
    },

    async verifyotp({ commit }, { otp, email }) {
        try {
            const response = await fetch(`${url}/auth/email/verify`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    otp,
                    email
                })
            })

            if (!response.ok) {
                throw new Error(`HTTP error! Status: ${response.status}`);
            }

            const data = await response.json();
            console.log('Success:', data.data);
            return data;
        } catch (error) {
            console.log(error)
        }
    },

    async genJWT({ commit }, { userid }) {
        try {
            const response = await fetch(`${url}/auth/genjwt?id=${userid}`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                }
            });

            const data = await response.json();
            const token = data.data.token
            console.log('Success in authentication:', data.data.token);
            commit('SET_JWT', token)

            localStorage.setItem('jwt_token', token);

            return data;
        } catch (error) {
            console.log(error)
        }
    },

    async getvaliduser({ commit }) {
        try {
            const token = localStorage.getItem('jwt_token');

            console.log(token)

            if (token) {
                commit('SET_JWT', token);

                const bearerToken = `Bearer ${token}`;

                const response = await fetch(`${url}/auth/getvaliduser`, {
                    method: 'GET',
                    headers: {
                        'Content-Type': 'application/json',
                        'authorization': bearerToken
                    }
                });

                if (!response.ok) {
                    if (response.status === 403) {
                        localStorage.removeItem('jwt_token');
                        commit('SET_JWT', null);
                        commit('SET_USER', null);
                        return null;
                    }

                    throw new Error(`HTTP error! Status: ${response.status}`);
                }

                const data = await response.json();

                if (data) {
                    const user = data.data.user;
                    console.log(user)
                    commit('SET_USER', user);
                }
            }
        } catch (error) {
            console.log('jwt error', error)
        }
    },

    async handlesignup({ commit }, { name, phone, location, email }) {
        const shoppingList = "";
        console.log(name, phone, location, email, shoppingList);

        try {
            const response = await fetch(`${url}/auth/signup`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    name,
                    email,
                    phone,
                    location,
                    shoppingList
                })
            });

            if (!response.ok) {
                throw new Error(`HTTP error! Status: ${response.status}`);
            }

            const data = await response.json();

            if (data) {
                const userdata = data.data.user;
                //console.log(userdata)
                return userdata;
            }
        } catch (error) {
            console.log('jwt error', error)
        }
    },

    async handlesearch({ commit }, { query }) {
        try {
            const encodedQuery = encodeURIComponent(query);

            commit('SET_SEARCH_RESULTS', []);

            const response = await fetch(`${search_url}/message/user/send`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                    'Origin': search_url,
                },
                body: JSON.stringify({
                    'text': encodedQuery,
                })
            });

            if (!response.ok) {
                throw new Error(`HTTP error! Status: ${response.status}`);
            }

            const data = await response.json();

            if (data) {
                console.log(data.data.chatresponse, 'data');

                const searchResp = data.data.chatresponse;
                const results = searchResp.results;

                commit('SET_SEARCH_RESULTS', results);
                commit('SET_SEARCH_RESULTS_TOTAL', results.length)
            }
        } catch (error) {
            console.error('Search error:', error);
            // Handle error state
            //commit('SET_SEARCH_ERROR', error.message);
        }
    },

    async handlegetmore({ commit }, params) {
        try {
            const query = params.query || '';
            const offset = params.offset || 0;
            const limit = params.limit || 10;

            const encodedQuery = encodeURIComponent(query);

            const response = await fetch(`${search_url}/more/products?offset=${offset}&limit=${limit}&query=${encodedQuery}`, {
                method: 'GET',
                headers: {
                    'Accept': 'application/json',
                    'Origin': search_url,
                }
            });

            if (!response.ok) {
                throw new Error(`HTTP error! Status: ${response.status}`);
            }

            const responseData = await response.json();

            if (!responseData.success || !responseData.data) {
                throw new Error('Invalid response format');
            }

            const { results, totaldocs, result_tags } = responseData.data;

            console.log(results, totaldocs, result_tags, 'get more vibes');

            return responseData.data;
        } catch (error) {
            console.error('Search error:', error);
        }
    }
}