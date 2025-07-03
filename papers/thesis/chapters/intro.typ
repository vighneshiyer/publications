#import "../ilm/lib.typ": callout

= Introduction

/*
What are the main things I want to say?

- Performance, efficiency, and power density improvements for all digital integrated circuits have come through technology scaling trends, improved integration, and improved microarchitectures
- Those trends have stalled out due to the limitations of technology scaling (end of Dennard scaling, dark silicon). But manycore architectures failed to materialize too.
- Modern SoCs are more 'heterogenenous' (proliferation of accelerators, the supposed "golden age")
  - The truth is more subtle. The continued uarch gains haven't come from 'extreme heterogeneity' but rather from specialization / tuning / optimization of general purpose computing architectures
  - We have created heterogeneity, not via the "sea of accelerators", but rather from 'specializing' general-purpose architectures for different parts of the perf/area density/power curve (e.g. CPU P/E core variants, DSP engines with new datatypes, NPUs with the ability to exploit massive DLP and high arithmetic intensity, SIMT engines) - continue to exploit Amdahl's law on various axes of parallelism (DLP, MLP, speculation / ILP)
- At the same time, the chip design cycle hasn't gotten any faster. Still dominated by the waterfall methodology, the microarchitectural tweaks from one generation to the other are determined years in advance of the design. There is no RTL-level performance feedback in the design loop.
  - The limitation comes from the slow iteration process of RTL design and evaluation.
- From these two points, I will present the hypothesis:
- The premises:
  - The vast majority of performance improvements in computing from computer architecture have and will come from the specialization and optimization of general purpose von-Neumann architectures.
    - These architectures are designed to target different methods of exploiting intrinsic parallelism in a workload (ILP, MLP, DLP) with their own performance vs area and power efficiency tradeoffs.
  - Agile design is important to improve beyond the 5 year design cycle that needs to be coupled closer with new workload characteristics
- The hypothesis:
  - We need to build a tool that can simulate a general purpose microarchitecture with low startup latency and high throughput, while being able to reveal and localize slight performance deltas
  - We need to build workloads that can behave like full applications
  - We need to understand the accuracy and speedup tradeoffs of the tool we build
- Point out the problems with this hypothesis up-front, right here. Be brutal. But continue anyways. Big problems
  - Trace-driven models that are 'good enough' exist in industry to guide performance optimization / new uArch features
  - Sampled RTL simulation assumes that verification has done its job, but that is often the bottleneck
*/

/*
- Digital hardware is everywhere, especially on your phone, laptop, desktop, and through the cloud (datacenters)
- Scaling trends of microprocessors
- Accelerators galore
- But what do accelerators do for you? Consider your phone. What do you use it for? What role do these accelerators play?
- Single-thread performance is still king
- But it isn't scaling? Not true! Vertical integration gives continual benefits. Speedometer scores are the key. Energy efficiency of cores continues to improve. Cores themselves have become more heterogeneous.
- But how does this work in practice? There is no vertical iteration loop prior to tape out? So, there is still a full silicon spin cycle + software development time to figure out optimizations. How does Apple do it? Why do others lag so far behind?
*/

/* Random notes
- Moore's law, dennard scaling, dark silicon, the typical plot of perf over time, accelerators on dies, reemergence of mass integration like MCM and wafer scale packaging, but even with all this, ml accelerators, the vast majority of power consumption and time per application is spent on the general purpose cores, then show geekerwan scaling on spec for apple cores, also show speedometer here, also talk about p and e cores
- The parallelism panic at the parlab days

- Scaling driven by technology, microarchitecture, compilers, and software
- Now people claim that specialization is the key to continued scaling
- But none of the code you run every day actually uses specialized accelerators, besides a few like video decoding
- Look at what matters, practical performance scaling and more features happens because of improvements in general purpose compute with respect to energy efficiency and raw perf
- See the apple scaling curves from geekerwan

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

- Moore's law was not in principle just about integrated circuit scaling or cost, but rather about scaling and cost of an entire system, and those continue to scale! Bandwidth, board and package level integration, io Integration, memory integration, radio integration, more advanced cooling like in nvl72, scaling itself has not ended, specialiation is less valuable than thought, workload specialization of general purpose cores to enable software development productivity is the real key

> In the first quarter of this century, computing hardware design- ers were faced with both the limitations of technology scaling for performance [1 ], and the ensuing conflagration of on-chip power density [2]. Fortunately, the challenges of the Dark Silicon era [ 3] have transitioned into a prosperous period of specialized accelera- tor design [ 4 , 5 ]. Emerging enabling technology and tools for agile and democratized hardware design are powering an exciting land

- List of Android SoCs: https://docs.google.com/spreadsheets/d/1ZvQonnQ5Yl4QmURVmj7BH4CW8aEloMqbDnWSaBGAxh4/edit?gid=0#gid=0
  - Very interesting and useful enumeration of the core configurations in various Qualcomm, Mediatek, Samsung, Google SoCs
  - https://www.reddit.com/r/hardware/comments/1jqfxjn/list_of_android_socs/ (very cool, need to credit this guy)

== The Enduring Reign of General-Purpose Compute
*/

Digital integrated circuits, and semiconductors in general, are ubiquitous.
Everywhere we look, no matter the form factor or usecase, nearly every system on our planet is enabled or has been influenced by digital hardware.
Among other applications, this proliferation encompasses consumer electronics, IoT devices, home appliances, urban infrastructure, cars, factories, and datacenters.

#grid(
  columns: (1.2fr, 1fr),
  rows: (3in),
  gutter: 0.1in,
  align: center + horizon,
  grid.cell([
    #figure(
      image("../figs/intro/sia-semi-outlook.png", height: 2in),
      caption: [Data from the Semiconductor Industry Association supports the strong and consistent proliferation of digital SoCs for increasingly many applications #cite(<sia-semi-outlook>)]
    )<fig:sia-semi-outlook>
  ]),
  grid.cell([
    #figure(
      image("../figs/intro/sia-march25.png", height: 2in),
      caption: [Recent data from March 2025 shows the wildly cyclical nature of the semiconductor industry, even as long-term growth is consistent #cite(<sia-march25>)]
    )<fig:sia-march25>
  ])
)

The proliferation of digital systems is expected to continue unabated (as evidenced by @fig:sia-semi-outlook and @fig:sia-march25).
In this chapter, we will cover the technology and architecture trends that enabled digital systems to scale in size and complexity, driven by: Moore's Law, Dennard Scaling, .

, what those scaling trends are projected to be looking to the future, and what that implies for the future of digital hardware design.
This will motivate the subject of this thesis, which is a simulation methodology for the design of the general-purpose computing architectures of modern SoCs.
//, which motivates research into the improvement of their design methodology.
// In this thesis, we will focus on accelerating the simulation of digital chips that execute the vast majority of compute cycles on the planet and have the largest user-facing impact: the chips powering _mobile_, _laptop_, _desktop_, and _datacenter_ systems.

// Underpinning the proliferation of digital hardware is the core component of any digital system: the _general-purpose microprocessor_.
// How have the typical mobile and datacenter SoCs and SiPs evolved over the past several decades?

// Microprocessors are the invisible engines of modern life. From the smartphones in our pockets and the tablets we browse on, to the laptops powering our work and the watches tracking our steps, these intricate slivers of silicon dictate our interaction with the digital world. Even the seemingly ethereal "cloud" is built upon vast datacenters packed with servers, each driven by powerful microprocessors. Understanding the evolution of these devices over the past half-century is crucial to understanding the trajectory of technology and predicting its future.

*TODO*: need to add a summarization paragraph for all the intro chapter contents

This document explores that journey, focusing on the interplay between technological advancements, architectural innovation, and the ever-present demands of software. We will examine the golden age of scaling defined by Moore's Law and Dennard Scaling, the challenges that arose as these trends faltered, the proposed solutions like massive parallelism and hardware acceleration, and ultimately argue that despite the allure of specialization, the continued improvement of general-purpose processing remains the most critical driver of performance and user experience for the vast majority of applications we use every day.

== Scaling Trends of Digital Systems

Over time, digital chips have gone from small single-core microprocessors to today's massive heterogeneous multi-core systems-on-chip (SoC) which contain a multitude of different compute units.
We will begin by analyzing the technology and architecture trends that enabled digital systems to scale in size and complexity, driven by Moore's Law and Dennard Scaling.
, what those scaling trends are projected to be looking to the future, and what that implies for the future of digital hardware design.
This will motivate the subject of this thesis, which is a simulation methodology for the design of the general-purpose computing architectures of modern SoCs.

The story of microprocessor scaling begins in the 1960s and 70s. Early microprocessors like the Intel 4004 were revolutionary but primitive by today's standards, operating on 4-bit data with clock speeds measured in kilohertz. The operating systems designed for these early machines were equally basic, often single-tasking environments.

The engine driving progress was famously articulated by Gordon Moore in 1965. *Moore's Law*, in its common interpretation, observed that the number of transistors that could be economically integrated onto a silicon chip doubled approximately every two years. This exponential growth in transistor density led to increasingly complex designs and lower costs per function.

=== Moore's Law

Every discussion of the scaling of integrated circuits inevitably begins with a discussion of #link("https://en.wikipedia.org/wiki/Moore%27s_law")["Moore's Law"] which was based on a paper published by Gordon Moore in 1965 titled: _"Cramming more components onto integrated circuits"_ @moores-law.
In the paper, Moore makes a few statements about _cost_ and _integration density_ scaling:

#quote(attribution: [Gordon Moore @moores-law], block: true)[
Reduced cost is one of the big attractions of integrated electronics, and the cost advantage continues to increase as the technology evolves toward the production of larger and larger circuit functions on a single semiconductor substrate.
For simple circuits, the cost per component is nearly inversely proportional to the number of components, the result of the equivalent piece of semiconductor in the equivalent package containing more components.

*⋮*

The complexity for minimum component costs has increased at a rate of roughly a _factor of two per year_.
Certainly over the short term this rate can be expected to continue, if not to increase.
]

#figure(
  //_two_ scaling trends Moore expected to continue],
  caption: [Two figures from Moore's paper @moores-law which illustrate 1) the reduction in minimum per-transistor costs at increasing integration densities and 2) the exponential increase in total integration complexity over the past decade.],
  grid(
    columns: (1fr, 1fr),
    rows: (2in),
    gutter: 0.1in,
    align: center + horizon,
    image("../figs/intro/moores_law-cost_curves.png"),
    image("../figs/intro/moores_law-component_trend.png"),
  )
)<fig:moores-paper>

// Mead turned this observation into a 'law' which became in-part a self-fulling prophecy about the scaling of semiconductors. #cite(<moores-law-mead>)

At the 1975 IEDM conference, Moore published an update titled _"Progress in digital integrated electronics"_ @moores-law-1975 where he predicted the density scaling and per-transistor cost trends would continue.
Around the same time, Carver Mead took the data from Moore's papers and coined the term "Moore's Law" @moores-law-mead @moores-law-past-present-future.
// , where he predicted the continued doubling of integration density per year until 1980, followed by a slower doubling every two years.

// #pagebreak()

#callout[
  #text(size: 13pt, weight: 600)[The original formulation of Moore's Law]

  - The transistor density _at minimum cost per transistor_ for an integrated circuit will _double every year_
  - This trend will taper off around 1980, after which transistor density will _double every two years_
  - There will be a further tapering in the future when further density scaling becomes physically infeasible as transistor gate lengths approach atomic scales
]

=== Is Moore's Law Still Alive?

// For one, transistor density at minimum cost per transistor has stopped
// - Cost per most dense transistor
// - Total integration density of a semiconductor die / package
// A corollary is that the cost per transistor in increasingly scaled technologies would continue to go down as transistors shrank and yields improved.

It has been frequently declared that the original formulation of "Moore's Law" died in the mid-2010s #cite(<moores-law-death>) #cite(<moores-law-slowing-down>).
However, it is more useful to piece apart _three practical aspects_ of Moore's Law and examine them separately.

1. #underline[_Total integration complexity scaling_]
  - The maximum number of components that are integrated in a complete digital system, deployed and programmed as "one unified computer"
2. #underline[_Integration density scaling_]
  - The maximum number of transistors that can be fabricated per _mm#super[2]_ of silicon area
3. #underline[_Cost per component scaling_]
  - The cost per transistor in increasingly scaled down fabrication technologies

// 3 types of scaling:
//    - costs per transistor (purely process driven)
//    - transistor (compute/memory) area density (driven by innovation in process and stdcell design / CAD)
//    - power density (energy efficiency) (driven by process and increasingly architecture - multiple core variants, different parallelism exploitation architectures)
//      - discuss this in the Dennard scaling section
// max integration limits via better packaging solutions: Dojo (panel-level packaging, TSMC Intergated FanOut System on Wafer), GB200 / Ultra (massive CoWoS), Cerebras WSE (monolithic wafer-scale intergration)
// max integration limits via technology: backside power, TSVs, 3D stacking, microfludic cooling, continued transistor scaling and smaller track stdcell libraries

// First present the total integration scaling picture
// https://en.wikipedia.org/wiki/Transistor_count (scrape data from here and plot it myself)
//    - https://interludeone.com/posts/2021-04-21-chips/chips.html (he did a nice split by chip designer)
//    - https://mlsysbook.ai/contents/core/hw_acceleration/hw_acceleration.html#multi-chip-ai-acceleration (transistor count scaling figure, also contains the latest Cerebras WSE-3)
// I just made my own plot since these existing ones weren't good enough.

#figure(
  image("../figs/intro/integration_complexity_over_time.svg"),
  caption: [Data from @transistor-count-wikipedia reproduced on a scatterplot with products segmented by type which demonstrates the sustained exponential trend of increasing total integration complexity.],
)<fig:integration-complexity-over-time>

#heading("Total Integration Complexity Scaling", level: 4) We can visualize the scaling trends of _unified_ digital systems (i.e. a single die, package, or board/wafer-level system that has relatively uniform bandwidth and latency across the entire system) in @fig:integration-complexity-over-time.

The trend of exponential increases in
Especially at the upper end, technologies, both with respect to process and package engineering, continue to push out the barriers to continued large-scale integration.

- Talk about TSMC diagram + attach other diagram
  - https://www.tomshardware.com/tech-industry/manufacturing/tsmc-charts-a-course-to-trillion-transistor-chips-eyes-monolithic-chips-with-200-billion-transistors-built-on-1nm-node
- https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=10589682&tag=1 (transistors per processor over time, energy efficiency over time, vertical connection 3D density over time, technology evolution chart)
  - I need to pull these 4 figures from this link (3D vertical connection density scaling + total number of transistors scaling projections from TSMC)
  - From this article: https://spectrum.ieee.org/trillion-transistor-gpu

- https://spectrum.ieee.org/stco-system-technology-cooptimization
  - Keeping Moore’s Law Going Is Getting Complicated
  - Lots of good data on continued transistor scaling with new transistor structures, 3D integration, backside power delivery
  - Nice transistor scaling diagrams from imec (x2) - probably attach both of these

- Moore's Law today has slowed down, but it still quite alive. Scaling integration continues with 2.5d and 3d integration (advanced packaging, foveros), memory stacking and on-package integration (see hbm and mobile SoCs), backside power delivery, larger and larger reticle sizes, continued transistor scaling (albeit slowed down as the contacted gate pitch has not moved much lately). New types of packaging becoming more used (panel scale packaging, wafer scale chips). Co-packaged optics with 3d stacking to scale past shoreline bandwidth limitations. microfluidics and forced air cooling
- Add the GPT notes
  - https://chatgpt.com/share/68407a7c-f178-8004-aced-f8f2b200b3cb

#heading("Integration Density Scaling", level: 4) Yes this also is continuing through technology improvements, but is certainly slowing down with respect to both logic and SRAM densities.

- density scaling wrt 'components' continues unabated, taller and taller SRAM stacks, ...
- transistor density increasing via wikichip SRAM density charts, but slowing down and time to doubling is growing fast
- https://fuse.wikichip.org/news/7375/tsmc-n3-and-challenges-ahead/ (wikichip diagrams of SRAM and logic density scaling over time)
- https://www.semiconductor-digest.com/moores-law-indeed-stopped-at-28nm/ (some wikichip diagrams here too about scaling) (I should recreate the wikichip scaling diagrams)
- Great diagram on page 21 of IDRS 2022 https://irds.ieee.org/images/files/pdf/2022/2022IRDS_MM.pdf

#heading("Cost-per-Component Scaling", level: 4) OK this has already been finished for a long time. Costs stopped going down per transistor as we scale to advanced packaging and sub-7nm nodes.

What about the cost aspect? Show the cost graphs. This is a problem indeed, cost isn't continuing to scale even as integration density improves.

- https://semiwiki.com/semiconductor-services/308018-the-rising-tide-of-semiconductor-cost/ (cost graph from Marvell 2020 investor day)
- https://semianalysis.com/2022/07/24/the-dark-side-of-the-semiconductor/ (another wafer cost graph from SemiAnalysis)
- https://www.tomshardware.com/tech-industry/manufacturing/chips-arent-getting-cheaper-the-cost-per-transistor-stopped-dropping-a-decade-ago-at-28nm (another graph showing cost per transistor is flattening off after 28nm)
- Use the figures from my qual too for per-transistor cost over process growing slowly
  - Also use some of the Kurnal / HighYield die shot breakdowns for evidence of growing integration
  - https://www.reddit.com/r/hardware/comments/1kdrmoq/high_yield_the_definitive_intel_arrow_lake/ (HighYield Arrow Lake die shot breakdown)

=== Dennard Scaling

- https://github.com/karlrupp/microprocessor-trend-data
  - The classical picture we need to put here
- https://spectrum.ieee.org/hot-chips
  - Mention this in the Dennard scaling section, not the Moore's law one. Thermal limits continue to limit total complexity scaling, but technologies are emerging that will counteract this in the near-term.
  - Frore Systems (MEMS based cooling airjet)
  - https://www.nature.com/articles/s41586-020-2666-1 (Co-designing electronics with microfluidics for more sustainable cooling)
  - https://www.mdpi.com/2072-666X/9/6/287 ( 3D Integrated Circuit Cooling with Microfluidics )

Complementing Moore's Law was *Dennard Scaling*, described by Robert H. Dennard and colleagues in 1974. This principle observed that as transistors shrank, their power density remained roughly constant. If you scaled down the dimensions of a transistor (length, width, oxide thickness) and the operating voltage by a factor `k`, the current would also scale down by `k`. Since power is voltage times current (`P = V * I`), power consumption per transistor decreased by `k^2`. However, since Moore's Law allowed you to pack `k^2` more transistors into the same area, the power *density* (power per unit area) stayed constant. Simultaneously, the smaller transistors switched faster, leading to an increase in clock frequency, also roughly proportional to `k`.

The synergy was profound: each new process generation delivered chips that were smaller, faster, cheaper to manufacture (per function), *and* consumed roughly the same power per unit area. This virtuous cycle fueled decades of exponential growth in single-core processor performance. Performance improvements of 50% or more year-over-year were common, graphically represented by the steep upward curve familiar from countless industry presentations.

[Insert Plot: Typical Performance Scaling (Log scale Perf vs. Year, showing exponential growth)]

This era saw the rise of iconic processor families and the accompanying explosion in personal computing, driven largely by the seemingly unstoppable march of single-threaded performance improvements.

=== The End of Dennard Scaling and Dark Silicon

Around the mid-2000s, the beautiful synergy of Moore's Law and Dennard Scaling began to break down. While Moore's Law continued (albeit perhaps slowing slightly), Dennard Scaling hit fundamental physical limits. As transistors became incredibly small, leakage current (power consumed even when transistors are nominally "off") became a significant portion of total power consumption. Reducing voltage further yielded diminishing returns and introduced reliability issues.

The consequence was stark: simply packing more transistors and cranking up the clock speed was no longer feasible without exceeding practical thermal limits. Processor power density began to increase dramatically with each generation, leading to the infamous "Power Wall." Clock speed increases stalled, hovering in the 3-4 GHz range for high-performance desktop processors – a plateau that persists largely to this day.

The first major architectural shift to combat this was the move to *multi-core processors*. If clock speed couldn't increase, perhaps performance could still scale by adding more processing cores to the same die. Intel's Core Duo and AMD's Athlon X2 marked the beginning of this era for mainstream computing around 2005-2006. Dual-core processors offered improved throughput for multitasking and threaded applications, providing a way to continue leveraging the increasing transistor counts delivered by Moore's Law, even if single-thread performance scaling had slowed. This also offered tangible benefits for real-time responsiveness, as background tasks could run on one core without significantly impacting foreground interaction on another.

Simultaneously, techniques like *Dynamic Voltage and Frequency Scaling (DVFS)* became crucial. DVFS allows the operating system to adjust the processor's clock speed and voltage on the fly based on the current workload. Lowering frequency and voltage during idle or low-intensity periods drastically reduces power consumption, extending battery life in mobile devices and reducing heat output in all systems. DVFS also helped manage increasing *process variation*, where manufacturing inconsistencies mean not all cores on a die (or even all transistors within a core) perform identically or have the same power characteristics. DVFS allows binning chips and running cores at frequencies appropriate to their individual capabilities and thermal envelopes.

Even with the shift to multicore, the constraints imposed by the end of Dennard Scaling continued to tighten. Moore's Law kept delivering more transistors per chip, but the inability to power them all simultaneously due to thermal limits became increasingly apparent. This led to the concept of *Dark Silicon* – the idea that a significant fraction of a chip's silicon area would have to remain unpowered ("dark") at any given time to stay within the power budget.

=== The Manycore Hypothesis and Failure

- PARLAB days, Itanium
- Single threaded performance is leveling off both in terms of IPC extraction and max frequency, so the only next step to gain performance is to exploit parallelism
  - wimpy cores over brawny cores, many of them, message passing, exploit fine-grained parallelism
  - but IPC continued to scale... AND more importantly application code isn't as amenable to explicitly programmed parallelism as it was thought to be - the magic compiler never materialized to make VLIW or Itanium feasible

The transition to multicore wasn't seamless. While adding cores provided more *potential* throughput, realizing that potential required software to be parallelized. This triggered widespread concern, sometimes dubbed the "Parallelism Panic," within the computer science community. Most existing software and programming paradigms were fundamentally sequential. How could developers effectively harness 4, 8, 16, or even more cores?

This challenge spurred significant research efforts, prominently including the *Parallel Computing Laboratory (PARLAB)* at UC Berkeley, launched around 2007. Their vision acknowledged the multicore shift as inevitable and sought to understand the fundamental building blocks of parallel computation to guide hardware and software co-evolution.

A key outcome of this thinking was the identification of the "Seven Dwarfs" of computation – computational patterns deemed crucial across a wide range of scientific and engineering applications:
1.  Dense Linear Algebra (e.g., matrix multiplication)
2.  Sparse Linear Algebra (e.g., solving systems with mostly zero entries)
3.  Spectral Methods (e.g., using FFTs)
4.  N-Body Methods (e.g., particle simulations)
5.  Structured Grids (e.g., finite difference methods)
6.  Unstructured Grids (e.g., finite element methods)
7.  MapReduce / Graph Traversal (emerging pattern for data analytics)

The hope was that by identifying these core patterns, hardware could be designed to accelerate them efficiently, and software frameworks could be built to make parallel programming easier for these common cases. The vision implicitly leaned towards systems that could scale to many cores, potentially hundreds, effectively tackling these "dwarf" workloads.

However, the PARLAB vision, while influential in high-performance computing (HPC), largely failed to translate into the mainstream, general-purpose computing world. Several factors contributed to this:
*   *HPC Focus:* The dwarfs primarily represented patterns found in scientific computing, not necessarily the dominant workloads on phones, laptops, or typical cloud servers (e.g., web browsing, text editing, database queries, serving web pages).
*   *Programming Complexity:* Despite efforts, effectively parallelizing general-purpose applications remained difficult. Amdahl's Law, which states that speedup is limited by the sequential portion of a task, remained a harsh reality. Many common applications had significant sequential bottlenecks or complex dependencies that resisted easy parallelization.
*   *The Rise of Heterogeneity:* Simply scaling identical cores proved less power-efficient than anticipated, leading towards different kinds of cores and accelerators.
*   *Software Ecosystem Inertia:* The vast majority of developers continued to write primarily sequential code, leveraging existing languages, libraries, and operating system abstractions that targeted single-threaded or coarse-grained parallelism.

Attempts to apply manycore concepts directly to tasks like web browsing often broke down immediately due to the complex, event-driven, and often inherently sequential nature of rendering, JavaScript execution, and layout engines. The parallelism revolution envisioned by PARLAB did not materialize for the average user's daily tasks.

== Digital Systems Today and in the Future

- Moore's Law continues to drive absolute integration complexity
- Dennard scaling's demise means we have to deal with dark silicon and focus on energy efficiency and specialization of architectures
- The failure of the manycore hypothesis indicates that rather than trying to cast every problem into a massive MIMD manycore grid, we should pick architectures for different design points
  - PLOT: Flexibility on one axis, Energy efficiency, Performance, types of parallelism exploitable, arithmetic intensity required to saturate
  - In-order CPUs, large OoO CPUs, GPUs, VLIW machines, DSP cores, vector machines, matrix engines (e.g. NPUs)
  - Crucially, these are all general purpose von-Neumann architectures!

If you can't power all the transistors at once, simply adding more identical general-purpose cores becomes inefficient. Why pay the area and leakage cost for cores that spend most of their time turned off? This reality spurred two major trends:

1.  *Hardware Accelerators:* Instead of more general-purpose cores, chip designers began integrating specialized hardware blocks designed to perform specific tasks *much* more efficiently (in terms of performance per watt) than a CPU could. Early examples included hardware video decoders/encoders (essential for smooth video playback without draining batteries), image signal processors (ISPs) in phone cameras, and cryptographic engines. More recently, Neural Processing Units (NPUs) or AI accelerators have become common for machine learning inference tasks. The idea is to offload power-hungry tasks from the CPU to these highly optimized units, keeping the general-purpose cores free for other work and reducing overall power consumption.

2.  *Heterogeneous Core Architectures:* Recognizing that not all tasks require maximum performance, ARM pioneered the big.LITTLE architecture, now widely adopted (e.g., Intel's Performance-cores and Efficient-cores, or P-cores and E-cores). This approach combines high-performance ("big" / P) cores designed for peak single-threaded speed with smaller, simpler, highly power-efficient ("LITTLE" / E) cores. The operating system scheduler dynamically assigns tasks to the appropriate core type: demanding foreground tasks run on the P-cores, while background tasks, idle periods, or less critical threads run on the E-cores. This allows the chip to deliver high peak performance when needed while maintaining excellent average power efficiency, effectively mitigating the Dark Silicon problem by using different *types* of silicon optimized for different operating points.

=== Heterogeneous Compute Architectures

These trends marked a move away from homogenous multicore designs towards complex Systems-on-Chip (SoCs) integrating a variety of processing elements tailored for different purposes.

- Specialized cores
- DSPs, VLIWs, GPUs, NPUs
- Geekerwan evidence
  - M4 pro/max: https://www.bilibili.com/video/BV1y1DoYKEui/
  - Snapdragon X elite: https://www.bilibili.com/video/BV1jJSzYTEbr/
  - O1 / 8Elite: https://www.bilibili.com/video/BV18sJHz5ENR/?spm_id_from=333.788.recommend_more_video.-1&vd_source=d3b77c56a4df4b3dd9c25c5c51184d5b (there is a very good scaling curve diagram here which shows the 3 core variant design in action)

// Apple's transition to its own silicon, starting with the A-series chips in iPhones and iPads and culminating in the M-series chips for Macs (M1, M2, M3, etc.), represents a stunning validation of the importance of general-purpose CPU performance and efficiency.
//
// Apple's custom ARM-based cores (e.g., Firestorm, Icestorm, Blizzard, Avalanche, Everest, Sawtooth) consistently delivered leadership-class single-thread performance, often surpassing contemporary x86 offerings from Intel and AMD, while consuming significantly less power.

- Collect numbers for devices that seem comparable on SPEC Geekerwan curves.
  - https://tech.yahoo.com/phones/articles/just-benchmarked-snapdragon-8-elite-043000603.html
    - Snapdragon 8 Elite, Chrome, Oryon high-perf core - 33.2 (much higher peak power)
    - Galaxy S24 Ultra, Chrome, Snapdragon 8 Gen 3, Cortex X4 - 16.3
    - iPhone 16 Pro, Safari, A18 Pro - 28.1 (much lower peak power)
    - iPhone 16 Pro Max, Safari, A18 Pro - 27.8
  - https://www.notebookcheck.net/Oppo-Find-X8-Pro-smartphone-review-Attack-on-the-iPhone-with-innovative-battery-technology.924091.0.html
    - Oppo Find X8 Pro, Chrome, Dimensity 9400, Cortex X925 - 16.3 (quite low!)
    - iPhone 16 Pro Max, Safari, A18 Pro - 33.5 (very very high, as expected)
    - Lots of good results are here from all kinds of phones! Try to look here. The results have error margins and are more reliable than the yahoo results.
    I think the main point is that on the SPEC curves some devices seem just marginally worse/better than iPhones, but on this benchmark we see huge differences.

- https://www.reddit.com/r/hardware/comments/1g9ff4o/qualcomm_snapdragon_8_elite_single_thread/

> Metric 	D9400 	8 Elite 	A18 Pro
> Geekbench 6 ST 	2901 	3261 	3568
> Clock speed 	3.63 GHz 	4.32 GHz 	4.04 GHz
> Power consumption 	7.9W 	7.6W 	6.6W
> P-core Area 	3.2 mm² 	2.2 mm² 	2.9 mm²
> Performance-per-clock 	799 	770 	883
> Performance-per-watt 	367 	429 	540
> Performance-per-area 	906 	1482 	1230
>
> PPC : Apple > Mediatek > Qualcomm.
> PPW : Apple > Qualcomm > Mediatek.
> PPA : Qualcomm > Apple > Mediatek.
>
> Notes :
>
> • Mediatek P-core area includes the private L2 cache.
> • SME block area not included for Apple P-core.

- SD 8 Elite vs 8 Gen 3: https://www.reddit.com/r/samsung/comments/1i89vnm/snapdragon_8_elite_vs_gen_3_vs_gen_2_the_real/
  - 8 Elite gives up a lot of top-end power for top-end performance, even if it does indeed come out on top
  - 8 Elite vs A18 Pro specs: https://nanoreview.net/en/soc-compare/qualcomm-snapdragon-8-gen-4-vs-apple-a18-pro

- Big.Little diagrams: https://forums.anandtech.com/threads/mediatek-soc-thread.2614945/
  - https://hothardware.com/reviews/arm-tcs-2023-cortex-x4-immortalis-g720
  - https://hothardware.com/photo-gallery/article/3312?image=big_arm-tcs23-cpu-efficiency-curve.jpg&tag=popup
  - Combine with latest Geekerwan SPEC curves
- A17 Pro Geekerwan curves: https://www.youtube.com/watch?v=iSCTlB1dhO0
- Snapdragon 8 Elite Geekerwan curves: https://www.youtube.com/watch?v=GkJCWncZbJc
- Speedometer 3.0 scores: https://www.techpowerup.com/forums/threads/post-your-speedometer-3-0-score.320241/
- https://www.reddit.com/r/hardware/comments/1gvo28c/latest_arm_cpu_cores_compared_performanceperarea/

> Latest ARM CPU cores compared: Performance-Per-Area and Performance-Per-Clock
>
> Core 	INT 	INT% 	FP 	FP% 	P 	Area 	Clock 	PPA 	PPC
> A18-P 	10.7 	120% 	16.0 	114% 	117% 	3.1 mm² 	4.04 GHz 	36.56 	28.96
> A18-E 	3.3 	37% 	5.0 	35% 	36% 	0.8 mm² 	2.2 GHz 	45.00 	16.36
> Oryon-L 	8.9 	100% 	14.0 	100% 	100% 	2.1 mm² 	4.32 GHz 	47.61 	23.14
> Oryon-M 	5.2 	58% 	8.0 	57% 	58% 	0.85 mm² 	3.53 GHz 	68.23 	16.43
> X925 	8.8 	99% 	13.9 	99% 	99% 	2.8 mm² 	3.63 GHz 	35.35 	27.27
> X4 	7.4 	83% 	10.0 	71% 	77% 	1.4 mm² 	3.3 GHz 	55.0 	23.33
> A720 	3.6 	40% 	5.7 	40% 	40% 	0.8 mm² 	2.4 GHz 	50.0 	16.66

*Geekerwan Scaling Curves:* Independent analysis, such as the detailed benchmark comparisons by Geekerwan, graphically illustrates this leap. Plots tracking SPECint (a standard benchmark for integer CPU performance) show Apple's A-series and M-series cores achieving dramatic year-over-year gains, establishing a significant lead over competitors, sometimes even when built on an older process node. This points towards massive investments in microarchitecture.

    [Insert Plot: Geekerwan Apple CPU Scaling (SPECint vs. Year/Generation)]

*Speedometer Benchmark:* Crucially, this performance translates to real-world applications. The Speedometer benchmark, which measures web application responsiveness (a task dominated by JavaScript execution and browser rendering on the CPU), shows consistent, significant generational improvements on Apple devices, correlating strongly with their CPU advancements. This directly impacts the user's perception of speed in one of the most common computing tasks.

    [Insert Plot: Speedometer Score Scaling (Score vs. Year/Generation for Apple devices)]

The SPEC perf vs power curves don't tell the whole story.
There is also application level specialization - see Speedometer scores which use the P core at max sustained throughput.
There is also the leakage power and core area tradeoff vs performance and dynamic power.
All these complicating factors require careful uArch design.

*P-cores and E-cores:* Apple masterfully implements the heterogeneous P-core / E-core strategy. Their E-cores themselves are often as fast as competitors' previous-generation P-cores, while their P-cores push the boundaries of performance. This combination delivers both exceptional peak speed and remarkable battery life. However, the foundation of the user experience rests on the sheer capability of those P-cores.

Apple's success stems from a combination of factors: massive investment in CPU microarchitecture design, tight hardware-software co-design facilitated by controlling the entire ecosystem (hardware, OS, key applications), and a relentless focus on optimizing for real-world workloads rather than just synthetic benchmarks. Their chips *do* contain accelerators (GPU, NPU, video engines, etc.), but the dramatic performance advantage felt by users is largely attributable to the raw power and efficiency of their general-purpose CPU cores. They demonstrated that "true software-optimized hardware" primarily meant building incredibly capable CPUs to run the software users care about most.

But CPUs aren't stagnating! Show performance results of M series systems on Speedometer. Energy efficiency and absolute performance continue to improve as cores are designed with specialized features for target workloads (e.g. speculation features such as load address/value prediction, pointer preemptive prefetching, things that expose uarch side-channels actually are good!)
Core microarchitecture iteration is still important! But performance benefits are hard to measure due to simulation bottlenecks.

=== Proliferation of Accelerators

- https://www.guru3d.com/story/intel-lunar-lake-processor-architecture-die-and-pch-annotated/ (Lunar Lake die shot with heterogeneity)
- The golden age of Patterson and Hennessy (https://www.doc.ic.ac.uk/~wl/teachlocal/arch/papers/cacm19golden-age.pdf)
  - Common misinterpretation: the "sea of accelerators" myth: https://accelerator.eecs.harvard.edu/isca14tutorial/isca2014-tutorial-aladdin.pdf
  // - The common misconception of the golden age: the sea of accelerators
  - The actual message: specialization of general purpose architectures for domains + more optimized design cycles through agile design + heterogeneous GPP architectures designed for different balance points and types of parallelism that can be extracted for the workload - there is nothing here about non-Von-Neumann architectures in fact
- Tpu evolution diagram, it's all about specialized general purpose architectures to balance system balance, arithmetic intensity, and intrinsic parallelism, how best to extract that parallelism
  - Even in ML chips that are growing in volume today, the architectures have become more generalized and often resemble a specialised manycore MIMD machine (Cerebras, Tenstorrent, TPU - a little different than those as of v4 at least). Some exceptions exist like SambaNova.

10 years after the 'golden age' Turing talk was given, do we really see the kind of 'specialization' that was hypothesized?
Rather, we see specialization and optimization of general purpose architectures that can exploit common computing motifs increasingly well through better programming models, APIs, and compilers (e.g. autovectorization). We also see specialization of GPPs to optimize for common software workloads (web browsers, layout rendering, javascript JIT, and so forth).
Some still argue that in the future, we will indeed see the 'sea of accelerators' and pervasive accelerators on a die, and that those will account for the majority of computing performance gains and compute cycles spent on an SoC, but there isn't a good reason to believe this.
Limits encountered via Moore's Law and Dennard scaling don't point to increased random kernel accelerators, but rather continued improvement of general purpose architectures to max out Amdahl's Law (both with respect to data parallelism, MLP, ILP, and system balance tradeoffs).

The chip block diagrams do *not* indicate any kind of *pervasive specialization* that the "golden age" position paper may have posited, but rather reflect adapting general purpose processing engines for different amounts of exploitable parallelism for different workloads. Only a handful of exceptions exist and those are arguably not even 'accelerators' since they have no application-visible programming model (e.g. video codecs, fixed function ISP pipelines).

Heterogeneity with respect to general purpose architectures! Not related to the 'sea of accelerators', but rather limited by dark silicon. 'accelerator level parallelism' is another dubious concept.

- The golden age supposedly
- Does that mean a sea of accelerators?
- Software evolves too quickly to burn in kernels in silicon
- Software motifs are consistent, the opportunities for parallelism, ilp, MLP, dlp, tlp, are all quite consistent regardless of the workload
- And then efficiency of this also sucks compared to efficient general purpose engines
- Software needs productivity, so hardware must adapt, see speedometer, specialization of general purpose engines, see this with ame and neural engine, see this with the tpu evolution too, see this with the arm isa specialized for JavaScript execution like fp stuff and also indirect threading, see Quinnell slides

- There are several notions of the "age of specialization"
1. Accelerators that are not generally user application programmable but are rather fixed function pipelines commonly associated with IOs (video codecs, audio pipelines, isp camera pipelines)
2. Accelerators that expose an explicit programming ISA or API (NPU, GPU, Apple's neural engine, DSP cores)
3. Specializations of general purpose computing architectures that are designed to optimally execute user applications

- Which ones can be exploited generally by user programs to exploit their intrinsic parallelism extraction opportunities? I argue that nearly all application level benefits come from the 3rd type. There is no "sea of accelerators" as is commonly assumed in the academic literature even as dennard scaling ended decades ago. While there is room to improve the cross architecture application mapping and communication schemes, these come after the specialization of each architecture itself.


=== Software Trends

- https://en.wikipedia.org/wiki/Wirth%27s_law
- A Plea for Lean Software: https://cr.yp.to/bib/1995/wirth.pdf
  - "software scaling" lol

- https://github.com/hollance/neural-engine/blob/master/docs/ane-vs-gpu.md
  - Annotated die photo of Apple A12 showing area dominance of general purpose compute
- Software dominates - the number of software engineers vastly outnumbers the number of hardware ones. You can't force new low-level programming models or radically new architectures on users (the users of hardware are software developers).
  - The consequence is that software must have a stable substrate to iterate on
  - And that substrate (hardware) must adapt to software needs (indirect threading, JITed code, ..., see Quinnell's talk)

Software drives the next generation hardware whether we like it or not. To some degree hardware advancements make software advancements / inefficiencies possible in the first place. So we must discuss the software first.
Software stack complexity continues to grow with more abstractions, consider webapp side
Programming productivity is king, more SW engineers vs HW ones
Cloud and edge application stacks are actually converging with respect to compute characteristics (indirect dispatch, JITs, VMs, more isolation), with differences in scale

=== Retrospective on SoC Evolution

The rise of accelerators and the challenges in scaling traditional CPUs led many industry observers and researchers (often highlighted in talks at conferences like the Design Automation Conference - DAC) to proclaim that *specialization is the future*. The narrative became that continued performance scaling would primarily come from offloading more and more tasks to dedicated hardware accelerators. General-purpose CPUs, the argument went, were hitting fundamental limits, and the only way forward was through increasingly heterogeneous, accelerator-rich designs.

However, this narrative often overlooks a critical aspect: *what software do people actually run?* While accelerators are undeniably useful for specific, well-defined, computationally intensive tasks, they don't address the bulk of the code executed on typical consumer devices.

Consider your daily usage of a smartphone or laptop:
*   Web browsing (rendering HTML, CSS, executing JavaScript)
*   Email and messaging
*   Social media scrolling and interaction
*   Word processing or spreadsheet editing
*   Code development
*   Running various utility applications

For these tasks, the vast majority of the execution time and, crucially, energy consumption occurs on the *general-purpose CPU cores*. While a video might be decoded by a dedicated hardware block, the user interface surrounding it, the network stack fetching it, the browser rendering the page it's embedded in – all rely heavily on the CPU. Even emerging AI features often involve significant pre- and post-processing on the CPU surrounding the core NPU inference task.

Furthermore, the software development ecosystem remains overwhelmingly centered around general-purpose CPUs. Developers write code in C++, Java, Python, Swift, JavaScript, etc., targeting standard CPU instruction sets. Compilers, debuggers, profilers, libraries, and frameworks are all built around this model. Getting developers to effectively target a diverse and constantly changing landscape of specialized accelerators is a massive challenge. It requires new tools, new programming models, and significant effort to rewrite or adapt existing codebases.

While accelerators like video decoders, ISPs, and increasingly NPUs have found their niche because they address high-value, computationally expensive, and relatively stable functions, they are not the primary drivers of the overall *snappiness* and responsiveness that users perceive. That feeling of performance comes largely from the speed and efficiency of the general-purpose cores executing the main application logic, the operating system, and the user interface code. Practical performance scaling and the ability to add more complex software features still hinge critically on improvements in general-purpose compute, both in raw speed and, increasingly, energy efficiency.

=== Redefining "Scaling": The System is the Computer

Perhaps the notion that "Moore's Law is dead" or "scaling has ended" is based on too narrow a definition, focusing solely on transistor density or single-core frequency. If we consider Moore's original insight more broadly – as concerning the scaling of *capability* and *cost* of an entire computing *system* – then scaling is far from over. We are witnessing a shift towards system-level integration and innovation:

*   *Bandwidth Scaling:* Memory bandwidth continues to increase dramatically through technologies like DDR5, LPDDR5X, and High Bandwidth Memory (HBM) stacked directly on packages. Interconnect bandwidth (PCIe Gen 5/6, NVLink, Infinity Fabric) allows faster communication between components.
*   *Board and Package Level Integration:* Advanced packaging techniques like Multi-Chip Modules (MCMs), chiplets (e.g., AMD's CPU/IO dies, Intel's Foveros), 2.5D interposers, and 3D stacking allow integrating diverse components (CPU, GPU, memory, I/O) much more tightly than traditional PCBs allowed, reducing latency and power consumption. Wafer-scale packaging pushes this further.
*   *I/O Integration:* More peripheral functions are integrated directly onto the SoC or processor package, including Thunderbolt/USB4 controllers, Wi-Fi and Bluetooth radios, and network interfaces, reducing system complexity and cost.
*   *Memory Integration:* Integrating memory controllers directly onto the CPU die has been standard practice for years. Stacking DRAM directly on top of logic (HBM) or integrating it into the package brings memory even closer.
*   *Radio Integration:* Complex cellular modems, Wi-Fi, and Bluetooth radios are now routinely integrated into the main SoC package or co-packaged closely.
*   *Advanced Cooling:* As power density remains a challenge, system-level solutions like liquid cooling (even in dense server racks like Nvidia's NVL72 Grace-Hopper system) allow for higher-performing components within manageable thermal envelopes.

From this perspective, scaling continues robustly. The system *as a whole* becomes more capable, more integrated, and often more cost-effective per unit of performance or capability.

==== The Continued Importance of General Purpose Compute

Despite the end of Dennard Scaling and the plateauing of clock speeds, single-thread performance *has not* stopped improving. While the explosive gains of the 1990s are gone, progress has continued at a respectable, compounding rate, driven by several factors:

1.  *Microarchitectural Innovation:* This has been the primary engine. CPU designers have relentlessly improved the *Instructions Per Clock* (IPC) executed by each core. This involves techniques like:
    *   Deeper instruction pipelines
    *   More sophisticated branch prediction to avoid pipeline stalls
    *   Wider instruction issue and execution units (superscalar designs)
    *   Larger and smarter cache hierarchies (L1, L2, L3) with better prefetching algorithms
    *   Improved Out-of-Order (OoO) execution engines to find and execute independent instructions in parallel, hiding memory latency.
    *   Optimized instruction decoders and micro-op caches.

2.  *Compiler Optimizations:* Compilers have become better at generating efficient machine code, performing sophisticated instruction scheduling, register allocation, and vectorization (using SIMD units like SSE, AVX, Neon).

3.  *Process Technology Improvements:* While scaling benefits are diminishing and costs are increasing, new process nodes (e.g., 10nm, 7nm, 5nm, 3nm) still offer some density and efficiency improvements, allowing for more transistors to implement the microarchitectural enhancements mentioned above, or to implement larger caches.

4.  *Software Optimizations:* Libraries, operating systems, and applications themselves are continually optimized to run more efficiently on modern hardware.

This relentless, compounding improvement is evident when tracking CPU performance over time. We saw a significant leap with Intel's Nehalem architecture (2008), followed by steady incremental gains. Architectures like AMD's Bulldozer (2011) and Intel's Itanium struggled to deliver competitive single-thread performance, highlighting the difficulty of achieving gains. However, AMD's Zen architecture (2017 onwards) marked a major resurgence, demonstrating that significant IPC improvements were still possible. And perhaps most dramatically, Apple's silicon efforts have rewritten the performance landscape.

== Agile Hardware Design

=== RTL-First Design and Evaluation

- Immediate PPA
- Reference all the qual slides I prepared in the past

- But how does this work in practice? There is no vertical iteration loop prior to tape out? So, there is still a full silicon spin cycle + software development time to figure out optimizations. How does Apple do it? Why do others lag so far behind?

=== The Nature of Modern Co-Design and Future Outlook

How does a company like Apple achieve this level of hardware-software integration and performance? It's not magic, but rather a long, iterative process built over many generations of silicon.

*   *Iterative Design:* Each chip generation builds upon the lessons learned from the previous one. Designs evolve incrementally, incorporating new microarchitectural ideas and responding to bottlenecks identified in earlier products.
*   *On-Device Tracing and Simulation:* Apple heavily utilizes performance tracing on actual devices running real applications (or realistic workloads). These traces capture detailed information about instruction execution, cache misses, branch mispredictions, memory accesses, and power consumption.
*   *Trace-Based Simulation:* The collected traces are then fed into complex, slow, cycle-accurate simulators of next-generation hardware designs. This allows engineers to evaluate the impact of proposed microarchitectural changes (e.g., a larger cache, a better branch predictor) on real-world code *before* committing to silicon.
*   *Software Optimization:* While hardware is being designed, software teams (OS, compilers, key applications like Safari) work to optimize their code for existing and upcoming hardware features. However, much software optimization often happens *after* the hardware is finalized, adapting to its specific characteristics.
*Slow Iteration Loop:* Crucially, this entire co-design loop is still very slow. From initial concept to silicon shipping takes years. Even with advanced emulation platforms (FPGA-based systems that can run software on a hardware prototype), fully exploring the design space and performing true end-to-end optimization of complex applications *with* the microarchitecture in real-time is not feasible. The feedback loop involves discrete generations of hardware.

What does this portend for the future?
The evidence strongly suggests that continued investment in general-purpose CPU microarchitecture, particularly focusing on single-threaded performance and energy efficiency, remains paramount. While accelerators will play important supporting roles for specific tasks (ML, video, graphics), they are unlikely to displace the CPU from its central position in handling the vast majority of code execution in typical user-facing applications.

The focus needs to be on making the common case fast and efficient. This means building better P-cores and E-cores, improving cache hierarchies, enhancing branch prediction, and working closely with compiler and OS developers. The primary target for optimization should be the software stacks that developers actually use and the applications users actually run.

== Premises and Conclusion

// *Conclusion:* Specialization through accelerators has its place, but its value proposition for mainstream computing may be less universal than often claimed. The history of computing, particularly the recent trajectory exemplified by Apple Silicon, suggests that relentless innovation in general-purpose CPU cores (both performance and efficiency variants) remains the bedrock of user experience. The most valuable form of "specialization" might be the workload specialization *of general-purpose cores* – designing cores and cache systems that are particularly adept at running the common software stacks (web browsers, productivity apps, common runtimes) efficiently. Enabling software developer productivity on these general-purpose platforms remains the key to unlocking new features and capabilities. The future of computing likely lies in continued strong general-purpose performance, smart heterogeneity (P/E cores), targeted acceleration for high-value tasks, and massive system-level integration – a broader definition of scaling that is very much alive and well.

- https://vighneshiyer.github.io/2024_01-quals-tidalsim.html#/2/10/5
- Summarize all the facts / premises and their respective conclusions
- Draw the ultimate conclusion that to enable the next-gen HW designs, we need to innovate on the simulation methodology front (among other things)
- gpp has well defined arch state, almost always von-Neumann architectures, simulation and optimnization is crucial


