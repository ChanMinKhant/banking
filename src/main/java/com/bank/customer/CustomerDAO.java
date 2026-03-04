package com.bank.customer;

import com.bank.user.User;
import com.bank.bill.Bill; 
import com.bank.transaction.Transaction;
import java.util.List;

public interface CustomerDAO {

    // Retrieve current balance from database
    double getBalance(String phone);

    // Add funds to account via sp_deposit
    boolean deposit(String phone, double amount);

    // Remove funds from account via sp_withdraw
    boolean withdraw(String phone, double amount);

    // Internal direct transfer logic
    boolean transfer(String fromPhone, String toPhone, double amount);

    // Logic to claim and pay an invoice via invoice_id
    boolean payBill(String customerPhone, String invoiceId);

    // Fetch history from view_transactions
    List<Transaction> getTransactions(String phone);

    // Fetch all available unpaid bills from view_unpaid_bills
    List<Bill> getUnpaidBills(String phone);

    // Secure transfer with password validation
    boolean transferMoney(String fromPhone, String toPhone, double amount, String password) throws Exception;

    // Helper to find recipient names for confirmation screens
    String getUserNameByPhone(String phone);

	boolean payBill(String customerPhone, String invoiceId, String password) throws Exception;
}