import fs from 'fs'


mkdir = (dirName) ->
  unless fs.existsSync dirName
    fs.mkdirSync dirName

writeFile = (filename, data) ->
  fs.writeFileSync filename, data

export default {
  mkdir
  writeFile
}