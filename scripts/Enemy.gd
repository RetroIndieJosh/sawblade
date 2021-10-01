extends Node2D

const FORWARD_FORCE = 80
const UP_FORCE = 2

onready var broken_body = preload("res://scenes/Broken Body.tscn")
onready var instance = broken_body.instance()

var is_dead = false

func kill(force_mult):
        if is_dead:
                return

        var forward_force = FORWARD_FORCE * force_mult;
        for child in instance.get_children():
                var offset = Vector2(forward_force, randf() * UP_FORCE)
                child.apply_impulse(Vector2.ZERO, offset)
        add_child(instance)
        $"Full Body".queue_free()
        is_dead = true

func _on_Full_Body_body_entered(body):
        if body.name == "Player":
                kill(body.direction)
