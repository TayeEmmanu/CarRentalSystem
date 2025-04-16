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
    <title>Error - Car Rental System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="container">
    <div class="error-container">
        <h1>An Error Occurred</h1>
        <p>We're sorry, but something went wrong. Please try again later.</p>
        <a href="${pageContext.request.contextPath}/" class="btn">Go to Home</a>
    </div>
</div>
</body>
</html>

