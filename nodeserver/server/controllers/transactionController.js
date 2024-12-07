import Transaction from "../models/transaction";

class TransactionController {
    async getUserTransactions(req, res) {
        try {
            const page = parseInt(req.query.page) || 1;
            const limit = parseInt(req.query.limit) || 10;
            const skip = (page - 1) * limit;

            const transactions = await Transaction.find({ initiatorId: req.user.userId }, { __v: 0 })
                .sort({ createdAt: -1 })
                .skip(skip)
                .limit(limit);

            const total = transactions.length;

            res.status(200).json({
                message: 'Transactions retrieved',
                page,
                totalPages: Math.ceil(total / limit),
                totalCount: total,
                itemsPerPage: limit,
                transactions: transactions,
            });

        } catch (error) {
            console.log(error);
            res.status(500).json({
                success: false,
                message: 'Error fetching transactions',
                error: error.message
            });
        }
    }

    async getTransaction(req, res) {
        try {
            const transactionId = req.query.id;

            if (!transactionId) {
                return res.status(400).send({ message: "Transaction ID is required" });
            }

            const transaction = await Transaction.findById(transactionId, { __v: 0, updatedAt: 0 }).lean();

            if (!transaction) {
                return res.status(404).json({
                    success: false,
                    message: 'Transaction not found'
                });
            }

            res.status(200).send({
                success: true,
                data: {
                    message: 'Transaction found',
                    transaction: transaction
                }
            });
        } catch (error) {
            console.log(error);
            res.status(500).send({ message: error.message });
        }
    }
}

export default new TransactionController();
