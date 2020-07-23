extends Spatial
var MAX_BULLET_SPEED = 2
var BULLET_SPEED = .15
var Min_BULLET_SPEED = -2

var current_rotation = 0
var rotation_speed = 5

var BULLET_DAMAGE = 15

const KILL_TIMER = 80
var timer = 0

var hit_something = false

var init_scale: Vector3

func _ready():
	$Area.connect("body_entered", self, "collided")
	init_scale = scale * 4

func _physics_process(delta):
	
	BULLET_SPEED = (BULLET_SPEED + delta)
	
	if BULLET_SPEED > MAX_BULLET_SPEED:
		BULLET_SPEED = Min_BULLET_SPEED
		
	var factor = (((10*timer)/KILL_TIMER)*10+1)
	scale.x = init_scale.x * factor
	
	var forward_dir = global_transform.basis.z + global_transform.basis.x
	forward_dir = forward_dir
	global_translate(forward_dir * BULLET_SPEED * delta)
	self.rotate(global_transform.basis.z.normalized(),.08*PI)
	
	timer += delta
	if timer >= KILL_TIMER:
		queue_free()


func collided(body):
	if hit_something == false:
		if body.has_method("bullet_hit"):
			body.bullet_hit(BULLET_DAMAGE, global_transform)
	
	

	
	hit_something = true
	queue_free()
