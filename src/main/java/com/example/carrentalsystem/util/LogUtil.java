package com.example.carrentalsystem.util;

import jakarta.servlet.http.HttpServletRequest;
import com.example.carrentalsystem.model.SystemLog;
import com.example.carrentalsystem.model.User;
import com.example.carrentalsystem.service.SystemLogService;

public class LogUtil {

    private static final SystemLogService logService = new SystemLogService();

    public static void info(String message) {
        log("INFO", message, null, null);
    }

    public static void info(String message, HttpServletRequest request) {
        User user = AuthUtil.getCurrentUser(request);
        Integer userId = user != null ? user.getId() : null;
        String ipAddress = getClientIpAddress(request);

        log("INFO", message, userId, ipAddress);
    }

    public static void warning(String message) {
        log("WARNING", message, null, null);
    }

    public static void warning(String message, HttpServletRequest request) {
        User user = AuthUtil.getCurrentUser(request);
        Integer userId = user != null ? user.getId() : null;
        String ipAddress = getClientIpAddress(request);

        log("WARNING", message, userId, ipAddress);
    }

    public static void error(String message) {
        log("ERROR", message, null, null);
    }

    public static void error(String message, HttpServletRequest request) {
        User user = AuthUtil.getCurrentUser(request);
        Integer userId = user != null ? user.getId() : null;
        String ipAddress = getClientIpAddress(request);

        log("ERROR", message, userId, ipAddress);
    }

    private static void log(String level, String message, Integer userId, String ipAddress) {
        SystemLog log = new SystemLog();
        log.setLevel(level);
        log.setMessage(message);
        log.setUserId(userId);
        log.setIpAddress(ipAddress);

        logService.createLog(log);
    }

    private static String getClientIpAddress(HttpServletRequest request) {
        if (request == null) {
            return null;
        }

        String ipAddress = request.getHeader("X-Forwarded-For");
        if (ipAddress == null || ipAddress.isEmpty() || "unknown".equalsIgnoreCase(ipAddress)) {
            ipAddress = request.getHeader("Proxy-Client-IP");
        }
        if (ipAddress == null || ipAddress.isEmpty() || "unknown".equalsIgnoreCase(ipAddress)) {
            ipAddress = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ipAddress == null || ipAddress.isEmpty() || "unknown".equalsIgnoreCase(ipAddress)) {
            ipAddress = request.getHeader("HTTP_CLIENT_IP");
        }
        if (ipAddress == null || ipAddress.isEmpty() || "unknown".equalsIgnoreCase(ipAddress)) {
            ipAddress = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ipAddress == null || ipAddress.isEmpty() || "unknown".equalsIgnoreCase(ipAddress)) {
            ipAddress = request.getRemoteAddr();
        }

        return ipAddress;
    }
}
