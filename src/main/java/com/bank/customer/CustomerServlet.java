package com.bank.customer;

import com.bank.user.User;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/customer/CustomerServlet")
public class CustomerServlet extends HttpServlet {
    private CustomerDAO customerDAO = new CustomerDAOImpl();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if(session == null || session.getAttribute("user") == null){
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        boolean success = false;

        try {
            switch(action){
                case "deposit":
                    double depositAmount = Double.parseDouble(request.getParameter("amount"));
                    success = customerDAO.deposit(user.getPhoneNumber(), depositAmount);
                    break;
                    
                case "withdraw":
                    double withdrawAmount = Double.parseDouble(request.getParameter("amount"));
                    success = customerDAO.withdraw(user.getPhoneNumber(), withdrawAmount);
                    break;
                    
                case "transfer":
                    String toPhone = request.getParameter("toPhone");
                    double amount = Double.parseDouble(request.getParameter("amount"));
                    // REFACTORED: Using "password" to match transfer.jsp input name
                    String password = request.getParameter("password"); 

                    success = customerDAO.transferMoney(user.getPhoneNumber(), toPhone, amount, password);

                    if(success){
                        // Update session balance for immediate UI feedback
                        double updatedBalance = customerDAO.getBalance(user.getPhoneNumber());
                        user.setBalance(updatedBalance);
                        session.setAttribute("user", user);
                        response.sendRedirect(request.getContextPath() + "/jsp/customer_dashboard.jsp?message=Transfer Successful!");
                        return;
                    } else {
                        response.sendRedirect(request.getContextPath() + "/jsp/transfer.jsp?error=Invalid PIN or Recipient not found");
                        return;
                    }

                case "payBill":
                    String invId = request.getParameter("invoiceId");
                    String pass = request.getParameter("password"); // New parameter from form
                    success = customerDAO.payBill(user.getPhoneNumber(), invId, pass);
                    break;
            }
        } catch(Exception e){
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/jsp/customer_dashboard.jsp?error=" + e.getMessage());
            return;
        }

        if(success){
            response.sendRedirect(request.getContextPath() + "/jsp/customer_dashboard.jsp?message=Action successful!");
        } else {
            response.sendRedirect(request.getContextPath() + "/jsp/customer_dashboard.jsp?error=Action failed!");
        }
    }
}