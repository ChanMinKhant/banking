<%@ page import="com.bank.user.User" %>
<%@ page import="com.bank.transaction.Transaction" %>
<%@ page import="com.bank.transaction.TransactionDAO" %>
<%@ page import="com.bank.transaction.TransactionDAOImpl" %>
<%@ page session="true" %>

<%
    User user = (User) session.getAttribute("user");
    if(user == null){
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }

    TransactionDAO dao = new TransactionDAOImpl();
    java.util.List<Transaction> transactions = dao.getTransactionsByPhone(user.getPhoneNumber());
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Transaction History</title>
    <style>
        body { font-family: Arial; background: #f4f4f4; margin:0; padding:20px; }
        .container { max-width: 900px; margin:auto; background:white; padding:20px; border-radius:10px; box-shadow:0 4px 8px rgba(0,0,0,0.1);}
        table { width: 100%; border-collapse: collapse; margin-top:20px; }
        th, td { padding:10px; border:1px solid #ccc; text-align:center; }
        th { background:#007bff; color:white; }
    </style>
</head>
<body>
<div class="container">
    <h2>Transaction History</h2>

    <%
        if(transactions.isEmpty()){
    %>
        <p>No transactions found.</p>
    <%
        } else {
    %>
        <table>
            <tr>
                <th>ID</th>
                <th>From</th>
                <th>To</th>
                <th>Type</th>
                <th>Amount</th>
                <th>Reference</th>
                <th>Date</th>
            </tr>
            <%
                for(Transaction t : transactions){
            %>
            <tr>
                <td><%= t.getTransactionId() %></td>
                <td><%= t.getFromUser() %></td>
                <td><%= t.getToUser() %></td>
                <td><%= t.getTransactionType() %></td>
                <td>$<%= String.format("%.2f", t.getAmount()) %></td>
                <td><%= t.getReferenceId() != null ? t.getReferenceId() : "-" %></td>
                <td><%= t.getCreatedAt() %></td>
            </tr>
            <% } %>
        </table>
    <% } %>
</div>
</body>
</html>