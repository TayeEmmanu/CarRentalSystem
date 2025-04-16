<%--
  Created by IntelliJ IDEA.
  User: oldst
  Date: 2025-04-14
  Time: 10:11 p.m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>System Administration - Car Rental System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="../common/header.jsp" />

<main>
    <div class="container">
        <h1>System Administration</h1>

        <c:if test="${not empty sessionScope.success}">
            <div class="success-message">
                <p>${sessionScope.success}</p>
            </div>
            <c:remove var="success" scope="session" />
        </c:if>

        <c:if test="${not empty sessionScope.error}">
            <div class="error-message">
                <p>${sessionScope.error}</p>
            </div>
            <c:remove var="error" scope="session" />
        </c:if>

        <div class="admin-tabs">
            <div class="tab-navigation">
                <button class="tab-btn active" data-tab="general">General Settings</button>
                <button class="tab-btn" data-tab="security">Security Settings</button>
                <button class="tab-btn" data-tab="email">Email Settings</button>
                <button class="tab-btn" data-tab="backup">Backup & Restore</button>
                <button class="tab-btn" data-tab="logs">System Logs</button>
            </div>

            <div class="tab-content">
                <!-- General Settings Tab -->
                <div class="tab-pane active" id="general-tab">
                    <h2>General Settings</h2>

                    <form action="${pageContext.request.contextPath}/admin/system/save-general" method="post" class="settings-form">
                        <div class="form-group">
                            <label for="companyName">Company Name</label>
                            <input type="text" id="companyName" name="companyName" value="Car Rental System" required>
                        </div>

                        <div class="form-group">
                            <label for="contactEmail">Contact Email</label>
                            <input type="email" id="contactEmail" name="contactEmail" value="info@carrentalsystem.com" required>
                        </div>

                        <div class="form-group">
                            <label for="contactPhone">Contact Phone</label>
                            <input type="text" id="contactPhone" name="contactPhone" value="+1 (555) 123-4567" required>
                        </div>

                        <div class="form-group">
                            <label for="address">Business Address</label>
                            <textarea id="address" name="address" rows="3" required>123 Main St, City, Country</textarea>
                        </div>

                        <div class="form-group">
                            <label for="currency">Currency</label>
                            <select id="currency" name="currency">
                                <option value="USD" selected>USD ($)</option>
                                <option value="EUR">EUR (€)</option>
                                <option value="GBP">GBP (£)</option>
                                <option value="CAD">CAD ($)</option>
                            </select>
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary">Save Changes</button>
                        </div>
                    </form>
                </div>

                <!-- Security Settings Tab -->
                <div class="tab-pane" id="security-tab">
                    <h2>Security Settings</h2>

                    <form action="${pageContext.request.contextPath}/admin/system/save-security" method="post" class="settings-form">
                        <div class="form-group">
                            <label for="passwordPolicy">Password Policy</label>
                            <select id="passwordPolicy" name="passwordPolicy">
                                <option value="basic">Basic (8+ characters)</option>
                                <option value="medium" selected>Medium (8+ chars, letters & numbers)</option>
                                <option value="strong">Strong (8+ chars, letters, numbers & symbols)</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="sessionTimeout">Session Timeout (minutes)</label>
                            <input type="number" id="sessionTimeout" name="sessionTimeout" value="30" min="5" max="120" required>
                        </div>

                        <div class="form-group checkbox-group">
                            <input type="checkbox" id="enableTwoFactor" name="enableTwoFactor">
                            <label for="enableTwoFactor">Enable Two-Factor Authentication</label>
                        </div>

                        <div class="form-group checkbox-group">
                            <input type="checkbox" id="requireEmailVerification" name="requireEmailVerification" checked>
                            <label for="requireEmailVerification">Require Email Verification for New Accounts</label>
                        </div>

                        <div class="form-group checkbox-group">
                            <input type="checkbox" id="lockFailedLogins" name="lockFailedLogins" checked>
                            <label for="lockFailedLogins">Lock Account After 5 Failed Login Attempts</label>
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary">Save Changes</button>
                        </div>
                    </form>
                </div>

                <!-- Email Settings Tab -->
                <div class="tab-pane" id="email-tab">
                    <h2>Email Settings</h2>

                    <form action="${pageContext.request.contextPath}/admin/system/save-email" method="post" class="settings-form">
                        <div class="form-group">
                            <label for="smtpServer">SMTP Server</label>
                            <input type="text" id="smtpServer" name="smtpServer" value="smtp.example.com" required>
                        </div>

                        <div class="form-group">
                            <label for="smtpPort">SMTP Port</label>
                            <input type="number" id="smtpPort" name="smtpPort" value="587" required>
                        </div>

                        <div class="form-group">
                            <label for="smtpUsername">SMTP Username</label>
                            <input type="text" id="smtpUsername" name="smtpUsername" value="noreply@carrentalsystem.com" required>
                        </div>

                        <div class="form-group">
                            <label for="smtpPassword">SMTP Password</label>
                            <input type="password" id="smtpPassword" name="smtpPassword" value="********" required>
                        </div>

                        <div class="form-group checkbox-group">
                            <input type="checkbox" id="enableSsl" name="enableSsl" checked>
                            <label for="enableSsl">Enable SSL/TLS</label>
                        </div>

                        <div class="form-group">
                            <label for="fromEmail">From Email</label>
                            <input type="email" id="fromEmail" name="fromEmail" value="noreply@carrentalsystem.com" required>
                        </div>

                        <div class="form-group">
                            <label for="fromName">From Name</label>
                            <input type="text" id="fromName" name="fromName" value="Car Rental System" required>
                        </div>

                        <div class="form-actions">
                            <button type="button" class="btn btn-secondary">Test Connection</button>
                            <button type="submit" class="btn btn-primary">Save Changes</button>
                        </div>
                    </form>
                </div>

                <!-- Backup & Restore Tab -->
                <div class="tab-pane" id="backup-tab">
                    <h2>Backup & Restore</h2>

                    <div class="backup-section">
                        <h3>Create Backup</h3>
                        <p>Create a backup of the entire database. This includes all users, cars, customers, and rental data.</p>
                        <form action="${pageContext.request.contextPath}/admin/system/backup" method="post">
                            <div class="form-actions">
                                <button type="submit" class="btn btn-primary">Create Backup</button>
                            </div>
                        </form>
                    </div>

                    <div class="backup-section">
                        <h3>Backup History</h3>
                        <table class="data-table">
                            <thead>
                            <tr>
                                <th>Date</th>
                                <th>Size</th>
                                <th>Created By</th>
                                <th>Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td>2023-04-15 09:30:22</td>
                                <td>2.4 MB</td>
                                <td>admin</td>
                                <td>
                                    <button class="btn btn-small">Download</button>
                                    <button class="btn btn-small btn-warning">Restore</button>
                                    <button class="btn btn-small btn-danger">Delete</button>
                                </td>
                            </tr>
                            <tr>
                                <td>2023-04-01 14:15:07</td>
                                <td>2.3 MB</td>
                                <td>admin</td>
                                <td>
                                    <button class="btn btn-small">Download</button>
                                    <button class="btn btn-small btn-warning">Restore</button>
                                    <button class="btn btn-small btn-danger">Delete</button>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="backup-section">
                        <h3>Restore from File</h3>
                        <p>Restore the database from a backup file. This will overwrite all current data.</p>
                        <form action="${pageContext.request.contextPath}/admin/system/restore" method="post" enctype="multipart/form-data">
                            <div class="form-group">
                                <label for="backupFile">Backup File</label>
                                <input type="file" id="backupFile" name="backupFile" required>
                            </div>
                            <div class="form-actions">
                                <button type="submit" class="btn btn-warning">Restore Database</button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- System Logs Tab -->
                <div class="tab-pane" id="logs-tab">
                    <h2>System Logs</h2>

                    <div class="log-filters">
                        <div class="form-group">
                            <label for="logLevel">Log Level</label>
                            <select id="logLevel">
                                <option value="all">All Levels</option>
                                <option value="info">Info</option>
                                <option value="warning">Warning</option>
                                <option value="error">Error</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="logDate">Date</label>
                            <input type="date" id="logDate">
                        </div>

                        <div class="form-group">
                            <label for="logSearch">Search</label>
                            <input type="text" id="logSearch" placeholder="Search logs...">
                        </div>

                        <button class="btn btn-secondary">Apply Filters</button>
                    </div>

                    <div class="log-viewer">
                        <div class="log-entry info">
                            <span class="log-time">2023-04-15 10:23:45</span>
                            <span class="log-level info">INFO</span>
                            <span class="log-message">User 'admin' logged in successfully</span>
                        </div>
                        <div class="log-entry warning">
                            <span class="log-time">2023-04-15 09:45:12</span>
                            <span class="log-level warning">WARNING</span>
                            <span class="log-message">Failed login attempt for user 'john'</span>
                        </div>
                        <div class="log-entry error">
                            <span class="log-time">2023-04-15 08:30:22</span>
                            <span class="log-level error">ERROR</span>
                            <span class="log-message">Database connection failed: Connection timeout</span>
                        </div>
                        <div class="log-entry info">
                            <span class="log-time">2023-04-15 08:15:07</span>
                            <span class="log-level info">INFO</span>
                            <span class="log-message">System backup completed successfully</span>
                        </div>
                    </div>

                    <div class="log-actions">
                        <button class="btn btn-secondary">Download Logs</button>
                        <button class="btn btn-danger">Clear Logs</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const tabButtons = document.querySelectorAll('.tab-btn');
        const tabPanes = document.querySelectorAll('.tab-pane');

        tabButtons.forEach(button => {
            button.addEventListener('click', function() {
                // Remove active class from all buttons and panes
                tabButtons.forEach(btn => btn.classList.remove('active'));
                tabPanes.forEach(pane => pane.classList.remove('active'));

                // Add active class to clicked button
                this.classList.add('active');

                // Show the corresponding tab pane
                const tabId = this.getAttribute('data-tab');
                document.getElementById(tabId + '-tab').classList.add('active');
            });
        });
    });
</script>

<style>
    .admin-tabs {
        background-color: #fff;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        margin-top: 20px;
        overflow: hidden;
    }

    .tab-navigation {
        display: flex;
        overflow-x: auto;
        background-color: #f5f5f5;
        border-bottom: 1px solid #ddd;
    }

    .tab-btn {
        padding: 15px 20px;
        background: none;
        border: none;
        cursor: pointer;
        font-weight: 500;
        color: #555;
        white-space: nowrap;
        border-bottom: 3px solid transparent;
        transition: all 0.3s ease;
    }

    .tab-btn:hover {
        background-color: #e0e0e0;
        color: #333;
    }

    .tab-btn.active {
        background-color: #fff;
        color: #3498db;
        border-bottom-color: #3498db;
    }

    .tab-content {
        padding: 20px;
    }

    .tab-pane {
        display: none;
    }

    .tab-pane.active {
        display: block;
    }

    .settings-form {
        max-width: 800px;
    }

    .backup-section {
        margin-bottom: 30px;
        padding-bottom: 30px;
        border-bottom: 1px solid #eee;
    }

    .backup-section:last-child {
        border-bottom: none;
        margin-bottom: 0;
        padding-bottom: 0;
    }

    .log-filters {
        display: flex;
        flex-wrap: wrap;
        gap: 15px;
        align-items: flex-end;
        margin-bottom: 20px;
        padding: 15px;
        background-color: #f9f9f9;
        border-radius: 8px;
    }

    .log-viewer {
        background-color: #f5f5f5;
        border: 1px solid #ddd;
        border-radius: 4px;
        padding: 10px;
        height: 400px;
        overflow-y: auto;
        font-family: monospace;
        margin-bottom: 20px;
    }

    .log-entry {
        padding: 8px;
        margin-bottom: 5px;
        border-radius: 4px;
        display: flex;
    }

    .log-time {
        flex: 0 0 180px;
        color: #666;
    }

    .log-level {
        flex: 0 0 80px;
        font-weight: bold;
        text-align: center;
        border-radius: 4px;
        margin-right: 10px;
    }

    .log-level.info {
        background-color: #e3f2fd;
        color: #1565c0;
    }

    .log-level.warning {
        background-color: #fff8e1;
        color: #ff8f00;
    }

    .log-level.error {
        background-color: #ffebee;
        color: #c62828;
    }

    .log-message {
        flex: 1;
    }

    .log-actions {
        display: flex;
        justify-content: flex-end;
        gap: 10px;
    }
</style>
</body>
</html>

