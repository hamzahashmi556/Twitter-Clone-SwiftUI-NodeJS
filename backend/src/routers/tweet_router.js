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
        return res.status(200).send({ tweet: tweet })
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
module.exports = router