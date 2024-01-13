@tool
extends EditorPlugin


func _enter_tree() -> void:
	print_rich("[b]Jay's Reusable Components and Things[/b] has been loaded [color=green]successfully![/color]")
	pass

func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass
