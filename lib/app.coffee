packageFile = require '../package.json'
program = require 'commander'

program
  .version packageFile.version, '-v, --version'
  .command('download [options]', 'Download contest').alias 'd'
  .parse(process.argv);