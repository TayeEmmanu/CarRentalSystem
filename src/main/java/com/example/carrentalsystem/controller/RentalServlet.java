package com.example.carrentalsystem.controller;

import com.example.carrentalsystem.model.Car;
import com.example.carrentalsystem.model.Customer;
import com.example.carrentalsystem.model.Rental;
import com.example.carrentalsystem.service.CarService;
import com.example.carrentalsystem.service.CustomerService;
import com.example.carrentalsystem.service.RentalService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;
import java.math.BigDecimal;

@WebServlet(name = "RentalServlet", urlPatterns = {"/rentals", "/rentals/*"})
public class RentalServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(RentalServlet.class);
    private final RentalService rentalService = new RentalService();
    private final CarService carService = new CarService();
    private final CustomerService customerService = new CustomerService();
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            // List all rentals
            List<Rental> rentals = rentalService.getAllRentals();
            request.setAttribute("rentals", rentals);
            request.getRequestDispatcher("/WEB-INF/views/rentals/list.jsp").forward(request, response);
        } else if (pathInfo.equals("/add")) {
            // Show add rental form
            List<Car> availableCars = carService.getAvailableCars();
            List<Customer> customers = customerService.getAllCustomers();

            // Set today's date for the form
            LocalDate today = LocalDate.now();
            String formattedToday = today.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));

            request.setAttribute("cars", availableCars);
            request.setAttribute("customers", customers);
            request.setAttribute("today", formattedToday);
            request.getRequestDispatcher("/WEB-INF/views/rentals/add.jsp").forward(request, response);

        } else if (pathInfo.startsWith("/edit/")) {
            // Show edit rental form
            try {
                int id = Integer.parseInt(pathInfo.substring(6));
                Optional<Rental> rental = rentalService.getRentalById(id);

                if (rental.isPresent()) {
                    List<Car> cars = carService.getAllCars();
                    List<Customer> customers = customerService.getAllCustomers();

                    request.setAttribute("rental", rental.get());
                    request.setAttribute("cars", cars);
                    request.setAttribute("customers", customers);
                    request.getRequestDispatcher("/WEB-INF/views/rentals/edit.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/add")) {
            // Add new rental
            try {
                int carId = Integer.parseInt(request.getParameter("carId"));
                int customerId = Integer.parseInt(request.getParameter("customerId"));
                LocalDate startDate = LocalDate.parse(request.getParameter("startDate"));
                LocalDate endDate = LocalDate.parse(request.getParameter("endDate"));

                // Create new rental
                Rental rental = new Rental();
                rental.setCarId(carId);
                rental.setCustomerId(customerId);
                rental.setStartDate(startDate);
                rental.setEndDate(endDate);
                rental.setStatus("ACTIVE");

                // Calculate total cost if not provided
                if (request.getParameter("totalCost") != null && !request.getParameter("totalCost").isEmpty()) {
                    rental.setTotalCost(new BigDecimal(request.getParameter("totalCost")));
                }

                rentalService.saveRental(rental);

                request.getSession().setAttribute("success", "Rental created successfully!");
                response.sendRedirect(request.getContextPath() + "/rentals");
            } catch (Exception e) {
                logger.error("Error adding rental", e);

                // Prepare form data for redisplay
                List<Car> availableCars = carService.getAvailableCars();
                List<Customer> customers = customerService.getAllCustomers();
                LocalDate today = LocalDate.now();
                String formattedToday = today.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));

                request.setAttribute("cars", availableCars);
                request.setAttribute("customers", customers);
                request.setAttribute("today", formattedToday);
                request.setAttribute("error", "Error creating rental: " + e.getMessage());
                request.getRequestDispatcher("/WEB-INF/views/rentals/add.jsp").forward(request, response);
            }
        } else if (pathInfo.startsWith("/edit/")) {
            // Update rental
            try {
                int id = Integer.parseInt(pathInfo.substring(6));
                Optional<Rental> existingRental = rentalService.getRentalById(id);

                if (existingRental.isPresent()) {
                    Rental rental = existingRental.get();
                    rental.setCarId(Integer.parseInt(request.getParameter("carId")));
                    rental.setCustomerId(Integer.parseInt(request.getParameter("customerId")));
                    rental.setStartDate(LocalDate.parse(request.getParameter("startDate"), DATE_FORMATTER));
                    //rental.setEndDate(LocalDate.parse(request.getParameter(String.valueOf(DATE_FORMATTER)));
                    rental.setEndDate(LocalDate.parse(request.getParameter("endDate"), DATE_FORMATTER));
                    rental.setStatus(request.getParameter("status"));

                    rentalService.saveRental(rental);

                    response.sendRedirect(request.getContextPath() + "/rentals");
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } catch (Exception e) {
                logger.error("Error updating rental", e);
                request.setAttribute("error", "Error updating rental: " + e.getMessage());
                doGet(request, response);
            }
        } else if (pathInfo.startsWith("/delete/")) {
            // Delete rental
            try {
                int id = Integer.parseInt(pathInfo.substring(8));
                rentalService.deleteRental(id);
                response.sendRedirect(request.getContextPath() + "/rentals");
            } catch (Exception e) {
                logger.error("Error deleting rental", e);
                request.setAttribute("error", "Error deleting rental: " + e.getMessage());
                doGet(request, response);
            }
        } else if (pathInfo.startsWith("/complete/")) {
            // Complete rental
            try {
                int id = Integer.parseInt(pathInfo.substring(10));
                rentalService.completeRental(id);
                response.sendRedirect(request.getContextPath() + "/rentals");
            } catch (Exception e) {
                logger.error("Error completing rental", e);
                request.setAttribute("error", "Error completing rental: " + e.getMessage());
                doGet(request, response);
            }
        } else if (pathInfo.startsWith("/cancel/")) {
            // Cancel rental
            try {
                int id = Integer.parseInt(pathInfo.substring(8));
                rentalService.cancelRental(id);
                response.sendRedirect(request.getContextPath() + "/rentals");
            } catch (Exception e) {
                logger.error("Error cancelling rental", e);
                request.setAttribute("error", "Error cancelling rental: " + e.getMessage());
                doGet(request, response);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}
