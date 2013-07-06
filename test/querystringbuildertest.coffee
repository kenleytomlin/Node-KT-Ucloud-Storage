mocha = require 'mocha'
should = require 'should'
QueryStringBuilder = require '../lib/QueryStringBuilder'

describe 'It should create a querystring from an object', ->
  query = undefined
  describe '', ->
    before ->
      query =
        limit: 10
        format: 'json'
    it 'should return a query string limit=10&format=json', ->
      queryString = QueryStringBuilder.build query
      queryString.should.be.a 'string'
      queryString.should.equal 'limit=10&format=json'

  describe '', ->
    query = undefined
    before ->
      query = null
    it 'should return an error', ->
      queryString = QueryStringBuilder.build query
      queryString.should.be.a 'object'
      queryString.message.should.equal 'QueryStringBuilder : No object to parse'