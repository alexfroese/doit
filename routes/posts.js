var express = require("express");
var router = express.Router();
var mongoose = require("mongoose");
var Post = mongoose.model("Post");

router.get("/", function(req, res, next) {
	Post.find(function(err, posts) {
		if (err)
			return next(err);

		res.json(posts);
	});
});

module.exports = router;
