package com.example.carrentalsystem.util;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class DatabaseContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Force initialization of DatabaseUtil
        try {
            Class.forName(DatabaseUtil.class.getName());
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Failed to initialize DatabaseUtil", e);
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Close database connections
        DatabaseUtil.closeDataSource();
    }
}