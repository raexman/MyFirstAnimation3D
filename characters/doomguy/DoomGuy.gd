extends KinematicBody

#THINGS TO DO:
	#Research more about the state machine
	#Spawn particle on a particular frame
	#Find out why the blending gets weird when walking while shooting
	#Can we add signals to animations?
	#Implement real velocity
	#Implement real jumping with gravity

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export (float) var c = 0;
export (bool) var on_air = false
export (PackedScene) var bullet
export (bool) var jump = false
var state_machine

var last_mouse_position = Vector2(0,0)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization her
			#How can we get to this path using dot notation
		#How can we get to this path using dot notation
	$AnimationTree["parameters/MovementStateMachine/playback"].start("idle")
	$AnimationTree["parameters/MovementStateMachine/conditions/is_idle"] = true


func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	var movement = Vector3(0,0,0)
	var state = 0
	
	if(Input.is_action_pressed("move_front")):
		movement.z = delta
	if(Input.is_action_pressed("move_back")):
		movement.z = -delta
	if(Input.is_action_pressed("move_left")):
		movement.x = delta
	if(Input.is_action_pressed("move_right")):
		movement.x = -delta
	
	var current_mouse_position = get_viewport().get_mouse_position()
	var mouse_position_delta = last_mouse_position - current_mouse_position
	
	if(mouse_position_delta.x != 0):
		rotate_y(mouse_position_delta.x * delta)
	
#	if(mouse_position_delta.y != 0):
#		rotate_z(mouse_position_delta.y * delta)

	last_mouse_position = current_mouse_position
	
	if(Input.is_action_pressed("fire")):
		$AnimationTree["parameters/shooting/blend_amount"] = 1
		if(bullet): 
			var current_bullet = bullet.instance()
	else:
		$AnimationTree["parameters/shooting/blend_amount"] = 0	

		
	#If there's no movement, the character should be idle. 
	if(movement.length() == 0):
		$AnimationTree["parameters/MovementStateMachine/conditions/is_idle"] = true
		$AnimationTree["parameters/MovementStateMachine/conditions/is_moving"] = false
	else:
		global_translate(movement)
		
		$AnimationTree["parameters/MovementStateMachine/walking_strafing/blend_position"].x = movement.x / delta
		$AnimationTree["parameters/MovementStateMachine/walking_strafing/blend_position"].y = movement.z / delta
		$AnimationTree["parameters/MovementStateMachine/conditions/is_moving"] = true	
		$AnimationTree["parameters/MovementStateMachine/conditions/is_idle"] = false	
		
	if(Input.is_action_pressed("jump")):
		#How can we get to this path using dot notation
		$AnimationTree["parameters/MovementStateMachine/conditions/start_jumping"] = true
		$AnimationTree["parameters/MovementStateMachine/conditions/is_idle"] = false
	elif ($AnimationTree["parameters/MovementStateMachine/conditions/start_jumping"]):
		$AnimationTree["parameters/MovementStateMachine/conditions/is_landing"] = true
		$AnimationTree["parameters/MovementStateMachine/conditions/start_jumping"] = false
		
	#$AnimationTree["parameters/state/current"] = state

func _on_Player_animation_finished(anim_name):
	print(anim_name)


func _on_Player_animation_changed(old_name, new_name):
	print("Old name: " + old_name + " | New Name: " + new_name)


func _on_Player_animation_started(anim_name):
	print(anim_name)


