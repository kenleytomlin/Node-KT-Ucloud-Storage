UCloud = require '../index'
mocha = require 'mocha'
should = require 'should'
nock = require 'nock'

options =
  authUrl: 'https://api.ucloudbiz.olleh.com/storage/v1/auth'
  api_key: 'API_KEY'
  user: 'test@gmail.com'

describe 'UCloud.delete', ->
  describe '204 - Success', ->
    ucloud = undefined
    before ->
      ucloud = new UCloud options
      ucloud.storageUrl = 'https://ssproxy.ucloudbiz.olleh.com/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36/'
      ucloud.token = 'AUTH_tk431f2f1c58bd4e7ba3b09a25db67c512'
      ucloud.autoRefresh = false
    it 'should delete a file from the UCloud storage server', (done) ->
      scope = nock('https://ssproxy.ucloudbiz.olleh.com').delete('/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36/mall/hello.txt').reply(204)
      reqOpts =
        container:
          'mall'
        fileName:
          'hello.txt'
      ucloud.delete reqOpts, (err,res,msg) ->
        should.not.exist err
        should.exist res
        should.exist msg
        res.should.be.a 'boolean'
        msg.should.equal 'UCloud (http 204) : File hello.txt deleted'
        done()
  describe '401 - Token error', ->
    ucloud = undefined
    before ->
      ucloud = new UCloud options
      ucloud.storageUrl = 'https://ssproxy.ucloudbiz.olleh.com/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36/'
      ucloud.token = 'AUTH_tk431f2f1c58bd4e7ba3b09a25db67c512'
      ucloud.autoRefresh = false
    it 'should fail and return a 403', (done) ->
      scope = nock('https://ssproxy.ucloudbiz.olleh.com').delete('/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36/mall/hello.txt').reply(401)
      reqOpts =
        container:
          'mall'
        fileName:
          'hello.txt'
      ucloud.delete reqOpts, (err,res,msg) ->
        should.exist err
        should.not.exist res
        should.not.exist msg
        err.should.be.a 'object'
        err.message.should.equal 'UCloud (http 401) : Token error'
        done()
  describe '403 - Unauthorized', ->
    ucloud = undefined
    before ->
      ucloud = new UCloud options
      ucloud.storageUrl = 'https://ssproxy.ucloudbiz.olleh.com/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36/'
      ucloud.token = 'AUTH_tk431f2f1c58bd4e7ba3b09a25db67c512'
      ucloud.autoRefresh = false
    it 'should fail and return a 403', (done) ->
      scope = nock('https://ssproxy.ucloudbiz.olleh.com').delete('/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36/mall/hello.txt').reply(403)
      reqOpts =
        container:
          'mall'
        fileName:
          'hello.txt'
      ucloud.delete reqOpts, (err,res,msg) ->
        should.exist err
        should.not.exist res
        should.not.exist msg
        err.should.be.a 'object'
        err.message.should.equal 'UCloud (http 403) : Unauthorized'
        done()
  describe '404 - File does not exist', ->
    ucloud = undefined
    before ->
      ucloud = new UCloud options
      ucloud.storageUrl = 'https://ssproxy.ucloudbiz.olleh.com/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36/'
      ucloud.token = 'AUTH_tk431f2f1c58bd4e7ba3b09a25db67c512'
      ucloud.autoRefresh = false
    it 'should fail and return a 403', (done) ->
      scope = nock('https://ssproxy.ucloudbiz.olleh.com').delete('/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36/mall/hello.txt').reply(404)
      reqOpts =
        container:
          'mall'
        fileName:
          'hello.txt'
      ucloud.delete reqOpts, (err,res,msg) ->
        should.exist err
        should.not.exist res
        should.not.exist msg
        err.should.be.a 'object'
        err.message.should.equal 'UCloud (http 404) : Couldn\'t delete file hello.txt, file doesn\'t exist'
        done()