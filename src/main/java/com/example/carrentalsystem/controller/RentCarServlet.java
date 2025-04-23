package com.example.carrentalsystem.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.example.carrentalsystem.model.Car;
import com.example.carrentalsystem.model.Rental;
import com.example.carrentalsystem.model.User;
import com.example.carrentalsystem.service.CarService;
import com.example.carrentalsystem.service.RentalService;
import com.example.carrentalsystem.util.AuthUtil;
import com.example.carrentalsystem.util.LogUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Optional;

@WebServlet("/rent-car/*")
public class RentCarServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(RentCarServlet.class);
    private final CarService carService = new CarService();
    private final RentalService rentalService = new RentalService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get current user
        User currentUser = AuthUtil.getCurrentUser(request);

        if (currentUser == null) {
            logger.info("RentCarServlet: No user in session, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String pathInfo = request.getPathInfo();
        logger.info("RentCarServlet: doGet with pathInfo: {}", pathInfo);

        if (pathInfo == null || pathInfo.equals("/")) {
            // Show available cars
            List<Car> availableCars = carService.getAvailableCars();
            logger.info("RentCarServlet: Found {} available cars", availableCars.size());
            request.setAttribute("cars", availableCars);
            request.getRequestDispatcher("/WEB-INF/views/rent/available-cars.jsp").forward(request, response);
        } else {
            try {
                int carId = Integer.parseInt(pathInfo.substring(1));
                Optional<Car> car = carService.getCarById(carId);

                if (car.isPresent() && car.get().isAvailable()) {
                    logger.info("RentCarServlet: Showing rental form for car {}", carId);
                    request.setAttribute("car", car.get());
                    request.getRequestDispatcher("/WEB-INF/views/rent/rental-form.jsp").forward(request, response);
                } else {
                    logger.warn("RentCarServlet: Car {} not found or not available", carId);
                    response.sendRedirect(request.getContextPath() + "/rent-car");
                }
            } catch (NumberFormatException e) {
                logger.warn("RentCarServlet: Invalid car ID format: {}", e.getMessage());
                response.sendRedirect(request.getContextPath() + "/rent-car");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get current user
        User currentUser = AuthUtil.getCurrentUser(request);

        if (currentUser == null) {
            logger.info("RentCarServlet: No user in session, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String pathInfo = request.getPathInfo();
        logger.info("RentCarServlet: doPost with pathInfo: {}", pathInfo);

        if (pathInfo != null && pathInfo.length() > 1) {
            try {
                int carId = Integer.parseInt(pathInfo.substring(1));
                Optional<Car> car = carService.getCarById(carId);

                if (car.isPresent() && car.get().isAvailable()) {
                    // Parse rental dates
                    LocalDate startDate = LocalDate.parse(request.getParameter("startDate"));
                    LocalDate endDate = LocalDate.parse(request.getParameter("endDate"));

                    // Validate dates
                    if (endDate.isBefore(startDate)) {
                        logger.warn("RentCarServlet: End date is before start date");
                        request.setAttribute("error", "End date cannot be before start date");
                        request.setAttribute("car", car.get());
                        request.getRequestDispatcher("/WEB-INF/views/rent/rental-form.jsp").forward(request, response);
                        return;
                    }

                    // Calculate total cost
                    long days = ChronoUnit.DAYS.between(startDate, endDate) + 1; // Include end date
                    BigDecimal dailyRate = car.get().getDailyRate();
                    BigDecimal totalCost = dailyRate.multiply(BigDecimal.valueOf(days));

                    // Create rental
                    Rental rental = new Rental();
                    rental.setUserId(currentUser.getId());
                    rental.setCarId(carId);
                    rental.setStartDate(startDate);
                    rental.setEndDate(endDate);
                    rental.setTotalCost(totalCost);
                    rental.setStatus("ACTIVE");

                    boolean success = rentalService.saveRental(rental);

                    if (success) {
                        logger.info("RentCarServlet: Successfully created rental for car {} by user {}", carId, currentUser.getId());
                        LogUtil.info("User " + currentUser.getUsername() + " rented car #" + carId, request);

                        // Update car availability
                        car.get().setAvailable(false);
                        carService.saveCar(car.get());

                        request.getSession().setAttribute("message", "Car rented successfully");
                        response.sendRedirect(request.getContextPath() + "/my-rentals");
                    } else {
                        logger.error("RentCarServlet: Failed to create rental for car {}", carId);
                        request.setAttribute("error", "Failed to create rental");
                        request.setAttribute("car", car.get());
                        request.getRequestDispatcher("/WEB-INF/views/rent/rental-form.jsp").forward(request, response);
                    }
                } else {
                    logger.warn("RentCarServlet: Car {} not found or not available", carId);
                    response.sendRedirect(request.getContextPath() + "/rent-car");
                }
            } catch (Exception e) {
                logger.error("RentCarServlet: Error processing rental: {}", e.getMessage(), e);
                request.getSession().setAttribute("error", "Error processing rental: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/rent-car");
            }
        } else {
            logger.warn("RentCarServlet: Invalid path info");
            response.sendRedirect(request.getContextPath() + "/rent-car");
        }
    }
}
