chalk = require 'chalk'
axios = require 'axios'
_ = require 'lodash'
{ JSDOM } = require 'jsdom'
qs = require 'querystring'
fs = require 'fs'
helpers = require './helpers.coffee'
TurndownService = require 'turndown'

class Downloader
  constructor: (@options) ->
    unless @options.outputDir
      @options.outputDir = @options.contestId
    for option of @options
      @[option] = @options[option]

Downloader::run = ->
  try
    unless @contestId
      throw new Error 'Contest id is not provided'
    if !@session and @username and @password
      await @login()
    res = await @load()
    await @saveContest res.data
  catch err
    console.log chalk.red err.message

Downloader::load = (path = "/contest/#{@contestId}/problems") ->
  res = await axios.get "https://#{@domain}#{path}",
    headers:
      'Cookie': @_getCookies()
  if res.data.indexOf('Для просмотра страницы необходимо ') != -1 ||
      res.data.indexOf('To view this page you have to ') != -1
    throw new Error 'Need to authirize to view this contest'
  if res.data.indexOf('У вас нет прав просматривать это соревнование') != -1 ||
      res.data.indexOf('You are not allowed to view this contest') != -1
    throw new Error 'You are not allowed to view this contest'
  res

Downloader::login = ->
  unless @domain == 'official.contest.yandex.ru'
    throw new Error 'Login supported only for `official.contest.yandex.ru`'
  res = await axios.get "https://#{@domain}/login/"
  if _.isArray res.headers['set-cookie']
    cookies = res.headers['set-cookie'].reduce (x, y) =>
      x + y.split(' ')[0] + ' '
    , ''
  dom = new JSDOM res.data
  sk = dom.window.document.querySelector('body > div.page__main.page__sect > div > form > input[type="hidden"]:nth-child(1)').value
  data = qs.stringify
    sk: sk
    login: @username
    password: @password
    retpath: "/"
  res = await axios.post "https://#{@domain}/login/", data,
    headers:
      'Cookie': cookies
      'Content-Type': 'application/x-www-form-urlencoded'
    validateStatus: (status) =>
        status >= 200 && status < 303
    maxRedirects: 0

  unless res.headers['set-cookie']
    throw new Error 'Authorization failed'
  session = res.headers['set-cookie'][0].split(' ')[0].split('=')[1]
  @session = session.slice 0, -1

Downloader::_getCookies = () ->
  if @session
    return "Contest_Session_id=#{@session};"
  ""

Downloader::saveContest = (data) ->
  dom = new JSDOM data
  problemElems = dom.window.document.querySelector(
    'body > div.page__main.page__sect > div > ul.tabs-menu.tabs-menu_role_problems'
  ).childNodes
  for problemElem in problemElems
    await @saveProblem problemElem.querySelector('a').href

Downloader::saveProblem = (problemUrl) ->
  problemName = _.nth(problemUrl.split('/'), -2).toLowerCase()
  res = await @load problemUrl
  dom = new JSDOM res.data 
  helpers.mkdir "./#{@outputDir}"
  helpers.mkdir "./#{@outputDir}/#{problemName}"
  fs.writeFileSync "./#{@outputDir}/#{problemName}/main.#{@extension}", ''
  if @readme
    @createReadme "./#{@outputDir}/#{problemName}/readme.md", dom


Downloader::createReadme = (filename, dom) ->
  turndownService = new TurndownService
  markdown = turndownService.turndown dom.window.document.querySelector '.problem__statement.text'
  fs.writeFileSync filename, markdown


module.exports = Downloader