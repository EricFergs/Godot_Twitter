extends Control
var database : SQLite
@onready var v_box_container: VBoxContainer = $ScrollContainer/VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	database = SQLite.new()
	database.path ="res://checkpoint2.db"
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_logout_pressed() -> void:
	get_tree().change_scene_to_file("res://UserPge.tscn")


func _on_create_post_pressed() -> void:
	var post_text = $InsertText.text	
	
	
	database.open_db()
	var comment	 = {
			"username" : GlobalData.username,
			"post_id" : GlobalData.post_id,
			"comment_text" : post_text
	}
	#var sql = "INSERT INTO post (username, post_text) 
			   #VALUES (?, ?);"
	database.insert_row("comment",comment)
	database.close_db()
	v_box_container._ready()
