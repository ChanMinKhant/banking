<%@ page import="com.bank.user.User" %>
<%@ page import="com.bank.customer.CustomerDAO" %>
<%@ page import="com.bank.customer.CustomerDAOImpl" %>
<%@ page session="true" %>

<%
    // 1. Check if user is logged in
    User user = (User) session.getAttribute("user");
    if(user == null){
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }

    // 2. Get parameters
    String step = request.getParameter("step");
    String toPhone = request.getParameter("toPhone");
    String amountStr = request.getParameter("amount");
    
    double amount = 0;
    if(amountStr != null && !amountStr.isEmpty()){
        try { 
            amount = Double.parseDouble(amountStr); 
        } catch(Exception e) { 
            amount = 0; 
        }
    }

    // 3. VALIDATION: Amount must be greater than 0
    // If user tries to proceed to confirmation with 0 or less, stop them.
    if("confirm".equals(step) && amount <= 0) {
        request.setAttribute("error", "Invalid amount. Please enter more than $0.00");
        step = null; // Reset to Step 1
    }

    // 4. DAO logic for fetching recipient name
    CustomerDAO dao = new CustomerDAOImpl();
    String receiverName = null;
    
    if("confirm".equals(step) && toPhone != null && !toPhone.isEmpty()){
        // Validation: Cannot send money to yourself
        if(toPhone.equals(user.getPhoneNumber())) {
            request.setAttribute("error", "You cannot transfer money to your own number!");
            step = null;
        } else {
            receiverName = dao.getUserNameByPhone(toPhone);
            if(receiverName == null){
                request.setAttribute("error", "Recipient not found. Check phone number!");
                step = null; 
            }
        }
    }

    // Check if there's an error passed from the Servlet or set above
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
        input, button { width: 100%; padding: 12px; margin: 10px 0; border-radius: 8px; border: 1px solid #ccc; box-sizing: border-box; }
        button { background-color: #007bff; color: white; border: none; font-weight: bold; cursor: pointer; transition: 0.3s; }
        button:hover { background-color: #0056b3; }
        .error { color: #dc3545; background: #f8d7da; padding: 10px; border-radius: 5px; text-align: center; margin-bottom: 15px; border: 1px solid #f5c6cb; }
        .cancel { background-color: #dc3545; margin-top: 5px; }
        .cancel:hover { background-color: #a71d2a; }
        .info-box { background: #e7f3ff; padding: 15px; border-radius: 8px; margin-bottom: 15px; border-left: 5px solid #007bff; }
    </style>
</head>
<body>
<div class="container">

<h2>Transfer Money</h2>

<% if(error != null){ %>
    <p class="error"><%= error %></p>
<% } %>

<% if("confirm".equals(step) && receiverName != null){ %>
    <div class="info-box">
        <p>You are sending:</p>
        <h3 style="margin: 5px 0;">$<%= String.format("%.2f", amount) %></h3>
        <p>To: <strong><%= receiverName %></strong><br>
        Phone: <%= toPhone %></p>
    </div>

    <form action="<%=request.getContextPath()%>/customer/CustomerServlet" method="post">
        <input type="hidden" name="action" value="transfer">
        <input type="hidden" name="toPhone" value="<%= toPhone %>">
        <input type="hidden" name="amount" value="<%= amount %>">
        <input type="password" name="password" placeholder="Enter your Account Password" required>
        <button type="submit">Confirm & Send Now</button>
    </form>

    <form action="transfer.jsp" method="get">
        <button type="submit" class="cancel">Go Back</button>
    </form>

<% } else { %>
    
    <form action="transfer.jsp" method="get">
        <label>Recipient Phone:</label>
        <input type="text" name="toPhone" placeholder="09xxxxxxxxx" value="<%= (toPhone != null) ? toPhone : "" %>" required>
        
        <label>Amount to Send:</label>
        <input type="number" name="amount" placeholder="0.00" step="0.01" min="0.01" value="<%= (amount > 0) ? amount : "" %>" required>
        
        <input type="hidden" name="step" value="confirm">
        <button type="submit">Continue to Confirmation</button>
    </form>
<% } %>

</div>
</body>
</html>