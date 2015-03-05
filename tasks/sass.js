/**
 * grunt-contrib-stylus options
 * @type {Object}
 */

module.exports = {
  sass: {
    files: [{
      expand: true,
      cwd: '<%= folders.app %>/styles',
      src: ['{,*/}*.sass', '!**/_*'],
      dest: '<%= folders.tmp %>/styles',
      ext: '.css'
    }]
  }
};
