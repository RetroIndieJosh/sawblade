extends KinematicBody2D

export var show_debug = false
export var floor_det_dist = 20.0

export var accel_speed = 1.8

export var direction_max = 20

export var forward_speed = 40
export var gravity = 20
export var rotate_mult = 4

onready var direction_min = -direction_max
onready var velocity = Vector2.ZERO
onready var platform_detector = $PlatformDetector
onready var label = $"Label"
onready var sprite = $"Sprite"

onready var direction = 1;
onready var is_on_platform = false

func _physics_process(delta):
        process_input(delta)
        process_gravity(delta)

        move_on_floor()

        check_enemy()
        check_wall()

        if show_debug:
                display_debug()


func _process(delta):
        sprite.rotation += delta * direction

func _ready():
        label.visible = show_debug

func process_input(delta):
        if Input.is_action_pressed("left"):
                direction -= delta * accel_speed * accel_speed
        elif Input.is_action_pressed("right"):
                direction += delta * accel_speed * accel_speed
        direction = clamp(direction, direction_min, direction_max)

func check_enemy():
        var slide_count = get_slide_count()
        if slide_count:
                var collision = get_slide_collision(slide_count - 1)
                var collider = collision.collider
                if collider.get_name() == "Full Body":
                        collider.get_node("..").kill(direction)

func move_on_floor():
        is_on_platform = platform_detector.is_colliding()
        if is_on_platform:
                velocity.x = direction * forward_speed
        else:
                velocity.x = 0

        var snap_vector = Vector2.ZERO
        #if direction.y == 0.0:
        snap_vector = Vector2.DOWN * floor_det_dist
        velocity = move_and_slide_with_snap(
                velocity, snap_vector, Vector2.UP, not is_on_platform, 4, 0.9, false
        )

func check_wall():
        if is_on_wall():
                velocity.x = 0
                direction = 0

func display_debug():
        label.set_text("%s\ndir %.2f\npos (%.2f, %.2f)\nvel (%.2f, %.2f)" 
                % ["on platform" if is_on_platform else "NOT on platform", direction,
                position.x, position.y, velocity.x, velocity.y])

func process_gravity(delta):
        if is_on_platform:
                velocity.y = 0
                return
        velocity.y += gravity * delta
