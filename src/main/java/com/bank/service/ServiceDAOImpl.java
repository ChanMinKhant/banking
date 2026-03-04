package com.bank.service;

import com.bank.util.DBConnection;
import com.bank.bill.Bill;
import com.bank.transaction.Transaction;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ServiceDAOImpl implements ServiceDAO {

    @Override
    public boolean generateBill(Bill bill) {
        // REFACTORED: Changed customer_phone to description
        String sql = "INSERT INTO bills (invoice_id, description, service_phone, amount, due_date, status) VALUES (?, ?, ?, ?, ?, 'UNPAID')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, bill.getInvoiceId());
            ps.setString(2, bill.getDescription()); // Set description instead of phone
            ps.setString(3, bill.getServicePhone());
            ps.setDouble(4, bill.getAmount());
            ps.setDate(5, new java.sql.Date(bill.getDueDate().getTime()));
            return ps.executeUpdate() > 0;
        } catch (Exception e) { 
            e.printStackTrace(); 
            return false; 
        }
    }

    @Override
    public List<Transaction> getIncomingPayments(String servicePhone) {
        List<Transaction> list = new ArrayList<>();
        String sql = "SELECT * FROM transactions WHERE to_phone = ? AND transaction_type = 'BILL_PAYMENT' ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, servicePhone);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                Transaction t = new Transaction();
                t.setAmount(rs.getDouble("amount"));
                t.setReferenceId(rs.getString("reference_id"));
                t.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(t);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public List<Bill> getIssuedBills(String servicePhone) {
        List<Bill> list = new ArrayList<>();
        String sql = "SELECT * FROM bills WHERE service_phone = ? ORDER BY due_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, servicePhone);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                Bill b = new Bill();
                b.setInvoiceId(rs.getString("invoice_id"));
                b.setDescription(rs.getString("description")); // REFACTORED: Get description from DB
                b.setAmount(rs.getDouble("amount"));
                b.setDueDate(rs.getDate("due_date"));
                b.setStatus(rs.getString("status"));
                list.add(b);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}