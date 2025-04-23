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
<%--  <title>Customers - Car Rental System</title>--%>
<%--  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">--%>
<%--</head>--%>
<%--<body>--%>
<%--<jsp:include page="/WEB-INF/views/common/header.jsp" />--%>

<%--<main class="container">--%>
<%--  <h1>Customers Management</h1>--%>

<%--  <c:if test="${not empty error}">--%>
<%--    <div class="error-message">--%>
<%--      <p>${error}</p>--%>
<%--    </div>--%>
<%--  </c:if>--%>

<%--  <c:if test="${not empty success}">--%>
<%--    <div class="success-message">--%>
<%--      <p>${success}</p>--%>
<%--    </div>--%>
<%--  </c:if>--%>

<%--  <div class="action-bar">--%>
<%--    <div class="search-box">--%>
<%--      <input type="text" id="customerSearch" placeholder="Search customers...">--%>
<%--      <button class="btn" onclick="searchCustomers()">Search</button>--%>
<%--    </div>--%>
<%--    <a href="${pageContext.request.contextPath}/customers/add" class="btn">--%>
<%--      <span>Add New Customer</span>--%>
<%--    </a>--%>
<%--  </div>--%>

<%--  <table class="data-table" id="customersTable">--%>
<%--    <thead>--%>
<%--    <tr>--%>
<%--      <th>ID</th>--%>
<%--      <th>Name</th>--%>
<%--      <th>Email</th>--%>
<%--      <th>Phone</th>--%>
<%--      <th>Driver License</th>--%>
<%--      <th>Actions</th>--%>
<%--    </tr>--%>
<%--    </thead>--%>
<%--    <tbody>--%>
<%--    <c:forEach var="customer" items="${customers}">--%>
<%--      <tr>--%>
<%--        <td>${customer.id}</td>--%>
<%--        <td>${customer.firstName} ${customer.lastName}</td>--%>
<%--        <td>${customer.email}</td>--%>
<%--        <td>${customer.phone}</td>--%>
<%--        <td>${customer.driverLicense}</td>--%>
<%--        <td class="action-buttons">--%>
<%--          <a href="${pageContext.request.contextPath}/customers/edit/${customer.id}" class="btn btn-edit" title="Edit Customer">--%>
<%--            Edit--%>
<%--          </a>--%>
<%--          <button onclick="confirmDelete(${customer.id}, '${customer.firstName} ${customer.lastName}')" class="btn btn-delete" title="Delete Customer">--%>
<%--            Delete--%>
<%--          </button>--%>
<%--        </td>--%>
<%--      </tr>--%>
<%--    </c:forEach>--%>
<%--    </tbody>--%>
<%--  </table>--%>

<%--  <c:if test="${empty customers}">--%>
<%--    <div class="empty-state">--%>
<%--      <p>No customers found. Add a new customer to get started.</p>--%>
<%--      <a href="${pageContext.request.contextPath}/customers/add" class="btn">Add New Customer</a>--%>
<%--    </div>--%>
<%--  </c:if>--%>
<%--</main>--%>

<%--<jsp:include page="/WEB-INF/views/common/footer.jsp" />--%>

<%--<script src="${pageContext.request.contextPath}/js/script.js"></script>--%>
<%--<script>--%>
<%--  var searchInput = document.getElementById("customerSearch");--%>
<%--  searchInput.addEventListener("keyup", function (evt){--%>
<%--    if(evt.key === "Enter"){--%>
<%--      evt.preventDefault();--%>
<%--      searchCustomers();--%>
<%--    }--%>
<%--  })--%>
<%--  function confirmDelete(id, customerName) {--%>
<%--    if (confirm('Are you sure you want to delete the customer: ' + customerName + '?')) {--%>
<%--      const form = document.createElement('form');--%>
<%--      form.method = 'POST';--%>
<%--      form.action = '${pageContext.request.contextPath}/customers/delete/' + id;--%>
<%--      document.body.appendChild(form);--%>
<%--      form.submit();--%>
<%--    }--%>
<%--  }--%>

<%--  function searchCustomers() {--%>
<%--    const input = document.getElementById('customerSearch');--%>
<%--    const filter = input.value.toUpperCase();--%>
<%--    const table = document.getElementById('customersTable');--%>
<%--    const rows = table.getElementsByTagName('tr');--%>

<%--    for (let i = 1; i < rows.length; i++) {--%>
<%--      let found = false;--%>
<%--      const cells = rows[i].getElementsByTagName('td');--%>

<%--      for (let j = 0; j < cells.length - 1; j++) {--%>
<%--        const cell = cells[j];--%>
<%--        if (cell) {--%>
<%--          const textValue = cell.textContent || cell.innerText;--%>
<%--          if (textValue.toUpperCase().indexOf(filter) > -1) {--%>
<%--            found = true;--%>
<%--            break;--%>
<%--          }--%>
<%--        }--%>
<%--      }--%>

<%--      rows[i].style.display = found ? '' : 'none';--%>
<%--    }--%>
<%--  }--%>
<%--</script>--%>
<%--</body>--%>
<%--</html>--%>
