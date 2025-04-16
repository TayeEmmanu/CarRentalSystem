package com.example.carrentalsystem.controller;

import com.example.carrentalsystem.model.Customer;
import com.example.carrentalsystem.model.Rental;
import com.example.carrentalsystem.model.User;
import com.example.carrentalsystem.service.CustomerService;
import com.example.carrentalsystem.service.RentalService;
import com.example.carrentalsystem.util.AuthUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "MyRentalsServlet", urlPatterns = {"/my-rentals", "/my-rentals/*"})
    public class MyRentalsServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(MyRentalsServlet.class);
    private final RentalService rentalService = new RentalService();
    private final CustomerService customerService = new CustomerService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get current user
        User currentUser = AuthUtil.getCurrentUser(request);

        // Find customer by email (assuming user email matches customer email)
        Optional<Customer> customerOpt = customerService.getCustomerByEmail(currentUser.getEmail());

        if (!customerOpt.isPresent()) {
            // If no customer record exists for this user, show empty list
            request.setAttribute("rentals", new ArrayList<>());
            request.setAttribute("error", "No customer profile found. Please contact staff to set up your customer profile.");
            request.getRequestDispatcher("/WEB-INF/views/my-rentals/list.jsp").forward(request, response);
            return;
        }

        Customer customer = customerOpt.get();
        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            // List user's rentals
            List<Rental> rentals = rentalService.getRentalsByCustomerId(customer.getId());
            request.setAttribute("rentals", rentals);
            request.setAttribute("viewType", "customer");
            request.getRequestDispatcher("/WEB-INF/views/my-rentals/list.jsp").forward(request, response);
        } else if (pathInfo.startsWith("/view/")) {
            // View rental details
            try {
                int id = Integer.parseInt(pathInfo.substring(6));
                Optional<Rental> rental = rentalService.getRentalById(id);

                // Verify this rental belongs to the current user
                if (rental.isPresent() && rental.get().getCustomerId() == customer.getId()) {
                    request.setAttribute("rental", rental.get());
                    request.setAttribute("viewType", "customer");
                    request.getRequestDispatcher("/WEB-INF/views/my-rentals/view.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/access-denied");
                }
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/my-rentals");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get current user
        User currentUser = AuthUtil.getCurrentUser(request);

        // Find customer by email
        Optional<Customer> customerOpt = customerService.getCustomerByEmail(currentUser.getEmail());

        if (!customerOpt.isPresent()) {
            response.sendRedirect(request.getContextPath() + "/my-rentals");
            return;
        }

        Customer customer = customerOpt.get();
        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/my-rentals");
        } else if (pathInfo.startsWith("/cancel/")) {
            // Cancel rental
            try {
                int id = Integer.parseInt(pathInfo.substring(8));
                Optional<Rental> rental = rentalService.getRentalById(id);

                // Verify this rental belongs to the current user
                if (rental.isPresent() && rental.get().getCustomerId() == customer.getId()) {
                    // Only allow cancellation of active rentals
                    if ("ACTIVE".equals(rental.get().getStatus())) {
                        rentalService.cancelRental(id);
                        request.getSession().setAttribute("success", "Rental cancelled successfully!");
                    } else {
                        request.getSession().setAttribute("error", "Only active rentals can be cancelled.");
                    }
                } else {
                    response.sendRedirect(request.getContextPath() + "/access-denied");
                    return;
                }

                response.sendRedirect(request.getContextPath() + "/my-rentals");
            } catch (Exception e) {
                logger.error("Error cancelling rental", e);
                request.getSession().setAttribute("error", "Error cancelling rental: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/my-rentals");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/my-rentals");
        }
    }
}
