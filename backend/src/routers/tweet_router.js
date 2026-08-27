const express = require('express')
const Tweet = require('../models/tweet')
const auth = require('../middleware/auth')

// Original Router
const router = new express.Router()

// Create Tweet
router.post('/tweets', auth, async (req, res) => {
    const body = req.body
    const tweetJson = {
        ...body,
        userId: req.user._id
    }
    console.log(tweetJson)
    const tweet = new Tweet(tweetJson)
    try {
        await tweet.save()
        return res.status(200).send({ tweet: tweet })
    }
    catch (error) {
        res.status(400).json(error)
    }
})

module.exports = router