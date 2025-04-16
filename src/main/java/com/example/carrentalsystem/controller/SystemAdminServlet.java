package com.example.carrentalsystem.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.example.carrentalsystem.util.AuthUtil;

import java.io.IOException;

@WebServlet("/admin/system/*")
public class SystemAdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Only admin can access system administration
        if (!AuthUtil.isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/access-denied");
            return;
        }

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/settings")) {
            // Show system settings page
            request.getRequestDispatcher("/WEB-INF/views/admin/system-settings.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/system/settings");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Only admin can modify system settings
        if (!AuthUtil.isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/access-denied");
            return;
        }

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/admin/system/settings");
        } else if (pathInfo.equals("/save-general")) {
            // Process general settings form
            processGeneralSettings(request, response);
        } else if (pathInfo.equals("/save-security")) {
            // Process security settings form
            processSecuritySettings(request, response);
        } else if (pathInfo.equals("/save-email")) {
            // Process email settings form
            processEmailSettings(request, response);
        } else if (pathInfo.equals("/backup")) {
            // Process backup request
            processBackup(request, response);
        } else if (pathInfo.equals("/restore")) {
            // Process restore request
            processRestore(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/system/settings");
        }
    }

    private void processGeneralSettings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get form parameters
        String companyName = request.getParameter("companyName");
        String contactEmail = request.getParameter("contactEmail");
        String contactPhone = request.getParameter("contactPhone");
        String address = request.getParameter("address");
        String currency = request.getParameter("currency");

        // TODO: Save settings to database or properties file

        // Set success message and redirect back to settings page
        request.getSession().setAttribute("success", "General settings saved successfully");
        response.sendRedirect(request.getContextPath() + "/admin/system/settings");
    }

    private void processSecuritySettings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get form parameters
        String passwordPolicy = request.getParameter("passwordPolicy");
        int sessionTimeout = Integer.parseInt(request.getParameter("sessionTimeout"));
        boolean enableTwoFactor = request.getParameter("enableTwoFactor") != null;
        boolean requireEmailVerification = request.getParameter("requireEmailVerification") != null;
        boolean lockFailedLogins = request.getParameter("lockFailedLogins") != null;

        // TODO: Save settings to database or properties file

        // Set success message and redirect back to settings page
        request.getSession().setAttribute("success", "Security settings saved successfully");
        response.sendRedirect(request.getContextPath() + "/admin/system/settings");
    }

    private void processEmailSettings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get form parameters
        String smtpServer = request.getParameter("smtpServer");
        int smtpPort = Integer.parseInt(request.getParameter("smtpPort"));
        String smtpUsername = request.getParameter("smtpUsername");
        String smtpPassword = request.getParameter("smtpPassword");
        boolean enableSsl = request.getParameter("enableSsl") != null;
        String fromEmail = request.getParameter("fromEmail");
        String fromName = request.getParameter("fromName");

        // TODO: Save settings to database or properties file

        // Set success message and redirect back to settings page
        request.getSession().setAttribute("success", "Email settings saved successfully");
        response.sendRedirect(request.getContextPath() + "/admin/system/settings");
    }

    private void processBackup(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // TODO: Implement database backup functionality

        // Set success message and redirect back to settings page
        request.getSession().setAttribute("success", "Database backup created successfully");
        response.sendRedirect(request.getContextPath() + "/admin/system/settings");
    }

    private void processRestore(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // TODO: Implement database restore functionality

        // Set success message and redirect back to settings page
        request.getSession().setAttribute("success", "Database restored successfully");
        response.sendRedirect(request.getContextPath() + "/admin/system/settings");
    }
}
