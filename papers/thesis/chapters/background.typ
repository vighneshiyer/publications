= Background

// Headings for background section:
// An Overview of Computer Architectures Broadly
//   what is comp arch, efficiency vs flexibility on various axes (perf, energy, cost, yield, arithmetic intensity, parallelism extraction, software ease of use)
//   what is a von-Neumann architecture
//   focus on CPUs and their evolution specifically + arch vs uarch state
// Simulating von-Neumann Architectures
//   talk about all types of simulation
//   functional isa level simulation - interpreted vs JITed
//   performance simulators - timing-driven vs execution-driven, trace-driven simulators, all their associated problems and issues
//   rtl-abstraction simulation - all the various types - software, FPGA prototyped, FPGA emulation, ASIC emulation
//   table of comparison between all the various types
// Sampled Microarchitecture Simulation
//   discuss sampling broadly as a way to trade off fidelity and runtime and startup time (maybe)

== An Overview of Digital Systems

In this section, we will focus on von-Neumann computer architectures.
We will not discuss their design and verification aspects, but will focus on simulation and performance modeling.

What is a von-Neumann architecture? Instruction/data memories + processor + external memory.
This following analysis can also apply to non-Von-Neumann architectures such as Harvard architectures, vector machines, SIMT processors, and even dataflow/spatial architectures (although it is harder to adapt the simulation techniques we describe to these exotic architectures).

On the simulation section, focus on von-Neumann computer architectures - talk about various types and point out that besides a few exceptions like ILP pipelines and video decoders, we basically only have von-Neumann architectures today. What defines them? What are they? Talk about others like dataflow / spatial computing or neuromorphic computing or analog computing or processing-in-memory too but only briefly as to dismiss them as not relevant in the vast majority of cases. For von-Neumann systems explain how CPUs, GPUs / SIMT cores, NPUs / TPU, DSP cores, VLIW cores slot into the von-Neumann paradigm. Consider whether architectural state advances in lockstep and is interruptible and resumable vs not and what that means for accurate architectural modeling. Finally discuss the differences between arch and uarch states and logic.

=== Abstractions

=== How They are Built

- https://www.sigarch.org/when-to-prototype-when-to-simulate/
- https://pbzcnepu.net/isca/methodology.html

== Simulation of Digital Systems

Simulation for verification and for performance modeling.

=== Simulation paradigms

- https://dl.gi.de/server/api/core/bitstreams/c54a18be-1546-4936-a2b4-8d53b946b884/content
  - The image in 3.1 is ideal to reproduce
  - X-axis: modeling abstraction from precise to abstract, y-axis: throughput
  - Going from RTL to timing models to ISS to JIT

=== Simulation Abstractions

- https://jakob.engbloms.se/archives/2321 ( “Architectural Simulators Considered Harmful” – I would tend to agree)
    - https://ieeexplore.ieee.org/document/7155440 (the paper itself)
- https://jakob.engbloms.se/archives/2514 ( gem5 Full Speed Ahead (FSA))

=== ML-Based Simulation

- SimNet: https://www.osti.gov/servlets/purl/1889629
- TAO: https://dl.acm.org/doi/abs/10.1145/3656012
- Learning Generalizable Program and Architecture Representations for Performance Modeling: https://ieeexplore.ieee.org/abstract/document/10793149

== Sampled Simulation

- Background chapters
  - Microarchitectural simulation in general
  - Motivation for RTL-level simulation and new era of SoC-level simulations
  - Prior work in sampled simulation and its limitations
  - Generalizing the prior work in a unified framework
    - Time-based vs instruction-based interval selection
    - Random vs systematic vs representative sampling
    - Warmup models and various optimizations
    - Time-feedback from performance simulation to functional simulation
    - Prior work in multicore sampled simulation
- NPS: A Framework for Accurate Program Sampling Using Graph Neural Network: https://arxiv.org/abs/2304.08880

== Workloads and Their Evolution

Mu riscv nn

The evaluation gap:
- big gap between microbenchmarks and real applications
- trace collection from silicon and replay on trace-driven sim can work, but it requires a long iteration cycle, which isn't ideal
- proposed solution: use the speed of sampled simulation with the fidelity of RTL to run real apps in the RTL iteration loop / during performance modeling
- new benchmarks are required that are easy to run baremetal
- continue hacking using `pk` to run benchmarks that won't admit baremetal porting (but skip trying to get things working that require dynamic linking and the full Linux syscall suite - don't model the kernel when that is very tricky to do for uArch state injection)

== Sampled Simulation Broadly and the Structure of this Thesis

- tradeoff between short intervals and long ones
- tradeoff between random / systematic sampling and representative sampling
- tradeoff between variable length intervals vs fixed ones
- tradeoff between time feedback and time-unaware execution
- tradeoff between different types of embeddings

== Hypothesis

We want to combine short intervals with functional warmup and rtl simulation to demonstrate it is possible to do rtl first agile performance evaluation and iteration without the need for slow rtl simulations or performance models (that need another round of correlation and error analysis) or fpgas which are expensive, have long startup latency, and are difficult to provision

\subsection{Our Proposal}

% Sampled multi-level simulation!
To achieve high throughput we will leverage simulation sampling techniques, but instead of using architectural simulators for performance metric estimation, we will use RTL simulators.
We specifically employ a sampling methodology similar to SimPoint, but with functional warmup and shorter interval lengths.

\subsubsection{Why Use RTL Simulators?}

% Why multi-level simulation? Why not arch sim 2-level sim? Why go down to RTL?
% Why not just go into perf simulators?
% Don't want to design perf model and then design RTL to match that - what a waste, not agile!
% Aren't "trends" enough? Not when we care about small IPC changes! The absolute number matters!
% Miscorrelation vs RTL *compounds* over simulation time!
% the correlation problem gets compounded 2x - sampling error + perf sim - RTL sim correlation errors
% Also what are the special things we can get from RTL simulation that perf sim can't get us?

Existing sampled simulators mix functional simulators and architectural simulators (e.g. gem5, Sniper, SST).
We continue to use functional warmup models similar to those in architectural simulators, but we use RTL simulation for extracting performance metrics.

\paragraph{What is the benefit of introducing RTL simulators into the mix?}

For one, it has been shown that performance simulators can be wildly inaccurate\cite{arch_sim_considered_harmful, arch_sim_survey} and often have unbounded modeling errors in addition to sampling errors, while RTL simulation is cycle-accurate.
Also, using RTL simulation for performance estimation means there is no need to perform correlation between the performance simulators and RTL.

Having RTL also enables us to derive accurate PPA numbers for the SoC as a whole using a traditional synthesis flow, whereas performance simulators can at best give vague estimates.
Since our flow already leverages sampled simulation for performance trace estimation, we can apply a similar flow to extrapolate a full power trace using post-RTL power estimation CAD tools.

Finally, RTL simulators produce special collateral that cannot be produced from performance simulators, such as RTL-level waveforms and detailed microarchitectural events.
Thus, we can obtain many short waveforms that reflect unique aspects of the simulated workloads, suitable for applications ranging from power modeling to coverpoint synthesis.

\paragraph{Why was mixing RTL simulation with sampled simulation not attempted before?}

% We can't try to 'fix' perf models. And in the new open source research era we have RTL! for every part of the system too! we can draw realistic conclusions finally! cite Chipyard, ESP, OpenPiton

In order to use RTL simulation, you need to have RTL for the design point that you are trying to evaluate.
In the past, this has been difficult since the only available open-source RTL was low quality, low performance, poorly parameterizable, and not extensible.
Furthermore, to use RTL simulation with sampling requires a way to restore and resume simulation from architectural checkpoints: this can tightly couple the low-level state injection logic with a specific RTL design point.

Recently, we have seen an explosion of design frameworks with high quality open-source RTL for every part of a complete SoC\cite{chipyard, open_esp, openpiton, xiangshan, pulpv2, blackparrot}.
These design frameworks support extensive parameterization, easy integration of external RTL, and can leverage hardware compiler frameworks\cite{firrtl} to automate generation of state injection code.
It has now become possible to leverage RTL for large workload simulation and microarchitectural design space exploration.

\subsubsection{Why Use SimPoint-Style Sampling?}

% fine time-granularity, high liklihood of unique traces, eventual ability to extrapolate across workloads via binary-agnostic embedding similarity

SMARTs-style sampling only gives us a single number for a performance metric (e.g. IPC).
While it can be more accurate and have statistical error bounds, the intervals chosen for simulation are often redundant (i.e. they have similar microarchitectural characteristics).
When performing microarchitectural exploration, we often want a detailed view of IPC behaviors \textit{within} a workload's trace to, for example, diagnose pathological behaviors visible as unexpected IPC spikes.

SimPoint-style sampling uses interval embeddings and clustering, so the intervals chosen for simulation are at least guaranteed to have unique basic block traversal patterns.
This form of sampling gives us interval length time-granularity of the IPC trace.
Furthermore, if we can develop binary-agnostic interval embeddings, it will allow the simulator to extrapolate performance metrics \textit{across workloads} which have intervals with similar embeddings.
