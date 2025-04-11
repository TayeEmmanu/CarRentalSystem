/**
 * Car Rental System - Common JavaScript Functions
 */

document.addEventListener('DOMContentLoaded', function() {
    // Initialize all components that need JavaScript functionality
    initializeFormValidation();
    initializeDeleteConfirmations();
    initializeDatePickers();
    initializeStatusIndicators();
});

/**
 * Form Validation
 */
function initializeFormValidation() {
    // Get all forms with the 'needs-validation' class
    const forms = document.querySelectorAll('.needs-validation');

    // Loop over them and prevent submission if validation fails
    Array.from(forms).forEach(form => {
        form.addEventListener('submit', event => {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }

            form.classList.add('was-validated');
        }, false);
    });
}

/**
 * Delete Confirmations
 */
function initializeDeleteConfirmations() {
    // Add confirmation to all delete buttons/links
    const deleteButtons = document.querySelectorAll('.btn-delete, [data-action="delete"]');

    deleteButtons.forEach(button => {
        button.addEventListener('click', function(event) {
            const itemType = this.dataset.itemType || 'item';
            const confirmMessage = `Are you sure you want to delete this ${itemType}?`;

            if (!confirm(confirmMessage)) {
                event.preventDefault();
                event.stopPropagation();
            }
        });
    });
}

/**
 * Date Pickers
 */
function initializeDatePickers() {
    // Set min date for all date inputs with the 'future-date' class to today
    const futureDateInputs = document.querySelectorAll('input[type="date"].future-date');
    const today = new Date().toISOString().split('T')[0]; // Format: YYYY-MM-DD

    futureDateInputs.forEach(input => {
        input.min = today;
    });

    // Link start and end date inputs
    const startDateInputs = document.querySelectorAll('input[type="date"].start-date');

    startDateInputs.forEach(startInput => {
        const formGroup = startInput.closest('.form-group, .form-row, form');
        const endInput = formGroup ? formGroup.querySelector('input[type="date"].end-date') : null;

        if (endInput) {
            startInput.addEventListener('change', function() {
                endInput.min = this.value;
                if (endInput.value && endInput.value < this.value) {
                    endInput.value = this.value;
                }
            });
        }
    });
}

/**
 * Status Indicators
 */
function initializeStatusIndicators() {
    // Add tooltips to status indicators
    const statusIndicators = document.querySelectorAll('.status-indicator');

    statusIndicators.forEach(indicator => {
        indicator.title = indicator.textContent.trim();
    });
}

/**
 * Format currency
 * @param {number} amount - The amount to format
 * @param {string} currencyCode - The currency code (default: USD)
 * @returns {string} Formatted currency string
 */
function formatCurrency(amount, currencyCode = 'USD') {
    return new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: currencyCode
    }).format(amount);
}

/**
 * Calculate date difference in days
 * @param {Date|string} startDate - The start date
 * @param {Date|string} endDate - The end date
 * @param {boolean} inclusive - Whether to include both start and end dates in the count
 * @returns {number} Number of days between dates
 */
function calculateDateDifference(startDate, endDate, inclusive = true) {
    const start = startDate instanceof Date ? startDate : new Date(startDate);
    const end = endDate instanceof Date ? endDate : new Date(endDate);

    // Reset time part to ensure accurate day calculation
    start.setHours(0, 0, 0, 0);
    end.setHours(0, 0, 0, 0);

    // Calculate difference in days
    const diffTime = Math.abs(end - start);
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

    // Add 1 if inclusive (counting both start and end dates)
    return inclusive ? diffDays + 1 : diffDays;
}

/**
 * Calculate rental cost
 * @param {number} dailyRate - The daily rate
 * @param {Date|string} startDate - The start date
 * @param {Date|string} endDate - The end date
 * @returns {number} Total rental cost
 */
function calculateRentalCost(dailyRate, startDate, endDate) {
    const days = calculateDateDifference(startDate, endDate, true);
    return dailyRate * days;
}

/**
 * Validate form input
 * @param {HTMLInputElement} input - The input element to validate
 * @returns {boolean} Whether the input is valid
 */
function validateInput(input) {
    // Check if the input is required and empty
    if (input.required && !input.value.trim()) {
        showError(input, 'This field is required');
        return false;
    }

    // Validate email format
    if (input.type === 'email' && input.value.trim()) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(input.value.trim())) {
            showError(input, 'Please enter a valid email address');
            return false;
        }
    }

    // Validate phone format
    if (input.dataset.type === 'phone' && input.value.trim()) {
        const phoneRegex = /^\d{3}-\d{3}-\d{4}$/;
        if (!phoneRegex.test(input.value.trim())) {
            showError(input, 'Please enter a valid phone number (format: 555-123-4567)');
            return false;
        }
    }

    // Validate number range
    if (input.type === 'number') {
        const value = parseFloat(input.value);
        const min = parseFloat(input.min);
        const max = parseFloat(input.max);

        if (!isNaN(min) && value < min) {
            showError(input, `Value must be at least ${min}`);
            return false;
        }

        if (!isNaN(max) && value > max) {
            showError(input, `Value must be at most ${max}`);
            return false;
        }
    }

    // Validate date range
    if (input.type === 'date') {
        const value = new Date(input.value);
        const min = input.min ? new Date(input.min) : null;
        const max = input.max ? new Date(input.max) : null;

        if (min && value < min) {
            showError(input, `Date must be on or after ${input.min}`);
            return false;
        }

        if (max && value > max) {
            showError(input, `Date must be on or before ${input.max}`);
            return false;
        }
    }

    // Clear any previous error
    clearError(input);
    return true;
}

/**
 * Show error message for an input
 * @param {HTMLInputElement} input - The input element
 * @param {string} message - The error message
 */
function showError(input, message) {
    // Clear any existing error
    clearError(input);

    // Add error class to input
    input.classList.add('is-invalid');

    // Create error message element
    const errorElement = document.createElement('div');
    errorElement.className = 'invalid-feedback';
    errorElement.textContent = message;

    // Insert error message after input
    input.parentNode.insertBefore(errorElement, input.nextSibling);
}

/**
 * Clear error message for an input
 * @param {HTMLInputElement} input - The input element
 */
function clearError(input) {
    // Remove error class
    input.classList.remove('is-invalid');

    // Remove any existing error message
    const errorElement = input.nextElementSibling;
    if (errorElement && errorElement.className === 'invalid-feedback') {
        errorElement.remove();
    }
}

/**
 * Confirm action with a custom message
 * @param {string} message - The confirmation message
 * @param {Function} onConfirm - Function to call if confirmed
 * @param {Function} onCancel - Function to call if cancelled
 */
function confirmAction(message, onConfirm, onCancel) {
    if (confirm(message)) {
        if (typeof onConfirm === 'function') {
            onConfirm();
        }
    } else {
        if (typeof onCancel === 'function') {
            onCancel();
        }
    }
}

/**
 * Create a POST form and submit it
 * @param {string} action - The form action URL
 * @param {Object} data - The form data as key-value pairs
 */
function submitPostForm(action, data = {}) {
    // Create form
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = action;
    form.style.display = 'none';

    // Add form fields
    for (const key in data) {
        if (data.hasOwnProperty(key)) {
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = key;
            input.value = data[key];
            form.appendChild(input);
        }
    }

    // Add form to document and submit
    document.body.appendChild(form);
    form.submit();
}