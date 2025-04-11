package com.example.carrentalsystem.dao;

import com.example.carrentalsystem.model.Car;
import com.example.carrentalsystem.util.DatabaseUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class CarDAO {
    private static final Logger logger = LoggerFactory.getLogger(CarDAO.class);

    public List<Car> findAll() {
        List<Car> cars = new ArrayList<>();
        String sql = "SELECT * FROM cars ORDER BY make, model";

        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Car car = mapResultSetToCar(rs);
                cars.add(car);
            }
        } catch (SQLException e) {
            logger.error("Error finding all cars", e);
            throw new RuntimeException("Error finding all cars", e);
        }

        return cars;
    }

    public List<Car> findAvailableCars() {
        List<Car> cars = new ArrayList<>();
        String sql = "SELECT * FROM cars WHERE available = TRUE ORDER BY make, model";

        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Car car = mapResultSetToCar(rs);
                cars.add(car);
            }
        } catch (SQLException e) {
            logger.error("Error finding available cars", e);
            throw new RuntimeException("Error finding available cars", e);
        }

        return cars;
    }

    public Optional<Car> findById(int id) {
        String sql = "SELECT * FROM cars WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Car car = mapResultSetToCar(rs);
                    return Optional.of(car);
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding car by ID: " + id, e);
            throw new RuntimeException("Error finding car by ID: " + id, e);
        }

        return Optional.empty();
    }

    public void save(Car car) {
        if (car.getId() > 0) {
            update(car);
        } else {
            insert(car);
        }
    }

    private void insert(Car car) {
        String sql = "INSERT INTO cars (make, model, year, license_plate, daily_rate, available) VALUES (?, ?, ?, ?, ?, ?) RETURNING id";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, car.getMake());
            stmt.setString(2, car.getModel());
            stmt.setInt(3, car.getYear());
            stmt.setString(4, car.getLicensePlate());
            stmt.setBigDecimal(5, car.getDailyRate());
            stmt.setBoolean(6, car.isAvailable());

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    car.setId(rs.getInt(1));
                } else {
                    throw new SQLException("Creating car failed, no ID obtained.");
                }
            }
            logger.info("Car inserted successfully: " + car);
        } catch (SQLException e) {
            logger.error("Error inserting car", e);
            throw new RuntimeException("Error inserting car", e);
        }
    }

    private void update(Car car) {
        String sql = "UPDATE cars SET make = ?, model = ?, year = ?, license_plate = ?, daily_rate = ?, available = ? WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, car.getMake());
            stmt.setString(2, car.getModel());
            stmt.setInt(3, car.getYear());
            stmt.setString(4, car.getLicensePlate());
            stmt.setBigDecimal(5, car.getDailyRate());
            stmt.setBoolean(6, car.isAvailable());
            stmt.setInt(7, car.getId());

            stmt.executeUpdate();
            logger.info("Car updated successfully: " + car);
        } catch (SQLException e) {
            logger.error("Error updating car: " + car.getId(), e);
            throw new RuntimeException("Error updating car: " + car.getId(), e);
        }
    }

    public void updateAvailability(int carId, boolean available) {
        String sql = "UPDATE cars SET available = ? WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setBoolean(1, available);
            stmt.setInt(2, carId);

            stmt.executeUpdate();
            logger.info("Car availability updated: carId=" + carId + ", available=" + available);
        } catch (SQLException e) {
            logger.error("Error updating car availability: carId=" + carId, e);
            throw new RuntimeException("Error updating car availability: carId=" + carId, e);
        }
    }

    public void delete(int id) {
        String sql = "DELETE FROM cars WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            stmt.executeUpdate();
            logger.info("Car deleted successfully: " + id);
        } catch (SQLException e) {
            logger.error("Error deleting car: " + id, e);
            throw new RuntimeException("Error deleting car: " + id, e);
        }
    }

    private Car mapResultSetToCar(ResultSet rs) throws SQLException {
        int id = rs.getInt("id");
        String make = rs.getString("make");
        String model = rs.getString("model");
        int year = rs.getInt("year");
        String licensePlate = rs.getString("license_plate");
        BigDecimal dailyRate = rs.getBigDecimal("daily_rate");
        boolean available = rs.getBoolean("available");

        return new Car(id, make, model, year, licensePlate, dailyRate, available);
    }
}
