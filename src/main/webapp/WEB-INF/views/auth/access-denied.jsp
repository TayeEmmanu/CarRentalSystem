<%--
  Created by IntelliJ IDEA.
  User: oldst
  Date: 2025-04-14
  Time: 9:39 p.m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <title>Access Denied - Car Rental System</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="container">
  <div class="error-container">
    <h1>Access Denied</h1>
    <p>You do not have permission to access this resource.</p>
    <p>Please contact an administrator if you believe this is an error.</p>
    <a href="${pageContext.request.contextPath}/" class="btn">Go to Home</a>
  </div>
</div>
</body>
</html>
