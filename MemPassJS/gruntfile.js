module.exports = function(grunt) {

    // Project configuration.
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),

        uglify: {
            dist: {
                files: {
                    'mempass.min.js': [
                        "mempass.js",
                        "dice.js",
                        "options.js"
                    ]
                },
                options: {
                    beautify: false,
                    mangle: true,
                    sourceMap: true
                }
            }
        },

        copy: {
            dist: {
                files: [
                  // includes files within path
                  {expand: true, src: ['mempass.min.js'], dest: '../chrome-extension/mempass', filter: 'isFile'},
                  {expand: true, src: ['mempass.min.js'], dest: '../website/js', filter: 'isFile'},
                ]
            }
        }
    });

    // Load the plugin that provides the tasks.
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-copy');

    // Default task(s).
    grunt.registerTask('default', [
        'uglify','copy'
    ]);
};