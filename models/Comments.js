var mongoose = require("mongoose");

var CommentsSchema = mongoose.Schema({
	body: String,
	author: String,
	upvotes: { type: Number, default: 0 },
	posts: { type: mongoose.Schema.Types.ObjectId, ref: "Comment" }
});

CommentsSchema.methods.upvote = function(cb) {
	this.upvotes++;
	this.save(cb);
};

mongoose.model("Comments", CommentsSchema);
