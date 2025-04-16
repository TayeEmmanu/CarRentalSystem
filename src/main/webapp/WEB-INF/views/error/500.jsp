<%--
  Created by IntelliJ IDEA.
  User: oldst
  Date: 2025-04-15
  Time: 8:34 p.m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <title>Server Error - Car Rental System</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="container">
  <div class="error-container">
    <h1>500 - Server Error</h1>
    <p>Something went wrong on our end. Please try again later.</p>
    <a href="${pageContext.request.contextPath}/" class="btn">Go to Home</a>
  </div>
</div>
</body>
</html>

