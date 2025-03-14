extends Area2D

@export var sceneName: String = "WinScreen"

@onready var animplayer = $AnimatedSprite2D

func _ready():
	animplayer.play("default")

func _physics_process(delta: float) -> void:
	if animplayer.animation != "default":
		animplayer.play("default")

func _on_FinishLine_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player2":
		get_tree().change_scene_to_file(str("res://scenes/" + sceneName + ".tscn"))
