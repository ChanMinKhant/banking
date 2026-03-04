package com.bank.admin;

import com.bank.user.User;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/jsp/AdminServlet") // Mapping it where the JSP lives for easier redirection
public class AdminServlet extends HttpServlet {
    private AdminDAO adminDAO = new AdminDAOImpl();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Session & Security Check
        HttpSession session = request.getSession(false);
        User admin = (session != null) ? (User) session.getAttribute("user") : null;
        
        if (admin == null || !"ADMIN".equals(admin.getRole())) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        boolean success = false;
        String message = "";

        try {
            if ("toggleStatus".equals(action)) {
                success = adminDAO.toggleUserStatus(request.getParameter("phone"), request.getParameter("currentStatus"));
                message = success ? "User status updated." : "Update failed.";
                
            } else if ("delete".equals(action)) {
                success = adminDAO.deleteUser(request.getParameter("phone"));
                message = success ? "User deleted successfully." : "Delete failed.";
                
            } else if ("createService".equals(action)) {
                User u = new User();
                u.setUsername(request.getParameter("username"));
                u.setPhoneNumber(request.getParameter("phone"));
                u.setPassword(request.getParameter("password"));
                u.setRole("SERVICE"); 
                success = adminDAO.createServiceAccount(u);
                message = success ? "Service account created." : "Creation failed.";
            }
        } catch (Exception e) {
            e.printStackTrace();
            message = "Error: " + e.getMessage();
        }

        // 2. Redirect back to the dashboard with the result message
        // Use the actual name of your JSP (admin.jsp or admin_dashboard.jsp)
        response.sendRedirect("admin.jsp?msg=" + java.net.URLEncoder.encode(message, "UTF-8"));
    }
}