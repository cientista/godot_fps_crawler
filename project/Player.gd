
extends Node

var life=3 setget set_life
var shield=100
var shield_damage_factor=1
var shield_regen_speed=50
var no_shield_timeout=0
var no_shield_max_timeout=5
var walk_speed=15 setget set_speed
var jump_strength=9
var hit_invincibility_timeout=0
var hit_invincibility_max_timeout=1
var fire_rate=3
var accessory="" setget set_accessory
var item_to_throw=""

var modifiers= {
	"bomb.sticky":false,
	"bomb.resist_explosion":true,
	"attack.size":1,
	"attack.split_factor":0,
	"attack.split_delay":0.1,
	"attack.elemental_impact":"",
	"attack.elemental_chance":8,
	"attack.elemental_power":0.5,
	"explosion.power":40,
	"projectile.homing":false,
	"attack.autoaim":false,
	"multijump":0
}

var bullet_type=0 setget set_bullet_type
var bullet_shape=0 setget set_bullet_shape
var weapon_base_type=0 setget set_weapon_base_type


var refresh_bullet_pool=true
var refresh_weapon_base=true
var refresh_accessory=false

var attack_regen_speed=1
var attack_frequency=0.1
var attack_capacity=1
var attack_damage_factor=1


var shield_hud

func _fixed_process(delta):
	
	if hit_invincibility_timeout>0:
		hit_invincibility_timeout-=delta
	
	var old_shield=shield
	if no_shield_timeout>0:
		no_shield_timeout-=delta
	else:
		if shield<100:
			shield+=delta*shield_regen_speed
	
	if shield_hud != null and old_shield!=shield:
		shield_hud.value=shield

func hit(damage):
	
	if shield>0:
		shield-=damage*shield_damage_factor
	else:
		if hit_invincibility_timeout<=0:
			hit_invincibility_timeout=hit_invincibility_max_timeout
			life-=1
	
	no_shield_timeout=no_shield_max_timeout
	
	if shield<=0:
		shield=0
	
	if life<1:
		life=0
		print("game over")

	if shield_hud != null:
		shield_hud.value=shield
		shield_hud.lifes=life

func set_life(value):
	print("setting life")
	life=value
	if life<1:
		life=0
		print("game over")
	
	if shield_hud != null:
		shield_hud.lifes=life

func set_speed(value):
	walk_speed=min(value,100)

func get_item(item_node):
	item_node.execute()

func set_bullet_shape(value):
	bullet_shape=value
	refresh_bullet_pool=true

func set_bullet_type(value):
	bullet_type=value
	refresh_bullet_pool=true

func set_weapon_base_type(value):
	weapon_base_type=value
	refresh_bullet_pool=true
	refresh_weapon_base=true

func get_modifier(key):
	if modifiers.has(key):
		return modifiers[key]
	else:
		return null

func set_modifier(key,value):
	modifiers[key]=value

func set_accessory(value):
	if accessory!="" and accessory!=null:
		item_to_throw=accessory
	accessory=value
	refresh_accessory=true
