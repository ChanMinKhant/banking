<%@ page import="com.bank.user.User" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null || !user.getRole().equals("SERVICE")){
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Generate New Bill</title>
    <style>
        body { font-family: Arial; background: #f4f6f9; margin: 0; padding: 20px; }
        .container { max-width: 500px; margin: auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        h2 { text-align: center; color: #28a745; }
        input { width: 100%; padding: 12px; margin: 10px 0; border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box; }
        button { width: 100%; padding: 12px; background: #28a745; color: white; border: none; border-radius: 5px; cursor: pointer; font-size: 16px; }
        .error { color: red; text-align: center; margin-bottom: 10px; }
        .back-link { display: block; text-align: center; margin-top: 15px; text-decoration: none; color: #666; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Generate Utility Bill</h2>
        <% if(error != null) { %> <div class="error"><%= error %></div> <% } %>
        
        <form action="<%=request.getContextPath()%>/service/ServiceServlet" method="post">
            <input type="hidden" name="action" value="generateBill">
            
            <label>Invoice ID (Unique):</label>
            <input type="text" name="invoiceId" placeholder="e.g., WATER-2024-001" required>
            
            <label>Bill Description:</label>
            <input type="text" name="description" placeholder="e.g., Water Bill - January" required>
            
            <label>Amount ($):</label>
            <input type="number" step="0.01" name="amount" placeholder="0.00" required>
            
            <label>Due Date:</label>
            <input type="date" name="dueDate" required>
            
            <button type="submit">Issue Bill</button>
        </form>
        
        <a href="service_dashboard.jsp" class="back-link">← Back to Dashboard</a>
    </div>
</body>
</html>