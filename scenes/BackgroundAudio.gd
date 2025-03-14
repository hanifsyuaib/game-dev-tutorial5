extends Node

@onready var player = $Player2
@onready var initial_music = $StartAudio
@onready var new_music = $BackgroundAudio

@export var max_distance: float = 1000

var start_position = Vector2.ZERO
var music_switched = false

func _ready():
	start_position = player.position
	initial_music.play()
	new_music.stop()

func _process(delta):
	var distance = player.position.distance_to(start_position)
	
	# Dari start audio diganti ke background audio ketika jauh dari posisi awal
	if distance >= max_distance and not music_switched:
		if initial_music.playing:
			initial_music.stop()
		
		await get_tree().create_timer(0.1).timeout
		
		if not new_music.playing:
			new_music.play()
			
		music_switched = true 
