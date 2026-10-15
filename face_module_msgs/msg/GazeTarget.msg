# Gaze target for the eyes (and neck, if enabled), in the host frame.
geometry_msgs/PointStamped target
uint8 MOTION_SACCADE=0
uint8 MOTION_SMOOTH=1
uint8 motion
bool allow_neck           # true: the neck may turn to keep the target in view
