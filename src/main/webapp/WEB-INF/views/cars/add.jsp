<%--
  Created by IntelliJ IDEA.
  User: oldst
  Date: 2025-04-10
  Time: 10:56 p.m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <title>Add Car - Car Rental System</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main class="container">
  <h1>Add New Car</h1>

  <c:if test="${not empty error}">
    <div class="error-message">
      <p>${error}</p>
    </div>
  </c:if>

  <form action="${pageContext.request.contextPath}/cars/add" method="post" class="form needs-validation">
    <div class="form-group">
      <label for="make">Make:</label>
      <input type="text" id="make" name="make" required>
      <div class="invalid-feedback">Please enter the car make.</div>
    </div>

    <div class="form-group">
      <label for="model">Model:</label>
      <input type="text" id="model" name="model" required>
      <div class="invalid-feedback">Please enter the car model.</div>
    </div>

    <div class="form-group">
      <label for="year">Year:</label>
      <input type="number" id="year" name="year" min="1900" max="2100" required>
      <div class="invalid-feedback">Please enter a valid year (1900-2100).</div>
    </div>

    <div class="form-group">
      <label for="licensePlate">License Plate:</label>
      <input type="text" id="licensePlate" name="licensePlate" required>
      <div class="invalid-feedback">Please enter the license plate number.</div>
    </div>

    <div class="form-group">
      <label for="dailyRate">Daily Rate ($):</label>
      <input type="number" id="dailyRate" name="dailyRate" min="0" step="0.01" required>
      <div class="invalid-feedback">Please enter a valid daily rate.</div>
    </div>

    <div class="form-group checkbox-group">
      <input type="checkbox" id="available" name="available" checked>
      <label for="available">Available for Rent</label>
    </div>

    <div class="form-actions">
      <button type="submit" class="btn">Save Car</button>
      <a href="${pageContext.request.contextPath}/cars" class="btn btn-secondary">Cancel</a>
    </div>
  </form>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<script src="${pageContext.request.contextPath}/js/script.js"></script>
<script>
  document.addEventListener('DOMContentLoaded', function() {
    const form = document.querySelector('.needs-validation');

    form.addEventListener('submit', function(event) {
      if (!form.checkValidity()) {
        event.preventDefault();
        event.stopPropagation();
      }

      form.classList.add('was-validated');
    });
  });
</script>
</body>
</html>
