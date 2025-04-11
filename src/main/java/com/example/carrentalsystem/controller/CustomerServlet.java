package com.example.carrentalsystem.controller;

import com.example.carrentalsystem.model.Customer;
import com.example.carrentalsystem.service.CustomerService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "CustomerServlet", urlPatterns = {"/customers", "/customers/*"})
public class CustomerServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(CustomerServlet.class);
    private final CustomerService customerService = new CustomerService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            // List all customers
            List<Customer> customers = customerService.getAllCustomers();
            request.setAttribute("customers", customers);
            request.getRequestDispatcher("/WEB-INF/views/customers/list.jsp").forward(request, response);
        } else if (pathInfo.equals("/add")) {
            // Show add customer form
            request.getRequestDispatcher("/WEB-INF/views/customers/add.jsp").forward(request, response);
        } else if (pathInfo.startsWith("/edit/")) {
            // Show edit customer form
            try {
                int id = Integer.parseInt(pathInfo.substring(6));
                Optional<Customer> customer = customerService.getCustomerById(id);
                if (customer.isPresent()) {
                    request.setAttribute("customer", customer.get());
                    request.getRequestDispatcher("/WEB-INF/views/customers/edit.jsp").forward(request, response);
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
            // Add new customer
            try {
                Customer customer = new Customer();
                customer.setFirstName(request.getParameter("firstName"));
                customer.setLastName(request.getParameter("lastName"));
                customer.setEmail(request.getParameter("email"));
                customer.setPhone(request.getParameter("phone"));
                customer.setDriverLicense(request.getParameter("driverLicense"));

                customerService.saveCustomer(customer);

                request.getSession().setAttribute("success", "Customer added successfully!");
                response.sendRedirect(request.getContextPath() + "/customers");
            } catch (Exception e) {
                logger.error("Error adding customer", e);
                request.setAttribute("error", "Error adding customer: " + e.getMessage());
                request.getRequestDispatcher("/WEB-INF/views/customers/add.jsp").forward(request, response);
            }
        } else if (pathInfo.startsWith("/edit/")) {
            // Update customer
            try {
                int id = Integer.parseInt(pathInfo.substring(6));
                Optional<Customer> existingCustomer = customerService.getCustomerById(id);

                if (existingCustomer.isPresent()) {
                    Customer customer = existingCustomer.get();
                    customer.setFirstName(request.getParameter("firstName"));
                    customer.setLastName(request.getParameter("lastName"));
                    customer.setEmail(request.getParameter("email"));
                    customer.setPhone(request.getParameter("phone"));
                    customer.setDriverLicense(request.getParameter("driverLicense"));

                    customerService.saveCustomer(customer);

                    response.sendRedirect(request.getContextPath() + "/customers");
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } catch (Exception e) {
                logger.error("Error updating customer", e);
                request.setAttribute("error", "Error updating customer: " + e.getMessage());
                doGet(request, response);
            }
        } else if (pathInfo.startsWith("/delete/")) {
            // Delete customer
            try {
                int id = Integer.parseInt(pathInfo.substring(8));
                customerService.deleteCustomer(id);
                response.sendRedirect(request.getContextPath() + "/customers");
            } catch (Exception e) {
                logger.error("Error deleting customer", e);
                request.setAttribute("error", "Error deleting customer: " + e.getMessage());
                doGet(request, response);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}
