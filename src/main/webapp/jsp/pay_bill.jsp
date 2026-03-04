<%@ page import="com.bank.user.User" %>
<%@ page import="com.bank.bill.Bill" %>
<%@ page import="com.bank.customer.CustomerDAO" %>
<%@ page import="com.bank.customer.CustomerDAOImpl" %>
<%@ page session="true" %>

<%
    User user = (User) session.getAttribute("user");
    if(user == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }

    String invoiceId = request.getParameter("invoiceId");
    String step = (invoiceId != null) ? "confirm" : "search";
    
    Bill foundBill = null;
    if ("confirm".equals(step)) {
        CustomerDAO dao = new CustomerDAOImpl();
        // We fetch all bills and find the specific one by ID
        for (Bill b : dao.getUnpaidBills(user.getPhoneNumber())) {
            if (b.getInvoiceId().equals(invoiceId)) {
                foundBill = b;
                break;
            }
        }
        
        if (foundBill == null) {
            request.setAttribute("error", "Invoice ID not found or already paid.");
            step = "search";
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Pay Utility Bill</title>
    <style>
        body { font-family: Arial; background: #f4f4f4; padding: 20px; }
        .card { max-width: 400px; margin: auto; background: white; padding: 25px; border-radius: 12px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        h2 { text-align: center; color: #333; }
        input { width: 100%; padding: 12px; margin: 10px 0; border: 1px solid #ccc; border-radius: 6px; box-sizing: border-box; }
        button { width: 100%; padding: 12px; background: #28a745; color: white; border: none; border-radius: 6px; cursor: pointer; font-weight: bold; }
        .details { background: #f9f9f9; padding: 15px; border-radius: 6px; margin: 10px 0; border-left: 5px solid #28a745; }
        .error { color: red; text-align: center; }
    </style>
</head>
<body>

<div class="card">
    <h2>Bill Payment</h2>
    
    <% if (request.getAttribute("error") != null) { %>
        <p class="error"><%= request.getAttribute("error") %></p>
    <% } %>

    <% if ("search".equals(step)) { %>
        <form method="get" action="pay_bill.jsp">
            <label>Enter Invoice ID:</label>
            <input type="text" name="invoiceId" placeholder="e.g. WATER-101" required>
            <button type="submit">Check Bill Details</button>
        </form>

    <% } else if ("confirm".equals(step) && foundBill != null) { %>
        <div class="details">
            <p><strong>Service:</strong> <%= foundBill.getServiceName() %></p>
            <p><strong>Description:</strong> <%= foundBill.getDescription() %></p>
            <p><strong>Amount Due:</strong> $<%= String.format("%.2f", foundBill.getAmount()) %></p>
        </div>

        <form action="<%=request.getContextPath()%>/customer/CustomerServlet" method="post">
            <input type="hidden" name="action" value="payBill">
            <input type="hidden" name="invoiceId" value="<%= foundBill.getInvoiceId() %>">
            
            <label>Enter Account PIN to Pay:</label>
            <input type="password" name="password" placeholder="Enter your password" required>
            
            <button type="submit" style="background: #007bff;">Confirm & Pay Now</button>
        </form>
        <p style="text-align: center;"><a href="pay_bill.jsp">Cancel</a></p>
    <% } %>
</div>

</body>
</html>