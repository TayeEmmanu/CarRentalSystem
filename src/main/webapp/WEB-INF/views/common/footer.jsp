<%--
  Created by IntelliJ IDEA.
  User: oldst
  Date: 2025-04-10
  Time: 10:53 p.m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<footer>
    <div class="container">
        <div class="footer-content">
            <div class="footer-logo">
                <h3>Car Rental System</h3>
                <p>Your trusted partner for car rentals</p>
            </div>
            <div class="footer-links">
                <h4>Quick Links</h4>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/cars">Cars</a></li>
                    <li><a href="${pageContext.request.contextPath}/about">About Us</a></li>
                    <li><a href="${pageContext.request.contextPath}/contact">Contact</a></li>
                </ul>
            </div>
            <div class="footer-contact">
                <h4>Contact Us</h4>
                <p>Email: info@carrentalsystem.com</p>
                <p>Phone: +1 (555) 123-4567</p>
                <p>Address: 123 Main St, City, Country</p>
            </div>
        </div>
        <div class="footer-bottom">
            <p>&copy; 2023 Car Rental System. All rights reserved.</p>
        </div>
    </div>
</footer>

<style>
    footer {
        background-color: #333;
        color: #fff;
        padding: 40px 0 20px;
        margin-top: 50px;
    }

    .footer-content {
        display: flex;
        flex-wrap: wrap;
        justify-content: space-between;
        margin-bottom: 20px;
    }

    .footer-logo, .footer-links, .footer-contact {
        flex: 1;
        min-width: 200px;
        margin-bottom: 20px;
    }

    .footer-logo h3 {
        margin-top: 0;
        margin-bottom: 10px;
    }

    .footer-links ul {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .footer-links li {
        margin-bottom: 8px;
    }

    .footer-links a {
        color: #ddd;
        text-decoration: none;
    }

    .footer-links a:hover {
        color: #fff;
        text-decoration: underline;
    }

    .footer-bottom {
        border-top: 1px solid #555;
        padding-top: 20px;
        text-align: center;
    }
</style>

