export default {
    setup(props, context) {
        const state = reactive({
            serverUrl: `https://chat.payoor.shop`
        });

        return {
            state,
        };
    },
}