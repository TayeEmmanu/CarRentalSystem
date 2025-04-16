<%--
  Created by IntelliJ IDEA.
  User: oldst
  Date: 2025-04-14
  Time: 9:30 p.m.
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
                <!-- Placeholder for car image -->
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
                </div>

                <div class="car-description">
                    <h3>Description</h3>
                    <p>This ${car.year} ${car.make} ${car.model} is available for rent. It's in excellent condition and ready for your journey.</p>
                </div>

                <div class="car-actions">
                    <a href="${pageContext.request.contextPath}/cars" class="btn btn-secondary">Back to Cars</a>
                    <a href="${pageContext.request.contextPath}/rent-car/${car.id}" class="btn btn-primary">Rent This Car</a>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
</body>
</html>

