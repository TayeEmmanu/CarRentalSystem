package com.example.carrentalsystem.service;

import com.example.carrentalsystem.dao.RentalDAO;
import com.example.carrentalsystem.model.Car;
import com.example.carrentalsystem.model.Rental;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Optional;

public class RentalService {
    private final RentalDAO rentalDAO = new RentalDAO();
    private final CarService carService = new CarService();

    public List<Rental> getAllRentals() {
        return rentalDAO.findAll();
    }

    public List<Rental> getActiveRentals() {
        return rentalDAO.findActiveRentals();
    }

    public List<Rental> getRentalsByCustomerId(int customerId) {
        return rentalDAO.findRentalsByCustomerId(customerId);
    }

    public Optional<Rental> getRentalById(int id) {
        return rentalDAO.findById(id);
    }

    public void saveRental(Rental rental) {
        // Calculate total cost if not set
        if (rental.getTotalCost() == null || rental.getTotalCost().compareTo(BigDecimal.ZERO) == 0) {
            calculateTotalCost(rental);
        }

        rentalDAO.save(rental);
    }

    public void deleteRental(int id) {
        rentalDAO.delete(id);
    }

    public void completeRental(int id) {
        Optional<Rental> rentalOpt = rentalDAO.findById(id);
        if (rentalOpt.isPresent()) {
            Rental rental = rentalOpt.get();
            rental.setStatus("COMPLETED");
            rentalDAO.save(rental);

            // Make car available again
            carService.updateCarAvailability(rental.getCarId(), true);
        }
    }

    public void cancelRental(int id) {
        Optional<Rental> rentalOpt = rentalDAO.findById(id);
        if (rentalOpt.isPresent()) {
            Rental rental = rentalOpt.get();
            rental.setStatus("CANCELLED");
            rentalDAO.save(rental);

            // Make car available again
            carService.updateCarAvailability(rental.getCarId(), true);
        }
    }

    private void calculateTotalCost(Rental rental) {
        Optional<Car> carOpt = carService.getCarById(rental.getCarId());
        if (carOpt.isPresent()) {
            Car car = carOpt.get();
            long days = ChronoUnit.DAYS.between(rental.getStartDate(), rental.getEndDate()) + 1; // Include end date
            BigDecimal dailyRate = car.getDailyRate();
            BigDecimal totalCost = dailyRate.multiply(BigDecimal.valueOf(days));
            rental.setTotalCost(totalCost);
        }
    }
}
