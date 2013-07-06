fs = require 'fs'
crypto = require 'crypto'

shasum = crypto.createHash 'md5'

module.exports = (filePath,callback) ->
  if filePath
    stream = fs.ReadStream filePath
    stream.on 'data', (data) ->
      shasum.update data
    stream.on 'end', ->
      callback null, shasum.digest 'hex'
    stream.on 'error', ->
      callback new Error "UCloud Checksum : Error when creating a md5 checksum for #{filePath}"
  else
    callback new Error "UCloud Checksum : No filePath specified"
