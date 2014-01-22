Hapi = require "hapi"

S = Hapi.types.String
A = Hapi.types.Array
N = Hapi.types.Number
O = Hapi.types.Object

exports.get =
  description: "GET /bars"
  handler: (request, reply) ->
    getCollection (err, collection) ->
      collection.find().toArray (err, bars) ->
        reply bars

exports.post =
  validate:
    payload:
      name: S().required()
      address: S()
      location:
        lng: N()
        lat: N()
      openingHours:
        start: S()
        end: S()
      age: N().min(0).max(100)
      phoneNumber: S()
      description: S()
      images: A()
      webSite: S()
      facebook: S()
      mail: S()
  handler: (request, reply) ->
    now = new Date
    request.payload.createdAt = now
    request.payload.updatedAt = now
    getCollection (err, collection) ->
      collection.insert request.payload, (err, bar) ->
        if err?
          throw err
        reply bar

getCollection = (callback) ->
  exports.options.db.collection "bars", callback
