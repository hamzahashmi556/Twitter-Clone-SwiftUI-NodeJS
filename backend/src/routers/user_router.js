const express = require('express')
const User = require("../models/user")
const multer = require('multer');
const sharp = require('sharp');

// Original Router
const router = new express.Router()

// Helpers
const upload = multer({
    limits: {
        fileSize: 1000000000
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
router.post('/users/me/avatar', upload.single('avatar'), async (req, res) => {
    // try {
    // console.log("uploading picture start")
    // const user = await User.findById(req.params.id)

    // if (!user) {
    //     return res.status(404).send('No User Found')
    // }

    // if (!req.file) {
    //     return res.status(400).send('Please upload an image')
    // }

    // console.log("user record found")

    const buffer = await sharp(req.file.buffer)
        .resize({ width: 250, height: 250 })
        .png()
        .toBuffer()

    // console.log("buffer multipart form completed")


    // user.avatar = buffer
    // user.avatarExists = true
    // await user.save()

    // console.log("user record found")

    res.send(buffer)
    // } catch (e) {
    //     res.status(400).send(e.message)
    // }
}, (error, req, res, next) => {
    console.log("error uploading field " + error.message)
    res.status(400).send({ error: error })
})

module.exports = router
