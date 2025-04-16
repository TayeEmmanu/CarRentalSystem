package com.example.carrentalsystem.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.example.carrentalsystem.util.AuthUtil;

import java.io.IOException;

@WebServlet(urlPatterns = {"", "/"})
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is logged in
        if (!AuthUtil.isLoggedIn(request)) {
            // Redirect to login page if not logged in
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Forward to home page if logged in
        request.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(request, response);
    }
}
