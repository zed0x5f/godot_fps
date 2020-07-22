extends Spatial
var MAX_BULLET_SPEED = 5
var BULLET_SPEED = 1
var Min_BULLET_SPEED = -4

var current_rotation = 0
var rotation_speed = 5

var BULLET_DAMAGE = 15

const KILL_TIMER = 80
var timer = 0

var hit_something = false

func _ready():
	$Area.connect("body_entered", self, "collided")


func _physics_process(delta):
	
	BULLET_SPEED = (BULLET_SPEED + delta) 
	if BULLET_SPEED > MAX_BULLET_SPEED:
		BULLET_SPEED = Min_BULLET_SPEED
	
	var forward_dir = global_transform.basis.z.normalized()
	global_translate(forward_dir * BULLET_SPEED * delta)

	timer += delta
	if timer >= KILL_TIMER:
		queue_free()


func collided(body):
	if hit_something == false:
		if body.has_method("bullet_hit"):
			body.bullet_hit(BULLET_DAMAGE, global_transform)

	hit_something = true
	queue_free()
