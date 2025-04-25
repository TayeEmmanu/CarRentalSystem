package com.example.carrentalsystem.service;

import com.example.carrentalsystem.dao.SystemLogDAO;
import com.example.carrentalsystem.model.SystemLog;

import java.util.List;

public class SystemLogService {

    private SystemLogDAO systemLogDAO;

    public SystemLogService() {
        this.systemLogDAO = new SystemLogDAO();
    }

    public SystemLogService(SystemLogDAO systemLogDAO) {
        this.systemLogDAO = systemLogDAO;
    }

    public SystemLog getLogById(int id) {
        return systemLogDAO.findById(id);
    }

    public List<SystemLog> getAllLogs() {
        return systemLogDAO.findAll();
    }

    public List<SystemLog> getLogsByLevel(String level) {
        return systemLogDAO.findByLevel(level);
    }

    public int createLog(SystemLog log) {
        return systemLogDAO.save(log);
    }

    public boolean deleteAllLogs() {
        return systemLogDAO.deleteAll();
    }

    public boolean deleteLog(int id) {
        return systemLogDAO.deleteById(id);
    }
}
