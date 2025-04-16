package com.example.carrentalsystem.service;

import com.example.carrentalsystem.model.User;
import com.example.carrentalsystem.dao.UserDAO;
import com.example.carrentalsystem.util.PasswordUtil;

import java.util.List;

public class UserService {
    private final UserDAO userDAO;

    public UserService() {
        this.userDAO = new UserDAO();
    }

    public List<User> getAllUsers() {
        return userDAO.findAll();
    }

    public User getUserById(int id) {
        return userDAO.findById(id);
    }

    public User getUserByUsername(String username) {
        return userDAO.findByUsername(username);
    }

    public User getUserByEmail(String email) {
        return userDAO.findByEmail(email);
    }

    public boolean registerUser(User user, String plainPassword) {
        // Check if username or email already exists
        if (userDAO.findByUsername(user.getUsername()) != null) {
            return false; // Username already exists
        }

        if (userDAO.findByEmail(user.getEmail()) != null) {
            return false; // Email already exists
        }

        // Hash the password
        String passwordHash = PasswordUtil.hashPassword(plainPassword);
        user.setPasswordHash(passwordHash);

        // Save the user
        return userDAO.save(user);
    }

    public User authenticateUser(String username, String password) {
        User user = userDAO.findByUsername(username);

        if (user != null && user.isActive() && PasswordUtil.verifyPassword(password, user.getPasswordHash())) {
            // Update last login time
            userDAO.updateLastLogin(user.getId());
            return user;
        }

        return null; // Authentication failed
    }

    public boolean updateUser(User user) {
        return userDAO.save(user);
    }

    public boolean updatePassword(int userId, String newPassword) {
        User user = userDAO.findById(userId);

        if (user != null) {
            String passwordHash = PasswordUtil.hashPassword(newPassword);
            user.setPasswordHash(passwordHash);
            return userDAO.save(user);
        }

        return false;
    }

    public boolean deleteUser(int id) {
        return userDAO.delete(id);
    }

    public boolean changeUserRole(int userId, String newRole) {
        User user = userDAO.findById(userId);

        if (user != null) {
            user.setRole(newRole);
            return userDAO.save(user);
        }

        return false;
    }

    public boolean toggleUserActive(int userId) {
        User user = userDAO.findById(userId);

        if (user != null) {
            user.setActive(!user.isActive());
            return userDAO.save(user);
        }

        return false;
    }

}
