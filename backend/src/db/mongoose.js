const mongoose = require('mongoose')

mongoose.connect('mongodb://127.0.0.1:27017/twitter-clone-api')
    .then(() => {
        console.log('App connected to database');
    })
    .catch((error) => {
        console.log("Mongoose Error " + error.message);
    });