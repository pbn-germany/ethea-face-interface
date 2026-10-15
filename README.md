# ETHEA Face — open interface (draft v0.3)

ETHEA Face is a robot-mountable, expressive face module developed by PBN Germany GmbH (Stuttgart).
This repository publishes **everything a third party needs to mount, power, drive and monitor the module**.
It does not include the mechanism, the skin process or the learned models.

> **Status: draft.** Version 1.0 follows in December 2026. Values marked [E] are design targets, not measurements.

## Contents

| Path | What it is | Licence |
|---|---|---|
| `docs/interface_specification.md` | Mechanical, electrical and software interface: ISO 9409-1-50 flange, 24 V SELV, M12/M8 connectors, safe-torque-off input, ROS 2 topics | CC-BY 4.0 |
| `docs/benchmark_protocol.md` | Summary of the open life-test protocol (three-arm design, stress profile, end points, statistics) | CC-BY 4.0 |
| `face_module_msgs/` | ROS 2 message, service and action definitions of the action-unit API (ROS 2 Jazzy; Humble supported) | Apache-2.0 |
| `hardware/` | Interface drawings (flange, envelope, connector layout), from v1.0 | CERN-OHL-W v2 |

## The interface in one paragraph

Mount the module on an ISO 9409-1-50-4-M6 flange, supply 24 V DC, connect one Gigabit Ethernet link and wire the
host's emergency stop to the dual-channel safety input, which cuts the actuator supply (safe torque off). Then send
FACS action units (`face/au_command`), lip-sync visemes (`face/viseme`) and a gaze target (`face/gaze_target`).
Read back the measured expression (`face/state`) and the module's health (`face/health`: skin wear, drift headroom,
temperatures, faults). The face never commands the host robot. On fault, safety stop or loss of the host heartbeat
it returns to a safe state: actuators de-energised, the neck held by brakes, lids closed.

## Build the messages

```bash
cd ~/ros2_ws/src && git clone https://github.com/pbn-germany/ethea-face-interface.git
cd ~/ros2_ws && colcon build --packages-select face_module_msgs
```

## Contact
PBN Germany GmbH, Stuttgart: https://pbngermany.de
