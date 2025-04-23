<%--
  Created by IntelliJ IDEA.
  User: oldst
  Date: 2025-04-18
  Time: 11:07 a.m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Rent a Car - Car Rental System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="../common/header.jsp" />

<main>
    <div class="container">
        <h1>Rent a Car</h1>

        <c:if test="${not empty error}">
            <div class="error-message">
                <p>${error}</p>
            </div>
        </c:if>

        <div class="rental-form-container">
            <div class="car-details-panel">
                <h2>${car.make} ${car.model} (${car.year})</h2>
                <div class="car-image-placeholder">
                    <span>${car.make} ${car.model}</span>
                </div>
                <div class="car-specs">
                    <p><strong>License Plate:</strong> ${car.licensePlate}</p>
                    <p><strong>Daily Rate:</strong> $${car.dailyRate}</p>
                </div>
            </div>

            <div class="rental-form">
                <h2>Rental Details</h2>
                <form action="${pageContext.request.contextPath}/rent-car/${car.id}" method="post">
                    <div class="form-group">
                        <label for="startDate">Start Date:</label>
                        <input type="date" id="startDate" name="startDate" min="${java.time.LocalDate.now()}" required>
                    </div>

                    <div class="form-group">
                        <label for="endDate">End Date:</label>
                        <input type="date" id="endDate" name="endDate" min="${java.time.LocalDate.now()}" required>
                    </div>

                    <div class="form-group">
                        <label>Daily Rate:</label>
                        <span class="form-value">$${car.dailyRate}</span>
                    </div>

                    <div class="form-group">
                        <label>Estimated Total:</label>
                        <span id="estimatedTotal" class="form-value">$0.00</span>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/rent-car" class="btn btn-secondary">Cancel</a>
                        <button type="submit" class="btn btn-primary">Confirm Rental</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const startDateInput = document.getElementById('startDate');
        const endDateInput = document.getElementById('endDate');
        const estimatedTotalSpan = document.getElementById('estimatedTotal');
        const dailyRate = ${car.dailyRate};

        function updateEstimatedTotal() {
            const startDate = new Date(startDateInput.value);
            const endDate = new Date(endDateInput.value);

            if (startDate && endDate && startDate <= endDate) {
                // Calculate days (including end date)
                const diffTime = Math.abs(endDate - startDate);
                const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)) + 1;

                // Calculate total
                const total = dailyRate * diffDays;
                estimatedTotalSpan.textContent = '$' + total.toFixed(2);
            } else {
                estimatedTotalSpan.textContent = '$0.00';
            }
        }

        startDateInput.addEventListener('change', updateEstimatedTotal);
        endDateInput.addEventListener('change', updateEstimatedTotal);

        // Set default dates
        const today = new Date();
        const tomorrow = new Date();
        tomorrow.setDate(today.getDate() + 1);

        startDateInput.valueAsDate = today;
        endDateInput.valueAsDate = tomorrow;

        // Initial calculation
        updateEstimatedTotal();
    });
</script>

<style>
    .rental-form-container {
        display: flex;
        flex-wrap: wrap;
        gap: 30px;
        margin-top: 30px;
    }

    .car-details-panel {
        flex: 1;
        min-width: 300px;
        background-color: #f9f9f9;
        border-radius: 8px;
        padding: 20px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    }

    .car-image-placeholder {
        background-color: #e0e0e0;
        height: 200px;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 20px 0;
        border-radius: 8px;
    }

    .car-image-placeholder span {
        font-size: 1.5rem;
        color: #666;
    }

    .rental-form {
        flex: 1;
        min-width: 300px;
        background-color: #fff;
        border-radius: 8px;
        padding: 20px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    }

    .form-value {
        font-weight: bold;
        font-size: 1.1rem;
    }

    #estimatedTotal {
        color: #2e7d32;
    }
</style>
</body>
</html>

