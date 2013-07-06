mocha = require 'mocha'
should = require 'should'
nock = require 'nock'

config = require 
Ucloud = require '../index'

describe 'Ucloud.getStorage (in JSON)', ->
  ucloud = undefined
  scope = undefined
  before (done) ->
    options = 
      api_key: 'API_KEY'
      authUrl: 'https://api.ucloudbiz.olleh.com/storage/v1/auth'
      user: 'test@gmail.com'

    ucloud = new Ucloud options
    ucloud.storageUrl = 'https://ssproxy.ucloudbiz.olleh.com/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36'
    ucloud.token = 'AUTH_tk431f2f1c58bd4e7ba3b09a25db67c512'
    reply =
      "name":".ACCESS_LOGS"
      "count":2
      "bytes":1268
    headers =
      "X-Account-Object-Count":1
      "X-Account-Bytes-Used":78
      "X-Account-Container-Count":1
      "Content-Length":178
    scope = nock('https://ssproxy.ucloudbiz.olleh.com').get('/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36?limit=5&format=json').reply(200,headers)
    done()

  it 'should make a request to the storage api and get a list of containers', (done) ->
    options = 
      limit: 5
      format: 'json'

    ucloud.getStorage options, (err,res,body) ->
      should.not.exist err
      should.exist res
      should.exist body
      res.should.be.a 'boolean'
      res.should.equal true
      done()

describe 'UCloud.getStorage (in xml)', ->
  ucloud = undefined
  scope = undefined
  parsedXml = undefined
  before (done) ->
    options =
      api_key: 'API_KEY'
      authUrl: 'https://api.ucloudbiz.olleh.com/storage/v1/auth'
      user: 'test"gmail.com'

    ucloud = new Ucloud options
    ucloud.storageUrl = 'https://ssproxy.ucloudbiz.olleh.com/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36'
    ucloud.token = 'AUTH_tk431f2f1c58bd4e7ba3b09a25db67c512'
    reply =
      "name":".ACCESS_LOGS"
      "count":2
      "bytes":1268
    headers =
      "X-Account-Object-Count":1
      "X-Account-Bytes-Used":78
      "X-Account-Container-Count":1
      "Content-Length":178
    xml = '<?xml version="1.0" encoding="UTF-8"?> <account name="MichaelBarton"> <container> <name>test_container_1</name> <count>2</count> <bytes>78</bytes> </container> </account>'
    parsedXml = '{"X-Account-Object-Count":1,"X-Account-Bytes-Used":78,"X-Account-Container-Count":1,"Content-Length":178}'
    scope = nock('https://ssproxy.ucloudbiz.olleh.com').get('/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36?limit=5&format=xml').reply(200,headers,xml,false)
    done()
  it 'should make a request to the storage api and get a list of containers', (done) ->
    options =
      limit: 5
      format: 'xml'

    ucloud.getStorage options, (err,res,body) ->
      should.not.exist err
      should.exist res
      should.exist body
      res.should.be.a 'boolean'
      res.should.equal true
      body.should.equal parsedXml
      done()

describe '403 - Unauthorized', ->
  ucloud = undefined
  scope = undefined
  parsedXml = undefined
  headers = undefined
  before (done) ->
    options =
      api_key: 'API_KEY'
      authUrl: 'https://api.ucloudbiz.olleh.com/storage/v1/auth'
      user: 'test"gmail.com'
    headers =
      "X-Account-Object-Count":1
      "X-Account-Bytes-Used":78
      "X-Account-Container-Count":1
      "Content-Length":178
    ucloud = new Ucloud options
    ucloud.storageUrl = 'https://ssproxy.ucloudbiz.olleh.com/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36'
    ucloud.token = 'AUTH_tk431f2f1c58bd4e7ba3b09a25db67c512'
    scope = nock('https://ssproxy.ucloudbiz.olleh.com').get('/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36?limit=5&format=json').reply(403,headers,null,false)
    done()
  it 'should return an error', (done) ->
    options =
      limit: 5
      format: 'json'
    ucloud.getStorage options, (err,res,body) ->
      should.exist err
      err.message.should.equal 'UCloud (http 403) : Authentication failed'
      done()