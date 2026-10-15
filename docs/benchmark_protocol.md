> Part of the ETHEA Face open interface (draft). Licence: CC-BY 4.0.

# Benchmark protocol (summary; the full version is pre-registered in December 2026)
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
