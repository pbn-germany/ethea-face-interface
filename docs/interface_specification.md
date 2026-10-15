# ETHEA Face — Interface Specification v0.3 (draft)

> PBN Germany GmbH, Stuttgart · draft, October 2026 · v1.0 in December 2026.
> **Goal:** a third party can mount, power, drive and monitor the module without contacting PBN.
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

## 5. Benchmark protocol (summary; full version pre-registered at M1)
- **Cycle:** one onset–apex–offset of one expression from a standard sequence covering every validated AU,
  with dwell periods for creep. The rig runs the care-dialogue duty cycle of metric 2: on average 1.2 mouth cycles
  per second, so 1,000 rig hours ≈ 4.3 million cycles.
- **Stress profile:** vibration replayed from a walking Unitree R1 log (PSD in IEC 60068-2-64 format) plus shocks
  (IEC 60068-2-27); 5–40 °C, up to 85% RH; IP5X dust exposure of the sealed pod (IEC 60529); daily disinfectant
  cleaning; a standardised touch and abrasion rig on the skin. Rig positions are randomised across arms.
- **Arms (identical hardware):** A = published Morpheus control method, version-pinned, re-fitted only to the
  actuator map; the independent lab audits the port for competence (tracking error on the reference expressions)
  and hash-registers it before the first cycle. A' = A plus a neutral rest pose between expressions. B = ETHEA Face strain-aware control.
- **Same expression in all arms:** delivered landmark amplitude per AU is measured by the external camera rig;
  all three arms are held to the same delivered amplitude per AU (±3%), checked at every milestone and corrected
  by the commanded intensity, so no arm can gain life by expressing less.
- **Primary end point:** skin failure — skin tear, anchor release, or loss of an action unit caused by skin or
  anchor; the cause is decided by the independent lab. Failed actuators are replaced and the test continues; arm B
  may not need more actuator replacements than arm A. **Reported alongside:** all-cause life incl. actuators.
- **Estimator (one, pre-registered):** Weibull model with a common shape parameter across arms, fitted by maximum
  likelihood with run-outs as censored data; the ratio of characteristic lives is the result. **Success:** B/A ≥ 10
  and B/A' ≥ 3 (point estimate; if B has no failures, the 80% lower bound), with the 80% lower bound always reported.
  No step-stress for the ratio.
- **Prediction before data:** the fatigue exponent F of our silicone is measured on coupons in month 2; with the
  FEM-predicted strain reduction it gives the expected ratio (life ∝ strain^-2F, Gent, Lindley and Thomas 1964;
  halving peak strain gives 4–16× for F = 1–2), recorded before any head fails.
- **Statistical power:** 3 heads per arm, plus 8 mouth-and-cheek sub-assemblies each for arms A and B from month 3, with the heads.
  A 10× ratio can be shown within about 5,000 rig hours only if arm A fails within roughly 450 h (about 1.9 million
  cycles). No published value predicts arm A's life: the only material data (laminated silicone-foam-mesh skin at
  25% strain, US 11,207,864 B2) are run-outs after 1.4–4.4 million cycles, i.e. a lower bound. Whether arm A fails
  in time is therefore an open question that we test before Gate 1: the pre-submission run on the reference head,
  and our own coupon S-N data at 30–50% strain in month 2. Facial strains above 25%, vibration and heat are expected
  to shorten life, most in the high-strain mouth-and-cheek sub-assemblies [E]. If arm A has not failed, the pre-registered outcome is "not yet
  informative" and the claim continues in Stage 2.
- **Statistics for B10:** Weibull analysis with run-outs; B10 is stated as projected, with a lower bound.
- **Openness:** protocol, vibration profile and raw logs published; any lab can repeat the test.

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
