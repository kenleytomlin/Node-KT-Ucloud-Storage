mocha = require 'mocha'
should = require 'should'
nock = require 'nock'

UCloud = require '../index'

options =
  api_key: 'API_KEY'
  authUrl: 'https://api.ucloudbiz.olleh.com/storage/v1/auth'
  user: 'test@gmail.com'
describe 'UCloud.deleteContainer', ->
  describe '204 - Success', ->
    ucloud = undefined
    before ->
      ucloud = new UCloud options
      ucloud.storageUrl = 'https://ssproxy.ucloudbiz.olleh.com/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36/'
      ucloud.token = 'AUTH_tk431f2f1c58bd4e7ba3b09a25db67c512'
      ucloud.autoRefresh = false
    it 'should delete a container, return true and a message', (done) ->
      scope = nock('https://ssproxy.ucloudbiz.olleh.com').delete('/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36/mall').reply(204)
      ucloud.deleteContainer 'mall', (err,res,msg) ->
        should.not.exist err
        should.exist res
        should.exist msg
        res.should.be.a 'boolean'
        res.should.equal true
        msg.should.equal 'UCloud (http 204) : Deleted mall container'
        done()
  describe '404 - Not found', ->
    ucloud = undefined
    before ->
      ucloud = new UCloud options
      ucloud.storageUrl = 'https://ssproxy.ucloudbiz.olleh.com/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36/'
      ucloud.token = 'AUTH_tk431f2f1c58bd4e7ba3b09a25db67c512'
      ucloud.autoRefresh = false

    it 'should return an error because the container doesn\'t exist', (done) ->
      scope = nock('https://ssproxy.ucloudbiz.olleh.com').delete('/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36/mall').reply(404)
      ucloud.deleteContainer 'mall', (err,res,msg) ->
        should.exist err
        err.should.be.a 'object'
        err.message.should.equal 'UCloud (http 404) : Couldn\'t delete mall container, container doesn\'t exist'
        done()
        scope.done()
  describe '409 - Cannot delete', ->
    ucloud = undefined
    before ->
      ucloud = new UCloud options
      ucloud.storageUrl = 'https://ssproxy.ucloudbiz.olleh.com/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36/'
      ucloud.token = 'AUTH_tk431f2f1c58bd4e7ba3b09a25db67c512'
      ucloud.autoRefresh = false
      scope = nock('https://ssproxy.ucloudbiz.olleh.com').delete('/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36/mall').reply(409)
    it 'should return an error because the container contains objects', (done) ->
      ucloud.deleteContainer 'mall', (err,res,msg) ->
        should.exist err
        should.not.exist res
        should.not.exist msg
        err.should.be.a 'object'
        err.message.should.equal 'UCloud (http 409) : Couldn\'t delete mall container, mall container contains objects'
        done()
  describe '401 - Authentication failed, token error', ->
    ucloud = undefined
    before ->
      ucloud = new UCloud options
      ucloud.storageUrl = 'https://ssproxy.ucloudbiz.olleh.com/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36/'
      ucloud.token = 'AUTH_tk431f2f1c58bd4e7ba3b09a25db67c512'
      ucloud.autoRefresh = false      
      scope = nock('https://ssproxy.ucloudbiz.olleh.com').delete('/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36/mall').reply(401)
    it 'should return an error because there was a token error', (done) ->
      ucloud.deleteContainer 'mall', (err,res,msg) ->
        should.exist err
        err.should.be.a 'object'
        should.not.exist res
        should.not.exist msg
        err.message.should.equal 'UCloud (http 401) : Authentication failed, token error'
        done()
  describe '403 - Unauthorized', ->
    ucloud = undefined
    before ->
      ucloud = new UCloud options
      ucloud.storageUrl = 'https://ssproxy.ucloudbiz.olleh.com/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36/'
      ucloud.token = 'AUTH_tk431f2f1c58bd4e7ba3b09a25db67c512'
      ucloud.autoRefresh = false
      scope = nock('https://ssproxy.ucloudbiz.olleh.com').delete('/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36/mall').reply(403)
    it 'should return an error because the user is not authorized', (done) ->
      ucloud.deleteContainer 'mall', (err,res,msg) ->
        should.exist err
        err.should.be.a 'object'
        err.message.should.equal 'UCloud (http 403) : Unauthorized'
        done()
