<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Banking App - Register</title>
    <style>
        body { font-family: Arial; background: #f0f2f5; }
        .container { width: 400px; margin: 80px auto; background: #fff; padding: 30px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.2); }
        h2 { text-align: center; color: #333; }
        input[type=text], input[type=password] { width: 100%; padding: 12px; margin: 8px 0 16px 0; border: 1px solid #ccc; border-radius: 6px; }
        button { width: 100%; padding: 12px; background: #007bff; border: none; color: #fff; font-weight: bold; border-radius: 6px; cursor: pointer; }
        button:hover { background: #0056b3; }
        .msg { color: green; text-align: center; margin-bottom: 10px; }
        .error { color: red; text-align: center; margin-bottom: 10px; }
        a { text-decoration: none; color: #007bff; display: block; text-align: center; margin-top: 10px; }
    </style>
</head>
<body>
<div class="container">
    <h2>Customer Registration</h2>

    <% if(request.getAttribute("message") != null){ %>
        <div class="msg"><%= request.getAttribute("message") %></div>
    <% } %>

    <% if(request.getAttribute("error") != null){ %>
        <div class="error"><%= request.getAttribute("error") %></div>
    <% } %>

	<form action="<%=request.getContextPath()%>/auth/RegisterServlet" method="post">
	    <input type="text" name="username" placeholder="Username" required>
	    <input type="text" name="phone" placeholder="Phone Number" required>
	    <input type="password" name="password" placeholder="PIN / Password" required>
	    <button type="submit">Register</button>
	</form>

    <a href="./login.jsp">Already have an account? Login</a>
</div>
</body>
</html>