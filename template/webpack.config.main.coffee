fs = require('fs')
path = require('path')
webpack = require('webpack')
merge = require('webpack-merge')

baseConfig = require('./webpack.config.base.coffee')

mainConfig = merge baseConfig,
  output:
    filename: 'main.js'
  entry: './src/main.js'
  target: 'electron-main'
  node:
    __dirname:  process.env.NODE_ENV != 'production'
    __filename: process.env.NODE_ENV != 'production'
  externals: ['remote']
  plugins: [
    new webpack.NoEmitOnErrorsPlugin()
  ],

if process.env.NODE_ENV == 'production'
  config = merge mainConfig, {}
else if process.env.NODE_ENV == 'development'
  config = merge mainConfig, {}
else if process.env.NODE_ENV == 'test'
  config = merge mainConfig, {}
else
  console.error "`#{process.env.NODE_ENV}` is not defined."

module.exports = config
