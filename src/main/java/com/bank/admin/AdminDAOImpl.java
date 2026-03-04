package com.bank.admin;

import com.bank.util.DBConnection;
import com.bank.user.User;
import com.bank.transaction.Transaction;
import java.sql.*;
import java.util.*;

public class AdminDAOImpl implements AdminDAO {

    @Override
    public Map<String, Object> getSystemStats() {
        Map<String, Object> stats = new HashMap<>();
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery("SELECT * FROM view_admin_stats")) {
            if (rs.next()) {
                stats.put("totalUsers", rs.getInt("total_users"));
                stats.put("bankCapital", rs.getDouble("total_bank_capital"));
                stats.put("pendingBills", rs.getInt("pending_bills"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return stats;
    }

    @Override
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT username, phone_number, role, balance, status FROM users";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User u = new User();
                u.setUsername(rs.getString("username"));
                u.setPhoneNumber(rs.getString("phone_number"));
                u.setRole(rs.getString("role"));
                u.setBalance(rs.getDouble("balance"));
                u.setStatus(rs.getString("status"));
                list.add(u);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public List<Transaction> getAllTransactions() {
        List<Transaction> list = new ArrayList<>();
        // Note: Using the view we created to show descriptions
        String sql = "SELECT * FROM view_transactions ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Transaction t = new Transaction();
                t.setTransactionId(rs.getInt("transaction_id"));
                t.setFromUser(rs.getString("from_user"));
                t.setToUser(rs.getString("to_user"));
                t.setTransactionType(rs.getString("transaction_type"));
                t.setAmount(rs.getDouble("amount"));
                t.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(t);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public boolean toggleUserStatus(String phone, String currentStatus) {
        String newStatus = "ACTIVE".equals(currentStatus) ? "BLOCKED" : "ACTIVE";
        String sql = "UPDATE users SET status = ? WHERE phone_number = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setString(2, phone);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { return false; }
    }

    @Override
    public boolean deleteUser(String phone) {
        String sql = "DELETE FROM users WHERE phone_number = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { return false; }
    }
    
    @Override
    public boolean createServiceAccount(User u) throws Exception {
        // We explicitly set the role to 'SERVICE' and status to 'ACTIVE'
        String sql = "INSERT INTO users (username, phone_number, password, role, balance, status) VALUES (?, ?, ?, 'SERVICE', 0.0, 'ACTIVE')";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, u.getUsername());
            ps.setString(2, u.getPhoneNumber());
            ps.setString(3, u.getPassword()); // In a real app, hash this!
            
            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (SQLIntegrityConstraintViolationException e) {
            // This handles cases where the phone number is already registered
            System.err.println("Error: A user with this phone number already exists.");
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}