const mongoose = require('mongoose')
const validator = require('validator')
const bcrypt = require('bcryptjs')

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

    // next
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

const User = mongoose.model("User", userSchema)

module.exports = User