const express = require('express')
const Tweet = require('../models/tweet')
const auth = require('../middleware/auth')
const multer = require('multer');
const sharp = require('sharp');

// Original Router
const router = new express.Router()

const uploader = multer({
    limits: {
        fileSize: 100000000
    }
})

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
        return res.status(200).send( tweet )
    }
    catch (error) {
        res.status(400).json(error)
    }
})

// Upload Tweet Image
router.post('/tweet/uploadImage/:id', auth, uploader.single('image'), async (req, res) => {
    const tweetId = req.params.id
    try {
        // 1. find tweet
        const tweet = await Tweet.findOne({ _id: tweetId })
        if (!tweet) {
            return res.status(404).send('Tweet Missing from database')
        }

        // 2. check image
        const bufferValue = req.file.buffer
        if (!bufferValue) {
            return res.status(404).send('Image File missing or not correct')
        }
        const buffer = await sharp(bufferValue)
            .resize({ width: 350, height: 350 })
            .png()
            .toBuffer()

        // 3. update model
        tweet.image = buffer

        // 4. save in db
        await tweet.save()
        res.send({
            message: 'Image Uploaded Successfully',
            tweet: tweet
        })



    }
    catch (error) {
        return res.status(500).send(error.message)
    }
}, (error, req, res, next) => {
    res.status(400).send({ error: error.message })
})

// Get Tweet Image
router.get('/tweet/image/:id', auth, async (req, res) => {
    try {
        const id = req.params.id
        const tweet = await Tweet.findById(id)
        if (!tweet) {
            return res.status(404).send('Tweet Missing from database')
        } else if (!tweet.image) {
            return res.status(404).send('Image Missing from tweet')
        }
        res.set('Content-Type', 'image/jpg')
        res.send(tweet.image)
    }
    catch (error) {
        return res.status(500).send(error.message)
    }
})

// Get Tweets
router.get('/tweets', async (req, res) => {
    try {
        const tweets = await Tweet.find({})
        return res.status(200).send(tweets)
    }
    catch (error) {
        res.status(400).send(error.message)
    }
})

// Get User Tweets
router.get('/tweets/:id', auth, async (req, res) => {
    const userId = req.params.id
    try {
        const tweets = await Tweet.find({ userId: userId })
        if (!tweets) {
            return res.status(404).send("No Tweets found for this user")
        }
        return res.status(200).send(tweets)
    }
    catch (error) {
        return res.status(500).send(error.message)
    }
})

// Like Tweet
router.post('/tweets/:id/like', auth, async (req, res) => {
    const userId = req.user.id
    const tweetId = req.params.id
    try {
        const tweet = await Tweet.findById(tweetId)
        if (!tweet) {
            return res.status(404).send('tweet is missing from server')
        }
        if (tweet.likes.includes(userId)) {
            return res.status(400).send('You already liked this tweet')
        }
        await tweet.updateOne({ $push: { likes: userId } })
        return res.status(200).send('Tweet has been liked')
    }
    catch (error) {
        res.status(500).json(error.message)
    }

})

// Unlike Tweet
router.post('/tweets/:id/unlike', auth, async (req, res) => {
    const userId = req.user.id
    const tweetId = req.params.id
    try {
        const tweet = await Tweet.findById(tweetId)
        if (!tweet) {
            return res.status(404).send('tweet is missing from server')
        }
        if (!tweet.likes.includes(userId)) {
            return res.status(400).send('You already unliked this tweet')
        }
        await tweet.updateOne({ $pull: { likes: userId } })
        return res.status(200).send('Tweet has been unliked')
    }
    catch (error) {
        res.status(500).json(error.message)
    }

})

module.exports = router