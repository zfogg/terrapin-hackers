#!/usr/bin/coffee


# === Requirements ===
express    = require 'express'
cassets    = require 'connect-assets'

stylus     = require 'stylus'
nib        = require 'nib'

app = express()


# === Configuration ===
app.configure ->
  app.set 'port', process.env.PORT or 8003
  app.set 'secret', process.env.SECRET or 'Duck Fuke!'

  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'

  app.use express.static("#{__dirname}/public", maxAge: 86400)
  app.use cassets src: 'public'

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
  app.use express.favicon (__dirname + '/public/img/favicon.ico')
  app.use express.logger 'dev'
  app.use express.errorHandler
    dumpExceptions: true
    showStack: true

app.configure 'production', ->
  app.use express.errorHandler


# === Routes ===
app.get '/', (req, res) ->
  res.render ''

app.get '/mascot', (req, res) ->
  res.render 'mascot'

app.get '/t', (req, res) ->
  res.redirect 'https://twitter.com/terrapinhackers'

app.get '/fb', (req, res) ->
  res.redirect 'https://www.facebook.com/terrapinhackers'

app.get '/orgsync', (req, res) ->
  res.redirect '/join'

app.get '/join', (req, res) ->
  res.redirect 'https://orgsync.com/join/73768/terrapin-hackers'

app.get '/404', (req, res) ->
  res.send '404', 'Page not found.'

app.get '*', (req, res) ->
  res.redirect '/404'


# === Start ===
app.listen (app.get 'port'), ->
  console.log "Listening on http://localhost:#{app.get 'port'}/"

