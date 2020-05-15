extends Node

# CAMERA SIGNALS
signal screen_shake(trauma)
signal wants_cam_focus(node_path, camera_zoom)
signal released_cam_focus

# PLAYER SIGNALS
signal player_health_changed(new_health)
signal player_lives_changed(new_lives)
signal player_entered_room(room_path)
signal player_exited_room(room_path)
signal player_died

# ENEMY SIGNALS
signal enemy_spawned(enemy)
signal enemy_died(enemy)

# ROOM SIGNALS
signal room_cleared

# GAME LOOP SIGNALS
signal player_left

# UI SIGNALS
signal death_animation_ended
