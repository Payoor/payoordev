function sanitizeId(id) {
    return id.replace(/[^\w\s]/gi, ''); // Example: removes special characters
}

export default sanitizeId;