package com.example.carrentalsystem.dao;

import com.example.carrentalsystem.model.Customer;
import com.example.carrentalsystem.util.DatabaseUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class CustomerDAO {
    private static final Logger logger = LoggerFactory.getLogger(CustomerDAO.class);

    public List<Customer> findAll() {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM customers ORDER BY last_name, first_name";

        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Customer customer = mapResultSetToCustomer(rs);
                customers.add(customer);
            }
        } catch (SQLException e) {
            logger.error("Error finding all customers", e);
            throw new RuntimeException("Error finding all customers", e);
        }

        return customers;
    }

    public Optional<Customer> findById(int id) {
        String sql = "SELECT * FROM customers WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Customer customer = mapResultSetToCustomer(rs);
                    return Optional.of(customer);
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding customer by ID: " + id, e);
            throw new RuntimeException("Error finding customer by ID: " + id, e);
        }

        return Optional.empty();
    }

    public Optional<Customer> findByEmail(String email) {
        String sql = "SELECT * FROM customers WHERE email = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Customer customer = mapResultSetToCustomer(rs);
                    return Optional.of(customer);
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding customer by email: " + email, e);
            throw new RuntimeException("Error finding customer by email: " + email, e);
        }

        return Optional.empty();
    }

    public void save(Customer customer) {
        if (customer.getId() > 0) {
            update(customer);
        } else {
            insert(customer);
        }
    }

    private void insert(Customer customer) {
        // Changed to use PostgreSQL's RETURNING syntax for getting generated keys
        String sql = "INSERT INTO customers (first_name, last_name, email, phone, driver_license) VALUES (?, ?, ?, ?, ?) RETURNING id";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, customer.getFirstName());
            stmt.setString(2, customer.getLastName());
            stmt.setString(3, customer.getEmail());
            stmt.setString(4, customer.getPhone());
            stmt.setString(5, customer.getDriverLicense());

            // Execute the query and get the generated ID directly from the result set
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    customer.setId(rs.getInt(1));
                } else {
                    throw new SQLException("Creating customer failed, no ID obtained.");
                }
            }

            logger.info("Customer inserted successfully: " + customer);
        } catch (SQLException e) {
            logger.error("Error inserting customer", e);
            throw new RuntimeException("Error inserting customer", e);
        }
    }

    private void update(Customer customer) {
        String sql = "UPDATE customers SET first_name = ?, last_name = ?, email = ?, phone = ?, driver_license = ? WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, customer.getFirstName());
            stmt.setString(2, customer.getLastName());
            stmt.setString(3, customer.getEmail());
            stmt.setString(4, customer.getPhone());
            stmt.setString(5, customer.getDriverLicense());
            stmt.setInt(6, customer.getId());

            stmt.executeUpdate();
            logger.info("Customer updated successfully: " + customer);
        } catch (SQLException e) {
            logger.error("Error updating customer: " + customer.getId(), e);
            throw new RuntimeException("Error updating customer: " + customer.getId(), e);
        }
    }

    public void delete(int id) {
        String sql = "DELETE FROM customers WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            stmt.executeUpdate();
            logger.info("Customer deleted successfully: " + id);
        } catch (SQLException e) {
            logger.error("Error deleting customer: " + id, e);
            throw new RuntimeException("Error deleting customer: " + id, e);
        }
    }

    private Customer mapResultSetToCustomer(ResultSet rs) throws SQLException {
        int id = rs.getInt("id");
        String firstName = rs.getString("first_name");
        String lastName = rs.getString("last_name");
        String email = rs.getString("email");
        String phone = rs.getString("phone");
        String driverLicense = rs.getString("driver_license");

        return new Customer(id, firstName, lastName, email, phone, driverLicense);
    }
}
