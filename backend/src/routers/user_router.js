const express = require('express')
const User = require("../models/user")
const multer = require('multer');
const sharp = require('sharp');
const auth = require('../middleware/auth')

// Original Router
const router = new express.Router()

// Helpers
const upload = multer({
    limits: {
        fileSize: 100000000
    }
})

// Create the User
router.post("/users", async (req, res) => {
    try {
        const user = new User(req.body)
        await user.save()
        res.status(201).send(user)
    } catch (error) {
        res.status(400).send(error.toString())
        console.log(error);

    }
})

// Fetch The Users
router.get("/users", async (req, res) => {
    try {
        const users = await User.find()
        res.send(users)
    }
    catch (e) {
        res.status.status(500).send(e.toString())
    }
})

// Login User Router
router.post('/users/login', async (req, res) => {
    try {
        const email = req.body.email
        const password = req.body.password
        const user = await User.findByCredentials(email, password)
        const token = await user.generateAuthToken()
        res.send({ user, token })
    }
    catch (e) {
        res.status(500).send(e)
        console.log(e)
    }
})

// Delete User Route
router.post('/users/:id', async (req, res) => {
    try {
        const id = req.params.id
        console.log('User id to delete ' + id)
        const user = await User.findByIdAndDelete(id)

        if (!user) {
            return res.status(400).send("No User Found to Delete")
        }
        res.send("user deleted")
    }
    catch (e) {
        console.log(e)
        res.status(500).send(e)
    }
})

// Find User
router.get('/users/:id', async (req, res) => {
    try {
        const id = req.params.id
        const user = await User.findById(id)

        if (!user) {
            return res.status(400).send('No User Found')
        }

        return res.send(user)
    }
    catch (e) {
        res.status(500).send(e)
    }
})

// Upload User Picture
router.post('/users/me/avatar', auth, upload.single('avatar'), async (req, res) => {
    console.log("uploading picture start")
    if (!req.file) {
        console.log("Please upload an image")
        return res.status(400).send('Please upload an image')
    }
    if (!req.file.buffer) {
        console.log("File corrupted no buffer found for image")
        return res.status(400).send("File corrupted no buffer found for image")
    }
    try {
        const bufferRaw = req.file.buffer
        console.log('buffer ' + bufferRaw)
        const buffer = await sharp(bufferRaw)
            .resize({ width: 250, height: 250 })
            .png()
            .toBuffer()

        console.log("buffer multipart form completed")
        req.user.avatar = buffer
        req.user.avatarExists = true
        await req.user.save()

        console.log("user record saved")
        res.send({ "message": 'Image Updated Successfully :)' })
    }
    catch (error) {
        res.status(400).send({ error: error.message })
    }
}, (error, req, res, next) => {
    console.log("error uploading field " + error.message)
    res.status(400).send({ error: error.message })
})

// Get Profile Picture
router.get('/users/:id/avatar', async (req, res) => {
    try {
        const user = await User.findById(req.params.id)
        if (!user) {
            throw new Error("The User does not exist")
        }
        else if (!user.avatar) {
            return res.status(404).send({ "user": user, "error": "no avatar" })
            // throw new Error("The User does not have profile picture")
        }
        res.set('Content-Type', 'image/jpg')
        res.send(user.avatar)
    }
    catch (error) {
        res.status(404).send(error.message)
    }
})

// Route for following
router.put('/users/:id/follow', auth, async (req, res) => {
    const myId = req.user.id
    const userId = req.params.id
    console.log('user id 1 ' + myId)
    console.log('user id 2 ' + userId)
    if (myId != userId) {
        try {
            const user = await User.findById(userId)
            if (!user.followers.includes(myId)) {
                // insert my id in his followers
                await user.updateOne({ $push: { followers: myId } })
                // insert his id in my following
                await req.user.updateOne({ $push: { followings: userId } })
                res.status(200).send('you followed ' + user.name)
            }
            else {
                res.status(403).send('you aree already following ' + user.name)
            }

        }
        catch (error) {
            res.status(500).json(error)
        }
    } else {
        res.status(403).send('Cannot unfollow your own user')
    }
})

// Unfollow User
router.put('/users/:id/unfollow', auth, async (req, res) => {
    const myId = req.user.id
    const userId = req.params.id
    console.log('user id 1 ' + myId)
    console.log('user id 2 ' + userId)
    if (myId != userId) {
        try {
            const user = await User.findById(userId)
            if (user.followers.includes(myId)) {
                // remove my id in his followers
                await user.updateOne({ $pull: { followers: myId } })
                // remove his id in my following
                await req.user.updateOne({ $pull: { followings: userId } })
                res.status(200).send('you unfollowed ' + user.name)
            }
            else {
                res.status(403).send('cannot unfollow, you don\'t follow ' + user.name)
            }

        }
        catch (error) {
            res.status(500).json(error)
        }
    } else {
        res.status(400).send('Cannot unfollow your own id')
    }
})

// Update User
router.patch('/users/:id', auth, async (req, res) => {
    const updates = Object.keys(req.body)
    console.log(updates)

    const allowedUpdates = ['name', 'email', 'password', 'bio', 'website', 'location']
    const isValidOperation = updates.every((update) => allowedUpdates.includes(update))

    if (!isValidOperation) {
        return res.status(400).send({
            error: "Invalid Request!"
        })
    }
    const user = req.user
    updates.forEach((update) => {
        user[update] = req.body[update]
    })
    try {
        await user.save()
        res.status(200).send(user)
    }
    catch (error) {
        res.status(400).json(error)
    }
})

module.exports = router
