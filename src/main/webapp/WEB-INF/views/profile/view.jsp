<%--
  Created by IntelliJ IDEA.
  User: oldst
  Date: 2025-04-14
  Time: 9:14 p.m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>My Profile - Car Rental System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="../common/header.jsp" />

<main>
    <div class="container">
        <h1>My Profile</h1>

        <c:if test="${not empty sessionScope.message}">
            <div class="success-message">
                <p>${sessionScope.message}</p>
            </div>
            <c:remove var="message" scope="session" />
        </c:if>

        <c:if test="${not empty error}">
            <div class="error-message">
                <p>${error}</p>
            </div>
        </c:if>

        <div class="profile-card">
            <div class="profile-header">
                <h2>${user.username}</h2>
                <span class="role-badge ${user.role.toLowerCase()}">${user.role}</span>
            </div>

            <div class="profile-details">
                <p><strong>Email:</strong> ${user.email}</p>
                <p><strong>Account Created:</strong> ${user.createdAt}</p>
                <p><strong>Last Login:</strong> ${user.lastLogin}</p>
                <p><strong>Status:</strong>
                    <c:choose>
                        <c:when test="${user.active}">
                            <span class="status-indicator available">Active</span>
                        </c:when>
                        <c:otherwise>
                            <span class="status-indicator unavailable">Inactive</span>
                        </c:otherwise>
                    </c:choose>
                </p>
            </div>

            <div class="profile-actions">
                <a href="${pageContext.request.contextPath}/change-password" class="btn">Change Password</a>
                <button class="btn btn-primary" id="editProfileBtn">Edit Profile</button>
            </div>

            <div class="edit-profile-form" style="display: none;">
                <h3>Edit Profile</h3>

                <form action="${pageContext.request.contextPath}/profile" method="post" class="form">
                    <div class="form-group">
                        <label for="username">Username</label>
                        <input type="text" id="username" value="${user.username}" disabled>
                        <small>Username cannot be changed</small>
                    </div>

                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" id="email" name="email" value="${not empty email ? email : user.email}" required>
                        <c:if test="${not empty emailError}">
                            <span class="error">${emailError}</span>
                        </c:if>
                    </div>

                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" id="cancelEditBtn">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const editProfileBtn = document.getElementById('editProfileBtn');
        const cancelEditBtn = document.getElementById('cancelEditBtn');
        const editProfileForm = document.querySelector('.edit-profile-form');
        const profileDetails = document.querySelector('.profile-details');
        const profileActions = document.querySelector('.profile-actions');

        editProfileBtn.addEventListener('click', function() {
            editProfileForm.style.display = 'block';
            profileDetails.style.display = 'none';
            profileActions.style.display = 'none';
        });

        cancelEditBtn.addEventListener('click', function() {
            editProfileForm.style.display = 'none';
            profileDetails.style.display = 'block';
            profileActions.style.display = 'block';
        });
    });
</script>
</body>
</html>

