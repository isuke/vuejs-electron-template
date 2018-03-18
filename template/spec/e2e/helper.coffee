module.exports =
  beforeEach: ->
    @app = new Application(
      path: electronPath
      args: [ path.join(__dirname, '..', '..', 'dist', 'main.js') ])
    @app.start()

  afterEach: ->
    @app.stop() if @app and @app.isRunning()
