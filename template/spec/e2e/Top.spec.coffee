helper = require('./helper.coffee')

describe 'Top', ->
  @timeout 10000

  beforeEach(helper.beforeEach)
  afterEach(helper.afterEach)

  it 'shows an initial window', ->
    @app.client.getWindowCount().then (count) ->
      expect(count).toBe 1
