<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Rental Details - Car Rental System</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        h1 {
            color: #333;
            margin-bottom: 20px;
        }

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

        .btn {
            display: inline-block;
            padding: 8px 16px;
            background-color: #3498db;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
            transition: background-color 0.3s;
        }

        .btn:hover {
            background-color: #2980b9;
        }

        .btn-secondary {
            background-color: #95a5a6;
        }

        .btn-secondary:hover {
            background-color: #7f8c8d;
        }

        .btn-danger {
            background-color: #e74c3c;
        }

        .btn-danger:hover {
            background-color: #c0392b;
        }

        .status-indicator {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 12px;
            font-size: 0.8rem;
            font-weight: bold;
        }

        .available {
            background-color: #e8f5e9;
            color: #2e7d32;
        }

        .unavailable {
            background-color: #ffebee;
            color: #c62828;
        }

        .completed {
            background-color: #e3f2fd;
            color: #1565c0;
        }
    </style>
</head>
<body>
<jsp:include page="../common/header.jsp" />
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
                    <span class="info-label">Car:</span>
                    <span class="info-value">${rental.carName}</span>
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
                    <span class="info-value">${rental.getDurationInDays()} days</span>
                </div>
            </div>

            <div class="rental-info-card">
                <h3>Payment Information</h3>
                <div class="info-item">
                    <span class="info-label">Total Cost:</span>
                    <span class="info-value">$${rental.totalCost}</span>
                </div>
            </div>
        </div>

        <div class="rental-actions-section">
            <a href="${pageContext.request.contextPath}/my-rentals" class="btn btn-secondary">Back to My Rentals</a>

            <c:if test="${rental.status.toLowerCase() == 'active'}">
                <form method="post" action="${pageContext.request.contextPath}/my-rentals/cancel/${rental.id}" style="display: inline;">
                    <button type="submit" class="btn btn-danger" onclick="return confirm('Are you sure you want to cancel this rental?')">Cancel Rental</button>
                </form>
            </c:if>
        </div>
    </div>
</div>
<jsp:include page="../common/footer.jsp" />
</body>
</html>
