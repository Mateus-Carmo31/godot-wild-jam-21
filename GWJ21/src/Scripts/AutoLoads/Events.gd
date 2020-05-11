extends Node

# CAMERA SIGNALS
signal screen_shake(trauma)
signal wants_cam_focus(node_path, camera_zoom)
signal released_cam_focus

# PLAYER SIGNALS
signal player_health_changed(new_health)
signal player_entered_room(room_path)
signal player_exited_room(room_path)
