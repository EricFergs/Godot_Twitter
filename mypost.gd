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
	var sql = "SELECT p.username,p.post_text,p.date,p.post_id FROM post p WHERE username = ?"
	database.query_with_bindings(sql,[username])
	
	for row in database.query_result:
		var username = row["username"]
		var post_text = row["post_text"]
		var date = row["date"]
		var post_id = row["post_id"]
		#print("Username:", username, "Post:", post_text, "Date:", date)
		var newTweet = TWEET.instantiate()
		var tweet_user = newTweet.get_node("User")
		var tweet_post = newTweet.get_node("Post")
		var tweet_date = newTweet.get_node("Date")
		var delete_post = newTweet.get_node("DeletePost")
		var tweet_post_id = newTweet.get_node("post_id")
		tweet_user.text = "User: " + username
		tweet_post.text = "Post: " + post_text
		tweet_date.text = "Date: " + date
		tweet_post_id.text = str(post_id)
		newTweet.generate_likes()
		delete_post.visible = true
		newTweet.get_node("AddLike").visible = false
		self.add_child(newTweet)
		# Close the database
	database.close_db()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func delete_post(post_id):
	database.open_db()
	var query_conditions = "post_id = " + post_id
	var success = database.delete_rows("post", query_conditions)
	_ready()
	
