<%--
  Created by IntelliJ IDEA.
  User: oldst
  Date: 2025-04-16
  Time: 2:40 p.m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Car Details - Car Rental System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="../common/header.jsp" />

<main>
    <div class="container">
        <h1>Car Details</h1>

        <div class="car-details-container">
            <div class="car-image">
                <div class="car-image-placeholder">
                    <span>${car.make} ${car.model}</span>
                </div>
            </div>

            <div class="car-info">
                <h2>${car.make} ${car.model} (${car.year})</h2>

                <div class="car-specs">
                    <div class="spec-item">
                        <span class="spec-label">License Plate:</span>
                        <span class="spec-value">${car.licensePlate}</span>
                    </div>

                    <div class="spec-item">
                        <span class="spec-label">Daily Rate:</span>
                        <span class="spec-value">$${car.dailyRate}</span>
                    </div>

                    <div class="spec-item">
                        <span class="spec-label">Status:</span>
                        <span class="spec-value">${car.available ? 'Available' : 'Not Available'}</span>
                    </div>
                </div>

                <div class="car-description">
                    <h3>Description</h3>
                    <p>This ${car.year} ${car.make} ${car.model} is ${car.available ? 'available for rent' : 'currently not available'}. It's in excellent condition and ready for your journey.</p>
                </div>

                <div class="car-actions">
                    <a href="${pageContext.request.contextPath}/cars" class="btn btn-secondary">Back to Cars</a>
                    <a href="${pageContext.request.contextPath}/cars/edit/${car.id}" class="btn btn-primary">Edit Car</a>
                    <c:if test="${sessionScope.user.role == 'ADMIN' ||  sessionScope.user.role == 'STAFF'}">
                        <a href="${pageContext.request.contextPath}/cars/delete/${car.id}"
                           class="btn btn-danger"
                           onclick="return confirm('Are you sure you want to delete this car?')">Delete Car</a>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
</body>
</html>
