fs = require('fs')
path = require('path')
webpack = require('webpack')
merge = require('webpack-merge')
HtmlWebpackPlugin = require('html-webpack-plugin')

baseConfig = require('./webpack.config.base.coffee')

rendererConfig = merge baseConfig,
  entry: [
    './src/renderer.js'
    'webpack-hot-middleware/client?noInfo=true&reload=true'
  ]
  output:
    filename: 'renderer.js'
  target: 'electron-renderer'
  externals:
    'Vue': 'vue'
    'axios': 'axios'
  plugins: [
    new webpack.ProvidePlugin
      'Vue': 'vue'
    new HtmlWebpackPlugin
      template: path.resolve(__dirname, 'src', 'renderer', 'index_template.html')
      nodeModules: if process.env.NODE_ENV == 'production' then false else path.resolve(__dirname, 'node_modules')
    new webpack.HotModuleReplacementPlugin()
  ]

if process.env.NODE_ENV == 'production'
  config = merge rendererConfig, {}
else if process.env.NODE_ENV == 'development'
  config = merge rendererConfig,
    output:
      publicPath: 'http://localhost:8080/'
    performance:
      hints: false
else if process.env.NODE_ENV == 'test'
  config = merge rendererConfig, {}
else
  console.error "`#{process.env.NODE_ENV}` is not defined."

module.exports = config
