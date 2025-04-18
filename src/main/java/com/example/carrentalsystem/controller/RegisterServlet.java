package com.example.carrentalsystem.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.example.carrentalsystem.service.UserService;
import com.example.carrentalsystem.util.AuthUtil;
import com.example.carrentalsystem.model.User;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // If user is already logged in, redirect to home page
        if (AuthUtil.isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        // Forward to registration page
        request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get form parameters
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String role = request.getParameter("role");

        // Validate input
        boolean hasError = false;

        if (username == null || username.trim().isEmpty()) {
            request.setAttribute("usernameError", "Username is required");
            hasError = true;
        } else if (username.length() < 3 || username.length() > 20) {
            request.setAttribute("usernameError", "Username must be between 3 and 20 characters");
            hasError = true;
        }

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("emailError", "Email is required");
            hasError = true;
        } else if (!email.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
            request.setAttribute("emailError", "Invalid email format");
            hasError = true;
        }

        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("passwordError", "Password is required");
            hasError = true;
        } else if (password.length() < 8) {
            request.setAttribute("passwordError", "Password must be at least 8 characters");
            hasError = true;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("confirmPasswordError", "Passwords do not match");
            hasError = true;
        }

        // Validate role
        if (role == null || role.trim().isEmpty()) {
            request.setAttribute("roleError", "Account type is required");
            hasError = true;
        } else if (!role.equals("ADMIN") && !role.equals("STAFF") && !role.equals("CUSTOMER")) {
            request.setAttribute("roleError", "Invalid account type");
            hasError = true;
        }

        if (hasError) {
            // Preserve input values
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.setAttribute("role", role);

            // Forward back to registration page with errors
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }

        // Create user object
        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setRole(role);

        // Register user
        boolean success = userService.registerUser(user, password);

        if (success) {
            // Set success message and redirect to login page
            request.getSession().setAttribute("message", "Registration successful! Please log in.");
            response.sendRedirect(request.getContextPath() + "/login");
        } else {
            // Registration failed
            request.setAttribute("error", "Username or email already exists");
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.setAttribute("role", role);
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
        }
    }
}
