package com.bank.admin;

import com.bank.user.User;
import com.bank.transaction.Transaction;
import java.util.List;
import java.util.Map;

public interface AdminDAO {
    Map<String, Object> getSystemStats();
    List<User> getAllUsers();
    List<Transaction> getAllTransactions(); // Added to fix JSP Error
    boolean toggleUserStatus(String phone, String currentStatus);
    boolean deleteUser(String phone);
	boolean createServiceAccount(User u) throws Exception;
}