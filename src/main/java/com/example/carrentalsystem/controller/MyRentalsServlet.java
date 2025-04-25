package com.example.carrentalsystem.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.example.carrentalsystem.model.Rental;
import com.example.carrentalsystem.model.User;
import com.example.carrentalsystem.service.RentalService;
import com.example.carrentalsystem.util.AuthUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "MyRentalsServlet", urlPatterns = {"/my-rentals", "/my-rentals/*"})
public class MyRentalsServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(MyRentalsServlet.class);
    private final RentalService rentalService;

    public MyRentalsServlet() {
        this.rentalService = new RentalService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        logger.info("MyRentalsServlet: doGet method called with path: {}", request.getRequestURI());

        try {
            // Get current user
            User currentUser = AuthUtil.getCurrentUser(request);
            if (currentUser == null) {
                logger.warn("MyRentalsServlet: No user in session, redirecting to login");
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            logger.info("MyRentalsServlet: User ID: {}, Username: {}", currentUser.getId(), currentUser.getUsername());

            String pathInfo = request.getPathInfo();
            logger.info("MyRentalsServlet: Path info: {}", pathInfo);

            if (pathInfo == null || pathInfo.equals("/")) {
                // Get actual rentals for the current user from the database
                List<Rental> rentals = rentalService.getRentalsByUserId(currentUser.getId());
                logger.info("MyRentalsServlet: Found {} rentals for user", rentals.size());

                request.setAttribute("rentals", rentals);

                // Forward to the JSP
                request.getRequestDispatcher("/WEB-INF/views/my-rentals/list.jsp").forward(request, response);

                logger.info("MyRentalsServlet: Forward completed");
            } else if (pathInfo.startsWith("/view/")) {
                try {
                    int rentalId = Integer.parseInt(pathInfo.substring(6));
                    logger.info("MyRentalsServlet: Viewing rental with ID: {}", rentalId);

                    // Get the actual rental from the database
                    var rentalOpt = rentalService.getRentalById(rentalId);

                    if (rentalOpt.isPresent()) {
                        Rental rental = rentalOpt.get();

                        // Verify this rental belongs to the current user
                        if (rental.getUserId() != currentUser.getId()) {
                            logger.warn("MyRentalsServlet: User {} attempted to view rental {} which belongs to another user",
                                    currentUser.getId(), rentalId);
                            response.sendRedirect(request.getContextPath() + "/access-denied");
                            return;
                        }

                        request.setAttribute("rental", rental);

                        // Forward to the JSP
                        request.getRequestDispatcher("/WEB-INF/views/my-rentals/view.jsp").forward(request, response);

                        logger.info("MyRentalsServlet: Forward completed");
                    } else {
                        logger.warn("MyRentalsServlet: Rental {} not found", rentalId);
                        response.sendRedirect(request.getContextPath() + "/my-rentals");
                    }
                } catch (NumberFormatException e) {
                    logger.warn("MyRentalsServlet: Invalid rental ID format: {}", e.getMessage());
                    response.sendRedirect(request.getContextPath() + "/my-rentals");
                }
            } else {
                logger.warn("MyRentalsServlet: Invalid path, redirecting to my-rentals");
                response.sendRedirect(request.getContextPath() + "/my-rentals");
            }
        } catch (Exception e) {
            logger.error("MyRentalsServlet: Unexpected error: {}", e.getMessage(), e);

            // Set error message and forward to error page
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/errors/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        logger.info("MyRentalsServlet: doPost method called");

        try {
            // Get current user
            User currentUser = AuthUtil.getCurrentUser(request);
            if (currentUser == null) {
                logger.warn("MyRentalsServlet: No user in session, redirecting to login");
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            String pathInfo = request.getPathInfo();
            logger.info("MyRentalsServlet: Path info: {}", pathInfo);

            if (pathInfo == null || pathInfo.equals("/")) {
                response.sendRedirect(request.getContextPath() + "/my-rentals");
            } else if (pathInfo.startsWith("/cancel/")) {
                try {
                    int rentalId = Integer.parseInt(pathInfo.substring(8));
                    logger.info("MyRentalsServlet: Cancelling rental with ID: {}", rentalId);

                    // Get the rental to verify ownership
                    var rentalOpt = rentalService.getRentalById(rentalId);

                    if (rentalOpt.isPresent()) {
                        Rental rental = rentalOpt.get();

                        // Verify this rental belongs to the current user
                        if (rental.getUserId() != currentUser.getId()) {
                            logger.warn("MyRentalsServlet: User {} attempted to cancel rental {} which belongs to another user",
                                    currentUser.getId(), rentalId);
                            response.sendRedirect(request.getContextPath() + "/access-denied");
                            return;
                        }

                        // Only allow cancellation of active rentals
                        if (!"ACTIVE".equals(rental.getStatus())) {
                            logger.warn("MyRentalsServlet: User attempted to cancel a non-active rental");
                            request.getSession().setAttribute("error", "Only active rentals can be cancelled");
                            response.sendRedirect(request.getContextPath() + "/my-rentals");
                            return;
                        }

                        // Cancel the rental
                        boolean success = rentalService.cancelRental(rentalId);

                        if (success) {
                            logger.info("MyRentalsServlet: Rental {} cancelled successfully", rentalId);
                            request.getSession().setAttribute("message", "Rental cancelled successfully");
                        } else {
                            logger.error("MyRentalsServlet: Failed to cancel rental {}", rentalId);
                            request.getSession().setAttribute("error", "Failed to cancel rental");
                        }
                    } else {
                        logger.warn("MyRentalsServlet: Rental {} not found for cancellation", rentalId);
                        request.getSession().setAttribute("error", "Rental not found");
                    }

                    response.sendRedirect(request.getContextPath() + "/my-rentals");
                } catch (NumberFormatException e) {
                    logger.warn("MyRentalsServlet: Invalid rental ID format: {}", e.getMessage());
                    response.sendRedirect(request.getContextPath() + "/my-rentals");
                }
            } else {
                logger.warn("MyRentalsServlet: Invalid path, redirecting to my-rentals");
                response.sendRedirect(request.getContextPath() + "/my-rentals");
            }
        } catch (Exception e) {
            logger.error("MyRentalsServlet: Unexpected error: {}", e.getMessage(), e);

            // Set error message and forward to error page
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/errors/error.jsp").forward(request, response);
        }
    }
}
