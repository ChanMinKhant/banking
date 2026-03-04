package com.bank.transaction;

import com.bank.user.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/customer/TransactionServlet")
public class TransactionServlet extends HttpServlet {
    private TransactionDAO transactionDAO = new TransactionDAOImpl();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Fetch transactions for current user
        List<Transaction> transactions = transactionDAO.getTransactionsByPhone(user.getPhoneNumber());
        request.setAttribute("transactions", transactions);

        request.getRequestDispatcher("/jsp/transactions.jsp").forward(request, response);
    }
}