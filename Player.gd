extends KinematicBody2D

const FLOOR_DETECT_DISTANCE = 20.0

const ACCEL_SPEED = 1.8

const DIRECTION_MAX = 20
const DIRECTION_MIN = -DIRECTION_MAX

const FORWARD_SPEED = 40
const GRAVITY = 20
const ROTATE_MULT = 4

onready var velocity = Vector2.ZERO
onready var platform_detector = $PlatformDetector
onready var direction = 1;
onready var label = $"Label"
onready var sprite = $"Sprite"

func _ready():
        pass # Replace with function body.

func _process(delta):
        sprite.rotation += delta * direction

func _physics_process(delta):
        var is_on_platform = platform_detector.is_colliding()

        if Input.is_action_pressed("left"):
                direction -= delta * ACCEL_SPEED * ACCEL_SPEED
        elif Input.is_action_pressed("right"):
                direction += delta * ACCEL_SPEED * ACCEL_SPEED
        direction = clamp(direction, DIRECTION_MIN, DIRECTION_MAX)

        if is_on_platform:
                velocity.x = direction * FORWARD_SPEED
        else:
                velocity.x = 0

        var prev_direction = max(0, direction)
        if is_on_wall():
                velocity.x = 0
                direction = 0

        # gravity
        if is_on_platform:
                velocity.y = 0
        else:
                velocity.y += GRAVITY * delta

        label.set_text("%s\ndir %.2f\npos (%.2f, %.2f)\nvel (%.2f, %.2f)" 
                % ["on platform" if is_on_platform else "NOT on platform", direction,
                position.x, position.y, velocity.x, velocity.y])

        var snap_vector = Vector2.ZERO
        #if direction.y == 0.0:
        snap_vector = Vector2.DOWN * FLOOR_DETECT_DISTANCE
        #var target_velocity = move_and_slide_with_snap(
        velocity = move_and_slide_with_snap(
                velocity, snap_vector, Vector2.UP, not is_on_platform, 4, 0.9, false
        )

        # check for collide with enemy
        var slide_count = get_slide_count()
        if slide_count:
                var collision = get_slide_collision(slide_count - 1)
                var collider = collision.collider
                if collider.get_name() == "Full Body":
                        print("KILL!!");
                        collider.get_node("..").kill(direction)
                        direction = -prev_direction
