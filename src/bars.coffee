Hapi = require "hapi"
Mongo = require "mongodb"

idRegEx = /^(?:[0-9a-fA-F]{24})$/

S = Hapi.types.String
A = Hapi.types.Array
N = Hapi.types.Number

postSchema = ->
  name: S().required()
  address: S()
  location:
    lat: N()
    lng: N()
  openingHours:
    from: S()
    until: S()
  age: N().min(0).max(100)
  phoneNumber: S()
  facebook: S()
  webSite: S()
  email: S()
  description: S()
  iconImage: S()
  logoImage: S()
  images: A()

putSchema = ->
  baseSchema = postSchema()
  baseSchema._id = S()
  baseSchema.createdAt = S()
  baseSchema.updatedAt = S()
  baseSchema

exports.get =
  description: "GET /bars"
  handler: (request, reply) ->
    getCollection (err, collection) ->
      collection.find().toArray (err, bars) ->
        reply bars

exports.post =
  validate:
    payload: postSchema()
  handler: (request, reply) ->
    now = new Date
    request.payload.createdAt = now
    request.payload.updatedAt = now
    getCollection (err, collection) ->
      collection.insert request.payload, (err, bar) ->
        if err?
          throw err
        reply bar

exports.put =
  validate:
    path:
      id: S().regex(idRegEx).required()
    payload: putSchema()
  handler: (request, reply) ->
    now = new Date
    request.payload.updatedAt = now
    getCollection (err, collection) ->
      collection.update { _id: new Mongo.ObjectID request.params.id }, { $set: request.payload }, (err, count) ->
        if count is 0
          reply("The bar was not found").code(404)
        else
          reply "ok"

exports.delete =
  validate:
    path:
      id: S().regex(idRegEx).required()
  handler: (request, reply) ->
    getCollection (err, collection) ->
      collection.remove { _id: new Mongo.ObjectID request.params.id }, (err, count) ->
        if count is 0
          reply("The bar was not found").code(404)
        else
          reply "ok"

getCollection = (callback) ->
  exports.options.db.collection "bars", callback
