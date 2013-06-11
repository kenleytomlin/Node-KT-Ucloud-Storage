#UCloud storage api
#Author : Kenley Tomlin
#Email : kenleytomlin@gmail.com

request = require 'request'
url = require 'url'
_ = require 'underscore'
async = require 'async'


QueryStringBuilder = require './lib/QueryStringBuilder'

class UCloud
  
  api_key = null
  authUrl = null
  user = null
  tokenExpiry = null

  storageUrl = null
  token = null

  autoRefresh = null
  #constructor
  #Creates a UCloud instance and sets api_key, host and user
  #PARAMS
  #options : { api_key: String, authUrl : String, user : String, [ autoRefresh : Bool (defaults to false) ] }

  constructor: (options) ->
    if options.api_key and options.user and options.authUrl
      @api_key = options.api_key
      @user = options.user
      @authUrl = options.authUrl
    else
      throw new Error ('Ucloud requires api_key, authentication host and a user (email address)')
    if options.autoRefresh and options.autoRefresh is true
      @autoRefresh = true
    else
      @autoRefresh = false

  auth: (callback) ->
    self = @
    reqOpts =
      reqHeaders:
        'X-Storage-Pass': @api_key
        'X_Storage-User': @user
      url:
        url.parse @authUrl
    request reqOpts, (err,res,body) ->
      if err
        console.error 'Request to %s failed',options.url
      if res.statusCode is 200
        self.storageUrl = res.headers['x-storage-url']
        self.token = res.headers['x-storage-token']
        self.tokenExpiry = res.headers['x-auth-token-expires'] + new Date().getTime()
        callback null, true, body
      else if res.statusCode is 401
        callback new Error 'UCloud Auth : Authentication failed'


  getStorage: (options,callback) ->
    self = @
    async.waterfall [
      (callback) ->
        if self.autoRefresh is true
          if self._checkExpiry is false
            self.auth (err,res) ->
              if err then callback err
              if res is true
                callback null
              else
                callback new Error 'Ucloud : Token refresh failed'
          else
            callback null
        else
          callback null
      , (callback) ->
        query = {}
        queryString = undefined
        if options.limit and _.isNumber options.limit
          query.limit = options.limit
        if options.format and _.isString options.format
          query.format = options.format
        if self.token    
          reqOpts =
              headers:
                'X-Auth-Token': @token
              qs: 
                query
              url: 
                url.parse self.storageUrl
          request reqOpts, (err,res,body) ->
            if err
              callback err
            if res.statusCode is 200
              callback null, true, body
            else if res.statusCode 204
              console.info 'Ucloud : No containers'
              callback null, false
            else if res.statusCode 401
              console.err 'Ucloud : Authentication failed, token error'
              callback null, false
            else if res.statusCode 403
              console.info 'Ucloud : Unauthorised'
              callback null, false
        else
          callback new Error 'Ucloud : No Token - Authenticate first!'
      ], (err,res,body) ->
        if err
          console.log err
          callback err
        else
          callback null,res,body

  # Check if the current token is due to expire or not
  _checkExpiry: ->
    now = new Date().getTime()
    return (@tokenExpiry - now) > 0

module.exports = UCloud