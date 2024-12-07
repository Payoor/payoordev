import express from 'express';
import TransactionController from '../controllers/transactionController';
import verifyJWT from '../middleware/user/verifyJWT';

const transactionRoute = express();

transactionRoute.get('/user/get/transactions', verifyJWT, TransactionController.getUserTransactions);

transactionRoute.get('/user/get/transaction', verifyJWT, TransactionController.getTransaction);

export default transactionRoute;
