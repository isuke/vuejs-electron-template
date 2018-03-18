module.exports = {
  prompts: {
    name: {
      type: 'string',
      required: true,
      label: 'Project name'
    },
    description: {
      type: 'string',
      required: true,
      label: 'Project description',
      default: 'A Vue.js project'
    },
    author: {
      type: 'string',
      label: 'Author'
    },
    license: {
      type: 'string',
      label: 'License',
      default: 'MIT'
    },
    altCss: {
      type: 'list',
      label: 'Use alt css',
      default: 'scss',
      choices: [
        'scss',
        'stylus'
      ]
    },
    unitTest: {
      type: 'confirm',
      default: true,
      label: 'Setup unit test?'
    }
  },
  filters: {
    'src/renderer/styles/**/*.scss': 'altCss == "scss"',
    'src/renderer/styles/**/*.styl': 'altCss == "stylus"',
    'spec/unit': 'unitTest'
  },
  completeMessage: '{{#inPlace}}To get started:\n\n  yarn install\n  yarn run dev.{{else}}To get started:\n\n  cd {{destDirName}}\n  yarn install\n  yarn run dev{{/inPlace}}'
}
