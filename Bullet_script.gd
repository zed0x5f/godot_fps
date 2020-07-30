extends Spatial

const MAX_BULLET_SPEED = 20
const MIN_BULLET_SPEED = -2
const KILL_TIMER = 80

var bullet_damage = 15

var bullet_speed = 15
var current_rotation = 0
var rotation_speed = 5

var timer = 0

var hit_something = false
var init_scale: Vector3

func _ready():
	$Area.connect("body_entered", self, "collided")
	init_scale = scale * 4

func _physics_process(delta):
	timer += delta
	bullet_speed = (bullet_speed + delta)
	
	if bullet_speed > MAX_BULLET_SPEED:
		bullet_speed = MIN_BULLET_SPEED
	if bullet_speed > 0:
		scale.z = init_scale.z
	else:
		scale.z = -1*init_scale.z
	var factor = (((10*timer)/KILL_TIMER)*10+1)
	#scale.x = init_scale.x * factor
	
	var forward_dir = global_transform.basis.z * bullet_speed + global_transform.basis.x * 3
	global_translate(forward_dir  * delta)
	self.rotate(global_transform.basis.z.normalized(), .08*PI)
	
	if timer >= KILL_TIMER:
		queue_free()


func collided(body):
	if hit_something == false:
		if body.has_method("bullet_hit"):
			body.bullet_hit(bullet_damage, global_transform)
	
	#var rotation = Quat(body.global_transform.basis)
	#print(rotation)
	$RayCast.force_raycast_update()
	var n = $RayCast.get_collision_normal().normalized()
	richochet(n)
	print(n)
	#hit_something = true
	#queue_free()

func richochet(normal):
	var rot = self.get_rotation()
	#easy as pi
	rot = -2*rot.dot(normal)*normal - rot
	rot.normalized()
	self.rotation = rot
	#print(rot)
	
