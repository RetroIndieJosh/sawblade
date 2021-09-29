extends Node2D

const EXPLODE_FORCE = 200

onready var broken_body = preload("res://scenes/Broken Body.tscn")

func kill(force_mult):
        var instance = broken_body.instance()
        var explode_force = EXPLODE_FORCE * force_mult;
        add_child(instance)
        for child in instance.get_children():
                var offset = Vector2(randf() * explode_force, randf() * explode_force)
                child.apply_impulse(Vector2.ZERO, offset)
        $"Full Body".queue_free()
