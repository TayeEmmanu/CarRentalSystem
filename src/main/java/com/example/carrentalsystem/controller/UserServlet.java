package com.example.carrentalsystem.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.example.carrentalsystem.service.UserService;
import com.example.carrentalsystem.model.User;
import com.example.carrentalsystem.util.AuthUtil;

import java.io.IOException;
import java.util.List;

@WebServlet("/users/*")
public class UserServlet extends HttpServlet {
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Only admin and staff can access user management
        if (!AuthUtil.isStaff(request)) {
            response.sendRedirect(request.getContextPath() + "/access-denied");
            return;
        }

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            // List all users
            List<User> users = userService.getAllUsers();
            request.setAttribute("users", users);
            request.getRequestDispatcher("/WEB-INF/views/users/list.jsp").forward(request, response);
        } else if (pathInfo.equals("/add")) {
            // Show add user form
            request.getRequestDispatcher("/WEB-INF/views/users/add.jsp").forward(request, response);
        } else if (pathInfo.startsWith("/edit/")) {
            // Show edit user form
            try {
                int userId = Integer.parseInt(pathInfo.substring(6));
                User user = userService.getUserById(userId);

                if (user != null) {
                    request.setAttribute("user", user);
                    request.getRequestDispatcher("/WEB-INF/views/users/edit.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/users");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/users");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/users");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Only admin and staff can modify users
        if (!AuthUtil.isStaff(request)) {
            response.sendRedirect(request.getContextPath() + "/access-denied");
            return;
        }

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/users");
        } else if (pathInfo.equals("/add")) {
            // Process add user form
            processAddUser(request, response);
        } else if (pathInfo.startsWith("/edit/")) {
            // Process edit user form
            processEditUser(request, response);
        } else if (pathInfo.startsWith("/delete/")) {
            // Process delete user - admin only
            if (!AuthUtil.isAdmin(request)) {
                response.sendRedirect(request.getContextPath() + "/access-denied");
                return;
            }
            processDeleteUser(request, response);
        } else if (pathInfo.startsWith("/toggle-active/")) {
            // Process toggle user active status
            processToggleActive(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/users");
        }
    }

    private void processAddUser(HttpServletRequest request, HttpServletResponse response)
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
        }

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("emailError", "Email is required");
            hasError = true;
        }

        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("passwordError", "Password is required");
            hasError = true;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("confirmPasswordError", "Passwords do not match");
            hasError = true;
        }

        if (role == null || role.trim().isEmpty()) {
            request.setAttribute("roleError", "Role is required");
            hasError = true;
        }

        if (hasError) {
            // Preserve input values
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.setAttribute("role", role);

            // Forward back to add user page with errors
            request.getRequestDispatcher("/WEB-INF/views/users/add.jsp").forward(request, response);
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
            // Set success message and redirect to users list
            request.getSession().setAttribute("message", "User added successfully");
            response.sendRedirect(request.getContextPath() + "/users");
        } else {
            // Registration failed
            request.setAttribute("error", "Username or email already exists");
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.setAttribute("role", role);
            request.getRequestDispatcher("/WEB-INF/views/users/add.jsp").forward(request, response);
        }
    }

    private void processEditUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get user ID from path
            String pathInfo = request.getPathInfo();
            int userId = Integer.parseInt(pathInfo.substring(6));

            // Get existing user
            User user = userService.getUserById(userId);

            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/users");
                return;
            }

            // Get form parameters
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String role = request.getParameter("role");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            String active = request.getParameter("active");

            // Validate input
            boolean hasError = false;

            if (username == null || username.trim().isEmpty()) {
                request.setAttribute("usernameError", "Username is required");
                hasError = true;
            }

            if (email == null || email.trim().isEmpty()) {
                request.setAttribute("emailError", "Email is required");
                hasError = true;
            }

            if (role == null || role.trim().isEmpty()) {
                request.setAttribute("roleError", "Role is required");
                hasError = true;
            }

            // Only validate password if it's being changed
            if (password != null && !password.isEmpty()) {
                if (!password.equals(confirmPassword)) {
                    request.setAttribute("confirmPasswordError", "Passwords do not match");
                    hasError = true;
                }
            }

            if (hasError) {
                // Preserve input values
                request.setAttribute("user", user);
                request.setAttribute("username", username);
                request.setAttribute("email", email);
                request.setAttribute("role", role);

                // Forward back to edit user page with errors
                request.getRequestDispatcher("/WEB-INF/views/users/edit.jsp").forward(request, response);
                return;
            }

            // Update user object
            user.setUsername(username);
            user.setEmail(email);
            user.setRole(role);
            user.setActive(active != null && active.equals("on"));

            // Update user in database
            boolean success = userService.updateUser(user);

            // Update password if provided
            if (success && password != null && !password.isEmpty()) {
                success = userService.updatePassword(userId, password);
            }

            if (success) {
                // Set success message and redirect to users list
                request.getSession().setAttribute("message", "User updated successfully");
                response.sendRedirect(request.getContextPath() + "/users");
            } else {
                // Update failed
                request.setAttribute("error", "Failed to update user");
                request.setAttribute("user", user);
                request.getRequestDispatcher("/WEB-INF/views/users/edit.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/users");
        }
    }

    private void processDeleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get user ID from path
            String pathInfo = request.getPathInfo();
            int userId = Integer.parseInt(pathInfo.substring(8));

            // Get current user
            User currentUser = AuthUtil.getCurrentUser(request);

            // Prevent self-deletion
            if (currentUser.getId() == userId) {
                request.getSession().setAttribute("error", "You cannot delete your own account");
                response.sendRedirect(request.getContextPath() + "/users");
                return;
            }

            // Delete user
            boolean success = userService.deleteUser(userId);

            if (success) {
                request.getSession().setAttribute("message", "User deleted successfully");
            } else {
                request.getSession().setAttribute("error", "Failed to delete user");
            }

            response.sendRedirect(request.getContextPath() + "/users");
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/users");
        }
    }

    private void processToggleActive(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get user ID from path
            String pathInfo = request.getPathInfo();
            int userId = Integer.parseInt(pathInfo.substring(15));

            // Get current user
            User currentUser = AuthUtil.getCurrentUser(request);

            // Prevent self-deactivation
            if (currentUser.getId() == userId) {
                request.getSession().setAttribute("error", "You cannot change your own active status");
                response.sendRedirect(request.getContextPath() + "/users");
                return;
            }

            // Toggle user active status
            boolean success = userService.toggleUserActive(userId);

            if (success) {
                request.getSession().setAttribute("message", "User status updated successfully");
            } else {
                request.getSession().setAttribute("error", "Failed to update user status");
            }

            response.sendRedirect(request.getContextPath() + "/users");
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/users");
        }
    }
}
