#UCloud storage api
#Author : Kenley Tomlin
#Email : kenleytomlin@gmail.com

request = require 'request'

class UCloud
  
  api_key = null
  host = null
  user = null

  #constructor
  #Creates a UCloud instance and sets api_key, host and user
  #PARAMS
  #options : { api_key: String, host : String, user : String }

  constructor: (options) ->
    if options.api_key and options.host and options.user
      @api_key = options.api_key
      @host = options.host
      @user = options.user
    else
      throw new Error ('Ucloud requires api_key, authentication host and a user (email address)')

  authenticate: (callback) ->

  storageInfo: (callback) ->

module.exports = UCloud