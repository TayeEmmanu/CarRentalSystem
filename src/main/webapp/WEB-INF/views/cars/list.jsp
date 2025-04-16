<%--
  Created by IntelliJ IDEA.
  User: oldst
  Date: 2025-04-10
  Time: 10:55 p.m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <title>${viewType == 'customer' ? 'Available Cars' : 'Car Inventory'} - Car Rental System</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="../common/header.jsp" />

<main>
  <div class="container">
    <h1>${viewType == 'customer' ? 'Available Cars' : 'Car Inventory'}</h1>

    <c:if test="${not empty sessionScope.success}">
      <div class="success-message">
        <p>${sessionScope.success}</p>
      </div>
      <c:remove var="success" scope="session" />
    </c:if>

    <c:if test="${not empty sessionScope.error}">
      <div class="error-message">
        <p>${sessionScope.error}</p>
      </div>
      <c:remove var="error" scope="session" />
    </c:if>

    <!-- Only show action buttons for staff -->
    <c:if test="${viewType == 'staff'}">
      <div class="action-bar">
        <a href="${pageContext.request.contextPath}/cars/add" class="btn btn-primary">Add New Car</a>
      </div>
    </c:if>

    <c:choose>
      <c:when test="${empty cars}">
        <div class="empty-state">
          <p>${viewType == 'customer' ? 'No cars are currently available for rent.' : 'No cars found in the inventory.'}</p>
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
                <p><strong>Daily Rate:</strong> ${car.dailyRate}</p>
                <c:if test="${viewType == 'staff'}">
                  <p>
                    <strong>Status:</strong>
                    <span class="status-indicator ${car.available ? 'available' : 'unavailable'}">
                        ${car.available ? 'Available' : 'Rented'}
                    </span>
                  </p>
                </c:if>
              </div>
              <div class="car-actions">
                <a href="${pageContext.request.contextPath}/cars/view/${car.id}" class="btn">View Details</a>

                <!-- Only show edit button for staff -->
                <c:if test="${viewType == 'staff'}">
                  <a href="${pageContext.request.contextPath}/cars/edit/${car.id}" class="btn btn-secondary">Edit</a>

                  <!-- Only show delete button for admin -->
                  <c:if test="${sessionScope.currentUser.admin}">
                    <form method="post" action="${pageContext.request.contextPath}/cars/delete/${car.id}" style="display: inline;">
                      <button type="submit" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this car?')">Delete</button>
                    </form>
                  </c:if>
                </c:if>

                <!-- Show rent button for customers if car is available -->
                <c:if test="${viewType == 'customer'}">
                  <a href="${pageContext.request.contextPath}/rent-car/${car.id}" class="btn btn-primary">Rent This Car</a>
                </c:if>
              </div>
            </div>
          </c:forEach>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</main>

<jsp:include page="../common/footer.jsp" />

<style>
  .car-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: 20px;
    margin-top: 20px;
  }

  .car-card {
    background-color: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    padding: 20px;
    transition: transform 0.3s ease;
  }

  .car-card:hover {
    transform: translateY(-5px);
  }

  .car-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 15px;
    padding-bottom: 10px;
    border-bottom: 1px solid #eee;
  }

  .car-header h3 {
    margin: 0;
  }

  .car-year {
    background-color: #f5f5f5;
    padding: 3px 8px;
    border-radius: 12px;
    font-size: 0.9rem;
    color: #555;
  }

  .car-details {
    margin-bottom: 20px;
  }

  .car-details p {
    margin: 8px 0;
  }

  .car-actions {
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
  }

  .empty-state {
    text-align: center;
    padding: 50px 20px;
    background-color: #f9f9f9;
    border-radius: 8px;
    margin-top: 20px;
  }
</style>
</body>
</html>

