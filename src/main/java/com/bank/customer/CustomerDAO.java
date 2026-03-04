package com.bank.customer;

import com.bank.user.User;
import com.bank.bill.Bill; 
import com.bank.transaction.Transaction;
import java.util.List;

public interface CustomerDAO {

    // Check balance
    double getBalance(String phone);

    // Deposit money
    boolean deposit(String phone, double amount);

    // Withdraw money
    boolean withdraw(String phone, double amount);

    // Transfer money to another customer
    boolean transfer(String fromPhone, String toPhone, double amount);

    // Pay bill
    boolean payBill(String customerPhone, String invoiceId);

    // Get transaction history
    List<Transaction> getTransactions(String phone);

    // Get unpaid bills
    List<Bill> getUnpaidBills(String phone);

    public boolean transferMoney(String fromPhone, String toPhone, double amount, String password) throws Exception;

	String getUserNameByPhone(String phone);
}