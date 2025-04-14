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
        <li><a href="${pageContext.request.contextPath}/cars">Cars</a></li>
        <li><a href="${pageContext.request.contextPath}/customers">Customers</a></li>
        <li><a href="${pageContext.request.contextPath}/rentals">Rentals</a></li>

        <c:if test="${not empty sessionScope.currentUser}">
          <li class="user-menu">
            <a href="#">${sessionScope.currentUser.username} ▼</a>
            <ul class="dropdown">
              <li><a href="${pageContext.request.contextPath}/profile">Profile</a></li>
              <li><a href="${pageContext.request.contextPath}/logout">Logout</a></li>
            </ul>
          </li>
        </c:if>

        <c:if test="${empty sessionScope.currentUser}">
          <li><a href="${pageContext.request.contextPath}/login">Login</a></li>
          <li><a href="${pageContext.request.contextPath}/register">Register</a></li>
        </c:if>
      </ul>
    </nav>
  </div>
</header>
