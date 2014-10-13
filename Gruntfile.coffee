module.exports = (grunt) ->

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    clean:
      js: ['./bin/*']
    coffeelint:
      options:
        max_line_length:
          value: 120
          level: "warn"
        no_trailing_whitespace:
          level: "warn"
    coffee:
      compile:
        files:
          './bin/finite-countdown.js': './src/finite-countdown.coffee'
    uglify:
      js:
        files: [{
          expand: true
          cwd: './'
          src: ['./bin/*.js']
          dest: './'
          ext: '.min.js'
        }]

  require('load-grunt-tasks')(grunt)

  grunt.registerTask 'replace-assets', [
    'clean:js',
    'coffeelint',
    'coffee',
    'uglify:js'
  ]

  grunt.registerTask 'default', ['replace-assets']
