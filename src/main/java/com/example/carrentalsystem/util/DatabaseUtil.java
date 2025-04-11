package com.example.carrentalsystem.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

public class DatabaseUtil {
    private static final Logger logger = LoggerFactory.getLogger(DatabaseUtil.class);
    private static HikariDataSource dataSource;

    static {
        try {
            // Force loading of the JDBC driver
            try {
                Class.forName("org.postgresql.Driver");
                logger.info("PostgreSQL JDBC Driver loaded successfully");
            } catch (ClassNotFoundException e) {
                logger.error("Failed to load PostgreSQL JDBC driver", e);
                throw new RuntimeException("Failed to load PostgreSQL JDBC driver", e);
            }

            Properties props = new Properties();
            try (InputStream is = DatabaseUtil.class.getClassLoader().getResourceAsStream("database.properties")) {
                if (is == null) {
                    throw new IOException("Could not find database.properties");
                }
                props.load(is);
                logger.info("Database properties loaded successfully");
            }

            HikariConfig config = new HikariConfig();
            config.setDriverClassName(props.getProperty("db.driver"));
            config.setJdbcUrl(props.getProperty("db.url"));
            config.setUsername(props.getProperty("db.username"));
            config.setPassword(props.getProperty("db.password"));
            config.setMaximumPoolSize(Integer.parseInt(props.getProperty("db.poolSize", "10")));
            config.setAutoCommit(true);

            // Add PostgreSQL specific properties
            config.addDataSourceProperty("cachePrepStmts", "true");
            config.addDataSourceProperty("prepStmtCacheSize", "250");
            config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");

            dataSource = new HikariDataSource(config);
            logger.info("Database connection pool initialized successfully");

            // Initialize database schema
            initializeDatabase();
        } catch (IOException e) {
            logger.error("Failed to load database properties", e);
            throw new RuntimeException("Failed to load database properties", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }

    private static void initializeDatabase() {
        try (Connection conn = getConnection()) {
            // Create tables
            createTables(conn);

            // Insert sample data if needed
            insertSampleData(conn);

            logger.info("Database schema initialized successfully");
        } catch (SQLException e) {
            logger.error("Failed to initialize database schema: " + e.getMessage(), e);
            throw new RuntimeException("Failed to initialize database schema", e);
        }
    }

    private static void createTables(Connection conn) throws SQLException {
        try (Statement stmt = conn.createStatement()) {
            // Create Cars table
            logger.info("Creating cars table if not exists");
            stmt.execute("CREATE TABLE IF NOT EXISTS cars (" +
                    "id SERIAL PRIMARY KEY, " +
                    "make VARCHAR(50) NOT NULL, " +
                    "model VARCHAR(50) NOT NULL, " +
                    "year INT NOT NULL, " +
                    "license_plate VARCHAR(20) NOT NULL UNIQUE, " +
                    "daily_rate DECIMAL(10, 2) NOT NULL, " +
                    "available BOOLEAN DEFAULT TRUE" +
                    ")");

            // Create Customers table
            logger.info("Creating customers table if not exists");
            stmt.execute("CREATE TABLE IF NOT EXISTS customers (" +
                    "id SERIAL PRIMARY KEY, " +
                    "first_name VARCHAR(50) NOT NULL, " +
                    "last_name VARCHAR(50) NOT NULL, " +
                    "email VARCHAR(100) NOT NULL UNIQUE, " +
                    "phone VARCHAR(20) NOT NULL, " +
                    "driver_license VARCHAR(50) NOT NULL UNIQUE" +
                    ")");

            // Create Rentals table
            logger.info("Creating rentals table if not exists");
            stmt.execute("CREATE TABLE IF NOT EXISTS rentals (" +
                    "id SERIAL PRIMARY KEY, " +
                    "car_id INT NOT NULL, " +
                    "customer_id INT NOT NULL, " +
                    "start_date DATE NOT NULL, " +
                    "end_date DATE NOT NULL, " +
                    "total_cost DECIMAL(10, 2) NOT NULL, " +
                    "status VARCHAR(20) NOT NULL, " +
                    "FOREIGN KEY (car_id) REFERENCES cars(id), " +
                    "FOREIGN KEY (customer_id) REFERENCES customers(id)" +
                    ")");
        }
    }

    private static void insertSampleData(Connection conn) throws SQLException {
        // Check if cars table is empty
        boolean carsEmpty = isTableEmpty(conn, "cars");

        if (carsEmpty) {
            logger.info("Cars table is empty, inserting sample data");
            try (Statement stmt = conn.createStatement()) {
                stmt.execute("INSERT INTO cars (make, model, year, license_plate, daily_rate, available) VALUES " +
                        "('Toyota', 'Camry', 2022, 'ABC123', 50.00, TRUE), " +
                        "('Honda', 'Civic', 2021, 'XYZ789', 45.00, TRUE), " +
                        "('Ford', 'Mustang', 2023, 'DEF456', 75.00, TRUE)");
            }
        }

        // Check if customers table is empty
        boolean customersEmpty = isTableEmpty(conn, "customers");

        if (customersEmpty) {
            logger.info("Customers table is empty, inserting sample data");
            try (Statement stmt = conn.createStatement()) {
                stmt.execute("INSERT INTO customers (first_name, last_name, email, phone, driver_license) VALUES " +
                        "('John', 'Doe', 'john.doe@example.com', '555-123-4567', 'DL12345678'), " +
                        "('Jane', 'Smith', 'jane.smith@example.com', '555-987-6543', 'DL87654321')");
            }
        }
    }

    private static boolean isTableEmpty(Connection conn, String tableName) throws SQLException {
        String sql = "SELECT COUNT(*) FROM " + tableName;

        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            // IMPORTANT: Move to the first row before accessing data
            if (rs.next()) {
                int count = rs.getInt(1);
                logger.info("Table " + tableName + " has " + count + " records");
                return count == 0;
            }
            // If rs.next() returns false, the ResultSet is empty (which shouldn't happen for COUNT(*))
            logger.warn("Empty ResultSet returned for COUNT(*) query on " + tableName);
            return true;
        }
    }

    public static void closeDataSource() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
            logger.info("Database connection pool closed");
        }
    }
}