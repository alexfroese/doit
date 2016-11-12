angular.module "flapper", ["ui.router"]
	.config ["$urlRouterProvider", "$stateProvider", ($urlRouterProvider, $stateProvider) ->
		$stateProvider.state "home",
			url: "/"
			templateUrl: "/views/posts/index.html"
			controller: "HomeCtrl"
			resolve:
				postsPromise: ["posts", (posts) ->
					posts.getAll()
				]
		.state "posts",
			url: "/posts/{id}"
			templateUrl: "/views/posts/post.html"
			controller: "PostsCtrl"
			resolve:
				post: ["$stateParams", "posts", ($stateParams, posts) ->
					posts.get $stateParams.id
				]
		$urlRouterProvider.otherwise "/"
	]
.factory "posts", ["$http", "auth", ($http, auth) ->
	o = posts: []
	o.getAll = ->
		$http.get "/posts"
			.success (data) ->
				angular.copy data, o.posts
	o.get = (id) ->
		$http.get "/posts/#{id}"
			.then (res) ->
				res.data
	o.create = (post) ->
		$http.post "/posts", post,
			headers: Authorization: "Bearer #{auth.getToken()}"
		.success (data) ->
			o.posts.push data
	o.upvote = (post) ->
		$http.put "/posts/#{post._id}/upvote", null,
			headers: Authorization: "Bearer #{auth.getToken()}"
		.success ->
			post.upvotes++
	o.addComment = (id, comment) ->
		$http.post "/posts/#{id}/comments", comment,
			headers: Authorization: "Bearer #{auth.getToken()}"
	o.upvoteComment = (post, comment) ->
		$http.put "/posts/#{post._id}/comments/#{comment._id}/upvote", null,
			headers: Authorization: "Bearer #{auth.getToken()}"
		.success ->
			comment.upvotes++
	o
]
.factory "auth", ["$http", "$window", ($http, $window) ->
	auth = {}
	auth.saveToken = (token) ->
		$window.localStorage["flapper-token"] = token
	auth.getToken = ->
		$window.localStorage["flapper-token"]
	auth.isLoggedIn = ->
		return if (token = auth.getToken())
			payload = JSON.parse $window.atob token.split(".")[1]

			payload.exp > parseInt Date.now() / 1000
		false
	auth.currentUser = ->
		return if auth.isLoggedIn()
			JSON.parse $window.atob auth.getToken().split(".")[1]
				.username
	auth.register = (user) ->
		$http.post "/users/register", user
			.success (data) ->
				auth.saveToken data.token
	auth.login = (user) ->
		$http.post "/users/login", user
			.success (data) ->
				auth.saveToken data.token
	auth.logout = ->
		$window.localStorage.removeItem "flapper-token"
	auth
]
.controller "HomeCtrl", ["$scope", "posts", ($scope, posts) ->
	$scope.posts = posts.posts
	$scope.addPost = ->
		return unless $scope.title
		posts.create
			title: $scope.title
			link: $scope.link
		$scope.title = ""
		$scope.link = ""
	$scope.upvote = (post) ->
		posts.upvote post
]

socket = io()
