async function createVerificationTest(number) {
    try {
        return new Promise((resolve) => {
            setTimeout(() => {
                resolve("pending");
            }, 10000); // 10-second delay
        });
    } catch (error) {
        console.log(error);
    }
}

export default createVerificationTest;