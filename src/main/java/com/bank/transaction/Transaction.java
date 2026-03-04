package com.bank.transaction;

import java.sql.Timestamp;

public class Transaction {
    private int transactionId;
    private String transactionType;
    private double amount;
    private String referenceId;
    private String fromUser;
    private String toUser;
    private Timestamp createdAt;

    // Constructors
    public Transaction() {}

    public Transaction(int transactionId, String transactionType, double amount, String referenceId,
                       String fromUser, String toUser, Timestamp createdAt) {
        this.transactionId = transactionId;
        this.transactionType = transactionType;
        this.amount = amount;
        this.referenceId = referenceId;
        this.fromUser = fromUser;
        this.toUser = toUser;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(int transactionId) {
        this.transactionId = transactionId;
    }

    public String getTransactionType() {
        return transactionType;
    }

    public void setTransactionType(String transactionType) {
        this.transactionType = transactionType;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public String getReferenceId() {
        return referenceId;
    }

    public void setReferenceId(String referenceId) {
        this.referenceId = referenceId;
    }

    public String getFromUser() {
        return fromUser;
    }

    public void setFromUser(String fromUser) {
        this.fromUser = fromUser;
    }

    public String getToUser() {
        return toUser;
    }

    public void setToUser(String toUser) {
        this.toUser = toUser;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}