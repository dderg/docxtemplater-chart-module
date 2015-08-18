var gulp = require('gulp');
var watch= require('gulp-watch');
var coffee= require('gulp-coffee');
var uglify= require('gulp-uglify');

var config={uglify:false}

var paths = {
	coffee: ['coffee/docUtils.coffee','coffee/chartManager.coffee','coffee/index.coffee', 'coffee/chartMaker.coffee'],
	coffeeTest: ['coffee/test.coffee'],
	testDirectory:__dirname+'/test',
    js:'js/'
};

gulp.task('allCoffee', function () {
	gulp.src(paths.coffee)
        .pipe(coffee({bare:true}))
        .pipe(gulp.dest(paths.js))

	a=gulp.src(paths.coffeeTest)
		.pipe(coffee({map:true}))

	if(config.uglify)
		a=a.pipe(uglify())

	a=a
		.pipe(gulp.dest(paths.testDirectory));
});

gulp.task('watch', function () {
	gulp.src(paths.coffee)
		.pipe(watch(function(files) {
			var f=files.pipe(coffee({bare:true}))
				.pipe(gulp.dest(paths.js))
			return f;
		}));

	gulp.watch(paths.coffeeTest,['coffeeTest']);
});

gulp.task('coffeeTest', function() {
	a=gulp.src(paths.coffeeTest)
		.pipe(coffee({map:true}))

	if(config.uglify)
		a=a.pipe(uglify())

	a=a
		.pipe(gulp.dest(paths.testDirectory));

	return a;
});

gulp.task('default',['coffeeTest','watch']);
