<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Car Rental System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main class="container">
    <div class="welcome-section">
        <h1>Welcome to Car Rental System</h1>
        <p>Your one-stop solution for car rentals</p>

        <div class="dashboard">
            <div class="dashboard-item">
                <h2>Cars</h2>
                <p>Manage your fleet of cars</p>
                <div class="dashboard-actions">
                    <a href="${pageContext.request.contextPath}/cars" class="btn">View Cars</a>
                    <a href="${pageContext.request.contextPath}/cars/add" class="btn btn-secondary">Add Car</a>
                </div>
            </div>

            <div class="dashboard-item">
                <h2>Customers</h2>
                <p>Manage your customer database</p>
                <div class="dashboard-actions">
                    <a href="${pageContext.request.contextPath}/customers" class="btn">View Customers</a>
                    <a href="${pageContext.request.contextPath}/customers/add" class="btn btn-secondary">Add Customer</a>
                </div>
            </div>

            <div class="dashboard-item">
                <h2>Rentals</h2>
                <p>Manage active and past rentals</p>
                <div class="dashboard-actions">
                    <a href="${pageContext.request.contextPath}/rentals" class="btn">View Rentals</a>
                    <a href="${pageContext.request.contextPath}/rentals/add" class="btn btn-secondary">Add Rental</a>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>