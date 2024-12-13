extends Control




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Title.text = "Welcome " + GlobalData.username
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_logout_pressed() -> void:
	#var main_menu = preload("res://UI.tscn").instantiate()
	#
	#get_tree().root.add_child(main_menu)
	#get_tree().change_scene_to_packed(main_menu)
	#get_tree().current_scene.queue_free()
	get_tree().change_scene_to_file("res://UI.tscn")


func _on_your_page_pressed() -> void:
	get_tree().change_scene_to_file("res://mypage.tscn")
