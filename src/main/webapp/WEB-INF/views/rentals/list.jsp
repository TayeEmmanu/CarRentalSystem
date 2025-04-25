<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
  <title>Rental Management - Car Rental System</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="../common/header.jsp" />

<main>
  <div class="container">
    <h1>Rental Management</h1>

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

    <div class="action-bar">
      <a href="${pageContext.request.contextPath}/rentals/add" class="btn btn-primary">Add New Rental</a>
    </div>

    <c:choose>
      <c:when test="${empty rentals}">
        <div class="empty-state">
          <p>No rentals found in the system.</p>
        </div>
      </c:when>
      <c:otherwise>
        <div class="rental-filters">
          <button class="filter-btn active" data-filter="all">All</button>
          <button class="filter-btn" data-filter="active">Active</button>
          <button class="filter-btn" data-filter="completed">Completed</button>
          <button class="filter-btn" data-filter="cancelled">Cancelled</button>
        </div>

        <table class="data-table">
          <thead>
          <tr>
            <th>ID</th>
            <th>Customer</th>
            <th>Car</th>
            <th>Start Date</th>
            <th>End Date</th>
            <th>Total Cost</th>
            <th>Status</th>
            <th>Actions</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach var="rental" items="${rentals}">
            <tr data-status="${rental.status.toLowerCase()}">
              <td>${rental.id}</td>
              <td>${rental.username}</td>
              <td>${rental.carName}</td>
              <td>${rental.startDate}</td>
              <td>${rental.endDate}</td>
              <td>$${rental.totalCost}</td>
              <td>
                                        <span class="status-indicator ${rental.status.toLowerCase() == 'active' ? 'available' : (rental.status.toLowerCase() == 'completed' ? 'completed' : 'unavailable')}">
                                            ${rental.status}
                                        </span>
              </td>
              <td class="actions">
                <a href="${pageContext.request.contextPath}/rentals/view/${rental.id}" class="btn btn-small">View</a>
                <a href="${pageContext.request.contextPath}/rentals/edit/${rental.id}" class="btn btn-small btn-secondary">Edit</a>

                <c:if test="${rental.status.toLowerCase() == 'active'}">
                  <form action="${pageContext.request.contextPath}/rentals/complete/${rental.id}" method="post" style="display: inline;">
                    <button type="submit" class="btn btn-small btn-primary">Complete</button>
                  </form>

                  <form action="${pageContext.request.contextPath}/rentals/cancel/${rental.id}" method="post" style="display: inline;">
                    <button type="submit" class="btn btn-small btn-warning" onclick="return confirm('Are you sure you want to cancel this rental?')">Cancel</button>
                  </form>
                </c:if>

                <form action="${pageContext.request.contextPath}/rentals/delete/${rental.id}" method="post" style="display: inline;">
                  <button type="submit" class="btn btn-small btn-danger" onclick="return confirm('Are you sure you want to delete this rental?')">Delete</button>
                </form>
              </td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </c:otherwise>
    </c:choose>
  </div>
</main>

<jsp:include page="../common/footer.jsp" />

<script>
  document.addEventListener('DOMContentLoaded', function() {
    const filterButtons = document.querySelectorAll('.filter-btn');
    const rentalRows = document.querySelectorAll('tr[data-status]');

    filterButtons.forEach(button => {
      button.addEventListener('click', function() {
        // Remove active class from all buttons
        filterButtons.forEach(btn => btn.classList.remove('active'));

        // Add active class to clicked button
        this.classList.add('active');

        // Get filter value
        const filter = this.getAttribute('data-filter');

        // Filter rental rows
        rentalRows.forEach(row => {
          if (filter === 'all' || row.getAttribute('data-status') === filter) {
            row.style.display = '';
          } else {
            row.style.display = 'none';
          }
        });
      });
    });
  });
</script>
</body>
</html>
