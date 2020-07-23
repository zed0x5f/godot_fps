extends RigidBody

const BASE_BULLET_BOOST = 9;

func _ready():
	pass

#var bullet_scene = preload("Bullet_Scene.tscn")
func bullet_hit(damage, bullet_global_trans):
	var direction_vect = bullet_global_trans.basis.z.normalized() * BASE_BULLET_BOOST;

	apply_impulse((bullet_global_trans.origin - global_transform.origin).normalized(), direction_vect * damage)
	var scene_root = get_tree().root.get_children()[0]
	#var clone = bullet_scene.instance()
	#scene_root.add_child(clone)

	#clone.global_transform = self.global_transform
	#clone.scale = Vector3(4, 4, 4)
	#clone.rotate(Vector3.RIGHT,PI)
	#clone.BULLET_DAMAGE = 15
