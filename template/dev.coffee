path                 = require('path')
webpack              = require('webpack')
coffee               = require('coffeescript/register')
WebpackDevServer     = require('webpack-dev-server')
webpackHotMiddleware = require('webpack-hot-middleware')
electron             = require('electron')
{ spawn }            = require('child_process')

webpackRendererConfig = require('./webpack.config.renderer.coffee')
webpackMainConfig     = require('./webpack.config.main.coffee')
colors                = require('./colors.js')

hotMiddleware = undefined

logStats = (proc, data) =>
  log = ''

  log += "#{colors[proc]}┏  #{proc} Process #{new Array((19 - proc.length) + 1).join('-')}\n#{colors.reset}"

  if typeof data == 'object'
    data.toString(
      colors: true,
      chunks: false
    ).split(/\r?\n/).forEach (line) =>
      log += "#{colors[proc]}|#{colors.reset} #{line}\n"
  else
    log += "#{colors[proc]}|#{colors.reset} #{data}\n"

  log += "#{colors[proc]}┗  #{new Array(28 + 1).join('-')}#{colors.reset}"

  console.log(log)

startRenderer = =>
  return new Promise (resolve, reject) =>
    compiler = webpack(webpackRendererConfig)

    hotMiddleware = webpackHotMiddleware compiler,
      log: false
      heartbeat: 2500

    compiler.plugin 'compilation', (compilation) =>
      compilation.plugin 'html-webpack-plugin-after-emit', (data, callback) =>
        hotMiddleware.publish({ action: 'reload' })
        callback()

    compiler.plugin 'done', (stats) =>
      logStats 'renderer', stats

    server = new WebpackDevServer compiler,
      publicPath: 'http://localhost:8080/'
      open: true
      hot: true
      quiet: true
      historyApiFallback: true
      noInfo: true
      contentBase: path.join(__dirname, 'dist')
      before: (app, ctx) =>
        app.use(hotMiddleware)
        ctx.middleware.waitUntilValid =>
          resolve()

    server.listen(8080)

startMain = =>
  return new Promise (resolve, reject) =>

    compiler = webpack(webpackMainConfig)

    compiler.plugin 'watch-run', (compilation, done) =>
      logStats 'main', 'compiling...'
      hotMiddleware.publish({ action: 'compiling' })
      done()

    compiler.watch {}, (err, stats) =>
      if err
        console.error(err)
      else
        logStats 'main', stats

      resolve()

startElectron = =>
  electronProcess = spawn(electron, ['--inspect=5858', path.join(__dirname, 'dist/main.js')])

  electronProcess.stdout.on 'data', (data) =>
    console.log data
  electronProcess.stderr.on 'data', (data) =>
    console.error data

  electronProcess.on 'close', =>
    process.exit()

init = =>
  Promise.all [startRenderer(), startMain()]
    .then =>
      startElectron()
    .catch (err) =>
      console.error(err)

init()
