extends TextureRect
var database : SQLite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_delete_post_pressed() -> void:
	get_parent().delete_post($post_id.text)


func _on_delete_post_2_pressed() -> void:
	GlobalData.post_id = $post_id.text
	get_tree().change_scene_to_file("res://commentsPage.tscn")

func generate_likes():
	database = SQLite.new()
	database.path ="res://checkpoint2.db"
	database.open_db()
	var sql = "SELECT COUNT(*) AS c FROM liked WHERE post_id = ?"
	database.query_with_bindings(sql,[$post_id.text])
	#print(database.query_result)
	var count = str(database.query_result[0]["c"])
	$Likes.text = "Likes: " + str(count)
	$likesecret.text = count
	database.close_db()
		
	


func _on_add_like_pressed() -> void:
	#database = SQLite.new()
	#database.path ="res://checkpoint2.db"
	#database.open_db()
	#var sql = "SELECT * FROM liked WHERE post_id = ? AND username = ?"
	#database.query_with_bindings(sql,[$post_id.text,GlobalData.username])
	if GlobalData.faking == true:
		$likesecret.text = str(int($likesecret.text) + 1)
		$Likes.text = "Likes: " + $likesecret.text
		GlobalData.faking = false
	else:
		GlobalData.faking = true
		$likesecret.text = str(int($likesecret.text) -1)
		$Likes.text = "Likes: " + $likesecret.text
