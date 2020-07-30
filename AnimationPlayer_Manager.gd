extends AnimationPlayer

const STATE_IDLE = null#null aint allowed in enums
enum {
	STATE_ROOT = -2,
	STATE_PARENT = -1,
	STATE_CHILD = 0,
}

class State:
	var parent:State
	var animationName:String
	var possibleAnimations:Array
	var animationSpeed:int
	var animationEndStateId
		
	func _init(manimationName, manimationEndStateId, manimationSpeed, mpossibleAnimations):
		self.animationName = manimationName
		self.animationEndStateId = manimationEndStateId
		self.animationSpeed = manimationSpeed
		
		for i in range(0, mpossibleAnimations.size()):#tell children who they daddy is
			mpossibleAnimations[i].parent = self
		
		self.possibleAnimations = mpossibleAnimations
		
		match self.animationEndStateId:
			STATE_IDLE:#idle can gointo idles
				self.possibleAnimations.insert(0,self)		
			STATE_ROOT:#pretty much if this is the unequip state
				self.possibleAnimations.insert(0,traverse_to_root(self))
			STATE_PARENT:
				self.possibleAnimations.insert(0,self.parent)
	
	func traverse_to_root(pointer:State):
		if pointer.parent == null:
			return pointer
		else:
			return self.traverse_to_root(pointer.parent)
	
	func get_animation_end():
		match self.animationEndStateId:
			STATE_IDLE:
				return null
			STATE_ROOT:
				return self.traverse_to_root(self)
			STATE_PARENT:
				return self.parent
			STATE_CHILD:
				return self.possibleAnimations[0]

#
var state:State = State.new(
"Idle_unarmed",STATE_IDLE,1,
[
	State.new("Knife_equip",STATE_CHILD,1,
	[
		State.new("Knife_idle",STATE_IDLE,1,
		[
			State.new("Knife_unequip",STATE_ROOT,1,
			[]),
			State.new("Knife_fire",STATE_PARENT,8,
			[]),
		]),
	]),
	State.new("Pistol_equip",STATE_CHILD,1.4,
	[
		State.new("Pistol_idle",STATE_IDLE,1,
		[
			State.new("Pistol_unequip",STATE_ROOT,1,
			[]),
			State.new("Pistol_fire",STATE_PARENT,10,
			[]),
			State.new("Pistol_reload",STATE_PARENT,5,
			[]),
		])
	]),
	State.new("Rifle_equip",STATE_CHILD,2,
	[
		State.new("Rifle_idle",STATE_IDLE,1,
		[
			State.new("Rifle_unequip",STATE_ROOT,1,
			[]),
			State.new("Rifle_fire",STATE_PARENT,4,
			[]),
			State.new("Rifle_reload",STATE_PARENT,5,
			[]),
		])
	]),
])

var current_state = null
var callback_function = null

func _ready():
	play_current_state()
	connect("animation_finished", self, "animation_ended")

func set_animation(animation_name):
	if animation_name == current_state:
		print ("AnimationPlayer_Manager.gd -- WARNING: animation is already ", animation_name)
		return true
	if has_animation(animation_name) == true:
		if current_state != null:
			for e in state.possibleAnimations:
				if e.animationName == animation_name:
					state = e
					play_current_state()
					return true
			print ("AnimationPlayer_Manager.gd -- WARNING: Cannot change to ", animation_name, " from ", current_state)
			return false
		else:
			print ("AnimationPlayer_Manager.gd -- WARNING: Current state is null which is shouldnt be")
	return false

func animation_ended(poo):
	var endState = state.get_animation_end()
	if endState != null:
		state = endState
		play_current_state()

func play_current_state():
	current_state = state.animationName
	play(state.animationName, -1, state.animationSpeed)

func animation_callback():
	if callback_function == null:
		print ("AnimationPlayer_Manager.gd -- WARNING: No callback function for the animation to call!")
	else:
		callback_function.call_func()
