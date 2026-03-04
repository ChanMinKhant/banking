<%@ page import="com.bank.user.User" %>
<%@ page import="com.bank.service.*" %>
<%@ page import="com.bank.bill.Bill" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null || !user.getRole().equals("SERVICE")){
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }

    ServiceDAO dao = new ServiceDAOImpl();
    List<Bill> bills = dao.getIssuedBills(user.getPhoneNumber());
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Issued Bills</title>
    <style>
        body { font-family: Arial; background: #f4f6f9; margin: 0; padding: 20px; }
        .container { max-width: 900px; margin: auto; background: white; padding: 25px; border-radius: 10px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        h2 { color: #333; border-bottom: 2px solid #28a745; padding-bottom: 10px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; border-bottom: 1px solid #eee; text-align: left; }
        th { background-color: #f8f9fa; color: #555; }
        .status { padding: 5px 10px; border-radius: 4px; font-size: 12px; font-weight: bold; }
        .paid { background: #d4edda; color: #155724; }
        .unpaid { background: #f8d7da; color: #721c24; }
        .back-btn { display: inline-block; margin-bottom: 15px; text-decoration: none; color: #007bff; }
    </style>
</head>
<body>
    <div class="container">
        <a href="service_dashboard.jsp" class="back-btn">← Back to Dashboard</a>
        <h2>Issued Bills History</h2>
        
        <table>
            <thead>
                <tr>
                    <th>Invoice ID</th>
                    <th>Description</th> <th>Amount</th>
                    <th>Due Date</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <% if(bills.isEmpty()) { %>
                    <tr><td colspan="5" style="text-align:center;">No bills issued yet.</td></tr>
                <% } else { 
                    for(Bill b : bills) { %>
                    <tr>
                        <td><%= b.getInvoiceId() %></td>
                        <td><%= b.getDescription() %></td> 
                        <td>$<%= String.format("%.2f", b.getAmount()) %></td>
                        <td><%= b.getDueDate() %></td>
                        <td>
                            <span class="status <%= b.getStatus().toLowerCase() %>">
                                <%= b.getStatus() %>
                            </span>
                        </td>
                    </tr>
                <%  } 
                } %>
            </tbody>
        </table>
    </div>
</body>
</html>