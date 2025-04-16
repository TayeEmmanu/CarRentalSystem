package com.example.carrentalsystem.model;

import java.time.LocalDateTime;
public class User {
    private int id;
    private String username;
    private String email;
    private String passwordHash;
    private String role; // ADMIN, STAFF, CUSTOMER
    private LocalDateTime createdAt;
    private LocalDateTime lastLogin;
    private boolean active;

    // Default constructor
    public User() {
        this.createdAt = LocalDateTime.now();
        this.active = true;
        this.role = "CUSTOMER"; // Default role
    }

    // Constructor with fields
    public User(String username, String email, String passwordHash) {
        this.username = username;
        this.email = email;
        this.passwordHash = passwordHash;
        this.createdAt = LocalDateTime.now();
        this.active = true;
        this.role = "CUSTOMER"; // Default role
    }

    // Constructor with role
    public User(String username, String email, String passwordHash, String role) {
        this.username = username;
        this.email = email;
        this.passwordHash = passwordHash;
        this.role = role;
        this.createdAt = LocalDateTime.now();
        this.active = true;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getLastLogin() {
        return lastLogin;
    }

    public void setLastLogin(LocalDateTime lastLogin) {
        this.lastLogin = lastLogin;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    // Role-based permission checks
    public boolean isAdmin() {
        return "ADMIN".equals(role);
    }

    public boolean isStaff() {
        return "STAFF".equals(role) || isAdmin();
    }

    public boolean isCustomer() {
        return "CUSTOMER".equals(role);
    }

    @Override
    public String toString() {
        return "User{" + "id=" + id + ", username='" + username + '\'' + ", email='" + email + '\'' + ", role='" + role + '\'' + '}';
    }
}
