= Background

== An Overview of Digital Systems

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

== Sampled Simulation Broadly and the Structure of this Thesis
