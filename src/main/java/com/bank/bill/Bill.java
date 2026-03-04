package com.bank.bill;

import java.util.Date;

public class Bill {

    private String invoiceId;
    private String description; // REFACTORED: Replaces customerPhone/Name
    private double amount;
    private Date dueDate;
    private String status;
    
    // For view logic (to show the name of the company that issued the bill)
    private String serviceName;
    private String servicePhone;

    public Bill() {}

    // ===== Getters & Setters =====

    public String getInvoiceId() {
        return invoiceId;
    }
    public void setInvoiceId(String invoiceId) {
        this.invoiceId = invoiceId;
    }

    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }

    public double getAmount() {
        return amount;
    }
    public void setAmount(double amount) {
        this.amount = amount;
    }

    public Date getDueDate() {
        return dueDate;
    }
    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate;
    }

    public String getServiceName() {
        return serviceName;
    }
    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public String getServicePhone() {
        return servicePhone;
    }
    public void setServicePhone(String servicePhone) {
        this.servicePhone = servicePhone;
    }

    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }
}