/**
 * grunt-autoprefixer options
 * @type {Object}
 */

module.exports = {
  options: {
    browsers: ['last 2 version']
  },
  dist: {
    files: [{
      expand: true,
      cwd: '<%= folders.tmp %>/styles',
      dest: '<%= folders.tmp %>/styles',
      src: '{,*/}*.css'
    }]
  }
};
