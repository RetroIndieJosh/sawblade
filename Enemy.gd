extends Node2D

const EXPLODE_FORCE = 200

onready var broken_body = preload("res://Broken Body.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# on collision
func kill(force_mult):
        var instance = broken_body.instance()
        var explode_force = EXPLODE_FORCE * force_mult;
        add_child(instance)
        for child in instance.get_children():
                var offset = Vector2(randf() * explode_force, randf() * explode_force)
                child.apply_impulse(Vector2.ZERO, offset)
        $"Full Body".queue_free()
