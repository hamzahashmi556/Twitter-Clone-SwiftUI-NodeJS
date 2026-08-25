const jwt = require('jsonwebtoken')
const User = require('../models/user')
const privateKey = "ramza@556"


const auth = async (req, res, next) => {
    try {
        const token = req.header('Authorization').replace('Bearer ', '')
        // console.log('Token Found')
        const decoded = jwt.verify(token, privateKey)
        console.log('Token Decoded & verified')
        const user = await User.findOne({ _id: decoded._id, 'tokens.token': token })

        if (!user) {
            throw new Error("User does not exists")
        }

        req.token = token
        req.user = user
        next()
    }
    catch (error) {
        res.status(401).send({ error: error.message })
        console.log("Auth Login Error: " + error.message)
    }
}

module.exports = auth