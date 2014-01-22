Hapi = require "hapi"
Mongo = require "mongodb"
Routes = require "./routes"

defaults =
  # dbUri: "ADD HERE yout MongoDB development url. mongodb://127.0.0.1:27017/Bolierplate"
  dbUri: "mongodb://127.0.0.1:27017/Zuller"
  port: +process.env.PORT or 8000

if process.env.NODE_ENV is "production"
  defaults.dbUri = "ADD HERE your MongoDB production url"

Routes.options = defaults

config = cors: true
server = new Hapi.Server defaults.port, "0.0.0.0", config

# pluginOptions =
#   subscribers:
#     console: ["ops", "request", "log", "error"]
#     "http://localhost/logs": ["log"]
#     "/tmp/logs/": ["request", "log"]
#     "udp://127.0.0.1:9000": ["request"]

# server.pack.require "good", pluginOptions, (err) ->
#   unless err
#     console.log "good plugin loaded"

server.route Routes.routes

Mongo.connect defaults.dbUri, (err, db) ->
  throw err if err
  Routes.options.db = db
  Routes.options.server = server

  server.start ->
    server.info.uri = if process.env.HOST? then "http://#{process.env.HOST}:#{process.env.PORT}" else server.info.uri
    console.log "Server started at #{server.info.uri}"
