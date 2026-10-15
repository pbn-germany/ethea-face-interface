# Topic: face/health (10 Hz).
std_msgs/Header header
float32 skin_wear_index         # 0.0 (new) - 1.0 (end of life)
float32 drift_headroom          # 0.0 (none left) - 1.0 (full)
uint64 cycles_since_skin_change
float32[] anchor_strain         # per instrumented anchor
float32 mount_strain
ActuatorHealth[] actuators
bool sto_active                 # true = actuator rail de-energised by the safety input
uint8 STATE_OK=0
uint8 STATE_WARN=1
uint8 STATE_FAULT=2
uint8 STATE_SAFE_STOP=3
uint8 state
string[] faults
