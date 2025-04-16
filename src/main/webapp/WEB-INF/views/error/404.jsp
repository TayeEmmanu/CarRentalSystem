<%--
  Created by IntelliJ IDEA.
  User: oldst
  Date: 2025-04-15
  Time: 8:33 p.m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <title>Page Not Found - Car Rental System</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="container">
  <div class="error-container">
    <h1>404 - Page Not Found</h1>
    <p>The page you are looking for does not exist or has been moved.</p>
    <a href="${pageContext.request.contextPath}/" class="btn">Go to Home</a>
  </div>
</div>
</body>
</html>

