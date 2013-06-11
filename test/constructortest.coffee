Ucloud = require '../index'

describe 'UCloud storage API constructor', ->
  describe '', ->
    options = 
      api_key: 'API_KEY'
      authUrl: 'https://api.ucloudbiz.olleh.com'
      user: 'test@gmail.com'
    it 'should create a ucloud object with the following properties, api_key, host, user and token', ->
      ucloud = new Ucloud options
      ucloud.api_key.should.equal options.api_key
      ucloud.authUrl.should.equal options.authUrl
      ucloud.user.should.equal options.user
      ucloud.should.not.throw
  describe '', ->
    options =
      authUrl : 'https://api.ucloudbiz.olleh.com'
      user : 'test@gmail.com'
    it 'should throw an error because the api_key is missing from the options', ->
      
