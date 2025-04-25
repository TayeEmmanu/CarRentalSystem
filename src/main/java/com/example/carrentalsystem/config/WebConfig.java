package com.example.carrentalsystem.config;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class WebConfig implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext context = sce.getServletContext();

        // Set the context path as an application attribute
        // This helps with resolving static resources
        String contextPath = context.getContextPath();
        context.setAttribute("contextPath", contextPath);

        System.out.println("Web application initialized with context path: " + contextPath);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Cleanup code if needed
    }
}
