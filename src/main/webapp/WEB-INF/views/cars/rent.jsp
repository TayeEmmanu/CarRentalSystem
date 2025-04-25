<%--
  Created by IntelliJ IDEA.
  User: oldst
  Date: 2025-04-16
  Time: 3:01 p.m.
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Rent Car - Car Rental System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="../common/header.jsp" />

<main>
    <div class="container">
        <h1>Rent ${car.make} ${car.model}</h1>

        <c:if test="${not empty error}">
            <div class="error-message">
                <p>${error}</p>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/rent-car/${car.id}" method="post" class="form">
            <div class="form-group">
                <label for="startDate">Start Date:</label>
                <input type="date" id="startDate" name="startDate" required min="${today}">
            </div>

            <div class="form-group">
                <label for="endDate">End Date:</label>
                <input type="date" id="endDate" name="endDate" required min="${today}">
            </div>

            <div class="form-group">
                <p>Daily Rate: $${car.dailyRate}</p>
            </div>

            <div class="form-actions">
                <a href="${pageContext.request.contextPath}/cars" class="btn btn-secondary">Cancel</a>
                <button type="submit" class="btn btn-primary">Confirm Rental</button>
            </div>
        </form>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
</body>
</html>

