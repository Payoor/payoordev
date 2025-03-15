export default {
    methods: {
        getJWTWithUserId(userid) {

            this.$store.dispatch("genJWT", { userid });

            this.$router.push({
                path: "/",
                query: {
                    user: userid,
                },
            });
        }
    }
}