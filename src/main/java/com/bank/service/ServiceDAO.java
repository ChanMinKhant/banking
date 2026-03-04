package com.bank.service;

import com.bank.bill.Bill;
import com.bank.transaction.Transaction;
import java.util.List;

public interface ServiceDAO {
    boolean generateBill(Bill bill);
    List<Bill> getIssuedBills(String servicePhone);
    List<Transaction> getIncomingPayments(String servicePhone);
}