package com.example.carrentalsystem.controller;

import com.example.carrentalsystem.model.Car;
import com.example.carrentalsystem.service.CarService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "CarServlet", urlPatterns = {"/cars", "/cars/*"})
public class CarServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(CarServlet.class);
    private final CarService carService = new CarService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            // List all cars
            List<Car> cars = carService.getAllCars();
            request.setAttribute("cars", cars);
            request.getRequestDispatcher("/WEB-INF/views/cars/list.jsp").forward(request, response);
        } else if (pathInfo.equals("/add")) {
            // Show add car form
            request.getRequestDispatcher("/WEB-INF/views/cars/add.jsp").forward(request, response);
        } else if (pathInfo.startsWith("/edit/")) {
            // Show edit car form
            try {
                int id = Integer.parseInt(pathInfo.substring(6));
                Optional<Car> car = carService.getCarById(id);
                if (car.isPresent()) {
                    request.setAttribute("car", car.get());
                    request.getRequestDispatcher("/WEB-INF/views/cars/edit.jsp").forward(request, response);
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
            // Add new car
            try {
                Car car = new Car();
                car.setMake(request.getParameter("make"));
                car.setModel(request.getParameter("model"));
                car.setYear(Integer.parseInt(request.getParameter("year")));
                car.setLicensePlate(request.getParameter("licensePlate"));
                car.setDailyRate(new BigDecimal(request.getParameter("dailyRate")));
                car.setAvailable(request.getParameter("available") != null);

                carService.saveCar(car);

                request.getSession().setAttribute("success", "Car added successfully!");
                response.sendRedirect(request.getContextPath() + "/cars");
            } catch (Exception e) {
                logger.error("Error adding car", e);
                request.setAttribute("error", "Error adding car: " + e.getMessage());
                request.getRequestDispatcher("/WEB-INF/views/cars/add.jsp").forward(request, response);
            }
        } else if (pathInfo.startsWith("/edit/")) {
            // Update car
            try {
                int id = Integer.parseInt(pathInfo.substring(6));
                Optional<Car> existingCar = carService.getCarById(id);

                if (existingCar.isPresent()) {
                    Car car = existingCar.get();
                    car.setMake(request.getParameter("make"));
                    car.setModel(request.getParameter("model"));
                    car.setYear(Integer.parseInt(request.getParameter("year")));
                    car.setLicensePlate(request.getParameter("licensePlate"));
                    car.setDailyRate(new BigDecimal(request.getParameter("dailyRate")));
                    car.setAvailable("on".equals(request.getParameter("available")));

                    carService.saveCar(car);

                    response.sendRedirect(request.getContextPath() + "/cars");
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } catch (Exception e) {
                logger.error("Error updating car", e);
                request.setAttribute("error", "Error updating car: " + e.getMessage());
                doGet(request, response);
            }
        } else if (pathInfo.startsWith("/delete/")) {
            // Delete car
            try {
                int id = Integer.parseInt(pathInfo.substring(8));
                carService.deleteCar(id);
                response.sendRedirect(request.getContextPath() + "/cars");
            } catch (Exception e) {
                logger.error("Error deleting car", e);
                request.setAttribute("error", "Error deleting car: " + e.getMessage());
                doGet(request, response);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}
