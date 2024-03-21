const express = require('express');
const multer = require('multer');
const cors = require('cors');
const path = require('path');
const fs = require('fs');
const http = require('http');

const app = express();
const PORT = 3000;

// Set up multer for file storage
const storage = multer.diskStorage({
    destination: (req, file, cb) => cb(null, '/data/'),
    filename: (req, file, cb) => cb(null, file.originalname),
});

// Initialize multer with the storage configuration
const upload = multer({ storage });

app.use(express.static('public'));

app.post('/test', upload.single('file'), (req, res) => {
    console.log(req.file); // You can perform operations on the file here.
	res.json({ message: 'File uploaded successfully via POST', file: req.file });
});

app.listen(PORT, () => {
    console.log(`Server running at http://localhost:${PORT}`);
});
