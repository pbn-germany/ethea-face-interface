# One FACS action-unit command.
string au_id              # FACS action unit, e.g. "AU12"
float32 intensity         # 0.0-1.0, mapped to FACS intensity A-E
uint8 SIDE_BOTH=0
uint8 SIDE_LEFT=1
uint8 SIDE_RIGHT=2
uint8 side
uint32 onset_ms           # ramp from current to target intensity
uint32 hold_ms            # 0 = hold until the next command
uint32 offset_ms          # ramp back to neutral after hold
