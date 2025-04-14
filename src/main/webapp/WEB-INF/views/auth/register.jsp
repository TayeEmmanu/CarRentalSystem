<%--
  Created by IntelliJ IDEA.
  User: oldst
  Date: 2025-04-14
  Time: 5:45 p.m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register - Car Rental System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="container">
    <div class="auth-form">
        <h1>Register</h1>

        <c:if test="${not empty error}">
            <div class="error-message">
                <p>${error}</p>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/register" method="post" class="form">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" value="${username}" required>
                <c:if test="${not empty usernameError}">
                    <span class="error">${usernameError}</span>
                </c:if>
            </div>

            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" value="${email}" required>
                <c:if test="${not empty emailError}">
                    <span class="error">${emailError}</span>
                </c:if>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required>
                <c:if test="${not empty passwordError}">
                    <span class="error">${passwordError}</span>
                </c:if>
            </div>

            <div class="form-group">
                <label for="confirmPassword">Confirm Password</label>
                <input type="password" id="confirmPassword" name="confirmPassword" required>
                <c:if test="${not empty confirmPasswordError}">
                    <span class="error">${confirmPasswordError}</span>
                </c:if>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary">Register</button>
            </div>
        </form>

        <div class="auth-links">
            <p>Already have an account? <a href="${pageContext.request.contextPath}/login">Login</a></p>
        </div>
    </div>
</div>
</body>
</html>
