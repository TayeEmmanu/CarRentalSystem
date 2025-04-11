<%--
  Created by IntelliJ IDEA.
  User: oldst
  Date: 2025-04-10
  Time: 10:53 p.m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<header>
  <div class="container">
    <div class="logo">
      <a href="${pageContext.request.contextPath}/">Car Rental System</a>
    </div>
    <nav>
      <ul>
        <li><a href="${pageContext.request.contextPath}/">Home</a></li>
        <li class="dropdown">
          <a href="${pageContext.request.contextPath}/cars">Cars</a>
          <div class="dropdown-content">
            <a href="${pageContext.request.contextPath}/cars">View All Cars</a>
            <a href="${pageContext.request.contextPath}/cars/add">Add New Car</a>
          </div>
        </li>
        <li class="dropdown">
          <a href="${pageContext.request.contextPath}/customers">Customers</a>
          <div class="dropdown-content">
            <a href="${pageContext.request.contextPath}/customers">View All Customers</a>
            <a href="${pageContext.request.contextPath}/customers/add">Add New Customer</a>
          </div>
        </li>
        <li class="dropdown">
          <a href="${pageContext.request.contextPath}/rentals">Rentals</a>
          <div class="dropdown-content">
            <a href="${pageContext.request.contextPath}/rentals">View All Rentals</a>
            <a href="${pageContext.request.contextPath}/rentals/add">Add New Rental</a>
          </div>
        </li>
      </ul>
    </nav>
  </div>
</header>
