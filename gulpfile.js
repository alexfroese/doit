var gulp = require("gulp");
var coffee = require("gulp-coffee");
var less = require("gulp-less");
var uglify = require("gulp-uglify");
var cssmin = require("gulp-cssmin");

gulp.task("coffee", function() {
	return gulp.src("./public/coffee/**/*.coffee")
		.pipe(coffee({
			bare: true
		}))
		.pipe(uglify())
		.pipe(gulp.dest("./public/js"));
});

gulp.task("less", function() {
	return gulp.src("./public/less/**/*.less")
		.pipe(less())
		.pipe(cssmin())
		.pipe(gulp.dest("./public/css"))
});

gulp.task("default", ["coffee", "less"]);
