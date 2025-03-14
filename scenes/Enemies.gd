extends RigidBody2D

@onready var animplayer = $AnimatedSprite2D
@onready var sound = $AudioStreamPlayer2D

func _ready():
	animplayer.play("idle")
	
	set_contact_monitor(true)
	set_max_contacts_reported(1)
	sleeping = false

func _physics_process(delta: float) -> void:
	if animplayer.animation != "idle":
		animplayer.play("idle")

func _on_Enemies_body_entered(body: Node2D) -> void:
	# Jika Player menyentuh Enemies, maka Enemies akan menghilang
	if body.name == "Player2":
		if sound and not sound.playing:
			sound.play()
		await sound.finished
		
		queue_free() 
