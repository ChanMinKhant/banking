package com.bank.service;

import com.bank.user.User;
import com.bank.bill.Bill;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.text.SimpleDateFormat;

@WebServlet("/service/ServiceServlet")
public class ServiceServlet extends HttpServlet {
    private ServiceDAO serviceDAO = new ServiceDAOImpl();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        if ("generateBill".equals(action)) {
            try {
                Bill bill = new Bill();
                bill.setInvoiceId(request.getParameter("invoiceId"));
                
                // REFACTORED: Get description from form instead of customerPhone
                bill.setDescription(request.getParameter("description")); 
                
                bill.setServicePhone(user.getPhoneNumber());
                bill.setAmount(Double.parseDouble(request.getParameter("amount")));
                
                String dateStr = request.getParameter("dueDate");
                bill.setDueDate(new SimpleDateFormat("yyyy-MM-dd").parse(dateStr));

                if (serviceDAO.generateBill(bill)) {
                    response.sendRedirect("../jsp/service_dashboard.jsp?message=Bill Generated Successfully");
                } else {
                    response.sendRedirect("../jsp/generate_bill.jsp?error=Failed to generate bill. ID might already exist.");
                }
            } catch (Exception e) {
                response.sendRedirect("../jsp/generate_bill.jsp?error=Invalid Data format");
            }
        }
    }
}