Ucloud = require '../index'

describe 'UCloud storage API constructor', ->
  describe '' ->
    options = 
      api_key: 'API_KEY'
      host: 'api.ucloudbiz.com'
      user: 'test@gmail.com'
    it 'should create a ucloud object with the following properties, api_key, host, user and token', ->
      ucloud = new Ucloud options
      ucloud.api_key.should.equal options.api_key
      ucloud.host.should.equal options.host
      ucloud.user.should.equal options.user
      ucloud.should.not.throw
  describe '' ->
    options =
      host : 'api.ucloudbiz'
      user : 'test@gmail.com'
    it 'should return an error because the api_key is missing from the options', ->
      ucloud = new Ucloud options
      ucloud.should.throw
