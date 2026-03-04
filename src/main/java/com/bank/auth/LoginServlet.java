package com.bank.auth;

import com.bank.user.User;
import com.bank.user.UserDAO;
import com.bank.user.UserDAOImpl;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/auth/LoginServlet")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAOImpl();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String identifier = request.getParameter("identifier");
        String password = request.getParameter("password");

        User user = userDAO.login(identifier, password);
        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            switch (user.getRole()) {
                case "CUSTOMER":
                    response.sendRedirect("../jsp/customer_dashboard.jsp");
                    break;
                case "ADMIN":
                    response.sendRedirect("../jsp/admin.jsp");
                    break;
                case "SERVICE":
                    response.sendRedirect("../jsp/service_dashboard.jsp");
                    break;
            }
        } else {
            request.setAttribute("error", "Invalid credentials or account blocked!");
            request.getRequestDispatcher("../jsp/login.jsp").forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) session.invalidate();
        response.sendRedirect("../jsp/login.jsp");
    }
}