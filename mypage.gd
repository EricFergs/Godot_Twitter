extends Control
var database : SQLite
var username = GlobalData.username
@onready var v_box_container: VBoxContainer = $ScrollContainer/VBoxContainer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	database = SQLite.new()
	database.path ="res://checkpoint2.db"
	$Title.text = "UserPage of " + GlobalData.username
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_logout_pressed() -> void:
	get_tree().change_scene_to_file("res://UserPge.tscn")

func get_current_datetime() -> String:
	var datetime = Time.get_datetime_dict_from_system()
	return "%04d-%02d-%02d %02d:%02d:%02d" % [
		datetime["year"], 
		datetime["month"], 
		datetime["day"], 
		datetime["hour"], 
		datetime["minute"], 
		datetime["second"]
	]

func _on_create_post_pressed() -> void:
	var post_text = $InsertText.text	
	var now = get_current_datetime()
	
	
	database.open_db()
	var post = {
			"username" : username,
			"post_text" : post_text
	}
	#var sql = "INSERT INTO post (username, post_text) 
			   #VALUES (?, ?);"
	database.insert_row("post",post)
	database.close_db()
	v_box_container._ready()
	#print(post_text,now)


func _on_follow_pressed() -> void:
	get_tree().change_scene_to_file("res://followerspage.tscn")
