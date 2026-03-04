<%@ page import="com.bank.user.User" %>
<%@ page import="com.bank.customer.CustomerDAO" %>
<%@ page import="com.bank.customer.CustomerDAOImpl" %>
<%@ page session="true" %>

<%
    // Check if user is logged in
    User user = (User) session.getAttribute("user");
    if(user == null){
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }

    // Get parameters
    String step = request.getParameter("step");
    String toPhone = request.getParameter("toPhone");
    String amountStr = request.getParameter("amount");
    double amount = 0;
    if(amountStr != null && !amountStr.isEmpty()){
        try { amount = Double.parseDouble(amountStr); } catch(Exception e) { amount = 0; }
    }

    // DAO for fetching recipient name
    CustomerDAO dao = new CustomerDAOImpl();
    String receiverName = null;
    if("confirm".equals(step) && toPhone != null && !toPhone.isEmpty()){
        receiverName = dao.getUserNameByPhone(toPhone);
        if(receiverName == null){
            request.setAttribute("error", "Recipient not found. Check phone number!");
            step = null; // go back to Step 1
        }
    }

    // Check if there's an error forwarded from servlet
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Transfer Money</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f4f4; padding: 20px; }
        .container { max-width: 450px; margin: auto; background: white; padding: 25px; border-radius: 12px; box-shadow:0 6px 15px rgba(0,0,0,0.1);}
        h2 { text-align: center; margin-bottom: 20px; }
        input, button { width: 100%; padding: 12px; margin: 10px 0; border-radius: 8px; border: 1px solid #ccc; }
        button { background-color: #007bff; color: white; border: none; font-weight: bold; cursor: pointer; transition: 0.3s; }
        button:hover { background-color: #0056b3; }
        .error { color: red; text-align: center; margin-bottom: 10px; }
        .cancel { background-color: #dc3545; margin-top: 5px; }
        .cancel:hover { background-color: #a71d2a; }
    </style>
</head>
<body>
<div class="container">

<h2>Transfer Money</h2>

<% if(error != null){ %>
    <p class="error"><%= error %></p>
<% } %>

<% if("confirm".equals(step) && receiverName != null){ %>
    <!-- Step 2: Confirm recipient and enter PIN -->
    <p>Send <strong>$<%= String.format("%.2f", amount) %></strong> to <strong><%= receiverName %></strong> (Phone: <%= toPhone %>)</p>

    <form action="<%=request.getContextPath()%>/customer/CustomerServlet" method="post">
        <input type="hidden" name="action" value="transfer">
        <input type="hidden" name="toPhone" value="<%= toPhone %>">
        <input type="hidden" name="amount" value="<%= amount %>">
        <input type="password" name="password" placeholder="Enter your PIN" required>
        <button type="submit">Confirm Payment</button>
    </form>

    <form action="transfer.jsp" method="get">
        <button type="submit" class="cancel">Cancel</button>
    </form>

<% } else { %>
    <!-- Step 1: Enter recipient phone and amount -->
    <form action="transfer.jsp" method="get">
        <input type="text" name="toPhone" placeholder="Recipient Phone Number" value="<%= (toPhone != null) ? toPhone : "" %>" required>
        <input type="number" name="amount" placeholder="Amount" step="0.01" value="<%= amount %>" required>
        <input type="hidden" name="step" value="confirm">
        <button type="submit">Next</button>
    </form>
<% } %>

</div>
</body>
</html>