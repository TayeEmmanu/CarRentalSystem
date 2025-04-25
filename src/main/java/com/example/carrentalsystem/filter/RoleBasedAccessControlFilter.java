package com.example.carrentalsystem.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.example.carrentalsystem.util.AuthUtil;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebFilter("/*")
public class RoleBasedAccessControlFilter implements Filter {

    // Map of paths to required roles
    private final Map<String, String> pathRoleMap = new HashMap<>();

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Define path-to-role mappings

        // Admin-only paths
        pathRoleMap.put("/admin", "ADMIN");
        pathRoleMap.put("/admin/", "ADMIN");
        pathRoleMap.put("/reports", "ADMIN");
        pathRoleMap.put("/reports/", "ADMIN");
        pathRoleMap.put("/system", "ADMIN");
        pathRoleMap.put("/system/", "ADMIN");

        // Staff-only paths (admin can also access)
        pathRoleMap.put("/cars/add", "STAFF");
        pathRoleMap.put("/cars/edit", "STAFF");
        pathRoleMap.put("/cars/delete", "STAFF");
        pathRoleMap.put("/customers", "STAFF");
        pathRoleMap.put("/customers/", "STAFF");
        pathRoleMap.put("/rentals", "STAFF");
        pathRoleMap.put("/rentals/", "STAFF");
        pathRoleMap.put("/staff", "STAFF");
        pathRoleMap.put("/staff/", "STAFF");

        // Update the path-to-role mappings in the init method
        // Change the users path from ADMIN to STAFF
        pathRoleMap.put("/users", "STAFF");
        pathRoleMap.put("/users/", "STAFF");

        // But keep the modification paths as ADMIN only
        pathRoleMap.put("/users/add", "ADMIN");
        pathRoleMap.put("/users/edit", "ADMIN");
        pathRoleMap.put("/users/delete", "ADMIN");
        pathRoleMap.put("/users/toggle-active", "ADMIN");

        // Customer-only paths (staff and admin can also access)
        pathRoleMap.put("/profile", "CUSTOMER");
        pathRoleMap.put("/my-rentals", "CUSTOMER");
        pathRoleMap.put("/rent-car", "CUSTOMER");
        pathRoleMap.put("/rent-car/", "CUSTOMER");
        pathRoleMap.put("/change-password", "CUSTOMER");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Skip this filter for public paths
        String path = httpRequest.getServletPath();
        if (isPublicPath(path)) {
            chain.doFilter(request, response);
            return;
        }

        // Check if the path requires a specific role
        String requiredRole = getRequiredRole(path);

        if (requiredRole != null) {
            // Check if the user has the required role
            if (!AuthUtil.hasRole(httpRequest, requiredRole)) {
                // Redirect to access denied page
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/access-denied");
                return;
            }
        }

        // User has the required role or no specific role is required
        chain.doFilter(request, response);
    }

    private boolean isPublicPath(String path) {
        return path.startsWith("/login") ||
                path.startsWith("/register") ||
                path.startsWith("/logout") ||
                path.startsWith("/css/") ||
                path.startsWith("/js/") ||
                path.startsWith("/images/") ||
                path.equals("/") ||
                path.equals("/index.jsp") ||
                path.equals("/access-denied");
    }

    private String getRequiredRole(String path) {
        // Check for exact path match
        if (pathRoleMap.containsKey(path)) {
            return pathRoleMap.get(path);
        }

        // Check for path prefix match
        for (Map.Entry<String, String> entry : pathRoleMap.entrySet()) {
            if (path.startsWith(entry.getKey())) {
                return entry.getValue();
            }
        }

        // No specific role required for this path
        return null;
    }

    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}
