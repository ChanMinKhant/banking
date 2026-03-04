<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.bank.admin.*, com.bank.user.User, com.bank.transaction.Transaction, java.util.*" %>
<%@ page session="true" %>

<%
    // 1. Security Check
    User admin = (User) session.getAttribute("user");
    if(admin == null || !"ADMIN".equals(admin.getRole())){
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }

    // 2. Initialize DAO and Fetch Data
    AdminDAO dao = new AdminDAOImpl();
    Map<String, Object> stats = dao.getSystemStats();
    List<User> users = dao.getAllUsers();
    List<Transaction> logs = dao.getAllTransactions();
    
    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Master Admin Dashboard</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f4f7f6; margin: 0; display: flex; }
        .sidebar { width: 260px; background: #2c3e50; color: white; height: 100vh; padding: 25px; position: fixed; }
        .main-content { margin-left: 310px; padding: 30px; width: calc(100% - 310px); }
        
        /* Stats Cards */
        .stats-container { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 30px; }
        .stat-card { background: white; padding: 20px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); border-left: 5px solid #3498db; }
        .stat-card h3 { margin: 0; font-size: 14px; color: #7f8c8d; text-transform: uppercase; }
        .stat-card p { margin: 10px 0 0 0; font-size: 28px; font-weight: bold; color: #2c3e50; }

        /* Tables */
        .card { background: white; padding: 25px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); margin-bottom: 30px; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th { background: #f8f9fa; color: #34495e; text-align: left; padding: 12px; border-bottom: 2px solid #eee; }
        td { padding: 12px; border-bottom: 1px solid #eee; font-size: 14px; }
        
        /* Buttons */
        .btn { padding: 8px 12px; border: none; border-radius: 6px; cursor: pointer; font-weight: 600; text-decoration: none; font-size: 12px; }
        .btn-block { background: #e74c3c; color: white; }
        .btn-unblock { background: #2ecc71; color: white; }
        .btn-delete { background: #95a5a6; color: white; margin-left: 5px; }
        .btn-create { background: #3498db; color: white; padding: 10px 20px; }
        
        .alert { padding: 15px; border-radius: 8px; margin-bottom: 20px; }
        .alert-success { background: #d4edda; color: #155724; }
        .alert-error { background: #f8d7da; color: #721c24; }
        
        input[type="text"], input[type="password"] { padding: 10px; border: 1px solid #ddd; border-radius: 6px; margin-right: 10px; }
    </style>
</head>
<body>

<div class="sidebar">
    <h2>Bank Admin</h2>
    <p style="color: #bdc3c7;">Logged in as: <strong><%= admin.getUsername() %></strong></p>
    <hr style="border: 0.5px solid #34495e;">
    <nav>
        <p><a href="#overview" style="color: white; text-decoration: none;">🏠 Overview</a></p>
        <p><a href="#users" style="color: white; text-decoration: none;">👥 Manage Users</a></p>
        <p><a href="#transactions" style="color: white; text-decoration: none;">📜 Transactions</a></p>
        <p><a href="<%=request.getContextPath()%>/auth/LoginServlet" style="color: #e74c3c; text-decoration: none;">🚪 Logout</a></p>
    </nav>
</div>

<div class="main-content">
    <h1 id="overview">System Dashboard</h1>

    <% if(msg != null) { %><div class="alert alert-success"><%= msg %></div><% } %>
    <% if(error != null) { %><div class="alert alert-error"><%= error %></div><% } %>

    <div class="stats-container">
        <div class="stat-card">
            <h3>Total Users</h3>
            <p><%= stats.get("totalUsers") %></p>
        </div>
        <div class="stat-card" style="border-left-color: #2ecc71;">
            <h3>Total Bank Capital</h3>
            <p>$<%= String.format("%.2f", stats.get("bankCapital")) %></p>
        </div>
        <div class="stat-card" style="border-left-color: #f1c40f;">
            <h3>Pending Utility Bills</h3>
            <p><%= stats.get("pendingBills") %></p>
        </div>
    </div>

    <div class="card">
        <h3>Quick Create: Service Provider</h3>
        <form action="AdminServlet" method="POST">
            <input type="hidden" name="action" value="createService">
            <input type="text" name="username" placeholder="Service Name (e.g., MPT)" required>
            <input type="text" name="phone" placeholder="Phone Number" required>
            <input type="password" name="password" placeholder="Set PIN" required>
            <button type="submit" class="btn btn-create">Add Provider</button>
        </form>
    </div>

    <div class="card" id="users">
        <h3>User Account Management</h3>
        <table>
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Phone</th>
                    <th>Role</th>
                    <th>Balance</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% for(User u : users) { %>
                <tr>
                    <td><strong><%= u.getUsername() %></strong></td>
                    <td><%= u.getPhoneNumber() %></td>
                    <td><%= u.getRole() %></td>
                    <td>$<%= String.format("%.2f", u.getBalance()) %></td>
                    <td>
                        <span style="color: <%= "ACTIVE".equals(u.getStatus()) ? "#2ecc71" : "#e74c3c" %>; font-weight: bold;">
                            <%= u.getStatus() %>
                        </span>
                    </td>
                    <td>
                        <form action="AdminServlet" method="POST" style="display:inline;">
                            <input type="hidden" name="action" value="toggleStatus">
                            <input type="hidden" name="phone" value="<%= u.getPhoneNumber() %>">
                            <input type="hidden" name="currentStatus" value="<%= u.getStatus() %>">
                            <button type="submit" class="btn <%= "ACTIVE".equals(u.getStatus()) ? "btn-block" : "btn-unblock" %>">
                                <%= "ACTIVE".equals(u.getStatus()) ? "Block" : "Unlock" %>
                            </button>
                        </form>
                        
                        <form action="AdminServlet" method="POST" style="display:inline;" onsubmit="return confirm('Delete this user permanently?');">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="phone" value="<%= u.getPhoneNumber() %>">
                            <button type="submit" class="btn btn-delete">Delete</button>
                        </form>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    
    <div class="card" id="transactions">
        <h3>Global Transaction Audit</h3>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>From</th>
                    <th>To / Description</th>
                    <th>Type</th>
                    <th>Amount</th>
                    <th>Date</th>
                </tr>
            </thead>
            <tbody>
                <% for(Transaction t : logs) { %>
                <tr>
                    <td><%= t.getTransactionId() %></td>
                    <td><%= t.getFromUser() %></td>
                    <td><strong><%= t.getToUser() %></strong></td>
                    <td><%= t.getTransactionType() %></td>
                    <td style="color: #2c3e50; font-weight: bold;">$<%= String.format("%.2f", t.getAmount()) %></td>
                    <td><%= t.getCreatedAt() %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>