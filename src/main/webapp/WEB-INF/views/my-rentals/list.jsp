<%--
  Created by IntelliJ IDEA.
  User: oldst
  Date: 2025-04-14
  Time: 10:09 p.m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>My Rentals - Car Rental System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="../common/header.jsp" />

<main>
    <div class="container">
        <h1>My Rentals</h1>

        <c:if test="${not empty sessionScope.success}">
            <div class="success-message">
                <p>${sessionScope.success}</p>
            </div>
            <c:remove var="success" scope="session" />
        </c:if>

        <c:if test="${not empty sessionScope.error || not empty error}">
            <div class="error-message">
                <p>${not empty sessionScope.error ? sessionScope.error : error}</p>
            </div>
            <c:if test="${not empty sessionScope.error}">
                <c:remove var="error" scope="session" />
            </c:if>
        </c:if>

        <c:choose>
            <c:when test="${empty rentals}">
                <div class="empty-state">
                    <p>You don't have any rentals yet.</p>
                    <a href="${pageContext.request.contextPath}/cars" class="btn btn-primary">Browse Available Cars</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="rental-list">
                    <div class="rental-filters">
                        <button class="filter-btn active" data-filter="all">All Rentals</button>
                        <button class="filter-btn" data-filter="active">Active</button>
                        <button class="filter-btn" data-filter="completed">Completed</button>
                        <button class="filter-btn" data-filter="cancelled">Cancelled</button>
                    </div>

                    <div class="rental-cards">
                        <c:forEach var="rental" items="${rentals}">
                            <div class="rental-card" data-status="${rental.status.toLowerCase()}">
                                <div class="rental-header">
                                    <h3>Rental #${rental.id}</h3>
                                    <span class="status-indicator ${rental.status.toLowerCase() == 'active' ? 'available' : (rental.status.toLowerCase() == 'completed' ? 'completed' : 'unavailable')}">
                                            ${rental.status}
                                    </span>
                                </div>

                                <div class="rental-details">
                                    <div class="car-info">
                                        <h4>${rental.car.make} ${rental.car.model} (${rental.car.year})</h4>
                                        <p>License Plate: ${rental.car.licensePlate}</p>
                                    </div>

                                    <div class="rental-dates">
                                        <p><strong>Start Date:</strong> ${rental.startDate}</p>
                                        <p><strong>End Date:</strong> ${rental.endDate}</p>
                                    </div>

                                    <div class="rental-cost">
                                        <p><strong>Total Cost:</strong> $${rental.totalCost}</p>
                                    </div>
                                </div>

                                <div class="rental-actions">
                                    <a href="${pageContext.request.contextPath}/my-rentals/view/${rental.id}" class="btn">View Details</a>

                                    <c:if test="${rental.status == 'ACTIVE'}">
                                        <form method="post" action="${pageContext.request.contextPath}/my-rentals/cancel/${rental.id}" style="display: inline;">
                                            <button type="submit" class="btn btn-danger" onclick="return confirm('Are you sure you want to cancel this rental?')">Cancel Rental</button>
                                        </form>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const filterButtons = document.querySelectorAll('.filter-btn');
        const rentalCards = document.querySelectorAll('.rental-card');

        filterButtons.forEach(button => {
            button.addEventListener('click', function() {
                // Remove active class from all buttons
                filterButtons.forEach(btn => btn.classList.remove('active'));

                // Add active class to clicked button
                this.classList.add('active');

                const filter = this.getAttribute('data-filter');

                // Show/hide rental cards based on filter
                rentalCards.forEach(card => {
                    if (filter === 'all') {
                        card.style.display = 'block';
                    } else {
                        const status = card.getAttribute('data-status');
                        card.style.display = status === filter ? 'block' : 'none';
                    }
                });
            });
        });
    });
</script>

<style>
    .rental-list {
        margin-top: 20px;
    }

    .rental-filters {
        display: flex;
        gap: 10px;
        margin-bottom: 20px;
        flex-wrap: wrap;
    }

    .filter-btn {
        background-color: #f5f5f5;
        border: 1px solid #ddd;
        border-radius: 4px;
        padding: 8px 15px;
        cursor: pointer;
        font-weight: 500;
        transition: all 0.3s ease;
    }

    .filter-btn:hover {
        background-color: #e0e0e0;
    }

    .filter-btn.active {
        background-color: #3498db;
        color: white;
        border-color: #3498db;
    }

    .rental-cards {
        display: flex;
        flex-direction: column;
        gap: 20px;
    }

    .rental-card {
        background-color: #fff;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        padding: 20px;
        transition: transform 0.3s ease;
    }

    .rental-card:hover {
        transform: translateY(-5px);
    }

    .rental-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 15px;
        padding-bottom: 10px;
        border-bottom: 1px solid #eee;
    }

    .rental-header h3 {
        margin: 0;
    }

    .rental-details {
        display: grid;
        grid-template-columns: 1fr 1fr 1fr;
        gap: 15px;
        margin-bottom: 20px;
    }

    @media (max-width: 768px) {
        .rental-details {
            grid-template-columns: 1fr;
        }
    }

    .rental-actions {
        display: flex;
        justify-content: flex-end;
        gap: 10px;
    }

    .empty-state {
        text-align: center;
        padding: 50px 20px;
        background-color: #f9f9f9;
        border-radius: 8px;
        margin-top: 20px;
    }

    .empty-state p {
        margin-bottom: 20px;
        color: #666;
        font-size: 18px;
    }
</style>
</body>
</html>

