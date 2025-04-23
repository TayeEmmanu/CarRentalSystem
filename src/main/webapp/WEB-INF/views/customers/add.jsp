<%--&lt;%&ndash;--%>
<%--  Created by IntelliJ IDEA.--%>
<%--  User: oldst--%>
<%--  Date: 2025-04-10--%>
<%--  Time: 10:57 p.m.--%>
<%--  To change this template use File | Settings | File Templates.--%>
<%--&ndash;%&gt;--%>
<%--<%@ page contentType="text/html;charset=UTF-8" language="java" %>--%>
<%--<%@ taglib prefix="c" uri="jakarta.tags.core" %>--%>
<%--<!DOCTYPE html>--%>
<%--<html>--%>
<%--<head>--%>
<%--  <title>Add Customer - Car Rental System</title>--%>
<%--  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">--%>
<%--</head>--%>
<%--<body>--%>
<%--<jsp:include page="/WEB-INF/views/common/header.jsp" />--%>

<%--<main class="container">--%>
<%--  <h1>Add New Customer</h1>--%>

<%--  <c:if test="${not empty error}">--%>
<%--    <div class="error-message">--%>
<%--      <p>${error}</p>--%>
<%--    </div>--%>
<%--  </c:if>--%>

<%--  <form action="${pageContext.request.contextPath}/customers/add" method="post" class="form needs-validation">--%>
<%--    <div class="form-group">--%>
<%--      <label for="firstName">First Name:</label>--%>
<%--      <input type="text" id="firstName" name="firstName" required>--%>
<%--      <div class="invalid-feedback">Please enter the first name.</div>--%>
<%--    </div>--%>

<%--    <div class="form-group">--%>
<%--      <label for="lastName">Last Name:</label>--%>
<%--      <input type="text" id="lastName" name="lastName" required>--%>
<%--      <div class="invalid-feedback">Please enter the last name.</div>--%>
<%--    </div>--%>

<%--    <div class="form-group">--%>
<%--      <label for="email">Email:</label>--%>
<%--      <input type="email" id="email" name="email" required>--%>
<%--      <div class="invalid-feedback">Please enter a valid email address.</div>--%>
<%--    </div>--%>

<%--    <div class="form-group">--%>
<%--      <label for="phone">Phone:</label>--%>
<%--      <input type="tel" id="phone" name="phone" placeholder="555-123-4567" required>--%>
<%--      <div class="invalid-feedback">Please enter a valid phone number.</div>--%>
<%--    </div>--%>

<%--    <div class="form-group">--%>
<%--      <label for="driverLicense">Driver License:</label>--%>
<%--      <input type="text" id="driverLicense" name="driverLicense" required>--%>
<%--      <div class="invalid-feedback">Please enter the driver license number.</div>--%>
<%--    </div>--%>

<%--    <div class="form-actions">--%>
<%--      <button type="submit" class="btn">Save Customer</button>--%>
<%--      <a href="${pageContext.request.contextPath}/customers" class="btn btn-secondary">Cancel</a>--%>
<%--    </div>--%>
<%--  </form>--%>
<%--</main>--%>

<%--<jsp:include page="/WEB-INF/views/common/footer.jsp" />--%>

<%--<script src="${pageContext.request.contextPath}/js/script.js"></script>--%>
<%--<script>--%>
<%--  document.addEventListener('DOMContentLoaded', function() {--%>
<%--    const form = document.querySelector('.needs-validation');--%>

<%--    form.addEventListener('submit', function(event) {--%>
<%--      if (!form.checkValidity()) {--%>
<%--        event.preventDefault();--%>
<%--        event.stopPropagation();--%>
<%--      }--%>

<%--      // Additional validation for phone format--%>
<%--      const phoneInput = document.getElementById('phone');--%>
<%--      const phoneRegex = /^\d{3}-\d{3}-\d{4}$/;--%>

<%--      if (!phoneRegex.test(phoneInput.value)) {--%>
<%--        phoneInput.setCustomValidity('Please enter phone in format: 555-123-4567');--%>
<%--        event.preventDefault();--%>
<%--      } else {--%>
<%--        phoneInput.setCustomValidity('');--%>
<%--      }--%>

<%--      form.classList.add('was-validated');--%>
<%--    });--%>

<%--    // Clear custom validity when input changes--%>
<%--    document.getElementById('phone').addEventListener('input', function() {--%>
<%--      this.setCustomValidity('');--%>
<%--    });--%>
<%--  });--%>
<%--</script>--%>
<%--</body>--%>
<%--</html>--%>
