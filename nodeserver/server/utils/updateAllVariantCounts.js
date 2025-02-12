import mongoose from '../db';

import NewProduct from '../models/newProduct';
import ProductVariant from '../models/productVariant';

async function updateAllVariantCounts() {
    try {
        if (mongoose.connection.readyState !== 1) {
            return;
        }

        await NewProduct.updateMany(
            { variantCount: { $exists: false } },
            { $set: { variantCount: 0 } }
        );

        const variantCounts = await ProductVariant.aggregate([
            {
                $group: {
                    _id: '$productId',
                    count: { $sum: 1 }
                }
            }
        ]);

        const bulkOps = variantCounts.map(({ _id, count }) => ({
            updateOne: {
                filter: { _id: _id },
                update: { $set: { variantCount: count } }
            }
        }));

        const updateResult = await NewProduct.bulkWrite(bulkOps);
        console.log('Bulk update result:', updateResult);

        const updatedProducts = await NewProduct.find({
            _id: { 
                $in: [
                    '67a383711372a505828b8d30',
                    '67a383711372a505828b8dbe',
                    '67a383711372a505828b8cf9'
                ]
            }
        });
        console.log('Updated products:', updatedProducts);

        return { success: true };
    } catch (error) {
        console.error('[Variant Count Update] Error:', error);
        return { success: false, error: error.message };
    }
}

export default updateAllVariantCounts;