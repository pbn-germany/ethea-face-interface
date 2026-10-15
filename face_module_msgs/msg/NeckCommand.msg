# Neck pose target. Values above the firmware limits are clamped.
std_msgs/Header header
float32 yaw               # rad
float32 pitch             # rad
float32 roll              # rad
float32 max_speed         # rad/s; 0 = default speed
