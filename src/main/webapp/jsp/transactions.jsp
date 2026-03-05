<%@ page import="com.bank.user.User" %>
<%@ page import="com.bank.transaction.Transaction" %>
<%@ page import="com.bank.transaction.TransactionDAO" %>
<%@ page import="com.bank.transaction.TransactionDAOImpl" %>
<%@ page session="true" %>

<%
    // 1. Check if user is logged in
    User user = (User) session.getAttribute("user");
    if(user == null){
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }

    // 2. Define current user identity for filtering
    String currentUsername = user.getUsername();

    // 3. Fetch data from DAO
    TransactionDAO dao = new TransactionDAOImpl();
    java.util.List<Transaction> transactions = dao.getTransactionsByPhone(user.getPhoneNumber());
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Transaction History</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f4f4f4; margin:0; padding:20px; }
        .container { max-width: 1000px; margin:auto; background:white; padding:25px; border-radius:12px; box-shadow:0 4px 15px rgba(0,0,0,0.1);}
        
        h2 { color: #333; margin-top: 0; }

        /* Filter Tabs */
        .filter-container { margin-bottom: 20px; display: flex; gap: 10px; }
        .filter-btn { padding: 8px 20px; border: none; border-radius: 20px; cursor: pointer; background: #eee; font-weight: bold; transition: 0.3s; color: #555; }
        .filter-btn.active { background: #007bff; color: white; }
        .filter-btn:hover:not(.active) { background: #e0e0e0; }

        /* Table Design */
        table { width: 100%; border-collapse: collapse; margin-top:10px; }
        th, td { padding:14px; border-bottom: 1px solid #eee; text-align:center; }
        th { background:#f8f9fa; color:#666; font-size: 14px; text-transform: uppercase; letter-spacing: 0.5px; }
        
        /* Direction Tags */
        .badge { padding: 5px 12px; border-radius: 15px; font-size: 11px; font-weight: bold; display: inline-block; }
        .bg-receive { background: #e6fcf5; color: #0ca678; border: 1px solid #c3fae8; }
        .bg-transfer { background: #fff5f5; color: #fa5252; border: 1px solid #ffe3e3; }
        
        tr:hover { background-color: #fafafa; }
    </style>
</head>
<body>

<div class="container">
    <h2>Transaction History</h2>

    <div class="filter-container">
        <button class="filter-btn active" onclick="filterTable('all', this)">All Activity</button>
        <button class="filter-btn" onclick="filterTable('receive', this)">Received Money</button>
        <button class="filter-btn" onclick="filterTable('transfer', this)">Transfers Sent</button>
    </div>

    <% if(transactions == null || transactions.isEmpty()){ %>
        <div style="text-align:center; padding: 40px; color: #888;">
            <p>No transactions found for your account yet.</p>
        </div>
    <% } else { %>
        <table id="transactionTable">
            <thead>
                <tr>
                    <th>Direction</th>
                    <th>From</th>
                    <th>To</th>
                    <th>Type</th>
                    <th>Amount</th>
                    <th>Reference</th>
                    <th>Date</th>
                </tr>
            </thead>
            <tbody>
                <%
                    for(Transaction t : transactions){
                        // LOGIC: If the current user is NOT the sender, they are the receiver
                        boolean isReceiver = t.getFromUser() != null && !t.getFromUser().equals(currentUsername);
                        String directionType = isReceiver ? "receive" : "transfer";
                %>
                <tr class="transaction-row" data-type="<%= directionType %>">
                    <td>
                        <span class="badge <%= isReceiver ? "bg-receive" : "bg-transfer" %>">
                            <%= isReceiver ? "RECEIVED" : "SENT" %>
                        </span>
                    </td>
                    <td><%= t.getFromUser() %></td>
                    <td>
                        <%= (t.getToUser() != null && !t.getToUser().trim().isEmpty()) 
                            ? t.getToUser() 
                            : "SERVICE" %>
                    </td>
                    <td style="font-size: 0.9em; color: #666;"><%= t.getTransactionType() %></td>
                    <td style="font-weight: bold; color: <%= isReceiver ? "#0ca678" : "#fa5252" %>">
                        <%= isReceiver ? "+" : "-" %>$<%= String.format("%.2f", t.getAmount()) %>
                    </td>
                    <td style="color: #888;"><%= t.getReferenceId() != null ? t.getReferenceId() : "-" %></td>
                    <td style="font-size: 0.85em; color: #555;"><%= t.getCreatedAt() %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
    <% } %>
</div>

<script>
    function filterTable(type, btn) {
        // 1. Toggle Active Button UI
        document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');

        // 2. Hide/Show Rows
        const rows = document.querySelectorAll('.transaction-row');
        rows.forEach(row => {
            if (type === 'all') {
                row.style.display = '';
            } else {
                row.style.display = row.getAttribute('data-type') === type ? '' : 'none';
            }
        });
    }
</script>

</body>
</html>