mocha = require 'mocha'
should = require 'should'
nock = require 'nock'

Ucloud = require '../index'

describe 'UCloud.createContainer', ->
  ucloud = undefined
  scope = undefined
  options =
    api_key: 'API_KEY'
    authUrl: 'https://api.ucloudbiz.olleh.com/storage/v1/auth'
    user: 'test@gmail.com'
  before (done)->
    ucloud = new Ucloud options
    ucloud.storageUrl = 'https://ssproxy.ucloudbiz.olleh.com/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36/'
    ucloud.token = 'AUTH_tk431f2f1c58bd4e7ba3b09a25db67c512'
    ucloud.autoRefresh = false
    scope = nock('https://ssproxy.ucloudbiz.olleh.com').put('/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36/mall').reply(201)
    done()

  it 'should create a container and return no errors', (done) ->
    options = 'mall'
    ucloud.createContainer options, (err,res,msg) ->
      should.not.exist err
      should.exist res
      should.exist msg
      res.should.be.a 'boolean'
      res.should.equal true
      msg.should.equal 'UCloud (http 201) : Container mall created'
      done()

  it 'should return an error because no container name was specified', (done) ->
    options = null
    ucloud.createContainer options, (err,res,msg) ->
      should.exists err
      err.should.be.a 'object'
      err.message.should.equal 'UCloud : No container specified'
      done()