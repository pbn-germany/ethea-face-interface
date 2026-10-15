# Lip-sync stream from the host. Topic: face/viseme (<= 100 Hz).
std_msgs/Header header    # stamp = time the viseme should be shown (PTP-synchronised)
string viseme             # viseme label from the published viseme set
float32 weight            # 0.0-1.0
