package com.example.carrentalsystem.dao;

import com.example.carrentalsystem.model.SystemLog;
import com.example.carrentalsystem.util.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class SystemLogDAO {

    public SystemLog findById(int id) {
        SystemLog log = null;
        String sql = "SELECT l.*, u.username " +
                "FROM system_logs l " +
                "LEFT JOIN users u ON l.user_id = u.id " +
                "WHERE l.id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    log = mapResultSetToSystemLog(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error finding log by ID: " + e.getMessage());
        }

        return log;
    }

    public List<SystemLog> findAll() {
        List<SystemLog> logs = new ArrayList<>();
        String sql = "SELECT l.*, u.username " +
                "FROM system_logs l " +
                "LEFT JOIN users u ON l.user_id = u.id " +
                "ORDER BY l.timestamp DESC";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                logs.add(mapResultSetToSystemLog(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error finding all logs: " + e.getMessage());
        }

        return logs;
    }

    public List<SystemLog> findByLevel(String level) {
        List<SystemLog> logs = new ArrayList<>();
        String sql = "SELECT l.*, u.username " +
                "FROM system_logs l " +
                "LEFT JOIN users u ON l.user_id = u.id " +
                "WHERE l.level = ? " +
                "ORDER BY l.timestamp DESC";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, level);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    logs.add(mapResultSetToSystemLog(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error finding logs by level: " + e.getMessage());
        }

        return logs;
    }

    public int save(SystemLog log) {
        String sql = "INSERT INTO system_logs (level, message, user_id, ip_address) VALUES (?, ?, ?, ?)";
        int generatedId = -1;

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, log.getLevel());
            stmt.setString(2, log.getMessage());

            if (log.getUserId() != null) {
                stmt.setInt(3, log.getUserId());
            } else {
                stmt.setNull(3, java.sql.Types.INTEGER);
            }

            stmt.setString(4, log.getIpAddress());

            int affectedRows = stmt.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedId = rs.getInt(1);
                        log.setId(generatedId);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error saving log: " + e.getMessage());
        }

        return generatedId;
    }

    public boolean deleteAll() {
        String sql = "DELETE FROM system_logs";
        boolean success = false;

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            int affectedRows = stmt.executeUpdate();
            success = affectedRows > 0;

        } catch (SQLException e) {
            System.err.println("Error deleting all logs: " + e.getMessage());
        }

        return success;
    }

    public boolean deleteById(int id) {
        String sql = "DELETE FROM system_logs WHERE id = ?";
        boolean success = false;

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            int affectedRows = stmt.executeUpdate();
            success = affectedRows > 0;

        } catch (SQLException e) {
            System.err.println("Error deleting log: " + e.getMessage());
        }

        return success;
    }

    private SystemLog mapResultSetToSystemLog(ResultSet rs) throws SQLException {
        SystemLog log = new SystemLog();
        log.setId(rs.getInt("id"));
        log.setTimestamp(rs.getTimestamp("timestamp"));
        log.setLevel(rs.getString("level"));
        log.setMessage(rs.getString("message"));

        int userId = rs.getInt("user_id");
        if (!rs.wasNull()) {
            log.setUserId(userId);
        }

        log.setIpAddress(rs.getString("ip_address"));

        try {
            log.setUsername(rs.getString("username"));
        } catch (SQLException e) {
            // Column might not be available in all queries
        }

        return log;
    }
}
