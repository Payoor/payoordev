import express from 'express';
import TransactionController from '../controllers/transactionController';
import verifyToken from "../services/payoor/verifyToken";

const transactionRoute = express();

transactionRoute.get('/user/get/transactions', verifyToken, TransactionController.getUserTransactions);

transactionRoute.get('/user/get/transaction', verifyToken, TransactionController.getTransaction);

export default transactionRoute;
