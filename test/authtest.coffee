UCloud = require '../index'
mocha = require 'mocha'
should = require 'should'
nock = require 'nock'

describe 'UCloud authenticate method test', ->
  describe '', ->
    scope = undefined
    headers = undefined
    before ->
      reply =
        storage: 
          default: 'local'
          local: 'https://ssproxy.ucloudbiz.olleh.com/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36'
      headers =
        'X-Storage-Url': 'https://ssproxy.ucloudbiz.olleh.com/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36'
        'X-Storage-Token': 'AUTH_tk5f6d351c490b44b8b60b015e744a435a'
        'X-Auth-Token': 'AUTH_tk5f6d351c490b44b8b60b015e744a435a'
        'Content-Length': '112'
        'X-Auth-Token-Expires': '39572'
      scope = nock('https://api.ucloudbiz.olleh.com').get('/storage/v1/auth').reply(200,reply,headers)
    it 'should set the token and storage url from the response header', (done) ->
      options =
        authUrl: 'https://api.ucloudbiz.olleh.com/storage/v1/auth'
        api_key: 'API_KEY'
        user: 'test@gmail.com'
      ucloud = new UCloud options
      ucloud.auth (err,res) ->
        should.not.exist err
        should.exist ucloud.storageUrl
        should.exist ucloud.token
        should.exist ucloud.tokenExpiry
        should.exist res
        res.should.be.a 'boolean'
        res.should.equal true
        ucloud.token.should.be.a 'string'
        ucloud.storageUrl.should.be.a 'string'
        ucloud.token.should.equal 'AUTH_tk5f6d351c490b44b8b60b015e744a435a'
        ucloud.storageUrl.should.equal 'https://ssproxy.ucloudbiz.olleh.com/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36'
        scope.done()
        done()

  describe 'auth error handling', ->
    it 'should return a message that the authentication has failed', (done) ->
      scope = nock('https://api.ucloudbiz.olleh.com').get('/storage/v1/auth').reply(401)
      options =
        authUrl: 'https://api.ucloudbiz.olleh.com/storage/v1/auth'
        api_key: 'API_KEY'
        user: 'test@gmail.com'
      ucloud = new UCloud options
      ucloud.auth (err,res) ->
        should.exist err
        should.not.exist res
        err.should.be.a 'object'
        err.message.should.equal 'UCloud Auth : Authentication failed'
        scope.done()
        done()
  
