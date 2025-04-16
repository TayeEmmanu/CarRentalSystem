package com.example.carrentalsystem.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import com.example.carrentalsystem.model.User;

public class AuthUtil {
    private static final String USER_SESSION_KEY = "currentUser";
    private static final int SESSION_TIMEOUT = 30 * 60; // 30 minutes in seconds

    /**
     * Sets the current user in the session
     *
     * @param request The HTTP request
     * @param user The user to set in the session
     */
    public static void setCurrentUser(HttpServletRequest request, User user) {
        HttpSession session = request.getSession(true);
        session.setAttribute(USER_SESSION_KEY, user);
        session.setMaxInactiveInterval(SESSION_TIMEOUT);
    }

    /**
     * Gets the current user from the session
     *
     * @param request The HTTP request
     * @return The current user, or null if not logged in
     */
    public static User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (User) session.getAttribute(USER_SESSION_KEY);
        }
        return null;
    }

    /**
     * Checks if a user is logged in
     *
     * @param request The HTTP request
     * @return true if a user is logged in, false otherwise
     */
    public static boolean isLoggedIn(HttpServletRequest request) {
        return getCurrentUser(request) != null;
    }

    /**
     * Checks if the current user has the specified role
     *
     * @param request The HTTP request
     * @param role The role to check
     * @return true if the user has the role, false otherwise
     */
    public static boolean hasRole(HttpServletRequest request, String role) {
        User user = getCurrentUser(request);
        if (user == null) {
            return false;
        }

        // Admin has access to everything
        if (user.isAdmin()) {
            return true;
        }

        // Staff has access to staff and customer resources
        if (user.isStaff() && ("STAFF".equals(role) || "CUSTOMER".equals(role))) {
            return true;
        }

        // Customer only has access to customer resources
        return user.isCustomer() && "CUSTOMER".equals(role);
    }

    /**
     * Checks if the current user is an admin
     *
     * @param request The HTTP request
     * @return true if the user is an admin, false otherwise
     */
    public static boolean isAdmin(HttpServletRequest request) {
        User user = getCurrentUser(request);
        return user != null && user.isAdmin();
    }

    /**
     * Checks if the current user is a staff member (or admin)
     *
     * @param request The HTTP request
     * @return true if the user is a staff member or admin, false otherwise
     */
    public static boolean isStaff(HttpServletRequest request) {
        User user = getCurrentUser(request);
        return user != null && user.isStaff();
    }

    /**
     * Logs out the current user
     *
     * @param request The HTTP request
     */
    public static void logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }
}
