// #import "@preview/tufte-memo:0.1.2": *
// #show: template.with(
//     title: [TidalSim: A Unified Microarchitectural Simulation Framework
// To Identify and Leverage Unique Aspects of Workloads on Heterogeneous SoCs for Performance Estimation and Verification
//     ],
//     authors: (
//         (
//         name: "Vighnesh Iyer",
//         role: "PhD Thesis",
//         affiliation: "UC Berkeley",
//         email: "vighnesh.iyer@berkeley.edu"
//         ),
//     )
// )
//
#import "@preview/ilm:1.4.0": *

#set text(lang: "en")

#show: ilm.with(
  title: [A Rigorous Evaluation and Implementation of Sampled Microarchitecture Simulation],
  author: "Vighnesh Iyer",
  date: datetime(year: 2025, month: 05, day: 30),
  abstract: [Coming soon.],
  bibliography: bibliography("bib.yml"),
  figure-index: (enabled: true),
  table-index: (enabled: true),
  listing-index: (enabled: true)
)

= Preface

The topic of this thesis is quite out of left field to be honest.

// undergraduate experience
== Undergrad Time

When I began my undergraduate education at UC Berkeley in 2013, I knew I wanted to broadly learn about topics in the field of electrical engineering and computer science, but did not have any speciality in mind.
I took the usual EECS curriculum which covered topics up and down the stack: analog/RF circuits, digital circuits, VLSI, computer architecture, operating systems, embedded systems, DSP, optimization, software engineering, and AI/ML.
I also thought I should supplement the engineering-oriented classes with some more "theoretical" ones so I took a bunch of random statistics classes before realizing I'm not cut out for that.

It wasn't until I took Berkeley's introduction to digital circuits and logic course (EECS 151) that I found something I was genuinely interested in.
At the same time, I also found the analog and RF circuits courses interesting, so I decided to pursue research in computer architecture and further down the stack.

// chip bringup
== Undergrad Research

Near the end of my undergrad career, I got involved in some "research", which was really just helping grad students with a chip bringup.
Honestly, I didn't even help that much, and instead I was quite an annoyance, asking lots of questions, and making slow progress.
I owe a large debt to the senior grad students who patiently explained the hardware and software components of the chip they built.

Eventually, I was able to lead the bringup of SERDES links on the chip!
The goal was for the SoC's RISC-V cores to access external DRAM (hosted on a FPGA devboard) via these SERDES links.
This was designed to be much faster than using our slow parallel bus from the chip to the FPGA.
This would bring this academic SoC's performance closer to that of a real SoC which would have an integrated DDR controller and PHY.

As usual, things don't work out as you would like.
While the SERDES links managed to stay up and synchronized for a few seconds, eventually the clock skew calibration would drift out of phase (there was no CDR on the chip's RX) and the BER would explode.
However, we were able to run some quick tests during the time the link stayed alive, and that was sufficient to get a number.
People outside this field would be surprised and disappointed about how much academic chip research is like this.

// power modeling (this was a bit too random to mention here)

// teaching eecs151
== Undergrad Teaching

I also taught

// motivation for grad school
== Applying to Grad School

Why go to grad school?
Originally my interest was sitting at the edge of analog and digital circuits in the context of building large digital SoCs.

// dumb SoP interests and admissions

I suggested a completely stupid line of research when I came into grad school.
I thought that it would be a good idea to propose a concrete line of research in my statement of purpose s
Of course, this backfired and instead turned off PIs who thought that this was my only specific interest, and if they weren't working on a similar idea, that I would not be interested.

// starting with analog circuits and INC prelim

I realized that analog circuit design wasn't in my blood. It is nice to start with some first principles, design a circuit, and size the transistors. But after that point, you do the layout, run some simulations, realize your idealized circuit models used for the first principles analysis were completely wrong, and then go crazy with parameter sweeping. I just couldn't get with the program - it was obvious I needed a change.

// working through early stage research projects in my PhD

When I started my PhD, I had no clue what I was actually interested in, and more importantly, what was worth doing.
Power modeling, fault injection, RTL design, specification mining, verification, fuzzing, stimulus generation, sudden shift to sampled simulation due to higher potential impact and an uncrowded area.

// eventually coming to simulation as the king of tools

Some words about the inspiration behind this project and how it came to be.
TBD.

// the reality of microarchitecture simulation sampling today and the work that remains to be done

Isn't sampling done to death?
People say this and just point to papers. But this is paper-brained nonsense.
Sampling doesn't even exist today from my real-life perspective.

// inspiration behind the organization and writing of this thesis

Dan's blog post style thesis and Ryan's tutorial-style thesis + my desire for a Socratic dialogue.

#align(right)[
_Vighnesh Iyer_
]

= Introduction

== The Digital Hardware Landscape

Digital hardware is ubiquitous.
Everywhere we look, no matter the form factor, application, or
Watches, phones, IoT devices, home appliances, urban infrastructure (traffic lights, trains), cars, robots, datacenters
we find digital systems
Chip landscape overall
Refer to the typical DAC / job talks

- Microprocessors dominate how we interact with digital electronics. Phones, tablets, laptops, watches, and servers in datacenters (the cloud).
- How has microprocessors evolved over the past 50 years?
- The very first unicore processors and operating systems
- Moore's Law and Dennard Scaling
- Dual core processors to counteract some poor scaling trends and improve real time performance
- DVFS technologies for power savings and to deal with increasing process variation
- Multicore processors continue to proliferate
- Mixed perf/energy efficiency processors (big/little architecture)
- The failure of the PARLAB vision (discuss the 7 dwarves as they seemed to provide opportunity for general purpose scaling machines, but it didn't pan out. they were mostly for HPC apps. when attempted to apply onto manycore systems and general applications like web browsers, they break down right away)
- Dark silicon
- Software engineers are dominant, we must align to what they want and accelerate their common stacks
- Continued performance improvements of single thread performance. Process scaling and uarch improvements continue to compound every generation going from the Nehelem era to the failure of Bulldozer/Itanium and into the Zen era we see today.
- The Apple breakthroughs on both the smartphone and laptop side (A14+ and M1+ series of chips)
- True software optimized hardware, continued scaling of performance, Speedometer performance continues to improve every generation even as process improvements stagnate or come at an increasing cost
- Accelerators are there, but are they the primary target of phone/tablets/laptops today? Even in the distant future? Probably not.
- Use GPT to chart this outline and fill in any missing holes.
- What does this portend?
  - How does Apple do their co-design today? It is iterative over many generations of silicon. On-device tracing and trace-based simulation. Software optimizations done after the fact.
  - Basically, the iteration loop is still very slow! True optimization of the end-to-end application with the microarchitecture is not possible, even with emulation machines.

- https://dl.acm.org/doi/pdf/10.1145/3649329.3663515
  - Invited: The Magnificent Seven Challenges and Opportunities in Domain-Specific Accelerator Design for Autonomous Systems

> In the first quarter of this century, computing hardware design- ers were faced with both the limitations of technology scaling for performance [1 ], and the ensuing conflagration of on-chip power density [2]. Fortunately, the challenges of the Dark Silicon era [ 3] have transitioned into a prosperous period of specialized accelera- tor design [ 4 , 5 ]. Emerging enabling technology and tools for agile and democratized hardware design are powering an exciting land

== Software Trends

Software drives the next generation hardware whether we like it or not. To some degree hardware advancements make software advancements / inefficiencies possible in the first place. So we must discuss the software first.
Software stack complexity continues to grow with more abstractions, consider webapp side
Programming productivity is king, more SW engineers vs HW ones
Cloud and edge application stacks are actually converging with respect to compute characteristics (indirect dispatch, JITs, VMs, more isolation), with differences in scale

== Digital Hardware Trends

Moore's Law, Dennard scaling, specialization, heterogeneous systems, more custom IPs
But CPUs aren't stagnating! Show performance results of M series systems on Speedometer. Energy efficiency and absolute performance continue to improve as cores are designed with specialized features for target workloads (e.g. speculation features such as load address/value prediction, pointer preemptive prefetching, things that expose uarch side-channels actually are good!)
Core microarchitecture iteration is still important! But performance benefits are hard to measure due to simulation bottlenecks.



- Digital hardware is everywhere, especially on your phone, laptop, desktop, and through the cloud (datacenters)
- Scaling trends of microprocessors
- Accelerators galore
- But what do accelerators do for you? Consider your phone. What do you use it for? What role do these accelerators play?
- Single-thread performance is still king
- But it isn't scaling? Not true! Vertical integration gives continual benefits. Speedometer scores are the key. Energy efficiency of cores continues to improve. Cores themselves have become more heterogeneous.
- But how does this work in practice? There is no vertical iteration loop prior to tape out? So, there is still a full silicon spin cycle + software development time to figure out optimizations. How does Apple do it? Why do others lag so far behind?


== Motivation

== Hypothesis

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

= Background

== An Overview of Digital Systems

=== Abstractions

=== How They are Built

== Simulation of Digital Systems

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

= Microarchitecture Oracle Analysis of Program Sampling

== TraceKit

== Functional-Only Simulation Tracing

=== Clustering Analysis

== RTL Simulation Tracing

== FireSim Tracing

=== Evaluation of Time-Based Sampling

== Functional Warmup Evaluation

= Sampled Simulation Leveraging RTL Simulation

After understanding the workload characteristics based on prior work and our investigation in the prior chapter, our next step is to build a prototype of a sampled simulation framework that uses RTL simulation to estimate performance metrics.
In contrast to the traditional approach to sampled simulation, which rely on either execution or trace driven CPU performance models, we leverage a very detailed RTL simulation of a particular CPU microarchitecture.

== Embedding

== Functional Warmup Models

== Microarchitecture State Injection

== Simulator Architecture

\begin{figure}
  \includegraphics[width=\linewidth]{dynamic/tidalsim/overview.pdf}
  \caption{An overview of the steps involved in the TidalSim flow.}
  \label{fig:tidalsim_overview}
\end{figure}

A high-level overview of the TidalSim flow is shown in Figure \ref{fig:tidalsim_overview}.
The steps of the flow are:

1. Call a functional simulator with a workload binary to get a commit log (contains PC, decoded instruction, register operands, and memory transactions for each committed instruction)
2. Split the commit log into intervals with a fixed number of instructions
3. Embed each interval using its basic block frequency vector
4. Cluster the interval embeddings using k-means clustering
5. Pick intervals closest to each cluster's centroid for simulation
6. Re-execute functional simulation to extract architectural checkpoints for each chosen interval and execute the microarchitectural warmup models to produce microarchitectural checkpoints
7. Inject each checkpoint into RTL simulation and measure performance metrics
8. Extrapolate each simulated interval's performance to produce a performance trace for the full workload

== Evaluation and Results

= A Novel Baremetal Benchmark Construction Methodology

== Existing Benchmarks

Embench
Mibench
SPEC
...

- https://github.com/tum-ei-eda/muriscv-nn?tab=readme-ov-file

```
for a chipyard environment, I got it to build by editing their CMake/toolchain_GCC.cmake to use

# Path to your RISC-V GCC compiler
message(RISCV_ARCH="${RISCV_ARCH}")
message(RISCV="$ENV{RISCV}")
set(RISCV_GCC_PREFIX "$ENV{RISCV}" CACHE PATH "Install location of GCC RISC-V toolchain.")
set(RISCV_GCC_BASENAME "riscv64-unknown-elf" CACHE STRING "Base name of the toolchain executables.")
set(TC_PREFIX "${RISCV_GCC_PREFIX}/bin/${RISCV_GCC_BASENAME}-")

and then run

mkdir build
cmake .. -DRISCV_ARCH=rv64gcv -DRISCV_ABI=lp64d -DUSE_VEXT=1
make
```

== Baremetal RISC-V

== Baremetal Rust

=== no_std Crates

== Rust Stdlib Microbenchmarks

== Crate Instrumentation for Function Stimulus

== Correlating Microbenchmarks with Full Application Performance

= Robust Sampling of Real Workloads

== What is Architectural State?

== Identifying Flaws in Checkpointing

== Increasing the Scope of State Injection

== Building More Complex Workloads

= Error Analysis of Sampled Simulation

= TidalSim: A Live Sampling Flow

== DSE Using TidalSim

= Future Work

== Unified Framework

= Other Things

\setchapterpreamble[u]{\margintoc}
\chapter{Trace-Driven Simulation}
\labch{trace_driven_sim}

\section{Overview of Trace-Driven Simulation}

\subsection{What is a Trace?}

\subsection{Trace-Driven uArch Models}

- Old paper: Can Trace-Driven Simulators Accurately Predict Superscalar Performance? (https://pharm.ece.wisc.edu/mikko/oldpapers/ICCD.96.final+.pdf)
  - They already make the case that the answer is no and things will continue to get worse...
  - This was understood in 1996 lol

MACSim: https://github.com/gthparch/macsim
Tao (ML model for trace-driven sim): https://arxiv.org/pdf/2404.10921 (some more examples of trace-driven simulators below)

ChampSim: https://arxiv.org/pdf/2210.14324
  Example usage of ChampSim for BP/cache design: https://www.cs.sfu.ca/~ashriram/Courses/CS7ARCH/hw/hw2.html
  https://arxiv.org/html/2408.05912v1 (Correct Wrong Path - an attempt to make Champsim aware of wrong path execution effects since those are hidden in a trace, unless explicitly instrumented)

\subsection{Limitations of Trace-Driven Simulation}
.
- Disprove trace driven sim first
  - Start with a single-threaded baremetal application that has no IO interactions at all except DRAM
  - Consider how to model performance impacts of
  - Then consider interaction with a DMA device
  - Then consider other IO devices e.g. NIC
  - Then consider the impact of an OS (thread multiplexing on a single hart)
  - Then consider time-dependent behavior e.g. with a timer for interrupt scheduling (for an OS)
  - Then consider the multi-threaded case
    - Some people think that multi-threaded trace-driven simulation is viable: https://ieeexplore.ieee.org/abstract/document/5762718 but this is very fishy
  - Finally consider the M:N userspace scheduling case for a IO bound application with very high concurrency. Does the 'trace' mean anything anymore? Do we capture the application-level metrics with IPC? This is what actually matters. Does the change in IPC/mispredict rate/etc actually deliver better end-to-end performance or tail latency effects?
    - See TailBench: https://people.csail.mit.edu/sanchez/papers/2016.tailbench.iiswc.pdf

- Ipc doesn't matter if it's spinning the scheduler thread, need app level metrics
- Dr traces induce 30x core slowdown and memory bw contention and cache pollution
- Fake results when fed into trace driven sim, io appears faster than reality

\section{Execution-Driven Simulation: The Only Way}

Then talk about exe sim
https://nitish2112.github.io/post/event-driven-simulation/

- https://www.sigarch.org/when-to-prototype-when-to-simulate/
- https://pbzcnepu.net/isca/methodology.html
-

\section{Design for Injection (DFI) Methodology}

Then about design for injection
And then the full flow from dbt sim to ice emulation
DBT sim -> ISA-level SoC sim -> execution-driven uArch / perf sim -> RTL sim -> Palladium-ish RTL sim -> ICE


identify your thesis, gather minimal evidence to prove your point and no more
leverage firesim to do trace driven sampling analysis first!!! then move to rtl injection after
  - basically do oracle embedding analysis

