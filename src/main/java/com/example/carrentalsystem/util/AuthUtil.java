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
