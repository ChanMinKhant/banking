package com.bank.customer;

import com.bank.util.DBConnection;
import com.bank.bill.Bill;
import com.bank.transaction.Transaction;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAOImpl implements CustomerDAO {

    @Override
    public double getBalance(String phone) {
        String sql = "SELECT balance FROM users WHERE phone_number=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone);
            ResultSet rs = ps.executeQuery();
            if(rs.next()) return rs.getDouble("balance");
        } catch (Exception e) { e.printStackTrace(); }
        return 0.0;
    }

    @Override
    public boolean deposit(String phone, double amount) {
        String sql = "{CALL sp_deposit(?, ?)}";
        try (Connection conn = DBConnection.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {
            cs.setString(1, phone);
            cs.setDouble(2, amount);
            cs.execute();
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    @Override
    public boolean withdraw(String phone, double amount) {
        String sql = "{CALL sp_withdraw(?, ?)}";
        try (Connection conn = DBConnection.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {
            cs.setString(1, phone);
            cs.setDouble(2, amount);
            cs.execute();
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    @Override
    public boolean transfer(String fromPhone, String toPhone, double amount) {
        String sql = "{CALL sp_transfer(?, ?, ?)}";
        try (Connection conn = DBConnection.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {
            cs.setString(1, fromPhone);
            cs.setString(2, toPhone);
            cs.setDouble(3, amount);
            cs.execute();
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    @Override
    public boolean payBill(String customerPhone, String invoiceId) {
        // Calls the refactored stored procedure that handles the balance swap
        String sql = "{CALL sp_pay_bill(?, ?)}";
        try (Connection conn = DBConnection.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {
            cs.setString(1, customerPhone);
            cs.setString(2, invoiceId);
            cs.execute();
            return true;
        } catch (Exception e) { 
            e.printStackTrace(); 
            return false; 
        }
    }

    @Override
    public List<Transaction> getTransactions(String phone) {
        List<Transaction> list = new ArrayList<>();
        // Use phone to find the username first, then filter the view
        String sql = "SELECT * FROM view_transactions WHERE from_user=(SELECT username FROM users WHERE phone_number=?) OR to_user=(SELECT username FROM users WHERE phone_number=?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone);
            ps.setString(2, phone);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                Transaction t = new Transaction();
                t.setTransactionId(rs.getInt("transaction_id"));
                t.setTransactionType(rs.getString("transaction_type"));
                t.setAmount(rs.getDouble("amount"));
                t.setReferenceId(rs.getString("reference_id"));
                t.setFromUser(rs.getString("from_user"));
                t.setToUser(rs.getString("to_user"));
                t.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(t);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public List<Bill> getUnpaidBills(String phone) {
        List<Bill> list = new ArrayList<>();
        // REFACTORED: No longer filtering by customer phone.
        // Any customer can see any unpaid bill to pay it.
        String sql = "SELECT * FROM view_unpaid_bills";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while(rs.next()) {
                Bill b = new Bill();
                b.setInvoiceId(rs.getString("invoice_id"));
                b.setDescription(rs.getString("description")); // Refactored column
                b.setAmount(rs.getDouble("amount"));
                b.setDueDate(rs.getDate("due_date"));
                b.setServiceName(rs.getString("service_provider"));
                list.add(b);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public boolean transferMoney(String fromPhone, String toPhone, double amount, String password) throws Exception {
        try (Connection conn = DBConnection.getConnection()) {
            // Check sender password & balance
            String sql = "SELECT password, balance FROM users WHERE phone_number=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, fromPhone);
            ResultSet rs = ps.executeQuery();
            
            if(rs.next()){
                String dbPass = rs.getString("password");
                double balance = rs.getDouble("balance");

                if(!dbPass.equals(password)) return false;
                if(balance < amount) throw new Exception("Insufficient balance");

                // Check recipient exists
                String checkReceiver = "SELECT user_id FROM users WHERE phone_number=?";
                PreparedStatement ps2 = conn.prepareStatement(checkReceiver);
                ps2.setString(1, toPhone);
                ResultSet rs2 = ps2.executeQuery();
                if(!rs2.next()) return false;

                // Perform transfer via stored procedure
                CallableStatement cs = conn.prepareCall("{CALL sp_transfer(?, ?, ?)}");
                cs.setString(1, fromPhone);
                cs.setString(2, toPhone);
                cs.setDouble(3, amount);
                cs.execute();
                return true;
            } else {
                throw new Exception("Sender not found");
            }
        }
    }

    @Override
    public String getUserNameByPhone(String phone) {
        String sql = "SELECT username FROM users WHERE phone_number=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone);
            ResultSet rs = ps.executeQuery();
            if(rs.next()) return rs.getString("username");
        } catch(Exception e) { e.printStackTrace(); }
        return null;
    }
    
    @Override
    public boolean payBill(String customerPhone, String invoiceId, String password) throws Exception {
        // 1. Verify password first
        String checkSql = "SELECT password FROM users WHERE phone_number=?";
        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(checkSql);
            ps.setString(1, customerPhone);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                if (!rs.getString("password").equals(password)) {
                    throw new Exception("Invalid PIN/Password!");
                }
            }

            // 2. Call the stored procedure to pay
            CallableStatement cs = conn.prepareCall("{CALL sp_pay_bill(?, ?)}");
            cs.setString(1, customerPhone);
            cs.setString(2, invoiceId);
            return cs.executeUpdate() > 0;
        }
    }
}