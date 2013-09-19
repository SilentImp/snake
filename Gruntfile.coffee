module.exports = (grunt)->
	grunt.initConfig
		watch:
			options:
				livereload: 3555
			coffee:
				files: 'development/coffee/*.coffee'
				tasks: 'coffee'
			compass:
				files: 'development/sass/*.scss'
				tasks: 'compass'
			haml:
				files: 'development/*.haml'
				tasks: 'haml'
			# imgo:
			# 	files: 'production/images/*.png'
			# 	tasks: 'imgo'
			htmlmin:
				files: 'production/*.html'
				tasks: 'htmlmin'
			concat: 
				files: [
					'development/css-separate/*.css'
					# 'development/js-separate/*.js'
				]
				tasks: 'concat'
			# uglify:
			# 	files: 'development/js-separate/**.js'
			# 	tasks: 'uglify'
			cssmin:
				files: 'development/css-separate/**.css'
				tasks: 'cssmin'
		haml:
			default:
				files:[
					src: 'development/*.haml'
					ext: '.html'
					flatten: true
					dest: 'production'
					expand: yes
				]
		compass:
			default:
				options:
					httpGeneratedImagesPath: '../images/'
					sassDir: 'development/sass/'
					imagesDir: 'development/images/'
					generatedImagesDir: 'production/images/'
					cssDir: 'development/css-separate/'
					require: 'sass-globbing'
		coffee:
			default:
				options:
					bare: true
				files:[
					src: 'development/coffee/*.coffee'
					ext: '.js'
					# dest: 'development/js-separate/'
					dest: 'production/js/'
					flatten: true
					expand: yes
				]
		fileregexrename:
			default:
				files:
					"production/": "production/images/**"
				options:
					replacements:[
						pattern: /([a-zA-Z\d]+)-[\da-zA-Z]*.png/ig
						replacement: "production/images/$1.png"
					]
		concat:
			css:
				src: 'development/css-separate/*.css'
				dest: 'production/css/common.css'
			# js:
			# 	src: 'development/js-separate/*.js'
			# 	dest: 'production/js/scripts.js'
		# uglify:
		# 	default:
		# 		files:
		# 			'production/js/scripts.js': '<%= concat.js.dest %>'
		cssmin:
			default:
				files:
					'production/css/common.css': '<%= concat.css.dest %>'
		imgo:
			default:
				src: 'production/images/*'
				options: '-m -b'
		htmlmin:
			default:
				options: 
					collapseWhitespace: true
					removeRedundantAttributes: true
					removeEmptyAttributes: true
				files:[
					src: ['*.html']
					cwd: 'production/'
					ext: '.html'
					dest: 'production/'
					flatten: true
					expand: yes
				]


	grunt.loadNpmTasks 'grunt-imgo'
	grunt.loadNpmTasks 'grunt-file-regex-rename'
	grunt.loadNpmTasks 'grunt-contrib-htmlmin'
	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.loadNpmTasks 'grunt-contrib-compass'
	grunt.loadNpmTasks 'grunt-contrib-cssmin'
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-concat'
	grunt.loadNpmTasks 'grunt-contrib-uglify'
	grunt.loadNpmTasks 'grunt-contrib-haml'

	grunt.registerTask 'default', ['watch']
	