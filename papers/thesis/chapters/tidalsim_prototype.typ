= Sampled Simulation Leveraging RTL Simulation

After understanding the workload characteristics based on prior work and our investigation in the prior chapter, our next step is to build a prototype of a sampled simulation framework that uses RTL simulation to estimate performance metrics.
In contrast to the traditional approach to sampled simulation, which rely on either execution or trace driven CPU performance models, we leverage a very detailed RTL simulation of a particular CPU microarchitecture.

== Embedding

== Functional Warmup Models

== Microarchitecture State Injection

== Simulator Architecture

#figure(
  image("../figs/overview.svg"),
  caption: [An overview of the steps involved in the TidalSim flow.]
)

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

#figure(
  image("../figs/wikisort.svg"),
  caption: [An overview of the steps involved in the TidalSim flow.]
)

#figure(
  image("../figs/huffbench.svg"),
  caption: [An overview of the steps involved in the TidalSim flow.]
)

three types of BBVs
pros and cons
  - aslr handling (pie binaries)
  - number of passes
  - accuracy
  - tradeoff analysis in embedding space

== Error Analysis
