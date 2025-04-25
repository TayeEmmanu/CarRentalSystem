package com.example.carrentalsystem.model;

import java.math.BigDecimal;
import java.time.LocalDate;

public class Rental {
    private int id;
    private int userId;
    private int carId;
    private LocalDate startDate;
    private LocalDate endDate;
    private BigDecimal totalCost;
    private String status;

    // For display purposes
    private String username;
    private String carName;

    public Rental() {
    }

    public Rental(int id, int userId, int carId, LocalDate startDate, LocalDate endDate,
                  BigDecimal totalCost, String status) {
        this.id = id;
        this.userId = userId;
        this.carId = carId;
        this.startDate = startDate;
        this.endDate = endDate;
        this.totalCost = totalCost;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getCarId() {
        return carId;
    }

    public void setCarId(int carId) {
        this.carId = carId;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }

    public BigDecimal getTotalCost() {
        return totalCost;
    }

    public void setTotalCost(BigDecimal totalCost) {
        this.totalCost = totalCost;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getCarName() {
        return carName;
    }

    public void setCarName(String carName) {
        this.carName = carName;
    }

    // Helper method to check if rental is active
    public boolean isActive() {
        return "ACTIVE".equalsIgnoreCase(status);
    }

    // Helper method to check if rental is completed
    public boolean isCompleted() {
        return "COMPLETED".equalsIgnoreCase(status);
    }

    // Helper method to check if rental is cancelled
    public boolean isCancelled() {
        return "CANCELLED".equalsIgnoreCase(status);
    }

    /**
     * Calculate the duration of the rental in days.
     * @return The number of days between start date and end date (inclusive)
     */
    public long getDurationInDays() {
        if (startDate != null && endDate != null) {
            return java.time.temporal.ChronoUnit.DAYS.between(startDate, endDate) + 1; // +1 to include end date
        }
        return 0;
    }

    @Override
    public String toString() {
        return "Rental{" +
                "id=" + id +
                ", userId=" + userId +
                ", carId=" + carId +
                ", startDate=" + startDate +
                ", endDate=" + endDate +
                ", totalCost=" + totalCost +
                ", status='" + status + '\'' +
                '}';
    }
}
