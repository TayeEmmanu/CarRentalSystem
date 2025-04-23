<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Rentals - Car Rental System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
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

        .rental-info {
            margin-bottom: 15px;
        }

        .rental-info p {
            margin: 5px 0;
        }

        .rental-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
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

        .success-message {
            padding: 10px 15px;
            border-radius: 4px;
            margin-bottom: 20px;
            background-color: #e8f5e9;
            color: #2e7d32;
            border: 1px solid #a5d6a7;
        }

        .error-message {
            padding: 10px 15px;
            border-radius: 4px;
            margin-bottom: 20px;
            background-color: #ffebee;
            color: #c62828;
            border: 1px solid #ef9a9a;
        }
    </style>
</head>
<body>
<jsp:include page="../common/header.jsp" />
<div class="container" style="max-width: 1200px; margin: 0 auto; padding: 20px;">
    <h1>My Rentals</h1>

    <c:if test="${not empty sessionScope.message}">
        <div class="success-message">
            <p>${sessionScope.message}</p>
        </div>
        <c:remove var="message" scope="session" />
    </c:if>

    <c:if test="${not empty sessionScope.error}">
        <div class="error-message">
            <p>${sessionScope.error}</p>
        </div>
        <c:remove var="error" scope="session" />
    </c:if>

    <div class="actions" style="margin-bottom: 20px;">
        <a href="${pageContext.request.contextPath}/cars" class="btn">Rent a Car</a>
    </div>

    <c:choose>
        <c:when test="${empty rentals}">
            <div class="empty-state">
                <p>You don't have any rentals yet.</p>
                <a href="${pageContext.request.contextPath}/rent-car" class="btn">Rent a Car Now</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="rental-filters">
                <button class="filter-btn active" data-filter="all">All</button>
                <button class="filter-btn" data-filter="active">Active</button>
                <button class="filter-btn" data-filter="completed">Completed</button>
                <button class="filter-btn" data-filter="cancelled">Cancelled</button>
            </div>

            <div class="rental-cards">
                <c:forEach var="rental" items="${rentals}">
                    <div class="rental-card" data-status="${rental.status.toLowerCase()}">
                        <div class="rental-header">
                            <h3>${rental.carName}</h3>
                            <span class="status-indicator ${rental.status.toLowerCase() == 'active' ? 'available' : (rental.status.toLowerCase() == 'completed' ? 'completed' : 'unavailable')}">
                                    ${rental.status}
                            </span>
                        </div>
                        <div class="rental-info">
                            <p><strong>Rental ID:</strong> #${rental.id}</p>
                            <p><strong>Start Date:</strong> ${rental.startDate}</p>
                            <p><strong>End Date:</strong> ${rental.endDate}</p>
                            <p><strong>Total Cost:</strong> $${rental.totalCost}</p>
                        </div>
                        <div class="rental-actions">
                            <a href="${pageContext.request.contextPath}/my-rentals/view/${rental.id}" class="btn btn-secondary">View Details</a>
                            <c:if test="${rental.status.toLowerCase() == 'active'}">
                                <form action="${pageContext.request.contextPath}/my-rentals/cancel/${rental.id}" method="post" style="display: inline;">
                                    <button type="submit" class="btn btn-danger" onclick="return confirm('Are you sure you want to cancel this rental?')">Cancel Rental</button>
                                </form>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>
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

                // Get filter value
                const filter = this.getAttribute('data-filter');

                // Filter rental cards
                rentalCards.forEach(card => {
                    if (filter === 'all' || card.getAttribute('data-status') === filter) {
                        card.style.display = 'block';
                    } else {
                        card.style.display = 'none';
                    }
                });
            });
        });
    });
</script>
</body>
</html>
