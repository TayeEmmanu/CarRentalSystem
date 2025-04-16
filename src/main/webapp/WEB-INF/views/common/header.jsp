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

        <%-- Admin Navigation --%>
        <c:if test="${sessionScope.currentUser.admin}">
          <li class="dropdown">
            <a href="#" class="dropdown-toggle">Admin ▼</a>
            <ul class="dropdown-menu">
              <li><a href="${pageContext.request.contextPath}/users">User Management</a></li>
              <li><a href="${pageContext.request.contextPath}/reports">Reports</a></li>
              <li><a href="${pageContext.request.contextPath}/admin/system/settings">System Settings</a></li>
            </ul>
          </li>
        </c:if>

        <%-- Staff Navigation --%>
        <c:if test="${sessionScope.currentUser.staff || sessionScope.currentUser.admin}">
          <li class="dropdown">
            <a href="#" class="dropdown-toggle">Management ▼</a>
            <ul class="dropdown-menu">
              <li><a href="${pageContext.request.contextPath}/cars">Car Inventory</a></li>
              <li><a href="${pageContext.request.contextPath}/customers">Customer Records</a></li>
              <li><a href="${pageContext.request.contextPath}/rentals">Rental Management</a></li>
            </ul>
          </li>
        </c:if>

        <%-- Customer Navigation --%>
        <c:if test="${sessionScope.currentUser.customer || !sessionScope.currentUser.staff}">
          <li><a href="${pageContext.request.contextPath}/cars">Available Cars</a></li>
          <li><a href="${pageContext.request.contextPath}/my-rentals">My Rentals</a></li>
        </c:if>

        <%-- User Account Menu --%>
        <c:if test="${not empty sessionScope.currentUser}">
          <li class="user-menu">
            <a href="#">
                ${sessionScope.currentUser.username}
              <span class="role-badge ${sessionScope.currentUser.role.toLowerCase()}">${sessionScope.currentUser.role}</span>
              ▼
            </a>
            <ul class="dropdown">
              <li><a href="${pageContext.request.contextPath}/profile">My Profile</a></li>
              <li><a href="${pageContext.request.contextPath}/change-password">Change Password</a></li>
              <li><a href="${pageContext.request.contextPath}/logout">Logout</a></li>
            </ul>
          </li>
        </c:if>

        <%-- Login/Register for non-authenticated users --%>
        <c:if test="${empty sessionScope.currentUser}">
          <li><a href="${pageContext.request.contextPath}/login">Login</a></li>
          <li><a href="${pageContext.request.contextPath}/register">Register</a></li>
        </c:if>
      </ul>
    </nav>
  </div>
</header>
