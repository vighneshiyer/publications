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
import "@preview/ilm:1.4.0": *

#set text(lang: "en")

#show: ilm.with(
  title: [A Rigorous Evaluation and Implementation of Sampling in Microarchitecture Simulation],
  author: "Vighnesh Iyer",
  date: datetime(year: 2025, month: 05, day: 30),
  abstract: [Coming soon.],
  bibliography: bibliography("references.bib"),
  figure-index: (enabled: true),
  table-index: (enabled: true),
  listing-index: (enabled: true)
)


= Preface

When I started my PhD, I had no clue what I was actually interested in, and more importantly, what was worth doing.
I had dabbled in various areas of computer science as an undergrad and I found something I was genuinely interested in when I took UC Berkeley's digital design course.
My interest in the hardware side of computer science increased as I also
Originally my interest was sitting at the edge of analog and digital circuits in the context of building large digital SoCs.

I suggested a completely stupid line of research when I came into grad school.
I thought that it would be a good idea to propose a concrete line of research in my statement of purpose s
Of course, this backfired and instead turned off PIs who thought that this was my only specific interest, and if they weren't working on a similar idea, that I would not be interested.

I began to
My first inst
I realized that analog circuit design wasn't in my blood. It is nice to start with some first principles, design a circuit, and size the transistors. But after that point, you do the layout, run some simulations, realize your idealized circuit models used for the first principles analysis were completely wrong, and then go crazy with parameter sweeping. I just couldn't get with the program - it was obvious I needed a change.

Some words about the inspiration behind this project and how it came to be.
TBD.

Isn't sampling done to death?
People say this and just point to papers. But this is paper-brained nonsense.
Sampling doesn't even exist today from my real-life perspective.

Dan's blog post style thesis and Ryan's tutorial-style thesis.

#align(right)[
_Vighnesh Iyer_
]

= Introduction

Chip landscape overall
Refer to the typical DAC / job talks
Moore's Law, Dennard scaling, specialization, heterogeneous systems, more custom IPs
But CPUs aren't stagnating! Show performance results of M series systems on Speedometer. Energy efficiency and absolute performance continue to improve as cores are designed with specialized features for target workloads (e.g. speculation features such as load address/value prediction, pointer preemptive prefetching, things that expose uarch side-channels actually are good!)
Core microarchitecture iteration is still important! But performance benefits are hard to measure due to simulation bottlenecks.

= Background

== An Overview of Digital Systems

=== Abstractions

=== How They are Built

== Simulation of Digital Systems

=== Simulation paradigms

=== Simulation Abstractions

- https://jakob.engbloms.se/archives/2321 ( “Architectural Simulators Considered Harmful” – I would tend to agree)
    - https://ieeexplore.ieee.org/document/7155440 (the paper itself)
- https://jakob.engbloms.se/archives/2514 ( gem5 Full Speed Ahead (FSA))

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

== Workloads and Their Evolution

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

