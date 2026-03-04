<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Banking App - Login</title>
    <style>
        body { font-family: Arial; background: #f0f2f5; }
        .container { width: 350px; margin: 100px auto; background: #fff; padding: 25px; border-radius: 10px; box-shadow: 0 4px 10px rgba(0,0,0,0.2);}
        h2 { text-align: center; color: #333; }
        input[type=text], input[type=password] { width: 100%; padding: 12px; margin: 8px 0 16px 0; border: 1px solid #ccc; border-radius: 6px; }
        button { width: 100%; padding: 12px; background: #007bff; border: none; color: #fff; font-weight: bold; border-radius: 6px; cursor: pointer; }
        button:hover { background: #0056b3; }
        .error { color: red; text-align: center; margin-bottom: 10px; }
        a { text-decoration: none; color: #007bff; display: block; text-align: center; margin-top: 10px; }
    </style>
</head>
<body>
<div class="container">
    <h2>Login</h2>

    <% if(request.getAttribute("error") != null){ %>
        <div class="error"><%= request.getAttribute("error") %></div>
    <% } %>

	<form action="<%=request.getContextPath()%>/auth/LoginServlet" method="post">
	    <input type="text" name="identifier" placeholder="Username or Phone" required>
	    <input type="password" name="password" placeholder="PIN / Password" required>
	    <button type="submit">Login</button>
	</form>

    <a href="./register.jsp">Don't have an account? Register</a>
</div>
</body>
</html>