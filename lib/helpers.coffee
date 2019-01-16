fs = require 'fs'
axios = require 'axios'


mkdir = (dirName) ->
  unless fs.existsSync dirName
    fs.mkdirSync dirName

writeFile = (filename, data) ->
  fs.writeFileSync filename, data

downloadImage = (url, path) ->
  writer = fs.createWriteStream path
  response = await axios
    url: url
    method: 'GET'
    responseType: 'stream'
  response.data.pipe writer
  new Promise (resolve, reject) ->
    writer.on 'finish', resolve
    writer.on 'error', reject
    return


module.exports =
  mkdir: mkdir
  writeFile: writeFile
  downloadImage: downloadImage