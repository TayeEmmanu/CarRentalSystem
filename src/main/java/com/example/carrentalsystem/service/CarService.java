package com.example.carrentalsystem.service;

import com.example.carrentalsystem.dao.CarDAO;
import com.example.carrentalsystem.model.Car;

import java.util.List;
import java.util.Optional;

public class CarService {
    private final CarDAO carDAO = new CarDAO();

    public List<Car> getAllCars() {
        return carDAO.findAll();
    }

    public List<Car> getAvailableCars() {
        return carDAO.findAvailableCars();
    }

    public Optional<Car> getCarById(int id) {
        return carDAO.findById(id);
    }

    public void saveCar(Car car) {
        carDAO.save(car);
    }

    public void deleteCar(int id) {
        carDAO.delete(id);
    }

    public void updateCarAvailability(int carId, boolean available) {
        carDAO.updateAvailability(carId, available);
    }
}
