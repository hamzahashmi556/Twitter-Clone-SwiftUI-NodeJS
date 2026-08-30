const mongoose = require('mongoose')

const notificationSchema = new mongoose.Schema({
    text: {
        type: String
    },
    userName: {
        type: String,
        required: true
    },
    senderId: {
        type: mongoose.Schema.ObjectId,
        ref: 'User',
        required: true
    },
    receiverId: {
        type: mongoose.Schema.ObjectId,
        ref: 'User',
        required: true
    },
    notificationType: {
        type: String,
    }
})

const Notification = mongoose.model("Notification", notificationSchema)

module.exports = Notification