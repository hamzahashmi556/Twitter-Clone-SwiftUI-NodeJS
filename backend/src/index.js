require("./db/mongoose")

const express = require('express')

const userRouter = require('./routers/user_router')
const tweetRouter = require('./routers/tweet_router')

const app = express()

app.use(express.json())

app.use(userRouter)
app.use(tweetRouter);

const port = process.env.PORT || 3000

app.listen(port, () => {
    console.log('server is up running on port ' + port)
})