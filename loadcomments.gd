extends VBoxContainer
var database : SQLite
var username = GlobalData.username
const TWEET = preload("res://tweet.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		child.queue_free()
	database = SQLite.new()
	database.path ="res://checkpoint2.db"
	database.open_db()
	var sql = "SELECT username, comment_text FROM comment WHERE post_id = ?"
	database.query_with_bindings(sql,[GlobalData.post_id])
	
	for row in database.query_result:
		var username = row["username"]
		var post_text = row["comment_text"]
		var date = "Forgot to add"
		#print("Username:", username, "Post:", post_text, "Date:", date)
		var newTweet = TWEET.instantiate()
		var tweet_user = newTweet.get_node("User")
		var tweet_post = newTweet.get_node("Post")
		var tweet_date = newTweet.get_node("Date")
		var tweet_comment = newTweet.get_node("ReadComment")
		tweet_user.text = "User: " + username
		tweet_post.text = "Post: " + post_text
		tweet_date.text = "Date: " + date
		tweet_comment.visible = false
		newTweet.get_node("AddLike").visible = false
		newTweet.get_node("Likes").visible = false
		self.add_child(newTweet)
		# Close the database
	database.close_db()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
