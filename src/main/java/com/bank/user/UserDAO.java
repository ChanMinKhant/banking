package com.bank.user;

import java.util.List;

public interface UserDAO {

    // Login with username or phone
    User login(String identifier, String password);

    // Register a new customer
    boolean registerUser(User user);

    // Get user by phone number
    User getUserByPhone(String phone);

    // Get all customers
    List<User> getAllCustomers();
}