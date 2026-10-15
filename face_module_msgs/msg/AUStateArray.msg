# Topic: face/state (50 Hz).
std_msgs/Header header
AUState[] aus
geometry_msgs/Vector3 gaze_direction   # unit vector in the face frame
geometry_msgs/Vector3 neck_rpy         # roll, pitch, yaw in rad
uint8 MODE_ACTIVE=0
uint8 MODE_NEUTRAL=1
uint8 MODE_SLEEP=2
uint8 MODE_CALIBRATING=3
uint8 MODE_SAFE_STOP=4
uint8 mode
