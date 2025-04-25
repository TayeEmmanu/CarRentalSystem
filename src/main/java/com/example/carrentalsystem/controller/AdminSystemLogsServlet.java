package com.example.carrentalsystem.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.example.carrentalsystem.model.SystemLog;
import com.example.carrentalsystem.model.User;
import com.example.carrentalsystem.service.SystemLogService;
import com.example.carrentalsystem.util.AuthUtil;
import com.example.carrentalsystem.util.LogUtil;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet("/admin/system-logs/*")
public class AdminSystemLogsServlet extends HttpServlet {

    private final SystemLogService logService = new SystemLogService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is admin
        User currentUser = AuthUtil.getCurrentUser(request);

        if (currentUser == null || !currentUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            // List all logs
            String level = request.getParameter("level");
            List<SystemLog> logs;

            if (level != null && !level.isEmpty()) {
                logs = logService.getLogsByLevel(level.toUpperCase());
                request.setAttribute("selectedLevel", level.toUpperCase());
            } else {
                logs = logService.getAllLogs();
            }

            request.setAttribute("logs", logs);
            request.getRequestDispatcher("/WEB-INF/views/admin/system-logs/list.jsp").forward(request, response);
        } else if (pathInfo.equals("/download")) {
            // Download logs as CSV
            response.setContentType("text/csv");
            response.setHeader("Content-Disposition", "attachment; filename=\"system_logs.csv\"");

            List<SystemLog> logs = logService.getAllLogs();
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

            try (PrintWriter writer = response.getWriter()) {
                // Write CSV header
                writer.println("ID,Timestamp,Level,Message,User ID,Username,IP Address");

                // Write log entries
                for (SystemLog log : logs) {
                    writer.print(log.getId());
                    writer.print(",");
                    writer.print(dateFormat.format(log.getTimestamp()));
                    writer.print(",");
                    writer.print(log.getLevel());
                    writer.print(",");
                    writer.print("\"" + log.getMessage().replace("\"", "\"\"") + "\"");
                    writer.print(",");
                    writer.print(log.getUserId() != null ? log.getUserId() : "");
                    writer.print(",");
                    writer.print(log.getUsername() != null ? log.getUsername() : "");
                    writer.print(",");
                    writer.println(log.getIpAddress() != null ? log.getIpAddress() : "");
                }
            }

            LogUtil.info("Admin " + currentUser.getUsername() + " downloaded system logs");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/system-logs");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is admin
        User currentUser = AuthUtil.getCurrentUser(request);

        if (currentUser == null || !currentUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String pathInfo = request.getPathInfo();
        String action = request.getParameter("action");

        if (action != null && action.equals("delete-all")) {
            // Delete all logs
            boolean success = logService.deleteAllLogs();

            if (success) {
                LogUtil.info("Admin " + currentUser.getUsername() + " deleted all system logs");
                request.getSession().setAttribute("message", "All logs deleted successfully");
            } else {
                request.getSession().setAttribute("error", "Failed to delete logs");
            }

            response.sendRedirect(request.getContextPath() + "/admin/system-logs");
        } else if (pathInfo != null && pathInfo.startsWith("/delete/")) {
            // Delete specific log
            try {
                int logId = Integer.parseInt(pathInfo.substring(8));
                boolean success = logService.deleteLog(logId);

                if (success) {
                    LogUtil.info("Admin " + currentUser.getUsername() + " deleted log #" + logId);
                    request.getSession().setAttribute("message", "Log deleted successfully");
                } else {
                    request.getSession().setAttribute("error", "Failed to delete log");
                }

                response.sendRedirect(request.getContextPath() + "/admin/system-logs");
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/system-logs");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/system-logs");
        }
    }
}
