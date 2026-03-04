package com.bank.customer;

import com.bank.customer.CustomerDAO;
import com.bank.customer.CustomerDAOImpl;
import com.bank.user.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/customer/BalanceServlet")
public class BalanceServlet extends HttpServlet {
    private CustomerDAO customerDAO = new CustomerDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if(session == null || session.getAttribute("user") == null){
            response.getWriter().write("{\"error\":\"not_logged_in\"}");
            return;
        }

        User user = (User) session.getAttribute("user");
        double balance = customerDAO.getBalance(user.getPhoneNumber());

        // Return balance as JSON
        response.getWriter().write("{\"balance\":" + balance + "}");
    }
}