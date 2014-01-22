Bars = require "./bars"
options = {}

exports.__defineSetter__ "options", (value) ->
  Bars.options = options = value
exports.__defineGetter__ "options", ->
  options

getAllFiles = directory: { path: "app" }

exports.routes = [
  { method: "GET", path: "/{path*}", handler: getAllFiles },
  { method: "GET", path: "/bars", config: Bars.get },
  { method: "POST", path: "/bars", config: Bars.post },
]
