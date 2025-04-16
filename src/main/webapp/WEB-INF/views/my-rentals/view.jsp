<%--
  Created by IntelliJ IDEA.
  User: oldst
  Date: 2025-04-14
  Time: 10:10 p.m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Rental Details - Car Rental System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="../common/header.jsp" />

<main>
    <div class="container">
        <h1>Rental Details</h1>

        <div class="rental-details-container">
            <div class="rental-header-section">
                <h2>Rental #${rental.id}</h2>
                <span class="status-indicator ${rental.status.toLowerCase() == 'active' ? 'available' : (rental.status.toLowerCase() == 'completed' ? 'completed' : 'unavailable')}">
                    ${rental.status}
                </span>
            </div>

            <div class="rental-info-grid">
                <div class="rental-info-card">
                    <h3>Car Information</h3>
                    <div class="info-item">
                        <span class="info-label">Make & Model:</span>
                        <span class="info-value">${rental.car.make} ${rental.car.model}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Year:</span>
                        <span class="info-value">${rental.car.year}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">License Plate:</span>
                        <span class="info-value">${rental.car.licensePlate}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Daily Rate:</span>
                        <span class="info-value">$${rental.car.dailyRate}</span>
                    </div>
                </div>

                <div class="rental-info-card">
                    <h3>Rental Period</h3>
                    <div class="info-item">
                        <span class="info-label">Start Date:</span>
                        <span class="info-value">${rental.startDate}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">End Date:</span>
                        <span class="info-value">${rental.endDate}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Duration:</span>
                        <span class="info-value">${rental.duration} days</span>
                    </div>
                </div>

                <div class="rental-info-card">
                    <h3>Payment Information</h3>
                    <div class="info-item">
                        <span class="info-label">Total Cost:</span>
                        <span class="info-value">$${rental.totalCost}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Payment Status:</span>
                        <span class="info-value">Paid</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Payment Method:</span>
                        <span class="info-value">Credit Card</span>
                    </div>
                </div>
            </div>

            <div class="rental-actions-section">
                <a href="${pageContext.request.contextPath}/my-rentals" class="btn btn-secondary">Back to My Rentals</a>

                <c:if test="${rental.status == 'ACTIVE'}">
                    <form method="post" action="${pageContext.request.contextPath}/my-rentals/cancel/${rental.id}" style="display: inline;">
                        <button type="submit" class="btn btn-danger" onclick="return confirm('Are you sure you want to cancel this rental?')">Cancel Rental</button>
                    </form>
                </c:if>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />

<style>
    .rental-details-container {
        background-color: #fff;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        padding: 30px;
        margin-top: 20px;
    }

    .rental-header-section {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 30px;
        padding-bottom: 15px;
        border-bottom: 1px solid #eee;
    }

    .rental-header-section h2 {
        margin: 0;
        color: #333;
    }

    .rental-info-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
        gap: 20px;
        margin-bottom: 30px;
    }

    .rental-info-card {
        background-color: #f9f9f9;
        border-radius: 8px;
        padding: 20px;
    }

    .rental-info-card h3 {
        margin-top: 0;
        margin-bottom: 15px;
        color: #3498db;
        font-size: 18px;
    }

    .info-item {
        margin-bottom: 10px;
        display: flex;
        justify-content: space-between;
    }

    .info-label {
        font-weight: bold;
        color: #555;
    }

    .info-value {
        color: #333;
    }

    .rental-actions-section {
        display: flex;
        justify-content: space-between;
        margin-top: 20px;
        padding-top: 20px;
        border-top: 1px solid #eee;
    }
</style>
</body>
</html>

