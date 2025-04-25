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

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get current user
        User currentUser = AuthUtil.getCurrentUser(request);

        // Refresh user data from database
        User user = userService.getUserById(currentUser.getId());

        request.setAttribute("user", user);
        request.getRequestDispatcher("/WEB-INF/views/profile/view.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get current user
        User currentUser = AuthUtil.getCurrentUser(request);

        // Get form parameters
        String email = request.getParameter("email");

        // Validate input
        boolean hasError = false;

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("emailError", "Email is required");
            hasError = true;
        }

        if (hasError) {
            // Preserve input values
            request.setAttribute("email", email);

            // Forward back to profile page with errors
            request.setAttribute("user", currentUser);
            request.getRequestDispatcher("/WEB-INF/views/profile/view.jsp").forward(request, response);
            return;
        }

        // Update user object
        currentUser.setEmail(email);

        // Update user in database
        boolean success = userService.updateUser(currentUser);

        if (success) {
            // Update session user
            AuthUtil.setCurrentUser(request, currentUser);

            // Set success message and redirect to profile page
            request.getSession().setAttribute("message", "Profile updated successfully");
            response.sendRedirect(request.getContextPath() + "/profile");
        } else {
            // Update failed
            request.setAttribute("error", "Failed to update profile");
            request.setAttribute("user", currentUser);
            request.getRequestDispatcher("/WEB-INF/views/profile/view.jsp").forward(request, response);
        }
    }
}
