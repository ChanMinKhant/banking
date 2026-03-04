package com.bank.transaction;

import java.util.List;

public interface TransactionDAO {
    List<Transaction> getTransactionsByPhone(String phone);
}