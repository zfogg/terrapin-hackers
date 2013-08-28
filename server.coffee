#!/usr/bin/coffee


# === Requirements ===
express    = require 'express'
cassets    = require 'connect-assets'

stylus     = require 'stylus'
nib        = require 'nib'

app = express()


# === Configuration ===
app.configure ->
    app.set 'port', process.env.PORT or 8080
    app.set 'secret', process.env.SECRET or 'beagle-site'

    app.set 'views', __dirname + '/views'
    app.set 'view engine', 'jade'

    app.use cassets src: 'public'
    app.use express.static "#{__dirname}/public", maxAge: 86400

    app.use express.bodyParser()
    app.use express.cookieParser()

    app.use stylus.middleware
        src: __dirname
        compile: (str, path) ->
            stylus(str)
                .set('filename', path)
                .set('compress', true)
                .use(nib())

    app.use app.router

app.configure 'development', ->
    app.use express.favicon()
    app.use express.logger 'dev'
    app.use express.errorHandler
        dumpExceptions: true
        showStack: true

app.configure 'production', ->
    app.use express.errorHandler


# === Routes ===
app.get '/', (req, res) ->
    res.render ''

app.get '/404', (req, res) ->
    res.send '404', 'Page not found.'


# === Start ===
app.listen app.get 'port'

