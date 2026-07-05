const mongoose = require('mongoose')

const tweetSchema = new mongoose.Schema({
    text: {
        type: String,
        required: true,
        trim: true
    },
    user: {
        type: String,
        required: true,
    },
    userName: {
        type: String,
        required: true,
        trim: true
    },
    image: {
        type: buffer
    },
    likes: {
        type: Array,
        default: []
    }
}, {
    timestamps: true
})

const Tweet = mongoose.model("Tweet", tweetSchema)

module.exports = Tweet