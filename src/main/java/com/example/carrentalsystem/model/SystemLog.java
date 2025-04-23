package com.example.carrentalsystem.model;

import java.util.Date;

public class SystemLog {
    private int id;
    private Date timestamp;
    private String level;
    private String message;
    private Integer userId;
    private String ipAddress;

    // For display purposes
    private String username;

    public SystemLog() {
    }

    public SystemLog(int id, Date timestamp, String level, String message, Integer userId, String ipAddress) {
        this.id = id;
        this.timestamp = timestamp;
        this.level = level;
        this.message = message;
        this.userId = userId;
        this.ipAddress = ipAddress;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Date getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Date timestamp) {
        this.timestamp = timestamp;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    @Override
    public String toString() {
        return "SystemLog{" +
                "id=" + id +
                ", timestamp=" + timestamp +
                ", level='" + level + '\'' +
                ", message='" + message + '\'' +
                ", userId=" + userId +
                ", ipAddress='" + ipAddress + '\'' +
                '}';
    }
}
