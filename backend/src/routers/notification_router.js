const express = require('express')
const Notification = require('../models/notification')
const auth = require('../middleware/auth')
const multer = require('multer');
const sharp = require('sharp');

// Original Router
const router = new express.Router()

router.post('/notifications', auth, async (req, res) => {
    try {
        const notification = new Notification({
            ...req.body,
            user: req.user._id
        })
        await notification.save()
        res.status(200).send(notification)
    } catch (error) {
        return res.status(500).send(error.message)
    }
})

router.get('/notifications/:id', async (req, res) => {
    try {
        const id = req.params.id
        const notifications = await Notification.find({ receiverId: id })
        return res.status(200).send(notifications)
    } catch (error) {
        return res.status(500).send(error.message)
    }
})

module.exports = router

