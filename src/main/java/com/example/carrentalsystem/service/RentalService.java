package com.example.carrentalsystem.service;

import com.example.carrentalsystem.dao.RentalDAO;
import com.example.carrentalsystem.model.Rental;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;
import java.util.Optional;

public class RentalService {
    private static final Logger logger = LoggerFactory.getLogger(RentalService.class);
    private final RentalDAO rentalDAO = new RentalDAO();
    private final CarService carService = new CarService();

    public List<Rental> getAllRentals() {
        return rentalDAO.findAll();
    }

    public Optional<Rental> getRentalById(int id) {
        return rentalDAO.findById(id);
    }

    public List<Rental> getRentalsByUserId(int userId) {
        return rentalDAO.findByUserId(userId);
    }

    public boolean saveRental(Rental rental) {
        boolean success = rentalDAO.save(rental);

        // Update car availability if rental is active
        if (success && "ACTIVE".equals(rental.getStatus())) {
            carService.updateCarAvailability(rental.getCarId(), false);
        }

        return success;
    }

    public boolean deleteRental(int id) {
        Optional<Rental> rental = getRentalById(id);
        if (rental.isPresent() && "ACTIVE".equals(rental.get().getStatus())) {
            // Make car available again if rental was active
            carService.updateCarAvailability(rental.get().getCarId(), true);
        }
        return rentalDAO.delete(id);
    }

    public boolean completeRental(int id) {
        Optional<Rental> rentalOpt = getRentalById(id);
        if (rentalOpt.isPresent()) {
            boolean success = rentalDAO.completeRental(id);

            if (success) {
                // Make car available again
                carService.updateCarAvailability(rentalOpt.get().getCarId(), true);

                logger.info("Rental {} completed successfully", id);
                return true;
            } else {
                logger.error("Failed to complete rental with ID {}", id);
                return false;
            }
        } else {
            logger.error("Failed to complete rental: Rental with ID {} not found", id);
            return false;
        }
    }

    public boolean cancelRental(int id) {
        Optional<Rental> rentalOpt = getRentalById(id);
        if (rentalOpt.isPresent()) {
            boolean success = rentalDAO.cancelRental(id);

            if (success) {
                // Make car available again
                carService.updateCarAvailability(rentalOpt.get().getCarId(), true);

                logger.info("Rental {} cancelled successfully", id);
                return true;
            } else {
                logger.error("Failed to cancel rental with ID {}", id);
                return false;
            }
        } else {
            logger.error("Failed to cancel rental: Rental with ID {} not found", id);
            return false;
        }
    }
}
