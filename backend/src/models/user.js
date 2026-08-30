const mongoose = require('mongoose')
const validator = require('validator')
const bcrypt = require('bcryptjs')
const jwt = require('jsonwebtoken')

const privateKey = "ramza@556"

const userSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
        trim: true
    },
    userName: {
        type: String,
        required: true,
        trim: true,
        unique: true
    },
    tokens: [{
        token: {
            type: String,
            required: true
        }
    }],
    email: {
        type: String,
        required: true,
        unique: true,
        lowercase: true,
        validate(value) {
            if (!validator.isEmail(value)) {
                throw new Error("Invalid Email Address")
            }
        }
    },
    password: {
        type: String,
        required: true,
        minLength: 7,
        trim: true,
        validate(value) {
            if (value.toLowerCase().includes('password')) {
                throw new Error('Password can not contain "password" keyword')
            }
        }
    },
    avatar: {
        type: Buffer
    },
    avatarExists: {
        type: Boolean
    },
    bio: {
        type: String,
    },
    website: {
        type: String,
    },
    location: {
        type: String,
    },
    followers: {
        type: Array,
        default: [],
    },
    followings: {
        type: Array,
        default: [],
    }
})

// Hide Sensitive Fields like password
userSchema.methods.toJSON = function () {
    const userObject = this.toObject()
    delete userObject.password
    return userObject
}

// Hash password field
userSchema.pre('save', async function (next) {
    const user = this
    if (user.isModified('password')) {
        user.password = await bcrypt.hash(user.password, 8)
    }
})

// Relationship between Tweets & the User
userSchema.virtual('tweets', {
    // Look inside:
    ref: 'Tweet',
    // Take:
    localField: '_id',
    // Compare it against:
    foreignField: 'user'
})

// Relationship between Notifications & the User
userSchema.virtual('notificationSent', {
    // Look inside:
    ref: 'Notification',
    // Take:
    localField: '_id',
    // Compare it against:
    foreignField: 'senderId'
})

userSchema.virtual('notificationReceived', {
    // Look inside:
    ref: 'Notification',
    // Take:
    localField: '_id',
    // Compare it against:
    foreignField: 'receiverId'
})

// Authentication
userSchema.statics.findByCredentials = async (email, password) => {
    const user = await User.findOne({ email })

    if (!user) {
        throw new Error('Unable to login could not find your account')
    }

    const isMatch = await bcrypt.compare(password, user.password)

    if (!isMatch) {
        throw new Error('Unable to login, incorrect password')
    }
    return user
}

// Generate Auth Token
userSchema.methods.generateAuthToken = async function () {
    const user = this;
    const token = jwt.sign({ _id: user._id }, privateKey)
    user.tokens = user.tokens.concat({ token })
    await user.save()
    return token
}

const User = mongoose.model("User", userSchema)

module.exports = User
