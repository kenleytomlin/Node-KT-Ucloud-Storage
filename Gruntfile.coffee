module.exports = (grunt) ->

  grunt.initConfig
    coffee:
      glob_to_multiple:
        expand: true
        options:
          bare: true
        src: ['**/*.coffee']
        cwd: 'src'
        dest: './'
        ext: '.js'

    cafemocha:
      specs:
        src: 'test/*.coffee'
        options:
          ui: 'bdd'
          require: 'should'
          reporter: 'spec'

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-cafe-mocha'

  #Default task
  grunt.registerTask 'default', ['coffee']
  grunt.registerTask 'test', ['coffee','cafemocha']