mocha = require 'mocha'
should = require 'should'
nock = require 'nock'
Ucloud = require '../index'

describe 'Ucloud.getContainer', ->
  describe 'get container info in json', ->
    scope = undefined
    headers = undefined
    json = undefined
    ucloud = undefined
    before ->
      options = 
        api_key: 'API_KEY'
        authUrl: 'https://api.ucloudbiz.olleh.com/storage/v1/auth'
        user: 'test@gmail.com'

      ucloud = new Ucloud options
      ucloud.storageUrl = 'https://ssproxy.ucloudbiz.olleh.com/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36/'
      ucloud.token = 'AUTH_tk431f2f1c58bd4e7ba3b09a25db67c512'
      ucloud.autoRefresh = false
      body = 
        [
          { "name":
            "test_obj_1"
          "hash":
            "4281c348eaf83e70ddce0e07221c3d28"
          "bytes":
            14
          "content_type":
            "application\/octet-stream"
          "last_modified":
            "2009-02-03T05:26:32.612278" },
          { "name":
            "test_obj_2"
          "hash":
            "b039efe731ad111bc1b0ef221c3849d0"
          "bytes":
            64
          "content_type":
            "application\/octet-stream"
          "last_modified":
            "2009-02-03T05:26:32.612278"
          }
        ]
      headers = 
        "X-Container-Object-Count":2
        "X-Container-Bytes-Used":500
      scope = nock('https://ssproxy.ucloudbiz.olleh.com').get('/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36/mall?format=json&limit=5').reply(200,headers,body)

    it 'should get information about a storage container', (done) ->
      options = 
        limit: 5
        format: 'json'
        container: 'mall'
      ucloud.getContainer options, (err,res,body) ->
        should.not.exist err
        should.exist res
        should.exist body
        res.should.be.a 'boolean'
        res.should.equal true
        body.should.equal body
        done()

  describe 'get container info in xml', ->
    scope = undefined
    headers = undefined
    xml = undefined
    ucloud = undefined
    before ->
      options = 
        api_key: 'API_KEY'
        authUrl: 'https://api.ucloudbiz.olleh.com/storage/v1/auth'
        user: 'test@gmail.com'

      ucloud = new Ucloud options
      ucloud.storageUrl = 'https://ssproxy.ucloudbiz.olleh.com/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36/'
      ucloud.token = 'AUTH_tk431f2f1c58bd4e7ba3b09a25db67c512'
      ucloud.autoRefresh = false
      xml = '<?xml version="1.0" encoding="UTF-8"?><container name="test_container_1"><object><name>test_object_1</name><hash>4281c348eaf83e70ddce0e07221c3d28</hash><bytes>14</bytes><content_type>application/octet-stream</content_type><last_modified>2009-02-03T05:26:32.612278</last_modified></object><object><name>test_object_2</name><hash>b039efe731ad111bc1b0ef221c3849d0</hash><bytes>64</bytes><content_type>application/octet-stream</content_type><last_modified>2009-02-03T05:26:32.612278</last_modified></object></container>'
      headers = 
        "X-Container-Object-Count": 2 
        "X-Container-Bytes-Used" : 78
        "Content-Length": 32
        "Content-Type": "application/xml; charset=UTF-8"
      scope = nock('https://ssproxy.ucloudbiz.olleh.com').get('/v1/AUTH_024067c0-f236-4d2a-80d0-736698fb6d36/mall?format=xml&limit=5').reply(200,headers,xml)

    it 'should get information about a storage container', (done) ->
      options =
        limit: 5
        format: 'xml'
        container: 'mall'    
      ucloud.getContainer options, (err,res,body) ->
        should.not.exist err
        should.exist res
        should.exist body
        res.should.be.a 'boolean'
        res.should.equal true
        done()