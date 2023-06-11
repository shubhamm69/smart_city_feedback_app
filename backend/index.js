const express = require('express');
const bodyParser = require('body-parser');

const app = express();

app.use(bodyParser.json());

// Data storage
let feedbackList = [];

app.get('/user-profile', (req, res) => {
    try {
        // Replace this with your logic to fetch the user profile from your data source or database
        const userProfile = {
            id: '1',
            name: 'John Doe',
            email: 'john.doe@example.com',
            phoneNumber: '+1 202-555-0123',
            address: '123 Main St, Washington, DC 20001',
            dateOfBirth: '1990-01-01',
            upvotes: 1,
            downvotes: 1,
        };

        res.json(userProfile); // Send the user profile as a JSON response
    } catch (error) {
        console.error('Error fetching user profile:', error);
        res.status(500).json({ error: 'Failed to fetch user profile' });
    }
});

app.get('/feedback-list', (req, res) => {
    try {
        res.json(feedbackList); // Send the feedback list as a JSON response
    } catch (error) {
        console.error('Error fetching feedback list:', error);
        res.status(500).json({ error: 'Failed to fetch feedback list' });
    }
});

app.post('/submit-feedback', (req, res) => {
    try {
        // Access the feedback data from the request body
        const { title, description, imageUrl } = req.body;

        // Replace this with your logic to save the feedback to your data storage or database
        // You can generate a unique ID for the feedback, store the provided fields, and assign a timestamp
        const feedback = {
            id: String(feedbackList.length + 1),
            title,
            description,
            imageUrl,
            timestamp: new Date().toISOString(),
        };

        feedbackList.push(feedback); // Add the feedback to the feedback list

        // Replace this with your logic to handle the feedback submission and provide an appropriate response
        res.status(201).json({ message: 'Feedback submitted successfully', feedback });
    } catch (error) {
        console.error('Error submitting feedback:', error);
        res.status(500).json({ error: 'Failed to submit feedback' });
    }
});

app.listen(3000, () => {
    console.log('Server started on port 3000');
});
