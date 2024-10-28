import formatNigerianPhoneNumber from './formatNigerianPhoneNumber';

import { parsePhoneNumber, isValidPhoneNumber } from 'libphonenumber-js';

function validatePhoneNumber(message) {
    const messageVal = message.trim();

    if (!messageVal) {
        return {
            isValid: false,
            error: 'Empty or invalid message received.'
        };
    }

    if (/[a-zA-Z]/.test(messageVal)) {
        return {
            isValid: false,
            error: 'Phone number should not contain letters.'
        };
    }

    try {
        const formattedNumber = formatNigerianPhoneNumber(messageVal);

        if (!isValidPhoneNumber(formattedNumber)) {
            //console.log('invalid')
            return {
                isValid: false,
                error: `Invalid phone number format: ${messageVal}`
            };
        }

        const phoneNumber = parsePhoneNumber(formattedNumber);

        //console.log(phoneNumber);

        const result = {
            isValid: true,
            originalInput: messageVal,
            formattedNumber: formattedNumber,
            phoneNumber: phoneNumber,
            country: phoneNumber.country || 'Unknown',
            nationalNumber: phoneNumber.nationalNumber,
            internationalFormat: phoneNumber.format('INTERNATIONAL')
        };

        //console.log('Phone number validation result:', result);

        return result;
    } catch (error) {
        //console.log(error)
        console.error('Error during phone number validation:', error.message);
        return {
            isValid: false,
            error: 'Error during phone number validation: ' + error.message
        };
    }
}

export default validatePhoneNumber;