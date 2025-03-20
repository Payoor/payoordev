export default {
    computed: {
        agentCode() {
            return this.$route.query.affiliatecode;
        },
    },
    methods: {
        pageRouter(lctn, query) {
            this.$router.push({
                path: lctn,
                query: {
                    ...query,
                    affiliatecode: this.agentCode
                }
            })
        },
        setAffiliateCode(code) {
            if (!code) return;

            const currentQuery = { ...this.$route.query };
            currentQuery.affiliatecode = code;

            this.$router.replace({
                path: this.$route.path,
                query: currentQuery
            });

            //localStorage.setItem('affiliatecode', code);
        },
        /*getStoredAffiliateCode() {
            if (this.agentCode) {
                return this.agentCode;
            }

            return localStorage.getItem('affiliatecode') || null;
        },
        clearAffiliateCode() {
            const currentQuery = { ...this.$route.query };
            delete currentQuery.affiliatecode;

            this.$router.replace({
                path: this.$route.path,
                query: currentQuery
            }); 

            //localStorage.removeItem('affiliatecode');
        }*/
    },
    created() {
       /* if (!this.agentCode) {
            const storedCode = localStorage.getItem('affiliatecode');
            if (storedCode) {
                this.setAffiliateCode(storedCode);
            }
        }*/
    }
}