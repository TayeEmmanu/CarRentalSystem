<%--
  Created by IntelliJ IDEA.
  User: oldst
  Date: 2025-04-14
  Time: 9:47 p.m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <title>Home - Car Rental System</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="common/header.jsp" />

<main>
  <div class="container">
    <div class="welcome-section">
      <h1>Welcome to Car Rental System</h1>
      <p>Hello, ${sessionScope.currentUser.username}!</p>

      <div class="role-specific-content">
        <c:choose>
          <c:when test="${sessionScope.currentUser.admin}">
            <div class="admin-dashboard">
              <h2>Admin Dashboard</h2>
              <div class="dashboard-cards">
                <div class="dashboard-card">
                  <h3>User Management</h3>
                  <p>Manage system users and their permissions.</p>
                  <a href="${pageContext.request.contextPath}/users" class="btn">Manage Users</a>
                </div>

                <div class="dashboard-card">
                  <h3>System Settings</h3>
                  <p>Configure system settings and preferences.</p>
                  <a href="${pageContext.request.contextPath}/admin/system-logs/list" class="btn">System Settings</a>
                </div>
              </div>
            </div>
          </c:when>
          <c:when test="${sessionScope.currentUser.staff}">
            <div class="staff-dashboard">
              <h2>Staff Dashboard</h2>
              <div class="dashboard-cards">
                <div class="dashboard-card">
                  <h3>Car Inventory</h3>
                  <p>Manage the car inventory and availability.</p>
                  <a href="${pageContext.request.contextPath}/cars" class="btn">Manage Cars</a>
                </div>
                <div class="dashboard-card">
                  <h3>Customer Records</h3>
                  <p>View user information.</p>
                  <a href="${pageContext.request.contextPath}/users/*" class="btn">View Users</a>
                </div>
                <div class="dashboard-card">
                  <h3>Rental Management</h3>
                  <p>Process and manage car rentals.</p>
                  <a href="${pageContext.request.contextPath}/rentals" class="btn">Manage Rentals</a>
                </div>
              </div>
            </div>
          </c:when>
          <c:otherwise>
            <div class="customer-dashboard">
              <h2>Customer Dashboard</h2>
              <div class="dashboard-cards">
                <div class="dashboard-card">
                  <h3>Available Cars</h3>
                  <p>Browse cars available for rent.</p>
                  <a href="${pageContext.request.contextPath}/cars" class="btn">Browse Cars</a>
                </div>
                <div class="dashboard-card">
                  <h3>My Rentals</h3>
                  <p>View your current and past rentals.</p>
                  <a href="${pageContext.request.contextPath}/my-rentals/view" class="btn">My Rentals</a>
                </div>
                <div class="dashboard-card">
                  <h3>My Profile</h3>
                  <p>View and update your profile information.</p>
                  <a href="${pageContext.request.contextPath}/profile" class="btn">My Profile</a>
                </div>
              </div>
            </div>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </div>
</main>

<jsp:include page="common/footer.jsp" />
</body>
</html>

