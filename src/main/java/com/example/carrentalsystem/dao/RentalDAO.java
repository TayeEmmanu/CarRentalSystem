package com.example.carrentalsystem.dao;

import com.example.carrentalsystem.model.Rental;
import com.example.carrentalsystem.util.DatabaseUtil;
import com.example.carrentalsystem.model.Car;

import java.sql.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class RentalDAO {

    public Optional<Rental> findById(int id) {
        String sql = "SELECT r.*, u.username, c.make || ' ' || c.model AS car_name " +
                "FROM rentals r " +
                "JOIN users u ON r.user_id = u.id " +
                "JOIN cars c ON r.car_id = c.id " +
                "WHERE r.id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToRental(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error finding rental by ID: " + e.getMessage());
        }

        return Optional.empty();
    }

    public List<Rental> findAll() {
        List<Rental> rentals = new ArrayList<>();
        String sql = "SELECT r.*, u.username, c.make || ' ' || c.model AS car_name " +
                "FROM rentals r " +
                "JOIN users u ON r.user_id = u.id " +
                "JOIN cars c ON r.car_id = c.id " +
                "ORDER BY r.start_date DESC";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                rentals.add(mapResultSetToRental(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error finding all rentals: " + e.getMessage());
        }

        return rentals;
    }

    public List<Rental> findByUserId(int userId) {
        List<Rental> rentals = new ArrayList<>();
        String sql = "SELECT r.*, u.username, c.make || ' ' || c.model AS car_name " +
                "FROM rentals r " +
                "JOIN users u ON r.user_id = u.id " +
                "JOIN cars c ON r.car_id = c.id " +
                "WHERE r.user_id = ? " +
                "ORDER BY r.start_date DESC";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    rentals.add(mapResultSetToRental(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error finding rentals by user ID: " + e.getMessage());
        }

        return rentals;
    }

    public boolean save(Rental rental) {
        if (rental.getId() > 0) {
            return update(rental);
        } else {
            return insert(rental);
        }
    }

    private boolean insert(Rental rental) {
        String sql = "INSERT INTO rentals (car_id, user_id, start_date, end_date, total_cost, status) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, rental.getCarId());
            stmt.setInt(2, rental.getUserId());
            stmt.setDate(3, java.sql.Date.valueOf(rental.getStartDate()));
            stmt.setDate(4, java.sql.Date.valueOf(rental.getEndDate()));
            stmt.setBigDecimal(5, rental.getTotalCost());
            stmt.setString(6, rental.getStatus());

            int affectedRows = stmt.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        rental.setId(rs.getInt(1));
                        return true;
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error inserting rental: " + e.getMessage());
        }

        return false;
    }

    private boolean update(Rental rental) {
        String sql = "UPDATE rentals SET car_id = ?, user_id = ?, start_date = ?, end_date = ?, " +
                "total_cost = ?, status = ? WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, rental.getCarId());
            stmt.setInt(2, rental.getUserId());
            stmt.setDate(3, java.sql.Date.valueOf(rental.getStartDate()));
            stmt.setDate(4, java.sql.Date.valueOf(rental.getEndDate()));
            stmt.setBigDecimal(5, rental.getTotalCost());
            stmt.setString(6, rental.getStatus());
            stmt.setInt(7, rental.getId());

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            System.err.println("Error updating rental: " + e.getMessage());
        }

        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM rentals WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            System.err.println("Error deleting rental: " + e.getMessage());
        }

        return false;
    }

    public boolean cancelRental(int id) {
        String sql = "UPDATE rentals SET status = 'CANCELLED' WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            System.err.println("Error cancelling rental: " + e.getMessage());
        }

        return false;
    }

    public boolean completeRental(int id) {
        String sql = "UPDATE rentals SET status = 'COMPLETED' WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            System.err.println("Error completing rental: " + e.getMessage());
        }

        return false;
    }

    private Rental mapResultSetToRental(ResultSet rs) throws SQLException {
        Rental rental = new Rental();
        rental.setId(rs.getInt("id"));
        rental.setCarId(rs.getInt("car_id"));
        rental.setUserId(rs.getInt("user_id"));
        rental.setStartDate(rs.getDate("start_date").toLocalDate());
        rental.setEndDate(rs.getDate("end_date").toLocalDate());
        rental.setTotalCost(rs.getBigDecimal("total_cost"));
        rental.setStatus(rs.getString("status"));

        // Set additional display fields if available
        try {
            rental.setUsername(rs.getString("username"));
        } catch (SQLException e) {
            // Column might not be available in all queries
        }

        try {
            rental.setCarName(rs.getString("car_name"));
        } catch (SQLException e) {
            // Column might not be available in all queries
        }

        return rental;
    }
}
