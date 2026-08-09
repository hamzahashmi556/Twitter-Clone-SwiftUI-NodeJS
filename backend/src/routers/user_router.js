const express = require('express')
const User = require("../models/user")

const router = new express.Router()


// Create the User
router.post("/users", async (req, res) => {
    try {
        const user = new User(req.body)
        await user.save()
        res.status(201).send(user)
    } catch (error) {
        res.status(400).send(error)
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
        res.status.status(500).send(e)
    }
})

module.exports = router
