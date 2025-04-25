  <%--
  Created by IntelliJ IDEA.
  User: oldst
  Date: 2025-04-10
  Time: 11:03 p.m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <title>Add Rental - Car Rental System</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main class="container">
  <h1>Add New Rental</h1>

  <c:if test="${not empty error}">
    <div class="error-message">
      <p>${error}</p>
    </div>
  </c:if>

  <form action="${pageContext.request.contextPath}/rentals/add" method="post" class="form needs-validation">
    <div class="form-group">
      <label for="carId">Car:</label>
      <select id="carId" name="carId" required>
        <option value="">Select a car</option>
        <c:forEach var="car" items="${cars}">
          <option value="${car.id}" data-rate="${car.dailyRate}">
              ${car.year} ${car.make} ${car.model} - ${car.licensePlate} ($${car.dailyRate}/day)
          </option>
        </c:forEach>
      </select>
      <div class="invalid-feedback">Please select a car.</div>
    </div>

    <div class="form-group">
      <label for="customerId">Customer:</label>
      <select id="customerId" name="customerId" required>
        <option value="">Select a customer</option>
        <c:forEach var="customer" items="${customers}">
          <option value="${customer.id}">
              ${customer.firstName} ${customer.lastName} - ${customer.email}
          </option>
        </c:forEach>
      </select>
      <div class="invalid-feedback">Please select a customer.</div>
    </div>

    <div class="form-group">
      <label for="startDate">Start Date:</label>
      <input type="date" id="startDate" name="startDate" value="${today}" min="${today}" class="start-date" required>
      <div class="invalid-feedback">Please select a start date.</div>
    </div>

    <div class="form-group">
      <label for="endDate">End Date:</label>
      <input type="date" id="endDate" name="endDate" min="${today}" class="end-date" required>
      <div class="invalid-feedback">Please select an end date.</div>
    </div>

    <div class="form-group">
      <label for="totalCost">Total Cost ($):</label>
      <input type="number" id="totalCost" name="totalCost" step="0.01" min="0" readonly>
      <p class="help-text">Total cost is calculated automatically based on the car's daily rate and rental duration.</p>
    </div>

    <div class="form-actions">
      <button type="submit" class="btn">Create Rental</button>
      <a href="${pageContext.request.contextPath}/rentals" class="btn btn-secondary">Cancel</a>
    </div>
  </form>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<script src="${pageContext.request.contextPath}/js/script.js"></script>
<script>
  document.addEventListener('DOMContentLoaded', function() {
    const form = document.querySelector('.needs-validation');
    const carSelect = document.getElementById('carId');
    const startDateInput = document.getElementById('startDate');
    const endDateInput = document.getElementById('endDate');
    const totalCostInput = document.getElementById('totalCost');

    // Function to calculate total cost
    function calculateTotalCost() {
      const carId = carSelect.value;
      const startDate = new Date(startDateInput.value);
      const endDate = new Date(endDateInput.value);

      if (carId && !isNaN(startDate) && !isNaN(endDate) && endDate >= startDate) {
        // Get the selected car option
        const selectedOption = carSelect.options[carSelect.selectedIndex];
        // Get daily rate from data attribute
        const dailyRate = parseFloat(selectedOption.getAttribute('data-rate'));

        if (!isNaN(dailyRate)) {
          // Calculate number of days (including end date)
          const days = Math.ceil((endDate - startDate) / (1000 * 60 * 60 * 24)) + 1;
          // Calculate total cost
          const totalCost = dailyRate * days;
          // Update total cost field
          totalCostInput.value = totalCost.toFixed(2);
        }
      }
    }

    // Add event listeners
    carSelect.addEventListener('change', calculateTotalCost);
    startDateInput.addEventListener('change', function() {
      endDateInput.min = this.value;
      if (endDateInput.value && endDateInput.value < this.value) {
        endDateInput.value = this.value;
      }
      calculateTotalCost();
    });
    endDateInput.addEventListener('change', calculateTotalCost);

    // Form validation
    form.addEventListener('submit', function(event) {
      if (!form.checkValidity()) {
        event.preventDefault();
        event.stopPropagation();
      }

      form.classList.add('was-validated');
    });

    // Set minimum date for end date based on start date
    startDateInput.addEventListener('change', function() {
      endDateInput.min = this.value;
    });

    // Initial calculation
    calculateTotalCost();
  });
</script>
</body>
</html>
