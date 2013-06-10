_ = require 'underscore'

module.exports.build = (options) ->
  if _.isObject(options)
    options
  else
    return new Error ('HeaderBuilder : argument to build must be an object')