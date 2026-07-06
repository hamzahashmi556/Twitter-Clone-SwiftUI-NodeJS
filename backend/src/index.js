
const express = require('express')
const Tweet = require('./models/tweet')

const userRouter = require('./routers/user_router')

require("./db/mongoose")

const app = express()

app.use(express.json())

app.use(userRouter)

const port = process.env.PORT || 3000

app.listen(port, () => {
    console.log('server is up running on port ' + port)
})