<%@ page import="com.bank.user.User" %>
<%@ page import="com.bank.service.*" %>
<%@ page import="com.bank.transaction.Transaction" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null || !user.getRole().equals("SERVICE")){
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    ServiceDAO dao = new ServiceDAOImpl();
    List<Transaction> payments = dao.getIncomingPayments(user.getPhoneNumber());
%>
<!DOCTYPE html>
<html>
<head>
    <title>Service Dashboard</title>
    <style>
        /* Reusing your CSS logic for consistency */
        body { font-family: Arial; background: #f4f6f9; margin: 0; }
        header { background: #28a745; color: white; padding: 20px; text-align: center; }
        .container { max-width: 900px; margin: 20px auto; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        .grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 30px; }
        .card { padding: 20px; border: 1px solid #ddd; border-radius: 8px; text-align: center; }
        .btn { display: inline-block; padding: 10px 20px; background: #28a745; color: white; text-decoration: none; border-radius: 5px; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 12px; border-bottom: 1px solid #eee; text-align: left; }
        th { background: #f8f9fa; }
    </style>
</head>
<body>
<header>
    <h1><%= user.getUsername() %> - Service Panel</h1>
</header>
<div class="container">
    <div class="grid">
        <div class="card">
            <h3>Billing</h3>
            <p>Create new invoices for customers.</p>
            <a href="generate_bill.jsp" class="btn">Generate Bill</a>
        </div>
        <div class="card">
            <h3>Records</h3>
            <p>View all bills issued by you.</p>
            <a href="manage_bills.jsp" class="btn" style="background:#007bff;">View History</a>
        </div>
    </div>

    <h3>Recent Incoming Payments</h3>
    <table>
        <tr>
            <th>Date</th>
            <th>Invoice ID</th>
            <th>Amount</th>
        </tr>
        <% for(Transaction t : payments) { %>
        <tr>
            <td><%= t.getCreatedAt() %></td>
            <td><%= t.getReferenceId() %></td>
            <td>$<%= String.format("%.2f", t.getAmount()) %></td>
        </tr>
        <% } %>
    </table>
    
    <div style="text-align:center; margin-top:30px;">
        <a href="<%=request.getContextPath()%>/auth/LoginServlet" style="color:red;">Logout</a>
    </div>
</div>
</body>
</html>