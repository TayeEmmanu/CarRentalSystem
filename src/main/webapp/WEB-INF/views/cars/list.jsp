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
  <title>Cars - Car Rental System</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main class="container">
  <h1>Cars Management</h1>

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
      <input type="text" id="carSearch" placeholder="Search cars...">
      <button class="btn" onclick="searchCars()">Search</button>
    </div>
    <a href="${pageContext.request.contextPath}/cars/add" class="btn">
      <span>Add New Car</span>
    </a>
  </div>

  <table class="data-table" id="carsTable">
    <thead>
    <tr>
      <th>ID</th>
      <th>Make</th>
      <th>Model</th>
      <th>Year</th>
      <th>License Plate</th>
      <th>Daily Rate</th>
      <th>Available</th>
      <th>Actions</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="car" items="${cars}">
      <tr>
        <td>${car.id}</td>
        <td>${car.make}</td>
        <td>${car.model}</td>
        <td>${car.year}</td>
        <td>${car.licensePlate}</td>
        <td>$${car.dailyRate}</td>
        <td>
                            <span class="status-indicator ${car.available ? 'available' : 'unavailable'}">
                                ${car.available ? 'Yes' : 'No'}
                            </span>
        </td>
        <td class="action-buttons">
          <a href="${pageContext.request.contextPath}/cars/edit/${car.id}" class="btn btn-edit" title="Edit Car">
            Edit
          </a>
          <button onclick="confirmDelete(${car.id}, '${car.make} ${car.model}')" class="btn btn-delete" title="Delete Car">
            Delete
          </button>
        </td>
      </tr>
    </c:forEach>
    </tbody>
  </table>

  <c:if test="${empty cars}">
    <div class="empty-state">
      <p>No cars found. Add a new car to get started.</p>
      <a href="${pageContext.request.contextPath}/cars/add" class="btn">Add New Car</a>
    </div>
  </c:if>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<script src="${pageContext.request.contextPath}/js/script.js"></script>
<script>
  // Search cars on enter key input instead of btn click
  var searchInput = document.getElementById("carSearch")
  searchInput.addEventListener("keyup", function (evt){
    if(evt.key === "Enter"){
      evt.preventDefault();
      searchCars();
    }
  })


  function confirmDelete(id, carName) {
    if (confirm('Are you sure you want to delete the car: ' + carName + '?')) {
      const form = document.createElement('form');
      form.method = 'POST';
      form.action = '${pageContext.request.contextPath}/cars/delete/' + id;
      document.body.appendChild(form);
      form.submit();
    }
  }

  function searchCars() {
    const input = document.getElementById('carSearch');
    const filter = input.value.toUpperCase();
    const table = document.getElementById('carsTable');
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

      rows[i].style.display = found ? '' : 'none';
    }
  }
</script>
</body>
</html>
