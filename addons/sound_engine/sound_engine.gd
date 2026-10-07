extends Node

var current_bgm=null
func _on_bgm_finished() -> void:%Bgm.play()
func stop_bgm():%Bgm.stop()
func play_bgm(stream:AudioStream):
	%Bgm.stream=stream
	%Bgm.play()
	current_bgm=stream
func set_bgm(stream:AudioStream):
	if current_bgm==stream:
		if %Bgm.playing:pass
		else:%Bgm.play()
	else:play_bgm(stream)


const SFX = preload("uid://c33qy6gtn75br")
func play_sfx(stream:AudioStream,db:float=0):
	var s:AudioStreamPlayer=SFX.instantiate()
	s.stream=stream
	s.volume_db=db
	%Sfx.add_child(s)

func play_sfx_sfx(sfx:Sfx):%Sfx.add_child(sfx)
