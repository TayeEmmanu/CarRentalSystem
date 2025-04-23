<%--
  Created by IntelliJ IDEA.
  User: oldst
  Date: 2025-04-18
  Time: 11:06 a.m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Available Cars - Car Rental System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="../common/header.jsp" />

<main>
    <div class="container">
        <h1>Available Cars for Rent</h1>

        <c:if test="${not empty sessionScope.error}">
            <div class="error-message">
                <p>${sessionScope.error}</p>
            </div>
            <c:remove var="error" scope="session" />
        </c:if>

        <c:choose>
            <c:when test="${empty cars}">
                <div class="empty-state">
                    <p>No cars are currently available for rent.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="car-grid">
                    <c:forEach var="car" items="${cars}">
                        <div class="car-card">
                            <div class="car-header">
                                <h3>${car.make} ${car.model}</h3>
                                <span class="car-year">${car.year}</span>
                            </div>
                            <div class="car-details">
                                <p><strong>License Plate:</strong> ${car.licensePlate}</p>
                                <p><strong>Daily Rate:</strong> $${car.dailyRate}</p>
                            </div>
                            <div class="car-actions">
                                <a href="${pageContext.request.contextPath}/rent-car/${car.id}" class="btn btn-primary">Rent This Car</a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
</body>
</html>

