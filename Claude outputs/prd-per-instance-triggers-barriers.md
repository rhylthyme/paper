# PRD: Per-instance triggering, barriers and in-flight limits for replicated steps

**Type:** feature / schema change (0.2.x → 0.3.0-alpha)
**Repos affected:** rhylthyme-spec, rhylthyme-cli-runner (Python validator + planner + curses runner), rhylthyme-mcp (JS validator + authoring guide), rhylthyme-timeline (renderer), rhylthyme-server (web player), rhylthyme-examples
**Origin:** McKeever et al. 2025, "User-friendly scheduler using a hybrid architecture and supercomputing for big data processing" (bioRxiv 10.1101/2025.09.01.673517), §2.2 *asynchronous nodes*, *barrier nodes* and *maximum asynchronous concurrency*, adapted from compute workflows to human-executed schedules.

---

## 1. Problem

`replicates` and `batch_size`/`stagger` let an author say "do this step (or track) *n* times" without copying JSON. What they cannot say is **what happens downstream of a replicated step, per instance**. Today, as far as the expansion and the paper describe it, a step that depends on a replicated step waits for *all* instances ("fan out into sub-tracks that rejoin"). Three common situations need finer control:

1. **Pipeline per instance.** Three trays of cookies bake one after another in a single oven. Each tray should start cooling *the moment it comes out*, not after the third tray is done. Today "cool" either waits for all three bakes or has to be hand-copied three times with hand-wired `afterStep` references, which is exactly the duplication `replicates` was meant to remove.
2. **Explicit rejoin point.** After per-instance cooling, "box the cookies" should wait for *every* tray. The author needs to mark where the per-instance chain collapses back into one step, and the validator needs to know it, because that step is where a delay in any instance propagates.
3. **Bounded work-in-progress.** The cooling rack holds two trays. The third bake must not start until a tray has left the rack. This is a limit on how many instances are *between* a replicated step and its rejoin point, which is different from `maxConcurrent` (a limit on one task at one instant). Labs have the same constraint (a centrifuge rotor holds 6 tubes; a bench has room for 4 open plates); airports have it (aircraft on the taxiway between landing and gate).

McKeever et al. solve the same three problems for compute workflows with *asynchronous nodes* (successors fire once per iteration), *barrier nodes* (wait for every iteration to arrive), and *maximum asynchronous concurrency* (cap on iterations that have started but not reached the barrier). Their motivation is disk space; ours is oven racks, rotors and bench space. The mapping is direct.

## 2. Goals

- Let an author (human or agent) express "for each instance of X, do Y" without copying steps.
- Let an author mark a barrier: "Z waits for every instance's Y".
- Let an author cap how many instances may be in flight between X and the barrier.
- Keep every existing program valid with unchanged timing (default behaviour = today's rejoin).
- Keep the two validators in parity and the constructs annotatable in OWL-Time like everything else.

## 3. Non-goals

- Dynamic instance counts decided at run time ("keep making trays until the dough is gone"). `count` stays static.
- Data flow between instances. Rhylthyme steps carry no outputs; only timing is threaded.
- Optimising placement of instances. The planners stay heuristic; this PRD adds constraints they must respect, not objectives.
- Changing `batch_size`/`stagger` on tracks. Track-level batches already produce independent track copies; this PRD is about **step-level** `replicates` and their downstream steps. (Track-level barriers are an open question, §9.)

## 4. Proposed schema changes (program schema 0.3.0-alpha)

### 4.1 `instances` on step-referencing triggers

Add an optional `instances` field to `afterStep` and `afterStepWithBuffer` (and therefore to their use inside `compound`) when the referenced step is replicated:

```json
"startTrigger": {
  "type": "afterStep",
  "stepId": "bake",
  "instances": "each"      // "each" | "all" | "any"   (default "all")
}
```

| value | meaning | OWL-Time |
|---|---|---|
| `"all"` (default) | The step starts when **every** instance of `stepId` has ended. This is the barrier, and it is today's rejoin behaviour. | `time:intervalAfter` the latest of the instances' `time:hasEnd` |
| `"each"` | The step is itself replicated, once per instance of `stepId`; instance *i* starts when instance *i* of `stepId` ends (plus `offsetSeconds`/`bufferSeconds` as usual). | `time:intervalMetBy` (or `intervalAfter` with offset) per instance pair |
| `"any"` | The step starts when the **first** instance ends. | `time:intervalAfter` the earliest `time:hasEnd` |

Rules:

- `instances` is only valid when `stepId` resolves to a replicated step or to a step that is itself `"each"`-replicated downstream of one (an *asynchronous descendant*, in McKeever's term). On an unreplicated step it is an error (`E_INSTANCES_ON_SINGLE`).
- `"each"` is transitive: a step chained `"each"` off an `"each"` step gets the same instance count and the same pairing (instance *i* → instance *i*). The instance count is inherited, never redeclared; declaring `replicates` on an `"each"` step is an error (`E_EACH_WITH_REPLICATES`), because it would be ambiguous whether to multiply.
- A step may reference two different replicated steps with `"each"` only inside a `compound` trigger and only if both have the same instance count (`E_EACH_COUNT_MISMATCH` otherwise). Instance *i* then waits for instance *i* of both.
- `"all"` and `"any"` collapse the chain: the referencing step is a single step again. It may be referenced downstream without `instances`.
- `event: "start"` combines with `instances` as expected (`"each"` + `event:start` → instance *i* starts when instance *i* of the upstream starts).

### 4.2 `maxInFlight` on `replicates`

```json
"replicates": {
  "count": 3,
  "mode": "serial",
  "maxInFlight": 2
}
```

Semantics: at most `maxInFlight` instances of this step may be *in flight* at once, where instance *i* is in flight from the start of instance *i* of this step until instance *i* has ended in **every** `"each"`-descendant of this step (i.e. until it has arrived at all barriers, or, if a chain has no barrier, until its last `"each"` step ends). Instance *i + maxInFlight* may not start before instance *i* leaves flight.

- `maxInFlight` ≥ 1; must be ≤ `count` (`E_INFLIGHT_GT_COUNT`); omitted means unbounded (today's behaviour).
- It is independent of `maxConcurrent`. `maxConcurrent` limits occupancy of one task at one instant; `maxInFlight` limits a *chain* of tasks across time. Both can bind; the planners must respect both and report which one is binding (§6.2).
- With `mode: "parallel"`, `maxInFlight` < `count` turns the parallel fan-out into a rolling window: instances 1..k start together, instance k+1 starts when the first leaves flight. With `mode: "stagger"`, the stagger delay is a *minimum* gap; the in-flight limit may push a start later. With `mode: "serial"`, instances already can't overlap, so `maxInFlight` only bites through the descendants (the cooling-rack case).

### 4.3 `$comment` annotations

Following the existing convention, the schema annotates these in OWL-Time terms (table in 4.1). `maxInFlight` is annotated as a bound on the number of `time:ProperInterval`s, each spanning from an instance's `hasBeginning` to the latest `hasEnd` among its paired descendants, that may `time:intervalOverlaps` any given instant.

## 5. Expansion semantics (normative)

Expansion happens before validation in both toolchains, as today. For a replicated step X with count *n*:

1. X expands to X[1..n] per the existing `mode` rules.
2. Every step S with `afterStep X, instances: "each"` expands to S[1..n], with S[i]'s trigger rewritten to `afterStep X[i]` (offset/buffer/event preserved). S[i] is placed in the same sub-track as X[i] so within-track non-overlap is checked per instance. Repeat for S's own `"each"` successors.
3. Every step B with `afterStep X (or any "each" descendant), instances: "all"` expands to a single step whose trigger is `compound{logic: all, triggers: [afterStep Y[1] … afterStep Y[n]]}`. `"any"` uses `logic: any`.
4. `maxInFlight = k` on X adds, for every i > k, a synthetic trigger on X[i]: `compound{all: [<X[i]'s own trigger>, afterStep L[i−k]]}` where L[i−k] is the last-ending `"each"` descendant instance of X[i−k] as resolved at planning time (or, if there are several leaf chains, `compound{all: […]}` over all of them). The synthetic trigger is marked (`_synthetic: "inFlight"`) so renderers can draw it differently and so it is not re-expanded.

Because expansion produces only constructs the validators already understand (plain `afterStep`, `compound`), the timing semantics stays a single resolution pass and the parity test extends naturally.

## 6. Component changes

### 6.1 Validators (Python and JS, in parity)

New checks, each with a stable code, message and *fix* hint (the MCP validator's format):

| code | condition | fix hint |
|---|---|---|
| `E_INSTANCES_ON_SINGLE` | `instances` set but `stepId` is not replicated or `"each"`-derived | "remove `instances`, or add `replicates` to `<stepId>`" |
| `E_EACH_WITH_REPLICATES` | step has both `instances:"each"` trigger and its own `replicates` | "drop `replicates` on `<stepId>`; it inherits `<n>` instances from `<upstream>`" |
| `E_EACH_COUNT_MISMATCH` | compound `"each"` over steps with different counts | "both upstream steps must have `count: <n>`" |
| `E_INFLIGHT_GT_COUNT` | `maxInFlight` > `count` | "set `maxInFlight` ≤ `<count>` or omit it" |
| `W_UNBARRIERED_CHAIN` | an `"each"` chain has no `"all"` barrier and the program has later steps that reference nothing in it | "add a step with `instances:"all"` if later work should wait for every instance" (warning, not error) |
| `E_INFLIGHT_NO_CHAIN` | `maxInFlight` set but no `"each"` descendants and `mode` is `serial` | "`maxInFlight` has no effect here; remove it or chain a per-instance step" (error, since it is almost certainly a mistake) |

Existing checks (unique ids, cycles, within-track overlap, undeclared resources) run on the expanded program unchanged.

### 6.2 Analyzer (`analyze_schedule`)

- Resource-conflict sweep gains a second kind of window: **in-flight over-subscription** (more than `maxInFlight` instances between X and its barrier). Report with the same shape as `maxConcurrent` conflicts, tagged `kind: "inFlight"`.
- Critical-chain walk must treat synthetic in-flight triggers as real predecessors, so a schedule that is limited by the rack, not the oven, reports the rack.
- Per-track slack is reported per instance sub-track.

### 6.3 Planners

The four strategies work on the expanded graph, so they mostly inherit the behaviour. Required additions: *minimize length* and *synchronized finish* must not violate `maxInFlight` when packing (today they only check `maxConcurrent`); *fit to time* may drop whole instances of a low-priority replicated step but must then drop the paired `"each"` descendants and re-derive the barrier over the remaining instances.

### 6.4 Runtimes

- **CLI runner:** since `afterStep` fires on *actual* completion, per-instance chains already behave correctly once expanded. The in-flight synthetic trigger must also fire on actual completion of the leaf descendant, so a tray that cools slowly really does hold the next bake. Manual/indefinite steps inside an `"each"` chain are per instance (the cook ends tray 2's cooling, not "cooling").
- **Web player:** same, on the simulated clock. The step list should group instances (`bake ×3`, expandable) rather than showing three rows named identically.

### 6.5 Renderer (`@rhylthyme/timeline`)

- Instances render as parallel sub-rows under the parent track, as parallel replicates do today.
- `"each"` arrows are drawn instance-to-instance; an `"all"` barrier is drawn as a single fan-in arrowhead with a small bar glyph (McKeever's barrier), `"any"` as a fan-in with a dashed bar.
- Synthetic in-flight triggers are drawn as a dotted arrow from the leaf descendant of instance *i* to instance *i+k*, labelled with the constraint (`rack ≤ 2`).

### 6.6 MCP server

- Authoring guide gains a section "Repeating work: per-instance chains, barriers and in-flight limits" with the cookie example (§7).
- `plan_schedule` prompt mentions the constructs in its constraints list so an agent asked "12 samples, the rotor holds 6" reaches for `maxInFlight` rather than hand-copying tracks.
- Tool output schemas: `analyze_schedule` conflict items get the `kind` field.

### 6.7 Importers

Out of scope to *infer* these from recipe text, but the Opentrons importer is a natural first producer: per-sample command sequences already arrive as iterations with a known count.

## 7. Worked example

Three trays of cookies, one oven, a rack that holds two trays:

```json
{
  "schemaVersion": "0.3.0-alpha",
  "programId": "cookies-three-trays",
  "name": "Three trays, one oven, small rack",
  "environmentType": "kitchen",
  "tracks": [{
    "trackId": "cookies", "name": "Cookies",
    "steps": [
      { "stepId": "mix", "name": "Mix dough", "task": "prep",
        "duration": { "type": "fixed", "seconds": 900 },
        "startTrigger": { "type": "programStart" } },
      { "stepId": "bake", "name": "Bake tray", "task": "oven",
        "duration": { "type": "fixed", "seconds": 720 },
        "replicates": { "count": 3, "mode": "serial", "maxInFlight": 2 },
        "startTrigger": { "type": "afterStep", "stepId": "mix" } },
      { "stepId": "cool", "name": "Cool on rack", "task": "rack",
        "duration": { "type": "fixed", "seconds": 900 },
        "startTrigger": { "type": "afterStep", "stepId": "bake", "instances": "each" } },
      { "stepId": "box", "name": "Box cookies", "task": "prep",
        "duration": { "type": "fixed", "seconds": 300 },
        "startTrigger": { "type": "afterStep", "stepId": "cool", "instances": "all" } }
    ]
  }],
  "resourceConstraints": [
    { "task": "prep", "maxConcurrent": 1 },
    { "task": "oven", "maxConcurrent": 1 },
    { "task": "rack", "maxConcurrent": 2 }
  ]
}
```

Resolved timing (minutes from start): mix 0–15; bake[1] 15–27, bake[2] 27–39; cool[1] 27–42, cool[2] 39–54; bake[3] would start at 39 but `maxInFlight: 2` holds it until cool[1] ends at 42, so bake[3] 42–54; cool[3] 54–69; box 69–74. Makespan 74 min, critical chain mix → bake[1] → cool[1] → (in-flight) bake[3] → cool[3] → box; the analyzer should say the rack, not the oven, is binding.

Note that `rack maxConcurrent: 2` alone would *not* produce this schedule: it would let bake[3] run 39–51 and then make cool[3] wait for a rack slot, leaving a hot tray with nowhere to go. That difference — hold the upstream step, don't strand the downstream one — is the whole reason `maxInFlight` is a separate construct.

## 8. Acceptance criteria

- [ ] Schema 0.3.0-alpha published with the three additions and `$comment` annotations; 0.2.0 programs validate unchanged and resolve to identical times (parity corpus, 616 steps / 39 programs, zero diffs).
- [ ] Both validators emit the six codes above with fix hints; a new negative-example set (one file per code) is rejected identically by both.
- [ ] The cookie example, a 12-sample PCR example (`thermocycler maxConcurrent 2`, `rotor maxInFlight 6`) and an airport example (landings → taxi `"each"` → gate barrier) are added to rhylthyme-examples and to the parity corpus, and resolve to the hand-computed times in §7 and their own comments.
- [ ] `analyze_schedule` reports in-flight windows and names the binding constraint on the cookie example.
- [ ] Renderer draws per-instance arrows, barrier glyph and dotted in-flight arrow; the paper's Figure-1 pipeline renders unchanged.
- [ ] CLI runner: ending cool[1] late (manual override) delays bake[3] and everything after it; ending it early advances them.
- [ ] MCP authoring guide updated; `plan_schedule` on the prompt "three trays, one oven, rack holds two" produces a program using `maxInFlight` without hand-copied steps (checked manually with one host).

## 9. Open questions

1. **Track-level barriers.** `batch_size`/`stagger` copy whole tracks. Should a step in *another* track be able to say `afterTrack: "orders", instances: "all"`? Probably yes eventually; deferred to keep this change to step scope.
2. **Naming.** `instances` vs. `per`/`join`; `maxInFlight` vs. `maxOpen`/`maxOutstanding`. `instances` keeps the trigger vocabulary flat; `maxInFlight` is McKeever's term minus "asynchronous". Open to bikeshedding before the schema is cut.
3. **Partial failure.** If instance 2 is aborted (`onAbort`), does the `"all"` barrier wait forever, fire with n−1, or fail? Proposal: barrier counts aborted instances as ended (fires with n−1) and the runtime flags the barrier as *degraded*; `onAbort` steps per instance are already possible after expansion.
4. **Negative offsets on `"each"`.** "Start cooling 2 min *before* the bake ends" per instance is meaningful only if the bake is indefinite, same rule as today; nothing new, but the validator message should mention the instance.
5. **Should `"all"` be required to be explicit** when a step references a replicated step, rather than defaulting silently? Explicit would catch authoring mistakes (an agent that forgot `"each"`), at the cost of breaking 0.2.0 programs. Recommendation: default stays `"all"` for compatibility, and the JS validator emits an *info*-level note (`I_IMPLICIT_BARRIER`) that agents can act on.

## 10. References

- McKeever P, Mittal V, Fukuda B, Yeung KY, Hung L-H. *User-friendly scheduler using a hybrid architecture and supercomputing for big data processing.* bioRxiv 2025.09.01.673517, §2.2 (iterable, asynchronous and barrier nodes; maximum asynchronous concurrency).
- Rhylthyme program schema 0.2.0-alpha: `replicates` (`count`, `mode`, `delay`), `batch_size`, `stagger`, `compound` triggers, `resourceConstraints.maxConcurrent`.
- Rhylthyme technical report, §3 (program model: replicates and staggered starts), §5 (validation, analysis, planners), §9 (limitations: no reactive rescheduling beyond delay propagation).
