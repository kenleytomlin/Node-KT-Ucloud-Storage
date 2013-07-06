mocha = require 'mocha'
should = require 'should'
nock = require 'nock'
fs = require 'fs'
UCloud = require '../index'

options =
  api_key: 'API_KEY'
  authUrl: 'https://api.ucloudbiz.olleh.com/storage/v1/auth'
  user: 'test@gmail.com'
buffer = undefined

describe 'UCloud.upload', ->
  describe '201 - Success', ->
    ucloud = undefined
    headers =
      "Etag":"5d41402abc4b2a76b9719d911017c592"
      "Content-Length": "0"
    before (done) ->
      ucloud = new UCloud options
      ucloud.storageUrl = 'https://ssproxy.ucloudbiz.olleh.com/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36/'
      ucloud.token = 'AUTH_tk431f2f1c58bd4e7ba3b09a25db67c512'
      ucloud.autoRefresh = false
      fs.writeFile './hello.txt','hello', (err) ->
        fs.readFile './hello.txt','binary', (err,data) ->
          buffer = data
          done()
    it 'should create an md5 checksum and then upload a file to the storage server checking the md5 checksum is correct', (done) ->
      scope = nock('https://ssproxy.ucloudbiz.olleh.com').put('/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36/mall/hello.txt',buffer).reply(201,'',headers)
      reqOpts =
        filePath:
          "./hello.txt"
        fileName:
          "hello.txt"
        container:
          "mall"
        checkMD5:
          true
      ucloud.upload reqOpts, (err,res,msg) ->
        should.not.exist err
        should.exist res
        should.exist msg
        res.should.be.a 'boolean'
        res.should.equal true
        msg.should.equal 'UCloud (http 201) : hello.txt uploaded'
        done()
  describe '201 - Success, bad MD5', ->
    ucloud = undefined
    headers =
      "Etag": "d9f5eb4bba4e2f2f046e54611bc8196b"
      "Content-Length": "0"
    before ->
      ucloud = new UCloud options
      ucloud.storageUrl = 'https://ssproxy.ucloudbiz.olleh.com/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36/'
      ucloud.token = 'AUTH_tk431f2f1c58bd4e7ba3b09a25db67c512'
      ucloud.autoRefresh = false
    it 'should create an md5 checksum and upload a file but return an error due to a bad checksum', (done) ->
      scope = nock('https://ssproxy.ucloudbiz.olleh.com').put('/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36/mall/hello.txt',buffer).reply(201,headers)
      reqOpts =
        filePath:
          "./hello.txt"
        fileName:
          "hello.txt"
        container:
          "mall"
        checkMD5:
          true
      ucloud.upload reqOpts, (err,res,msg) ->
        should.exist err
        should.not.exist res
        should.not.exist msg
        err.should.be.a "object"
        err.message.should.equal "UCloud (http 201) : Bad MD5 checksum received from server"
        done()      
  describe '401 - Authentication failure, bad token', ->
    ucloud = undefined
    before ->
      ucloud = new UCloud options
      ucloud.storageUrl = 'https://ssproxy.ucloudbiz.olleh.com/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36/'
      ucloud.token = 'AUTH_tk431f2f1c58bd4e7ba3b09a25db67c512'
      ucloud.autoRefresh = false
    it 'should create an md5 checksum and attempt to upload a file but return an error due to a bad token', (done) ->
      scope = nock('https://ssproxy.ucloudbiz.olleh.com').put('/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36/mall/hello.txt',buffer).reply(401)
      reqOpts =
        filePath:
          "./hello.txt"
        fileName:
          "hello.txt"
        container:
          "mall"
        checkMD5:
          true
      ucloud.upload reqOpts, (err,res,msg) ->
        should.exist err
        should.not.exist msg
        should.not.exist res
        err.should.be.a 'object'
        err.message.should.equal 'UCloud (http 401) : hello.txt upload failed, token error'
        done()
  describe '403 - Unauthorized', ->
    ucloud = undefined
    before ->
      ucloud = new UCloud options
      ucloud.storageUrl = 'https://ssproxy.ucloudbiz.olleh.com/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36/'
      ucloud.token = 'AUTH_tk431f2f1c58bd4e7ba3b09a25db67c512'
      ucloud.autoRefresh = false
    it 'should create an md5 checksum and attempt to upload a file but return an error due to a bad token', (done) ->
      scope = nock('https://ssproxy.ucloudbiz.olleh.com').put('/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36/mall/hello.txt',buffer).reply(403)
      reqOpts =
        filePath:
          "./hello.txt"
        fileName:
          "hello.txt"
        container:
          "mall"
        checkMD5:
          true
      ucloud.upload reqOpts, (err,res,msg) ->
        should.exist err
        should.not.exist msg
        should.not.exist res
        err.should.be.a 'object'
        err.message.should.equal 'UCloud (http 403) : hello.txt upload failed, unauthorized'
        done()
  describe '412 - Missing Content type or Content-Length headers', ->
    ucloud = undefined
    before ->
      ucloud = new UCloud options
      ucloud.storageUrl = 'https://ssproxy.ucloudbiz.olleh.com/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36/'
      ucloud.token = 'AUTH_tk431f2f1c58bd4e7ba3b09a25db67c512'
      ucloud.autoRefresh = false
    it 'should create an md5 checksum and attempt to upload a file but return an error due to missing headers', (done) ->
      scope = nock('https://ssproxy.ucloudbiz.olleh.com').put('/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36/mall/hello.txt',buffer).reply(412)
      reqOpts =
        filePath:
          "./hello.txt"
        fileName:
          "hello.txt"
        container:
          "mall"
        checkMD5:
          true
      ucloud.upload reqOpts, (err,res,msg) ->
        should.exist err
        should.not.exist msg
        should.not.exist res
        err.should.be.a 'object'
        err.message.should.equal 'UCloud (http 412) : hello.txt upload failed, Content-Length/Content-Type missing from headers'
        done()
  describe '422 - Value of Etag unmatched', ->
    ucloud = undefined
    before ->
      ucloud = new UCloud options
      ucloud.storageUrl = 'https://ssproxy.ucloudbiz.olleh.com/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36/'
      ucloud.token = 'AUTH_tk431f2f1c58bd4e7ba3b09a25db67c512'
      ucloud.autoRefresh = false
    it 'should creare an md5 checksum and attempt to upload a file but return an error dude to a bad Etag', (done) ->
      scope = nock('https://ssproxy.ucloudbiz.olleh.com').put('/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36/mall/hello.txt',buffer).reply(422)
      reqOpts =
        filePath:
          "./hello.txt"
        fileName:
          "hello.txt"
        container:
          "mall"
        checkMD5:
          true
      ucloud.upload reqOpts, (err,res,msg) ->
        should.exist err
        should.not.exist msg
        should.not.exist res
        err.should.be.a 'object'
        err.message.should.equal 'UCloud (http 422) : hello.txt upload failed, Etag value doesn\'t match'
        done()
    after (done) ->
      fs.unlink './hello.txt', (err) ->
          done()
