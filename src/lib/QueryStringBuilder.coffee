qs = require 'qs'

module.exports.build = (query) ->
  if query isnt null
    return qs.stringify(options)
  else
    return new Error 'QueryStringBuilder : No object to parse'