fs = require 'fs'


mkdir = (dirName) ->
  unless fs.existsSync dirName
    fs.mkdirSync dirName

writeFile = (filename, data) ->
  fs.writeFileSync filename, data

module.exports =
  mkdir: mkdir
  writeFile: writeFile