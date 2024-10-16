extends CharacterBody3D

enum states{
	walking,
	sneaking,
	crouching,
	inAir,
	standing,
	jumping
}

const SPEED = 4.0
const CROUCHSPEED = 2.0
const JUMP_VELOCITY = 2.5
@export var sensitivity = 2.5
var crouched : bool
var flashLightIsOut : bool
var LightLevel : float
var wasInAir : bool
@export var mouse_sensitivity := 0.2


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready(): #MOUSE PRESO NA TELA
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event): #PRIMEIRA PESSOA
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta): #MOVIMENTAÇÃO
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var speed = SPEED
	if Input.is_action_just_pressed("Crouch"):
		speed = CROUCHSPEED
		if !crouched:
			$AnimationPlayer.play("Crounch")
			crouched = true
	else:
		if crouched:
			$AnimationPlayer.play("upCrounch")
			crouched = false
	
	if Input.is_action_just_pressed("FlashLight"):
		if flashLightIsOut:
			$AnimationPlayer.play("FlashlightHide")
		else:
			$AnimationPlayer.play("FlashlightShow")
		flashLightIsOut = !flashLightIsOut
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

