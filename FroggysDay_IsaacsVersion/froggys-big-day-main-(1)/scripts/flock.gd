class_name Flock
extends Node2D
## Reynolds-style boids (separation, alignment, cohesion) plus an orbit
## behavior that makes the flies circle this node's origin in a tight cloud.
## Move the node to move the swarm.

@export var count := 40

@export_group("Perception")
@export var perception_radius := 40.0
@export var separation_radius := 12.0
@export_range(0, 360) var fov_degrees := 360.0

@export_group("Movement")
@export var max_speed := 130.0
@export var min_speed := 60.0
@export var max_force := 600.0

@export_group("Boid Weights")
@export var separation_weight := 1.2
@export var alignment_weight := 0.5
@export var cohesion_weight := 0.3
@export var jitter_weight := 0.15

@export_group("Orbit")
@export var orbit_radius := 50.0
@export var orbit_speed := 100.0
@export var orbit_weight := 1.5
## How firmly each fly is held to its own orbit radius.
@export var orbit_radius_hold := 2.0
## 0 = single ring, ~0.4-0.6 = fuzzy ball.
@export_range(0.0, 1.0) var orbit_radius_variation := 0.4
@export_enum("Clockwise:1", "Counter-clockwise:-1") var orbit_direction := 1
## If true, each fly picks a random direction (chaotic buzz instead of a vortex).
@export var mixed_directions := false

@export_group("Look")
## Your PNG. Leave empty to fall back to simple triangles.
@export var fly_texture: Texture2D
@export var fly_scale := 1.0
## Which way your art points in the PNG, so it rotates correctly.
@export_enum("Right:0", "Up:-90", "Left:180", "Down:90") var art_facing_degrees := 0
## Turn off if your art shouldn't rotate (e.g. a top-down fly that stays upright).
@export var rotate_with_heading := true
@export var fly_color := Color(0.1, 0.1, 0.1) ## Used for the triangle fallback only.
@export var fly_size := 5.0 ## Used for the triangle fallback only.

var positions := PackedVector2Array()
var velocities := PackedVector2Array()
var _accel := PackedVector2Array()
var _orbit_radii := PackedFloat32Array()
var _orbit_dirs := PackedInt32Array()


func _ready() -> void:
	positions.resize(count)
	velocities.resize(count)
	_accel.resize(count)
	_orbit_radii.resize(count)
	_orbit_dirs.resize(count)

	for i in count:
		_orbit_radii[i] = orbit_radius * randf_range(
			1.0 - orbit_radius_variation, 1.0 + orbit_radius_variation
		)
		_orbit_dirs[i] = (1 if randf() < 0.5 else -1) if mixed_directions else orbit_direction

		# Start on the orbit, already moving around it.
		var radial := Vector2.from_angle(randf() * TAU)
		positions[i] = radial * _orbit_radii[i]
		velocities[i] = radial.orthogonal() * _orbit_dirs[i] * orbit_speed


func _physics_process(delta: float) -> void:
	# Pass 1: compute every boid's steering from the OLD state.
	for i in count:
		_accel[i] = _compute_steering(i)
	# Pass 2: integrate.
	for i in count:
		var v := velocities[i] + _accel[i] * delta
		var speed := v.length()
		if speed > 0.0:
			v = v / speed * clampf(speed, min_speed, max_speed)
		velocities[i] = v
		positions[i] += v * delta
	queue_redraw()


func _compute_steering(i: int) -> Vector2:
	var pos := positions[i]
	var vel := velocities[i]
	var heading := vel.normalized()
	var cos_half_fov := cos(deg_to_rad(fov_degrees * 0.5))
	var r2 := perception_radius * perception_radius
	var sep_r2 := separation_radius * separation_radius

	var separation := Vector2.ZERO
	var align_sum := Vector2.ZERO
	var center_sum := Vector2.ZERO
	var n := 0

	for j in count:
		if j == i:
			continue
		var offset := positions[j] - pos
		var d2 := offset.length_squared()
		if d2 > r2 or d2 == 0.0:
			continue
		# Field of view: ignore flockmates outside our vision cone.
		if heading.dot(offset / sqrt(d2)) < cos_half_fov:
			continue
		n += 1
		align_sum += velocities[j]
		center_sum += positions[j]
		if d2 < sep_r2:
			separation -= offset / d2  # push away, stronger when closer

	var accel := Vector2.ZERO

	# --- Reynolds' three rules ---
	if n > 0:
		accel += _steer_toward(center_sum / n - pos, vel) * cohesion_weight
		accel += _steer_toward(align_sum / n, vel) * alignment_weight
	if separation != Vector2.ZERO:
		accel += _steer_toward(separation, vel) * separation_weight

	# --- Orbit the central point ---
	# Desired velocity = tangent (go around) + radial correction (hold radius).
	var r := pos.length()
	if r > 0.001:
		var radial := pos / r
		var tangent := radial.orthogonal() * _orbit_dirs[i]
		var my_radius := _orbit_radii[i]
		# Positive = too close to center (push out), negative = too far (pull in).
		var error := clampf((my_radius - r) / my_radius, -1.0, 1.0)
		var desired := (tangent + radial * error * orbit_radius_hold).normalized() * orbit_speed
		accel += (desired - vel).limit_length(max_force) * orbit_weight

	# --- Small random flutter so they look like flies ---
	accel += Vector2.from_angle(randf() * TAU) * max_force * jitter_weight

	return accel.limit_length(max_force)


## Reynolds steering: desired velocity minus current velocity, capped at max_force.
func _steer_toward(direction: Vector2, vel: Vector2) -> Vector2:
	if direction == Vector2.ZERO:
		return Vector2.ZERO
	var desired := direction.normalized() * max_speed
	return (desired - vel).limit_length(max_force)


func _draw() -> void:
	if fly_texture == null:
		_draw_triangles()
		return

	var size := fly_texture.get_size() * fly_scale
	var rect := Rect2(-size * 0.5, size)  # centered on each fly's position
	for i in count:
		var angle := 0.0
		if rotate_with_heading:
			angle = velocities[i].angle() - deg_to_rad(art_facing_degrees)
		draw_set_transform(positions[i], angle, Vector2.ONE)
		draw_texture_rect(fly_texture, rect, false)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)  # reset


func _draw_triangles() -> void:
	for i in count:
		var h := velocities[i].normalized()
		var p := h.orthogonal()
		var c := positions[i]
		draw_colored_polygon(
			PackedVector2Array([
				c + h * fly_size * 1.5,
				c - h * fly_size + p * fly_size * 0.6,
				c - h * fly_size - p * fly_size * 0.6,
			]),
			fly_color
		)
