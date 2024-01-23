extends Node

func play_audio(audio_stream: AudioStreamPlayer):
	pass

func play_audio_at_position_3d(audio_stream: AudioStreamPlayer3D, global_position: Vector3):
	var audio_copy: AudioStreamPlayer3D = audio_stream.duplicate()
	audio_copy.finished.connect(func(): audio_copy.queue_free())
	
	add_child(audio_copy)
	audio_copy.global_position = global_position
	audio_copy.play()

func play_audio_2d(audio_stream: AudioStreamPlayer2D):
	pass
