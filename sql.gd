extends Control

var database : SQLite


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	database = SQLite.new()
	database.path ="res://checkpoint2.db"
	database.open_db()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	var create_queries = [
		"""
		CREATE TABLE IF NOT EXISTS users (
			username VARCHAR(20) PRIMARY KEY,
			email VARCHAR(30) UNIQUE NOT NULL,
			password VARCHAR(30) NOT NULL
		);
		""",
		"""
		CREATE TABLE IF NOT EXISTS post (
			post_id INTEGER PRIMARY KEY AUTOINCREMENT,
			username VARCHAR(20),
			post_text VARCHAR(300),
			date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
			FOREIGN KEY (username) REFERENCES users(username) ON DELETE CASCADE
		);
		""",
		"""
		CREATE TABLE IF NOT EXISTS comment (
			comment_id INTEGER PRIMARY KEY AUTOINCREMENT,
			username VARCHAR(20),
			post_id INTEGER,
			comment_text VARCHAR(300),
			date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
			FOREIGN KEY (username) REFERENCES users(username) ON DELETE CASCADE,
			FOREIGN KEY (post_id) REFERENCES post(post_id) ON DELETE CASCADE
		);
		""",
		"""
		CREATE TABLE IF NOT EXISTS liked (
			post_id INTEGER,
			username VARCHAR(20),
			PRIMARY KEY (post_id, username),
			FOREIGN KEY (post_id) REFERENCES post(post_id) ON DELETE CASCADE,
			FOREIGN KEY (username) REFERENCES users(username) ON DELETE CASCADE
		);
		""",
		"""
		CREATE TABLE IF NOT EXISTS follow (
			followed_id VARCHAR(20),
			follower_id VARCHAR(20),
			PRIMARY KEY (followed_id, follower_id),
			FOREIGN KEY (followed_id) REFERENCES users(username) ON DELETE CASCADE,
			FOREIGN KEY (follower_id) REFERENCES users(username) ON DELETE CASCADE
		);
		""",
		"""
		CREATE TABLE IF NOT EXISTS profile (
			username VARCHAR(20) PRIMARY KEY,
			bio VARCHAR(500),
			pfp BLOB,
			FOREIGN KEY (username) REFERENCES users(username) ON DELETE CASCADE
		);
		""",
		"""
		CREATE TABLE IF NOT EXISTS bookmark (
			username VARCHAR(20),
			post_id INTEGER,
			PRIMARY KEY (username, post_id),
			FOREIGN KEY (username) REFERENCES users(username) ON DELETE CASCADE,
			FOREIGN KEY (post_id) REFERENCES post(post_id) ON DELETE CASCADE
		);
		""",
		"""
		CREATE TABLE IF NOT EXISTS user_settings (
			username VARCHAR(20) PRIMARY KEY,
			email_notifications BOOLEAN DEFAULT TRUE,
			theme_preference VARCHAR(20) DEFAULT 'light',
			privacy_level VARCHAR(20) DEFAULT 'public',
			FOREIGN KEY (username) REFERENCES users(username) ON DELETE CASCADE
		);
		""",
		"""
		CREATE TABLE IF NOT EXISTS event (
			event_name VARCHAR(100) PRIMARY KEY,
			event_description VARCHAR(500),
			event_date TIMESTAMP,
			created_by VARCHAR(20),
			FOREIGN KEY (created_by) REFERENCES users(username) ON DELETE CASCADE
		);
		"""
		]

	for query in create_queries:
		database.query(query)
			


func _on_enter_pressed() -> void:
	var username = $UserInput.text
	var password = $PassInput.text
	var result = $Title2.text
	var sql = "SELECT * FROM users WHERE username = ? and password = ?"
	var bindings = [username,password]
	database.query_with_bindings(sql,[username,password])
	
	if not database.query_result.is_empty():
		#var userpage = preload("res://UserPge.tscn").instantiate()
		#get_tree().root.add_child(userpage)
		#get_tree().change_scene_to_packed(userpage)
		#get_tree().current_scene.queue_free()
		GlobalData.username = username
		get_tree().change_scene_to_file("res://UserPge.tscn")
		result = "Success"
	else:
		result = "No user"
	
	$Title2.text = result
