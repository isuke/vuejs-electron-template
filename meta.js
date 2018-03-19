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
    },
    e2eTest: {
      type: 'confirm',
      default: true,
      label: 'Setup e2e test?'
    }
  },
  helpers: {
    'if_or': function(val1, val2, opts) {
      if (val1 || val2) {
        return opts.fn(this)
      }
    },
    'if_and': function(val1, val2, opts) {
      if (val1 && val2) {
        return opts.fn(this)
      }
    }
  },
  filters: {
    'src/renderer/styles/**/*.scss': 'altCss == "scss"',
    'src/renderer/styles/**/*.styl': 'altCss == "stylus"',
    'spec/unit/**/*': 'unitTest',
    'spec/e2e/**/*': 'e2eTest',
  },
  completeMessage: '{{#inPlace}}To get started:\n\n  yarn install\n  yarn run dev.{{else}}To get started:\n\n  cd {{destDirName}}\n  yarn install\n  yarn run dev{{/inPlace}}'
}
