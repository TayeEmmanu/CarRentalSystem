<%--
  Created by IntelliJ IDEA.
  User: oldst
  Date: 2025-04-14
  Time: 7:40 p.m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit User - Car Rental System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="../common/header.jsp" />

<main>
    <div class="container">
        <h1>Edit User</h1>

        <c:if test="${not empty error}">
            <div class="error-message">
                <p>${error}</p>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/users/edit/${user.id}" method="post" class="form">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" value="${not empty username ? username : user.username}" required>
                <c:if test="${not empty usernameError}">
                    <span class="error">${usernameError}</span>
                </c:if>
            </div>

            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" value="${not empty email ? email : user.email}" required>
                <c:if test="${not empty emailError}">
                    <span class="error">${emailError}</span>
                </c:if>
            </div>

            <div class="form-group">
                <label for="role">Role</label>
                <select id="role" name="role" required>
                    <option value="">Select Role</option>
                    <option value="ADMIN" ${not empty role ? (role == 'ADMIN' ? 'selected' : '') : (user.role == 'ADMIN' ? 'selected' : '')}>Admin</option>
                    <option value="STAFF" ${not empty role ? (role == 'STAFF' ? 'selected' : '') : (user.role == 'STAFF' ? 'selected' : '')}>Staff</option>
                    <option value="CUSTOMER" ${not empty role ? (role == 'CUSTOMER' ? 'selected' : '') : (user.role == 'CUSTOMER' ? 'selected' : '')}>Customer</option>
                </select>
                <c:if test="${not empty roleError}">
                    <span class="error">${roleError}</span>
                </c:if>
            </div>

            <div class="form-group">
                <label for="password">Password (leave blank to keep current)</label>
                <input type="password" id="password" name="password">
                <c:if test="${not empty passwordError}">
                    <span class="error">${passwordError}</span>
                </c:if>
            </div>

            <div class="form-group">
                <label for="confirmPassword">Confirm Password</label>
                <input type="password" id="confirmPassword" name="confirmPassword">
                <c:if test="${not empty confirmPasswordError}">
                    <span class="error">${confirmPasswordError}</span>
                </c:if>
            </div>

            <div class="form-group checkbox-group">
                <input type="checkbox" id="active" name="active" ${user.active ? 'checked' : ''}>
                <label for="active">Active</label>
            </div>

            <div class="form-actions">
                <a href="${pageContext.request.contextPath}/users" class="btn btn-secondary">Cancel</a>
                <button type="submit" class="btn btn-primary">Save</button>
            </div>
        </form>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
</body>
</html>
