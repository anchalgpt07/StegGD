extends Button

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	$FileDialog.set_filters(PoolStringArray(["*.png"]))


func _on_Browse_pressed():
	$FileDialog.popup_centered()


func _on_FileDialog_file_selected( path ):
	get_parent().text=path
