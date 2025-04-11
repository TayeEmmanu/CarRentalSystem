package com.example.carrentalsystem.dao;

import com.example.carrentalsystem.model.Car;
import com.example.carrentalsystem.model.Customer;
import com.example.carrentalsystem.model.Rental;
import com.example.carrentalsystem.util.DatabaseUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class RentalDAO  {
    private static final Logger logger = LoggerFactory.getLogger(RentalDAO.class);
    private final CarDAO carDAO = new CarDAO();
    private final CustomerDAO customerDAO = new CustomerDAO();

    public List<Rental> findAll() {
        List<Rental> rentals = new ArrayList<>();
        String sql = "SELECT * FROM rentals ORDER BY start_date DESC";

        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Rental rental = mapResultSetToRental(rs);
                loadRentalRelations(rental);
                rentals.add(rental);
            }
        } catch (SQLException e) {
            logger.error("Error finding all rentals", e);
            throw new RuntimeException("Error finding all rentals", e);
        }

        return rentals;
    }

    public List<Rental> findActiveRentals() {
        List<Rental> rentals = new ArrayList<>();
        String sql = "SELECT * FROM rentals WHERE status = 'ACTIVE' ORDER BY start_date";

        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Rental rental = mapResultSetToRental(rs);
                loadRentalRelations(rental);
                rentals.add(rental);
            }
        } catch (SQLException e) {
            logger.error("Error finding active rentals", e);
            throw new RuntimeException("Error finding active rentals", e);
        }

        return rentals;
    }

    public List<Rental> findRentalsByCustomerId(int customerId) {
        List<Rental> rentals = new ArrayList<>();
        String sql = "SELECT * FROM rentals WHERE customer_id = ? ORDER BY start_date DESC";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, customerId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Rental rental = mapResultSetToRental(rs);
                    loadRentalRelations(rental);
                    rentals.add(rental);
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding rentals by customer ID: " + customerId, e);
            throw new RuntimeException("Error finding rentals by customer ID: " + customerId, e);
        }

        return rentals;
    }

    public Optional<Rental> findById(int id) {
        String sql = "SELECT * FROM rentals WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Rental rental = mapResultSetToRental(rs);
                    loadRentalRelations(rental);
                    return Optional.of(rental);
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding rental by ID: " + id, e);
            throw new RuntimeException("Error finding rental by ID: " + id, e);
        }

        return Optional.empty();
    }

    public void save(Rental rental) {
        if (rental.getId() > 0) {
            update(rental);
        } else {
            insert(rental);
        }
    }

    private void insert(Rental rental) {
        // Changed to use PostgreSQL's RETURNING syntax for getting generated keys
        String sql = "INSERT INTO rentals (car_id, customer_id, start_date, end_date, total_cost, status) VALUES (?, ?, ?, ?, ?, ?) RETURNING id";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, rental.getCarId());
            stmt.setInt(2, rental.getCustomerId());
            stmt.setDate(3, Date.valueOf(rental.getStartDate()));
            stmt.setDate(4, Date.valueOf(rental.getEndDate()));
            stmt.setBigDecimal(5, rental.getTotalCost());
            stmt.setString(6, rental.getStatus());

            // Execute the query and get the generated ID directly from the result set
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    rental.setId(rs.getInt(1));
                } else {
                    throw new SQLException("Creating rental failed, no ID obtained.");
                }
            }

            // Update car availability
            if ("ACTIVE".equals(rental.getStatus())) {
                carDAO.updateAvailability(rental.getCarId(), false);
            }

            logger.info("Rental inserted successfully: " + rental);
        } catch (SQLException e) {
            logger.error("Error inserting rental", e);
            throw new RuntimeException("Error inserting rental", e);
        }
    }

    private void update(Rental rental) {
        String sql = "UPDATE rentals SET car_id = ?, customer_id = ?, start_date = ?, end_date = ?, total_cost = ?, status = ? WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, rental.getCarId());
            stmt.setInt(2, rental.getCustomerId());
            stmt.setDate(3, Date.valueOf(rental.getStartDate()));
            stmt.setDate(4, Date.valueOf(rental.getEndDate()));
            stmt.setBigDecimal(5, rental.getTotalCost());
            stmt.setString(6, rental.getStatus());
            stmt.setInt(7, rental.getId());

            stmt.executeUpdate();

            // Update car availability based on rental status
            if ("COMPLETED".equals(rental.getStatus()) || "CANCELLED".equals(rental.getStatus())) {
                carDAO.updateAvailability(rental.getCarId(), true);
            } else if ("ACTIVE".equals(rental.getStatus())) {
                carDAO.updateAvailability(rental.getCarId(), false);
            }

            logger.info("Rental updated successfully: " + rental);
        } catch (SQLException e) {
            logger.error("Error updating rental: " + rental.getId(), e);
            throw new RuntimeException("Error updating rental: " + rental.getId(), e);
        }
    }

    public void delete(int id) {
        // First, get the rental to update car availability
        Optional<Rental> rentalOpt = findById(id);
        if (rentalOpt.isPresent()) {
            Rental rental = rentalOpt.get();

            String sql = "DELETE FROM rentals WHERE id = ?";

            try (Connection conn = DatabaseUtil.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setInt(1, id);
                stmt.executeUpdate();

                // Make car available again if rental was active
                if ("ACTIVE".equals(rental.getStatus())) {
                    carDAO.updateAvailability(rental.getCarId(), true);
                }

                logger.info("Rental deleted successfully: " + id);
            } catch (SQLException e) {
                logger.error("Error deleting rental: " + id, e);
                throw new RuntimeException("Error deleting rental: " + id, e);
            }
        }
    }

    private Rental mapResultSetToRental(ResultSet rs) throws SQLException {
        int id = rs.getInt("id");
        int carId = rs.getInt("car_id");
        int customerId = rs.getInt("customer_id");
        LocalDate startDate = rs.getDate("start_date").toLocalDate();
        LocalDate endDate = rs.getDate("end_date").toLocalDate();
        BigDecimal totalCost = rs.getBigDecimal("total_cost");
        String status = rs.getString("status");

        return new Rental(id, carId, customerId, startDate, endDate, totalCost, status);
    }

    private void loadRentalRelations(Rental rental) {
        // Load car
        carDAO.findById(rental.getCarId()).ifPresent(rental::setCar);

        // Load customer
        customerDAO.findById(rental.getCustomerId()).ifPresent(rental::setCustomer);
    }
}
