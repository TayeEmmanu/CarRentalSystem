<%--
  Created by IntelliJ IDEA.
  User: oldst
  Date: 2025-04-18
  Time: 11:10 a.m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Rentals</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="../../common/header.jsp" />

<div class="container">
    <h1>Manage Rentals</h1>

    <c:if test="${not empty sessionScope.message}">
        <div class="alert alert-success">
                ${sessionScope.message}
            <c:remove var="message" scope="session" />
        </div>
    </c:if>

    <table class="table">
        <thead>
        <tr>
            <th>ID</th>
            <th>User</th>
            <th>Car</th>
            <th>Start Date</th>
            <th>End Date</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="rental" items="${rentals}">
            <tr>
                <td>${rental.id}</td>
                <td>${rental.username}</td>
                <td>${rental.bookTitle}</td>
                <td><fmt:formatDate value="${rental.startDate}" pattern="yyyy-MM-dd" /></td>
                <td><fmt:formatDate value="${rental.endDate}" pattern="yyyy-MM-dd" /></td>
                <td>${rental.returned ? 'Returned' : 'Active'}</td>
                <td>
                    <a href="${pageContext.request.contextPath}/admin/rentals/view/${rental.id}" class="btn btn-sm btn-primary">View</a>
                    <form action="${pageContext.request.contextPath}/admin/rentals/delete/${rental.id}" method="post" style="display: inline;">
                        <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure you want to delete this rental?')">Delete</button>
                    </form>
                </td>
            </tr>
        </c:forEach>

        <c:if test="${empty rentals}">
            <tr>
                <td colspan="7" class="text-center">No rentals found</td>
            </tr>
        </c:if>
        </tbody>
    </table>
</div>

<jsp:include page="../../common/footer.jsp" />
</body>
</html>

