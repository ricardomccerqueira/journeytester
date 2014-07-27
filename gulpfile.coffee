gulp    = require('gulp')
coffee  = require('gulp-coffee')
gutil   = require('gulp-util')
concat  = require('gulp-concat')
watch   = require('gulp-watch')

paths =
  scripts: [
    './src/_dependencies.coffee'
    './src/_config.coffee'
    './src/_journeytester.coffee'    
    './src/app.coffee'
  ]
  images: []

gulp.task 'scripts', () ->
  gulp.src(paths.scripts)
    .pipe(coffee({bare: true}).on('error', swallowError))
    .pipe(concat('journeytester.js'))
    .pipe(gulp.dest('./'))

gulp.task 'watch', () ->
  gulp.watch(paths.scripts, ['scripts'])

gulp.task('default', ['scripts', 'watch'])

swallowError = (error)->
  console.log(error.toString())
  this.emit('end')