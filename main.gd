extends Node2D

export (PackedScene) var car
export var car_population = 1
#export var car_sample = 1

var screen
var cars = []
var legacy_actions = []
var generation
var mutation_chance = 0.01

# actions: 0 up, 1 down, 2 left, 3 right

func _ready():
	screen = get_viewport_rect().size
	generation = 1
	spawn_cars()

func spawn_cars():
	print("Generation ", generation)
	for _i in range(car_population):
		var this_car = car.instance()
		cars.append(this_car)
		add_child(this_car)
		this_car.position = $StartPos.position
		this_car.play_limit = screen * 2 # hard coded
		var actions = []
		if (generation == 1):
			for _a in range(300):
				actions.append(int(rand_range(0,4)))
		else:
			var p1 = legacy_actions[randi() % legacy_actions.size()]
			var p2 = legacy_actions[randi() % legacy_actions.size()]
			actions = new_child(p1, p2)
		this_car.actions = actions
	$ResetTimer.start()

func _process(_delta):
	for c in cars:
		var score = int(1000000000 / c.position.distance_squared_to($Goal.position))
		c.get_node("Score").text = str(score)

func reset():
	legacy_actions = []
	var totalscore = 0
	for c in cars:
		totalscore += int(c.get_node("Score").text)
	
	for c in cars:
		if int(c.get_node("Score").text) > totalscore / car_population:
			legacy_actions.append(c.actions)
		c.queue_free()
	cars = []
	generation += 1
	spawn_cars()

func new_child(p1, p2):
	var child = []
	for i in range(len(p1)):
		if rand_range(0,1) < mutation_chance:
			child.append(int(rand_range(0,4)))
			continue
		
		if rand_range(0,1) < .5:
			child.append(p1[i])
		else:
			child.append(p2[i])
	return child

func _on_ResetTimer_timeout():
	reset()
