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
  <title>Edit Rental - Car Rental System</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main class="container">
  <h1>Edit Rental</h1>

  <c:if test="${not empty error}">
    <div class="error-message">
      <p>${error}</p>
    </div>
  </c:if>

  <form action="${pageContext.request.contextPath}/rentals/edit/${rental.id}" method="post" class="form">
    <div class="form-group">
      <label for="carId">Car:</label>
      <select id="carId" name="carId" required>
        <option value="">Select a car</option>
        <c:forEach var="car" items="${cars}">
          <option value="${car.id}" ${car.id == rental.carId ? 'selected' : ''}>
              ${car.year} ${car.make} ${car.model} - ${car.licensePlate} ($${car.dailyRate}/day)
          </option>
        </c:forEach>
      </select>
    </div>

    <div class="form-group">
      <label for="customerId">Customer:</label>
      <select id="customerId" name="customerId" required>
        <option value="">Select a customer</option>
        <c:forEach var="customer" items="${customers}">
          <option value="${customer.id}" ${customer.id == rental.customerId ? 'selected' : ''}>
              ${customer.firstName} ${customer.lastName} - ${customer.email}
          </option>
        </c:forEach>
      </select>
    </div>

    <div class="form-group">
      <label for="startDate">Start Date:</label>
      <input type="date" id="startDate" name="startDate" value="${rental.startDate}" required>
    </div>

    <div class="form-group">
      <label for="endDate">End Date:</label>
      <input type="date" id="endDate" name="endDate" value="${rental.endDate}" required>
    </div>

    <div class="form-group">
      <label for="status">Status:</label>
      <select id="status" name="status" required>
        <option value="ACTIVE" ${rental.status == 'ACTIVE' ? 'selected' : ''}>Active</option>
        <option value="COMPLETED" ${rental.status == 'COMPLETED' ? 'selected' : ''}>Completed</option>
        <option value="CANCELLED" ${rental.status == 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
      </select>
    </div>

    <div class="form-group">
      <label for="totalCost">Total Cost ($):</label>
      <input type="number" id="totalCost" name="totalCost" value="${rental.totalCost}" step="0.01" min="0" readonly>
      <p class="help-text">Total cost is calculated automatically based on the car's daily rate and rental duration.</p>
    </div>

    <div class="form-actions">
      <button type="submit" class="btn">Save</button>
      <a href="${pageContext.request.contextPath}/rentals" class="btn btn-secondary">Cancel</a>
    </div>
  </form>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<script src="${pageContext.request.contextPath}/js/script.js"></script>
<script>
  document.addEventListener('DOMContentLoaded', function() {
    // Get references to form elements
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
        // Extract daily rate from the option text (assumes format includes "$X.XX/day")
        const optionText = selectedOption.text;
        const dailyRateMatch = optionText.match(/\$(\d+\.\d+)\/day/);

        if (dailyRateMatch && dailyRateMatch[1]) {
          const dailyRate = parseFloat(dailyRateMatch[1]);
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
    startDateInput.addEventListener('change', calculateTotalCost);
    endDateInput.addEventListener('change', calculateTotalCost);

    // Set minimum date for end date based on start date
    startDateInput.addEventListener('change', function() {
      endDateInput.min = this.value;
      if (endDateInput.value && endDateInput.value < this.value) {
        endDateInput.value = this.value;
      }
      calculateTotalCost();
    });

    // Initial calculation
    calculateTotalCost();
  });
</script>
</body>
</html>