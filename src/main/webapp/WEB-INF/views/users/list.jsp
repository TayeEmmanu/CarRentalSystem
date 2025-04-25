<%--
  Created by IntelliJ IDEA.
  User: oldst
  Date: 2025-04-14
  Time: 7:38 p.m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Users - Car Rental System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="../common/header.jsp" />

<main>
    <div class="container">
        <h1>Users</h1>

        <c:if test="${not empty sessionScope.message}">
            <div class="success-message">
                <p>${sessionScope.message}</p>
            </div>
            <c:remove var="message" scope="session" />
        </c:if>

        <c:if test="${not empty sessionScope.error}">
            <div class="error-message">
                <p>${sessionScope.error}</p>
            </div>
            <c:remove var="error" scope="session" />
        </c:if>

        <div class="action-bar">
            <c:if test="${sessionScope.currentUser.admin}">
                <a href="${pageContext.request.contextPath}/users/add" class="btn">Add User</a>
            </c:if>
        </div>

        <table class="data-table">
            <thead>
            <tr>
                <th>ID</th>
                <th>Username</th>
                <th>Email</th>
                <th>Role</th>
                <th>Status</th>
                <th>Created</th>
                <th>Last Login</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="user" items="${users}">
                <tr>
                    <td>${user.id}</td>
                    <td>${user.username}</td>
                    <td>${user.email}</td>
                    <td>${user.role}</td>
                    <td>
                        <c:choose>
                            <c:when test="${user.active}">
                                <span class="status-indicator available">Active</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-indicator unavailable">Inactive</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>${user.createdAt}</td>
                    <td>${user.lastLogin}</td>
                    <td class="actions">
                        <c:if test="${sessionScope.currentUser.admin}">
                            <a href="${pageContext.request.contextPath}/users/edit/${user.id}" class="btn btn-small">Edit</a>

                            <c:if test="${sessionScope.currentUser.id != user.id}">
                                <form method="post" action="${pageContext.request.contextPath}/users/toggle-active/${user.id}" style="display: inline;">
                                    <button type="submit" class="btn btn-small btn-warning">
                                        <c:choose>
                                            <c:when test="${user.active}">Deactivate</c:when>
                                            <c:otherwise>Activate</c:otherwise>
                                        </c:choose>
                                    </button>
                                </form>

                                <!-- Only show delete button for admin -->
                                <c:if test="${sessionScope.currentUser.admin}">
                                    <form method="post" action="${pageContext.request.contextPath}/users/delete/${user.id}" style="display: inline;">
                                        <button type="submit" class="btn btn-small btn-danger" onclick="return confirm('Are you sure you want to delete this user?')">Delete</button>
                                    </form>
                                </c:if>
                            </c:if>
                        </c:if>
                        <c:if test="${!sessionScope.currentUser.admin}">
                            <span class="text-muted">View Only</span>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
</body>
</html>


