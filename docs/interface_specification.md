# ETHEA Face — Interface Specification v0.3 (draft)

> PBN Germany GmbH, Stuttgart · draft, October 2026 · v1.0 in December 2026.
> **Goal:** you can mount, power, drive and monitor the module without ever having to call us.
> Values marked [E] are design targets, not measurements.

## 1. Mechanical

| Item | Specification |
|---|---|
| Mounting flange | ISO 9409-1-50-4-M6 (Ø50 mm pitch circle, 4 × M6, Ø6 H7 locating pin) at the base of the neck pod |
| Mass | ≤ 3.0 kg incl. neck pod and compute [E] |
| Centre of mass | Published per release as (x, y, z) from the flange face, with the inertia tensor |
| Envelope | Adult-head size; STEP model and drawing per release |
| Neck pod | 3 DoF (yaw, pitch, roll); ranges and maximum speeds published per release; spring-applied brakes hold the pose on safe torque off |
| Face-only variant | Face module without the neck pod, for hosts with their own neck; adapter to the host's head plate |
| Mount strength | Rated for the IEC 60068-2-27 shock load with a safety factor of 2; integrated mount-strain sensor |
| Humanoid neck adapter | Adapter plates from ISO 9409-1-50 to common humanoid neck interfaces, published with the first reference carrier |

## 2. Electrical (SELV)

| Connector | Standard | Function |
|---|---|---|
| Power: M12 L-coded, 5-pin | IEC 61076-2-111 | 24 V DC actuators; 24 V DC logic (separate, so logic stays alive during STO); 2 × GND; PE |
| Data: M12 X-coded, 8-pin | IEC 61076-2-109 | Gigabit Ethernet: ROS 2 / DDS, camera streams, PTP time sync (IEEE 1588) |
| Safety: M8 A-coded, 4-pin | IEC 61076-2-104 | Dual-channel E-stop / STO input from the carrier's safety chain |
| Service | USB-C | Local service and recovery only |

- **Supply:** 24 V DC nominal (SELV). Mean power ≤ 40 W in the standard expression loop incl. neck and compute;
  peak ≤ 80 W [E]. Exact values per release.
- **Safety input:** 2 channels at 24 V DC, compatible with OSSD test pulses (≤ 1 ms). Opening either channel opens
  two contactors in the actuator rail (STO). Response time ≤ 20 ms [E]. Status reported on `face/health`.
- **Heat into the host:** most of the module's heat leaves through the flange (up to about 35 W [E]); flange
  temperature ≤ 45 °C [E]; measured values published per release.
- **Noise:** ≤ 45 dB(A) at 1 m in the standard expression loop [E].
- **Audio:** no loudspeaker. The host plays audio and streams visemes with timestamps.
- **Part numbers and pin-out tables:** in the v1.0 release (December 2026).

## 3. Software: ROS 2 driver (package `face_module`)

- **Target:** ROS 2 Jazzy (LTS); Humble supported. Units and frames follow REP-103 / REP-105. URDF/xacro and meshes
  provided for simulation.
- **Semantics:** commands are at FACS action-unit level (e.g. `AU12`), intensity 0.0–1.0 (mapped to FACS A–E), per
  side. Mapping to actuators is internal. The face never commands the host robot.

| Interface | Type | Content | Rate |
|---|---|---|---|
| `face/au_command` | subscribe | list of {au_id, intensity 0–1, side, onset_ms, hold_ms, offset_ms} | ≤ 100 Hz |
| `face/viseme` | subscribe | lip-sync stream with timestamps | ≤ 100 Hz |
| `face/gaze_target` | subscribe | `GazeTarget`: `geometry_msgs/PointStamped` in the host frame; saccade or smooth; neck allowed or not | ≤ 50 Hz |
| `face/neck_command` | subscribe | yaw / pitch / roll targets with speed limit (bounded by firmware limits) | ≤ 50 Hz |
| `face/heartbeat` | subscribe | from the host; no message within 100 ms → functional stop to the safe posture | ≥ 20 Hz |
| `face/state` | publish | measured AU intensities, gaze direction, neck pose, mode (active / neutral / safe-stop) | 50 Hz |
| `face/health` | publish | skin-wear index 0–1, drift headroom, per-actuator temperature, current and position error, anchor strain, mount strain, cycles since skin change, STO status, state OK / WARN / FAULT / SAFE_STOP | 10 Hz |
| `face/eye_cam/{left,right}/image_raw` | publish | `sensor_msgs/Image` + `CameraInfo`; **off by default**, enabled by the host | 30 Hz |
| `~/get_capabilities` | service | supported AUs, ranges, limits, firmware version | — |
| `~/set_mode` | service | active / neutral / sleep | — |
| `~/play_sequence` | service | named expression sequence from the published library | — |
| `~/recalibrate` | action | automatic self-calibration after skin replacement (target < 15 min) | — |
| `~/safe_stop`, `~/reset` | service | software stop; reset only after the self-test passes and the carrier confirms | — |

- **Watchdog:** a functional stop, not a safety function. Safety rests on the hardware STO path.
- **Network and QoS:** own VLAN or subnet; camera topics best-effort, command and health topics reliable;
  configurable DDS domain ID.
- **Non-ROS API:** Ethernet / JSON (WebSocket) with the same messages and semantics; Python and C++ clients.
- **Firmware update:** signed images over Ethernet, A/B partitions with rollback; version reported by
  `get_capabilities`.

## 4. Reference drivers and integration package
- **Open demo driver** (Apache-2.0): plays expressions, lip-syncs to audio, follows a gaze target. No ETHEA licence
  needed. Used in Stage 1 to show that the API is brain-agnostic.
- **ETHEA driver** (optional, licensed separately) as a dialogue "mind".
- **Integration package** (grows per stage): this specification, CAD envelope and mounting drawing, ROS 2 package
  with examples, URDF with mass properties, calibration and setup protocol, **< 4 h installation checklist**,
  benchmark protocol, safety datasheet and declaration of incorporation.

## 5. Benchmark protocol (summary; the full text is `docs/benchmark_protocol.md`, pre-registered at M1)
We measure how long the face keeps its expressions on a working robot. The heads run a fixed expression sequence
that covers every validated action unit, at 1.2 mouth cycles a second (1,000 rig hours ≈ 4.3 million cycles). They
do this on a shaker replaying vibration logged on a walking Unitree R1, with IEC 60068-2-27 shocks, 5–40 °C, up to
85% RH, IP5X dust, daily disinfectant and a touch-and-abrasion rig.

- **Arms (identical hardware):** A runs the published Morpheus control, version-pinned. The independent lab audits
  our port and hash-registers it. A' is A plus a neutral rest pose. B is our strain-aware control. An external
  camera rig holds all three to the same delivered expression per action unit (±3%), so no arm can last longer by
  doing less.
- **Failure:** the skin tears, an anchor lets go, or an action unit is lost through skin or anchor. The independent
  lab decides the cause. Failed actuators are replaced, B may not use more of them than A, and all-cause life is
  reported too.
- **Statistics:** one pre-registered Weibull model with a common shape parameter. Heads still running count as
  censored. The 80% lower bound is always reported.
- **Stage 1 success (Jury Session 2):** we measure the peak skin strain of A and B on the heads with digital image
  correlation. Silicone coupons are cycled to failure at those two strains (40 °C, 85% RH, n ≥ 10 per level,
  about 5 Hz). Coupon life at B's strain must be ≥ 10× that at A's.
- **Stage 2 success (whole heads):** B/A ≥ 10 and B/A' ≥ 3.
- **Why coupons in Stage 1:** a whole-head 10× shows within ~5,000 rig hours only if A fails within ~450 h. The only
  published data (US 11,207,864 B2, flat skin at 25% strain) are run-outs at 1.4–4.4 million cycles, so nobody can
  promise that. If A's heads are still running at month 10, the whole-head ratio is "not yet informative", with
  its lower bound, and the test continues.
- **Prediction first:** F is measured on coupons in month 2 and the strain cut on heads in month 3. Since life
  ∝ strain^-2F (Gent, Lindley and Thomas 1964), the predicted ratio is on record before any head fails. FEM is
  for design only.
- **Openness:** protocol, vibration profile and raw logs are public; any lab can rerun the test.

## 6. Thermal budget (design target)
≤ 40 W mean [E], dissipated mainly in the actuator pod and conducted to the flange and the host. Pass criterion in
the climate chamber: skin surface ≤ 43 °C at 40 °C ambient. The host must accept up to about 35 W [E] at the
flange; the measured value is published per release.

## 7. Licences, versions and standards
- **Interface hardware** (flange, connector layout, envelope, interface boards): CERN-OHL-W v2.
- **Software** (driver, messages, demo driver, SDK): Apache-2.0. **Documentation:** CC-BY 4.0.
- **Proprietary:** mechanism design, skin-anchor geometry, silicone formulation and process, learned models,
  calibration algorithm, manufacturing know-how.
- **Versioning:** semantic versioning; breaking interface changes announced ≥ 3 months ahead.
- **Standards work:** a ROS 2 REP proposal for an action-unit-level face interface; contribution of the interface
  and benchmark to ISO/TC 299 work on service robots (via DIN); safety design to ISO 12100 and ISO 13849-1;
  certification of the module's safety function in Stage 4; support for the host's ISO 13482 certification.
