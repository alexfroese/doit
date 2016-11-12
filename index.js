var express = require("express");
var app = express();
var server = require("http").createServer(app);
var io = require("socket.io")(server);
var bodyParser = require("body-parser");
var cookieParser = require("cookie-parser");
var morgan = require("morgan");
var path = require("path");

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());

app.use(morgan("dev"));

var mongoose = require("mongoose");
mongoose.Promise = require("bluebird");

require("./models/Posts");
require("./models/Comments");

mongoose.connect("mongodb://localhost/news");

var routes = require("./routes/index");
var posts = require("./routes/posts");

io.on("connection", function(socket) {
	console.log("socket connected");
});

app.use(express.static(path.join(__dirname, "public")));
app.use(express.static(path.join(__dirname, "bower_components")));

app.use("/", routes);
app.use("/posts", posts);

server.listen(3000, function() {
	console.log("listening");
});
