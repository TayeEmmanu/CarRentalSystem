    <%--
  Created by IntelliJ IDEA.
  User: oldst
  Date: 2025-04-10
  Time: 11:02 p.m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Customer - Car Rental System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main class="container">
    <h1>Edit Customer</h1>

    <c:if test="${not empty error}">
        <div class="error-message">
            <p>${error}</p>
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/customers/edit/${customer.id}" method="post" class="form">
        <div class="form-group">
            <label for="firstName">First Name:</label>
            <input type="text" id="firstName" name="firstName" value="${customer.firstName}" required>
        </div>

        <div class="form-group">
            <label for="lastName">Last Name:</label>
            <input type="text" id="lastName" name="lastName" value="${customer.lastName}" required>
        </div>

        <div class="form-group">
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" value="${customer.email}" required>
        </div>

        <div class="form-group">
            <label for="phone">Phone:</label>
            <input type="tel" id="phone" name="phone" value="${customer.phone}" required>
        </div>

        <div class="form-group">
            <label for="driverLicense">Driver License:</label>
            <input type="text" id="driverLicense" name="driverLicense" value="${customer.driverLicense}" required>
        </div>

        <div class="form-actions">
            <button type="submit" class="btn">Save</button>
            <a href="${pageContext.request.contextPath}/customers" class="btn btn-secondary">Cancel</a>
        </div>
    </form>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>
