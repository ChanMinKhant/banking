package com.bank.transaction;

import com.bank.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TransactionDAOImpl implements TransactionDAO {

    @Override
    public List<Transaction> getTransactionsByPhone(String phone) {
        List<Transaction> list = new ArrayList<>();
        String sql = "SELECT t.transaction_id, t.from_phone, t.to_phone, t.transaction_type, t.amount, t.reference_id, t.created_at, " +
                     "uf.username AS from_user, ut.username AS to_user " +
                     "FROM transactions t " +
                     "LEFT JOIN users uf ON t.from_phone = uf.phone_number " +
                     "LEFT JOIN users ut ON t.to_phone = ut.phone_number " +
                     "WHERE t.from_phone = ? OR t.to_phone = ? " +
                     "ORDER BY t.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, phone);
            ps.setString(2, phone);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Transaction t = new Transaction();
                // If sender or receiver has no username, show phone number
                t.setFromUser(rs.getString("from_user") != null ? rs.getString("from_user") : rs.getString("from_phone"));
                t.setToUser(rs.getString("to_user") != null ? rs.getString("to_user") : rs.getString("to_phone"));
                t.setTransactionId(rs.getInt("transaction_id"));
                t.setTransactionType(rs.getString("transaction_type"));
                t.setAmount(rs.getDouble("amount"));
                t.setReferenceId(rs.getString("reference_id"));
                t.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(t);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}