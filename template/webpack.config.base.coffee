fs            = require('fs')
path          = require('path')
webpack       = require('webpack')
merge         = require('webpack-merge')
{{#if_or unitTest e2eTest}}
nodeExternals = require('webpack-node-externals')
{{/if_or}}

loader = {}
loader.vuePre = [
  {
    loader: 'vue-pug-lint-loader'
    options: JSON.parse(fs.readFileSync(path.resolve(__dirname, '.pug-lintrc')))
  }
]
loader.js = ['babel-loader']
loader.coffee = ['babel-loader', 'coffee-loader']
loader.css    = [
  { loader: 'style-loader'  , options: sourceMap: true }
  { loader: 'css-loader'    , options: sourceMap: true }
  { loader: 'postcss-loader', options: sourceMap: true }
]
{{#if_eq altCss "scss"}}
loader.scss = [
{{/if_eq}}
{{#if_eq altCss "stylus"}}
loader.stylus = [
{{/if_eq}}
  { loader: 'style-loader'  , options: sourceMap: true }
  { loader: 'css-loader'    , options: sourceMap: true }
  { loader: 'postcss-loader', options: sourceMap: true }
{{#if_eq altCss "scss"}}
  { loader: 'sass-loader'   , options: sourceMap: true }
  { loader: 'import-glob-loader', options: sourceMap: true }
  {
    loader: 'sass-resources-loader'
    options:
      resources: [
        path.resolve(__dirname, './src/renderer/styles/_variables.scss')
        path.resolve(__dirname, './src/renderer/styles/_mixins.scss')
      ]
  }
{{/if_eq}}
{{#if_eq altCss "stylus"}}
  { loader: 'stylus-loader' , options: sourceMap: true }
  {
    loader: 'stylus-resources-loader'
    options:
      resources: [
        path.resolve(__dirname, './src/renderer/styles/_variables.styl')
        path.resolve(__dirname, './src/renderer/styles/_mixins.styl')
      ]
  }
{{/if_eq}}
]

baseConfig =
  output:
    path: path.resolve(__dirname, './dist')
    libraryTarget: 'commonjs2',
  module:
    rules: [
      {
        test: /\.vue$/
        enforce: "pre"
        exclude: /node_modules/
        use: loader.vuePre
      }
      {
        test: /\.vue$/
        use:
          loader: 'vue-loader'
          options:
            loaders:
              coffee: loader.coffee
              {{#if_eq altCss "scss"}}
              scss: loader.scss
              {{/if_eq}}
              {{#if_eq altCss "stylus"}}
              stylus: loader.stylus
              {{/if_eq}}
      }
      {
        test: /\.(png|jpg|gif|svg)$/
        use: [
          {
            loader: 'file-loader'
            options:
              name: '[name].[ext]'
          }
        ]
      }
      {
        test: /\.js$/
        use: loader.js
        exclude: /node_modules/
      }
      {
        test: /\.coffee$/
        use: loader.coffee
      }
      {
        test: /\.css$/
        use: loader.css
      }
      {{#if_eq altCss "scss"}}
      {
        test: /\.scss$/
        use: loader.scss
      }
      {{/if_eq}}
      {{#if_eq altCss "stylus"}}
      {
        test: /\.styl$/
        use: loader.stylus
      }
      {{/if_eq}}
    ]
  resolve:
    alias:
      '@src':        path.resolve(__dirname, 'src')
      '@renderer':   path.resolve(__dirname, 'src', 'renderer')
      '@scripts':    path.resolve(__dirname, 'src', 'renderer', 'scripts')
      '@components': path.resolve(__dirname, 'src', 'renderer', 'components')
      '@pages':      path.resolve(__dirname, 'src', 'renderer', 'pages')
      '@assets':     path.resolve(__dirname, 'src', 'renderer', 'assets')
      '@styles':     path.resolve(__dirname, 'src', 'renderer', 'styles')
      'vue$': 'vue/dist/vue.esm.js'
  externals:
    '_': 'lodash'
  plugins: [
    new webpack.DefinePlugin
      'process.env':
        NODE_ENV: "'#{process.env.NODE_ENV}'"
    new webpack.ProvidePlugin
      '_': 'lodash'
      'axios': 'axios'
    new webpack.NoEmitOnErrorsPlugin()
  ]

if process.env.NODE_ENV == 'production'
  config = merge baseConfig,
    devtool: '#source-map'
else if process.env.NODE_ENV == 'development'
  config = merge baseConfig, {}
{{#if_or unitTest e2eTest}}
else if process.env.NODE_ENV == 'test'
  config = merge baseConfig,
    externals: [nodeExternals()]
    devtool: 'inline-cheap-module-source-map'
{{/if_or}}
else
  console.error "`#{process.env.NODE_ENV}` is not defined."

module.exports = config
