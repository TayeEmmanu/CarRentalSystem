<%--
  Created by IntelliJ IDEA.
  User: oldst
  Date: 2025-04-10
  Time: 10:54 p.m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Error</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main class="container">
    <div class="error-container">
        <h1>Oops! Something went wrong</h1>
        <p>We're sorry, but an error occurred while processing your request.</p>
        <p>Error code: ${pageContext.errorData.statusCode}</p>
        <p>Please go back to the <a href="${pageContext.request.contextPath}/">home page</a> and try again.</p>
    </div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>
