#!/usr/bin/env node

require('babel-polyfill')

const CoffeeScript = require('coffeescript')

const { compile } = CoffeeScript;
CoffeeScript.compile = (file, options) => (
  compile(file, Object.assign(options, {
    transpile: {
      presets: ['env'],
    },
  }))
)
CoffeeScript.register()

require('./lib/app.coffee')