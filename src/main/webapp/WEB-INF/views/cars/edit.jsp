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
  <title>Edit Car - Car Rental System</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main class="container">
  <h1>Edit Car</h1>

  <c:if test="${not empty error}">
    <div class="error-message">
      <p>${error}</p>
    </div>
  </c:if>

  <form action="${pageContext.request.contextPath}/cars/edit/${car.id}" method="post" class="form">
    <div class="form-group">
      <label for="make">Make:</label>
      <input type="text" id="make" name="make" value="${car.make}" required>
    </div>

    <div class="form-group">
      <label for="model">Model:</label>
      <input type="text" id="model" name="model" value="${car.model}" required>
    </div>

    <div class="form-group">
      <label for="year">Year:</label>
      <input type="number" id="year" name="year" value="${car.year}" min="1900" max="2100" required>
    </div>

    <div class="form-group">
      <label for="licensePlate">License Plate:</label>
      <input type="text" id="licensePlate" name="licensePlate" value="${car.licensePlate}" required>
    </div>

    <div class="form-group">
      <label for="dailyRate">Daily Rate ($):</label>
      <input type="number" id="dailyRate" name="dailyRate" value="${car.dailyRate}" min="0" step="0.01" required>
    </div>

    <div class="form-group checkbox-group">
      <input type="checkbox" id="available" name="available" ${car.available ? 'checked' : ''}>
      <label for="available">Available</label>
    </div>

    <div class="form-actions">
      <button type="submit" class="btn">Save</button>
      <a href="${pageContext.request.contextPath}/cars" class="btn btn-secondary">Cancel</a>
    </div>
  </form>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>
