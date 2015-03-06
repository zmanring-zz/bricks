/**
 * grunt-contrib-watch options
 * @type {Object}
 */

module.exports = {
  server: {
    options: {
      livereload: true
    },
    files: [
      '<%= folders.tmp %>/*.html',
      '<%= folders.tmp %>/styles/{,*/}*.css',
      '{.tmp,<%= folders.app %>}/scripts/{,*/}*.js',
      '<%= folders.app %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}'
    ]
  },
  jade: {
    files: '<%= folders.app %>/jade/**/*.jade',
    tasks: ['jade']
  },
  sass: {
    files: '<%= folders.app %>/styles/**/*.sass',
    tasks: ['sass', 'autoprefixer']
  },
  coffee: {
    files: '<%= folders.app %>/scripts/**/*.coffee',
    tasks: ['coffee']
  }
};
