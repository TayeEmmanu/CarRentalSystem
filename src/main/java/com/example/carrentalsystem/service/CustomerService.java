package com.example.carrentalsystem.service;

import com.example.carrentalsystem.dao.CustomerDAO;
import com.example.carrentalsystem.model.Customer;

import java.util.List;
import java.util.Optional;

public class CustomerService {
    private final CustomerDAO customerDAO = new CustomerDAO();

    public List<Customer> getAllCustomers() {
        return customerDAO.findAll();
    }

    public Optional<Customer> getCustomerById(int id) {
        return customerDAO.findById(id);
    }

    public Optional<Customer> getCustomerByEmail(String email) {
        return customerDAO.findByEmail(email);
    }

    public void saveCustomer(Customer customer) {
        customerDAO.save(customer);
    }

    public void deleteCustomer(int id) {
        customerDAO.delete(id);
    }
}
