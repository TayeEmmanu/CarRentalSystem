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
    <title>System Logs</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="../../common/header.jsp" />

<div class="container">
    <h1>System Logs</h1>

    <c:if test="${not empty sessionScope.message}">
        <div class="alert alert-success">
                ${sessionScope.message}
            <c:remove var="message" scope="session" />
        </div>
    </c:if>

    <c:if test="${not empty sessionScope.error}">
        <div class="alert alert-danger">
                ${sessionScope.error}
            <c:remove var="error" scope="session" />
        </div>
    </c:if>

    <div class="actions">
        <div class="filter-section">
            <form action="${pageContext.request.contextPath}/admin/system-logs" method="get">
                <label for="level">Filter by Level:</label>
                <select id="level" name="level" onchange="this.form.submit()">
                    <option value="">All Levels</option>
                    <option value="INFO" ${selectedLevel eq 'INFO' ? 'selected' : ''}>INFO</option>
                    <option value="WARNING" ${selectedLevel eq 'WARNING' ? 'selected' : ''}>WARNING</option>
                    <option value="ERROR" ${selectedLevel eq 'ERROR' ? 'selected' : ''}>ERROR</option>
                </select>
            </form>
        </div>

        <div class="button-section">
            <a href="${pageContext.request.contextPath}/admin/system-logs/download" class="btn btn-primary">Download Logs</a>

            <form action="${pageContext.request.contextPath}/admin/system-logs" method="post" style="display: inline;">
                <input type="hidden" name="action" value="delete-all">
                <button type="submit" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete all logs? This action cannot be undone.')">Delete All Logs</button>
            </form>
        </div>
    </div>

    <table class="table">
        <thead>
        <tr>
            <th>ID</th>
            <th>Timestamp</th>
            <th>Level</th>
            <th>Message</th>
            <th>User</th>
            <th>IP Address</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="log" items="${logs}">
            <tr class="${log.level eq 'ERROR' ? 'error-row' : log.level eq 'WARNING' ? 'warning-row' : ''}">
                <td>${log.id}</td>
                <td><fmt:formatDate value="${log.timestamp}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                <td>${log.level}</td>
                <td>${log.message}</td>
                <td>${log.username != null ? log.username : 'System'}</td>
                <td>${log.ipAddress}</td>
                <td>
                    <form action="${pageContext.request.contextPath}/admin/system-logs/delete/${log.id}" method="post">
                        <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure you want to delete this log?')">Delete</button>
                    </form>
                </td>
            </tr>
        </c:forEach>

        <c:if test="${empty logs}">
            <tr>
                <td colspan="7" class="text-center">No logs found</td>
            </tr>
        </c:if>
        </tbody>
    </table>
</div>

<jsp:include page="../../common/footer.jsp" />
</body>
</html>

