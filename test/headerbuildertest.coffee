mocha = require 'mocha'
should = require 'should'

headerBuilder = require '../lib/HeaderBuilder'

describe 'HeaderBuilder', ->
  options = 
    'X-Host':'http://images.ooparoopa.com'
    'X-User':'bjk110@gmail.com'
    'X-Pass':'APIKEY'
  it 'should check that the options is an object', ->
    headers = headerBuilder.build options
    should.exist headers
    headers.should.be.a 'object'