
extends "projectile_abstract.gd"

var power=0
var velocity=Vector3()

func set_owner(value):
	.set_owner(value)

func shoot():
	get_node("flame").set_emitting(!get_node("flame").is_emitting())
	set_fixed_process(get_node("flame").is_emitting())
	
	return true

func _fixed_process(delta):
	for body in get_node("Area").get_overlapping_bodies():
		if body!=owner and body.has_method("hit"): 
			body.hit(self,true)

func reset():
	var mod=data.get_modifier("attack.elemental_impact")
	if mod=="explosion":
		data.set_modifier("attack.elemental_impact","fire")
		mod="fire"
	
	var flame=get_node("flame")
	if mod=="fire":
		flame.set_color_phase_color(0,Color(1,0.913725,0,0.890196))
		flame.set_color_phase_color(1,Color(1,0.090196,0,0.796078))
		flame.set_color_phase_color(2,Color(0.019608,0,0,0))
	elif mod=="acide":
		flame.set_color_phase_color(0,Color(0.069158,0.429688,0.038605,0.891317))
		flame.set_color_phase_color(1,Color(0.018265,0.222656,0.031039,0.79717))
		flame.set_color_phase_color(2,Color(0.019608,0,0,0))