<%--
  Created by IntelliJ IDEA.
  User: oldst
  Date: 2025-04-10
  Time: 11:02 p.m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <title>Rentals - Car Rental System</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main class="container">
  <h1>Rentals Management</h1>

  <c:if test="${not empty error}">
    <div class="error-message">
      <p>${error}</p>
    </div>
  </c:if>

  <c:if test="${not empty success}">
    <div class="success-message">
      <p>${success}</p>
    </div>
  </c:if>

  <div class="action-bar">
    <div class="search-box">
      <input type="text" id="rentalSearch" placeholder="Search rentals...">
      <button class="btn" onclick="searchRentals()">Search</button>
    </div>
    <div class="filter-options">
      <select id="statusFilter" onchange="filterRentals()">
        <option value="ALL">All Statuses</option>
        <option value="ACTIVE">Active</option>
        <option value="COMPLETED">Completed</option>
        <option value="CANCELLED">Cancelled</option>
      </select>
    </div>
    <a href="${pageContext.request.contextPath}/rentals/add" class="btn">
      <span>Add New Rental</span>
    </a>
  </div>

  <table class="data-table" id="rentalsTable">
    <thead>
    <tr>
      <th>ID</th>
      <th>Car</th>
      <th>Customer</th>
      <th>Start Date</th>
      <th>End Date</th>
      <th>Total Cost</th>
      <th>Status</th>
      <th>Actions</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="rental" items="${rentals}">
      <tr data-status="${rental.status}">
        <td>${rental.id}</td>
        <td>${rental.car.year} ${rental.car.make} ${rental.car.model}</td>
        <td>${rental.customer.firstName} ${rental.customer.lastName}</td>
        <td>${rental.startDate}</td>
        <td>${rental.endDate}</td>
        <td>$${rental.totalCost}</td>
        <td>
                            <span class="status-indicator status-${rental.status.toLowerCase()}">
                                ${rental.status}
                            </span>
        </td>
        <td class="action-buttons">
          <a href="${pageContext.request.contextPath}/rentals/edit/${rental.id}" class="btn btn-edit" title="Edit Rental">
            Edit
          </a>
          <c:if test="${rental.status eq 'ACTIVE'}">
            <button onclick="completeRental(${rental.id})" class="btn btn-success" title="Complete Rental">
              Complete
            </button>
            <button onclick="cancelRental(${rental.id})" class="btn btn-warning" title="Cancel Rental">
              Cancel
            </button>
          </c:if>
          <button onclick="confirmDelete(${rental.id})" class="btn btn-delete" title="Delete Rental">
            Delete
          </button>
        </td>
      </tr>
    </c:forEach>
    </tbody>
  </table>

  <c:if test="${empty rentals}">
    <div class="empty-state">
      <p>No rentals found. Add a new rental to get started.</p>
      <a href="${pageContext.request.contextPath}/rentals/add" class="btn">Add New Rental</a>
    </div>
  </c:if>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<script src="${pageContext.request.contextPath}/js/script.js"></script>
<script>
  function confirmDelete(id) {
    if (confirm('Are you sure you want to delete this rental?')) {
      const form = document.createElement('form');
      form.method = 'POST';
      form.action = '${pageContext.request.contextPath}/rentals/delete/' + id;
      document.body.appendChild(form);
      form.submit();
    }
  }

  function completeRental(id) {
    if (confirm('Are you sure you want to mark this rental as completed?')) {
      const form = document.createElement('form');
      form.method = 'POST';
      form.action = '${pageContext.request.contextPath}/rentals/complete/' + id;
      document.body.appendChild(form);
      form.submit();
    }
  }

  function cancelRental(id) {
    if (confirm('Are you sure you want to cancel this rental?')) {
      const form = document.createElement('form');
      form.method = 'POST';
      form.action = '${pageContext.request.contextPath}/rentals/cancel/' + id;
      document.body.appendChild(form);
      form.submit();
    }
  }

  function searchRentals() {
    const input = document.getElementById('rentalSearch');
    const filter = input.value.toUpperCase();
    const table = document.getElementById('rentalsTable');
    const rows = table.getElementsByTagName('tr');

    for (let i = 1; i < rows.length; i++) {
      let found = false;
      const cells = rows[i].getElementsByTagName('td');

      for (let j = 0; j < cells.length - 1; j++) {
        const cell = cells[j];
        if (cell) {
          const textValue = cell.textContent || cell.innerText;
          if (textValue.toUpperCase().indexOf(filter) > -1) {
            found = true;
            break;
          }
        }
      }

      if (found) {
        // Also check status filter
        const statusFilter = document.getElementById('statusFilter').value;
        if (statusFilter !== 'ALL') {
          const status = rows[i].getAttribute('data-status');
          if (status !== statusFilter) {
            found = false;
          }
        }
      }

      rows[i].style.display = found ? '' : 'none';
    }
  }

  function filterRentals() {
    const statusFilter = document.getElementById('statusFilter').value;
    const table = document.getElementById('rentalsTable');
    const rows = table.getElementsByTagName('tr');

    for (let i = 1; i < rows.length; i++) {
      if (statusFilter === 'ALL') {
        rows[i].style.display = '';
      } else {
        const status = rows[i].getAttribute('data-status');
        rows[i].style.display = (status === statusFilter) ? '' : 'none';
      }
    }

    // Also apply search filter
    searchRentals();
  }
</script>
</body>
</html>
