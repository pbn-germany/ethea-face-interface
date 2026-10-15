# ETHEA Face — open interface (draft v0.3)

ETHEA Face is an expressive face module that bolts onto a robot. PBN Germany GmbH (Stuttgart) builds it.
This repository holds what you need to mount it, power it, drive it and watch its health, so you can put it on
your own robot without asking us first. The mechanism, the skin process and the learned models are not here;
those stay ours.

> **Status: draft.** Version 1.0 comes out in December 2026. Anything marked [E] is a design target. We haven't
> measured it yet.

## What's in here

| Path | What it is | Licence |
|---|---|---|
| `docs/interface_specification.md` | Mechanical, electrical and software interface: ISO 9409-1-50 flange, 24 V SELV, M12/M8 connectors, safe-torque-off input, ROS 2 topics | CC-BY 4.0 |
| `docs/benchmark_protocol.md` | How we run the life test: the three control arms, the stress profile, what counts as a failure, the statistics | CC-BY 4.0 |
| `face_module_msgs/` | ROS 2 messages, services and actions for the action-unit API (ROS 2 Jazzy; Humble works too) | Apache-2.0 |
| `hardware/` | Flange, envelope and connector drawings, from v1.0 | CERN-OHL-W v2 |

## How it hooks up

Bolt the module to an ISO 9409-1-50-4-M6 flange. Give it 24 V DC and one Gigabit Ethernet cable. Wire your
robot's emergency stop to the two-channel safety input; opening it cuts power to the actuators (safe torque off).

Then talk to it in FACS action units on `face/au_command`. Lip-sync goes to `face/viseme`, and `face/gaze_target`
tells the eyes where to look. The face reports what it actually shows on `face/state` and how it is wearing on
`face/health`: skin wear, drift headroom, temperatures and faults.

The face never sends commands to your robot. If it faults, sees the safety input open, or stops hearing your
heartbeat for 100 ms, it goes to a safe posture: actuators off, neck held on its brakes, lids closed.

## Build the messages

```bash
cd ~/ros2_ws/src && git clone https://github.com/pbn-germany/ethea-face-interface.git
cd ~/ros2_ws && colcon build --packages-select face_module_msgs
```

## Contact
PBN Germany GmbH, Stuttgart: https://pbngermany.de
