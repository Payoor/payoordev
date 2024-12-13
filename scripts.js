Product.collection.dropIndex('filepath_1', (err, result) => {
    if (err) {
        console.error('Error dropping index:', err);
    } else {
        console.log('Index dropped:', result);
    }
});

