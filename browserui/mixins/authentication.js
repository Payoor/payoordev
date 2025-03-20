import utilsMixin from "@/mixins/utils";

export default {
    mixins: [utilsMixin],
    methods: {
        getJWTWithUserId(userid) {

            this.$store.dispatch("genJWT", { userid });

            this.pageRouter("/", {
                user: userid,
            });

            /*this.$router.push({
                path: "/",
                query: {
                    user: userid,
                },
            });*/
        }
    }
}