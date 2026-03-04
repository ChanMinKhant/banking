<%@ page import="com.bank.user.User" %>
<%@ page import="com.bank.customer.CustomerDAO" %>
<%@ page import="com.bank.customer.CustomerDAOImpl" %>
<%@ page session="true" %>

<%
    User user = (User) session.getAttribute("user");
    if(user == null){
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }

    String step = request.getParameter("step");
    String toPhone = request.getParameter("toPhone");
    String amountStr = request.getParameter("amount");
    double amount = 0;
    if(amountStr != null && !amountStr.isEmpty()){
        try {
            amount = Double.parseDouble(amountStr);
        } catch(Exception e) { amount = 0; }
    }

    CustomerDAO dao = new CustomerDAOImpl();
    String receiverName = null;

    if("confirm".equals(step) && toPhone != null && !toPhone.isEmpty()){
        receiverName = dao.getUserNameByPhone(toPhone); // fetch recipient name
        if(receiverName == null){
            // If phone not found in DB, show error
            out.println("<p style='color:red;'>Recipient not found. Check phone number!</p>");
            step = null; // go back to Step 1
        }
    }
%>

<html>
<head>
    <title>Transfer Money</title>
    <style>
        body { font-family: Arial; background: #f4f4f4; padding: 20px;}
        .container { max-width: 450px; margin: auto; background: white; padding: 20px; border-radius: 10px; box-shadow:0 4px 8px rgba(0,0,0,0.1);}
        input, button { width: 100%; padding: 10px; margin: 10px 0; }
        h2 { text-align: center; }
    </style>
</head>
<body>
<div class="container">

<h2>Transfer Money</h2>

<% if("confirm".equals(step) && receiverName != null){ %>
    <!-- Step 2: Show receiver and ask for PIN -->
    <p>Send <strong>$<%= String.format("%.2f", amount) %></strong> to <strong><%= receiverName %></strong> (Phone: <%= toPhone %>)</p>
    <form action="<%=request.getContextPath()%>/customer/CustomerServlet" method="post">
        <input type="hidden" name="action" value="transfer">
        <input type="hidden" name="toPhone" value="<%= toPhone %>">
        <input type="hidden" name="amount" value="<%= amount %>">
        <input type="password" name="password" placeholder="Enter your PIN" required>
        <button type="submit">Confirm Payment</button>
    </form>
    <form action="transfer.jsp" method="get">
        <button type="submit">Cancel</button>
    </form>

<% } else { %>
    <!-- Step 1: Enter recipient phone and amount -->
    <form action="transfer.jsp" method="get">
        <input type="text" name="toPhone" placeholder="Recipient Phone Number" value="<%= (toPhone!=null)?toPhone:"" %>" required>
        <input type="number" name="amount" placeholder="Amount" step="0.01" value="<%= amount %>" required>
        <input type="hidden" name="step" value="confirm">
        <button type="submit">Next</button>
    </form>
<% } %>

</div>
</body>
</html>