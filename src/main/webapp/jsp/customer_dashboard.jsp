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

    // Fetch latest balance from DB
    CustomerDAO dao = new CustomerDAOImpl();
    double latestBalance = dao.getBalance(user.getPhoneNumber());
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Dashboard</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f6f9;
            margin: 0;
            padding: 0;
        }

        header {
            background-color: #007bff;
            color: white;
            padding: 25px;
            text-align: center;
        }

        .container {
            max-width: 1000px;
            margin: 30px auto;
            padding: 25px;
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 6px 15px rgba(0,0,0,0.1);
        }

        .balance {
            font-size: 22px;
            margin-bottom: 25px;
            text-align: center;
            color: #333;
        }

        .actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .actions a {
            display: block;
            padding: 25px;
            text-align: center;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 10px;
            font-weight: bold;
            transition: all 0.3s ease;
        }

        .actions a:hover {
            background-color: #0056b3;
            transform: translateY(-3px);
        }

        .logout {
            margin-top: 35px;
            text-align: center;
        }

        .logout a {
            color: #dc3545;
            font-weight: bold;
            text-decoration: none;
        }

        .logout a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<header>
    <h1>Welcome, <%= user.getUsername() %>!</h1>
</header>

<div class="container">

    <p class="balance">Current Balance: $<span id="currentBalance"><%= String.format("%.2f", latestBalance) %></span></p>

    <div class="actions">
        <a href="<%=request.getContextPath()%>/jsp/deposit.jsp">Deposit Money</a>
        <a href="<%=request.getContextPath()%>/jsp/withdraw.jsp">Withdraw Money</a>
        <a href="<%=request.getContextPath()%>/jsp/transfer.jsp">Transfer Money</a>
        <a href="<%=request.getContextPath()%>/jsp/pay_bill.jsp">Pay Bill</a>
        <a href="<%=request.getContextPath()%>/jsp/unpaid_bills.jsp">View Unpaid Bills</a>
        <a href="<%=request.getContextPath()%>/jsp/transactions.jsp">Transaction History</a>
    </div>

    <div class="logout">
        <p><a href="<%=request.getContextPath()%>/auth/LoginServlet">Logout</a></p>
    </div>

</div>

<script>
    function fetchBalance() {
        fetch('<%=request.getContextPath()%>/customer/BalanceServlet')
            .then(response => response.json())
            .then(data => {
                if(data.balance !== undefined){
                    document.getElementById("currentBalance").innerText = data.balance.toFixed(2);
                }
            })
            .catch(err => console.error("Error fetching balance:", err));
    }

    // Refresh balance every 5 seconds
    setInterval(fetchBalance, 5000);

    // Fetch immediately on page load
    fetchBalance();
</script>

</body>
</html>