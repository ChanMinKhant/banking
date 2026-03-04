package com.bank.auth;

import com.bank.user.User;
import com.bank.user.UserDAO;
import com.bank.user.UserDAOImpl;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/auth/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAOImpl();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        User user = new User();
        user.setUsername(username);
        user.setPhoneNumber(phone);
        user.setPassword(password);
        user.setBalance(0.0);

        boolean success = userDAO.registerUser(user);
        if (success) {
            // Redirect to login page after successful registration
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp?message=Registration successful! Please login.");
        } else {
            // Redirect back to registration page with error
            response.sendRedirect(request.getContextPath() + "/jsp/register.jsp?error=Registration failed! Username or phone may already exist.");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("../jsp/register.jsp");
    }
}