#UCloud storage api
#Author : Kenley Tomlin
#Email : kenleytomlin@gmail.com

request = require 'request'
url = require 'url'
_ = require 'underscore'
async = require 'async'

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
      throw new Error ('UCloud Constructor : Ucloud requires api_key, authentication host and a user (email address)')
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
        console.error 'UCloud Auth : Request to %s failed',options.url
      if res.statusCode is 200
        self.storageUrl = res.headers['x-storage-url']
        self.token = res.headers['x-storage-token']
        self.tokenExpiry = res.headers['x-auth-token-expires'] + new Date().getTime()
        callback null, true, body
      else if res.statusCode is 401
        callback new Error 'UCloud Auth : Authentication failed'

  #Provides information on the storage account in json or xml format
  #PARAMS
  #options : [{ limit : Number, format : String }]

  getStorage: (options,callback) ->
    self = @
    async.waterfall [
      (callback) ->
        if self.autoRefresh is true
          self._checkExpiry(err) ->
            if err then callback err
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
        else
          query.format = 'json'
        if self.token    
          reqOpts =
              headers:
                'X-Auth-Token': @token
              qs: 
                query
              url: 
                url.parse self.storageUrl
          request reqOpts, (err,res,body) ->
            if err then callback err
            switch res.statusCode
              when 200
                callback null, true, body
              when 204
                callback null, false, 'Ucloud : No containers'
              when 401
                callback null, false, 'Ucloud : Authentication failed, token error'
              when 403
                callback null, false, 'Ucloud : Unauthorised'
        else
          callback new Error 'Ucloud : No Token - Authenticate first!'
      ], (err,res,body) ->
        if err then callback err
        callback null, res, body

  getContainer: (options,callback) ->
    query = {}
    self = @
    if options.container?  
      async.waterfall [
        (callback) ->
          if self.autoRefresh is true
            self._checkExpiry (err) ->
              if err then callback err
              callback null
          else
            callback null
        , (callback) ->
            if options.format?
              query.format = options.format
            else
              query.format = 'json'
            if options.limit?
              query.limit = options.limit
            if options.prefix?
              query.prefix = options.prefix
            if options.path?
              query.path = options.path
            containerUrl = url.resolve self.storageUrl, options.container
            reqOpts =
              url:
                url.parse containerUrl
              qs:
                query
            request reqOpts, (err,res,body) ->
              if err then callback err
              switch res.statusCode
                when 200
                  callback null, true, body
                when 204
                  callback null, false, 'Ucloud : No such container exists'
                when 401
                  callback null, false, 'Ucloud : Authentication failed, token error'
                when 403
                  callback null, false, 'Ucloud : Unauthorized'
                when 404
                  callback null, false, 'Ucloud : Account error, please try again'
        ], (err,res,body) ->
          if err then callback err
          callback null, res, body
    else
      callback new Error 'Ucloud : No container specified'

  # Private - Check if the current token is due to expire or not if it is due to expire then renew the token
  _checkExpiry: (callback) ->
    now = new Date().getTime()
    console.log @tokenExpiry
    if (@tokenExpiry - now) > 0
      @auth (err,res) ->
        if err then callback err
        callback null
    else
      callback null



module.exports = UCloud