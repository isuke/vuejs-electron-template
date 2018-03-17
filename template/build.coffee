path = require('path')
builder = require('electron-builder')

builder.build
  config:
    appId: 'com.example.{{ name }}'
    directories:
      output: path.join(__dirname, 'build')
    files: [
      path.join(__dirname, 'dist', '*')
    ],
    dmg:
      contents: [
        x: 410
        y: 150
        type: 'link'
        path: '/Applications'
      ,
        x: 130
        y: 150
        type: 'file'
      ]
    mac:
      icon: path.join(__dirname, 'icons', 'icon.icns')
    linux:
      icon: path.join(__dirname, 'icons')
.then =>
  console.log 'build finish'
.catch (err) =>
  console.error err
