> Part of the ETHEA Face open interface (draft). Licence: CC-BY 4.0.

# Benchmark protocol (summary; the full version is pre-registered in December 2026)

The question is simple: how long does a realistic silicone face keep its expressions when it rides on a working
robot? Nobody has published a number for that, so we wrote down how we will measure it before we start.

## What one cycle is

One cycle is one expression going from neutral to its peak and back (onset, apex, offset). The expressions come
from a fixed sequence that covers every validated action unit, with pauses in between so that creep shows up. On
average the mouth moves 1.2 times a second, which is our care-dialogue duty cycle (metric 2). That makes 1,000 rig
hours about 4.3 million cycles.

## What the heads go through

- Vibration replayed from a log recorded on a walking Unitree R1 (PSD in IEC 60068-2-64 format), plus shocks
  (IEC 60068-2-27).
- 5–40 °C and up to 85% relative humidity.
- IP5X dust on the sealed pod (IEC 60529).
- Daily wipe-downs with disinfectant, and a standard touch-and-abrasion rig on the skin.

Positions on the rig are shuffled between arms, so no arm gets the quiet corner.

## The three arms

All heads are identical. Only the control software differs.

- **A** runs the published Morpheus control method, pinned to one version and refitted only to our actuator map.
  An independent lab checks that our port tracks the reference expressions as well as it should, then
  hash-registers it before the first cycle. If A is a weak port, the comparison means nothing, which is why
  someone else signs off on it.
- **A'** is A plus a neutral rest pose between expressions. It's the cheap fix anyone could try.
- **B** is our strain-aware control.

A face can last longer just by doing less. To block that, an external camera rig measures how far the landmarks
actually move for each action unit, and all three arms are held within ±3% of each other. We check this at every
milestone and correct the commanded intensity when an arm drifts.

## What counts as a failure

The skin fails when it tears, when an anchor lets go, or when an action unit stops working because of the skin or
an anchor. The independent lab decides the cause. Actuators also break. When one does we replace it and carry on,
and arm B may not use more replacements than arm A. All-cause life, actuators included, goes in the report too.

## Statistics

We fit one model, chosen in advance: a Weibull model with the same shape parameter for every arm, fitted by
maximum likelihood, with heads still running treated as censored. The result is the ratio of characteristic lives.

## When we call it a success

**Stage 1, decided at Jury Session 2.** First we measure the peak skin strain of arms A and B on the heads, at the
same delivered expression, with digital image correlation. Then we take silicone coupons from the production batch
and cycle them to failure at those two strains, at 40 °C and 85% RH, with at least 10 coupons per strain level, at
about 5 Hz. Success means coupons at B's strain last at least 10× as long as coupons at A's strain. We use the same
estimator and always report the 80% lower bound.

**Stage 2, on whole heads.** B lasts at least 10× as long as A and at least 3× as long as A'. We use the point
estimate, or the 80% lower bound if no B head has failed yet, and we always report that lower bound. We don't use
step-stress to speed up the whole-head ratio.

## The prediction, written down first

In month 2 we measure the fatigue exponent F of our silicone on coupons. In month 3 we measure how much B lowers
the peak strain on the heads. Rubber fatigue follows power-law crack growth (Gent, Lindley and Thomas 1964), so
life scales with strain^-2F. Halving the peak strain gives 4–16× for F between 1 and 2. We record the predicted
ratio before any head fails. FEM is a design tool here. It isn't evidence.

## Why Stage 1 rests on coupons

There are 3 heads per arm. From month 3, 8 mouth-and-cheek sub-assemblies each for arms A and B run alongside
them. To show a 10× whole-head ratio in about 5,000 rig hours, arm A would have to fail within roughly 450 hours
(about 1.9 million cycles). Nobody can promise that. The only published material data, for a laminated
silicone-foam-mesh skin at 25% strain (US 11,207,864 B2), are samples that were still intact after 1.4–4.4 million
cycles. That is a lower bound, not a failure time.

Coupons fail within months, so the Stage 1 claim stands on them. If arm A's heads are still running at month 10,
we report the whole-head ratio as "not yet informative", give its lower bound, and keep the test going into Stage 2.

## B10

We run a Weibull analysis that treats heads still running as censored. B10 is reported as a projection, with a
lower bound.

## Openness

The protocol, the vibration profile and the raw logs are public. Any lab can rerun the test.
