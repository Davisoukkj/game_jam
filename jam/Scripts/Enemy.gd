extends CharacterBody3D

enum States{
	patrol,
	chasing,
	hunting,
	waiting
}

var currentState : States
var navigationAgent : NavigationAgent3D
@export var waypoints: Array[Marker3D]
var 	WaypointIndex: int
@export var speed = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	currentState = States.patrol
	navigationAgent = $NavigationAgent3D
	#waypoints = get_tree().get_nodes_in_group("EnemyWaypoint")
	#navigationAgent.set_target_location(waypoints[0].global_position)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	match currentState:
		States.patrol:
			if(navigationAgent.is_navigation_finished()):
				return
			var targetPos = navigationAgent.get_next_location()
			var direction = global_position.direction_to(targetPos)
			velocity = direction * speed
			move_and_slide()
			pass
		States.chasing:
			pass
		States.hunting:
			pass
		States.waiting:
			pass
	pass
