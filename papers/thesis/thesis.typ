#import "ilm/lib.typ": ilm
#set page("us-letter")
#set text(lang: "en")

#let title = "A Rigorous Evaluation and Implementation of Sampled Microarchitecture Simulation"
#let author = "Vighnesh Iyer"

/*
https://grad.berkeley.edu/academic-progress/dissertation/#background

The proper organization and page order for your manuscript is as follows:

Title Page
Copyright page or a blank page
Abstract
Optional preliminary pages such as:
    Dedication page
    Table of contents
    List of figures, list of tables, list of symbols
    Preface or introduction
    Acknowledgments
    Curriculum Vitae
Main text
References
Bibliography
Appendices

Please do not include an approval/signature page.

Paper size must be letter. Font size 12pt or larger. Same font face and size should be used for the entire document. Footnotes/captions/figures use 8pt font or larger.

Page numbers must be in upper/lower right corner or bottom center and 3/4in from edges. Placement of page numbers must be consistent.
Title and copyright page should be unnumbered.
Abstract should be numbered from 1, 2, 3, ...
Preliminary pages should be numbered from i, ii, iii, iv, ...
The main body should be numbered from 1, 2, 3 (yes, start again from 1)

The title and abstract page must be formatted exactly as they specify.
Title:
Abstract: https://grad.berkeley.edu/wp-content/uploads/Abstract.pdf
*/
#page([

])

#pagebreak()

#show: ilm.with(
  title: [#title],
  author: author,
  date: datetime(year: 2025, month: 05, day: 30),
  abstract: none,
  bibliography: bibliography("bib.yml"),
  figure-index: (enabled: true),
  table-index: (enabled: true),
  listing-index: (enabled: true),
  paper-size: "us-letter",
  display-cover-page: false
)


= Preface

The topic of this thesis is quite out of left field to be honest.

// undergraduate experience
== Undergrad Time

When I began my undergraduate education at UC Berkeley in 2013, I knew I wanted to broadly learn about topics in the field of electrical engineering and computer science, but did not have any speciality in mind.
Early on, I was very eager to work in web development.
I was very excited for my first internship as a "full stack" engineer.
But, as most people had already found out, web development is boring and gets repetitive quickly, to the extent that today, I would not be surprised if they are replaced with LLMs very soon.
I knew I had to find something more interesting in computing or else I would be stuck upgrading yet another CRUD webapp to the latest frontend framework.

I took the usual EECS curriculum which covered topics up and down the stack: analog/RF circuits, digital circuits, VLSI, computer architecture, operating systems, embedded systems, DSP, optimization, software engineering, and AI/ML.
I also thought I should supplement the engineering-oriented classes with some more "theoretical" ones so I took a bunch of random statistics classes before realizing I'm not cut out for that.

It wasn't until I took Berkeley's introduction to digital circuits and logic course (EECS 151) that I found something I was genuinely interested in.
At the same time, I also found the analog and RF circuits courses interesting, so I decided to pursue research in computer architecture and further down the stack.

// teaching eecs151
== Undergrad Teaching

While I was an undergrad, I was a TA for Berkeley's digital circuits course (EECS151) a few times.
This was one of the best experiences I had during my time at Berkeley.

Certainly, teaching a subject is the best way to learn it.
The first time I was a TA, I made many mistakes when explaining concepts to students or helping them on homework.
Teaching made me realize just how little I understood the material after having just taken the same class the prior semester.
Only after teaching for a while, do you have enough understanding to write new materials for the course.

There is something very valuable about teaching the same material over and over again: you realize quickly that a 'curriculum' is never actually done.
Students pick up on the smallest mistakes in the textbook, labs, homeworks, and projects.
They get annoyed quickly when some script fails to run or if the lab fails to hold their interest.
The lesson I learned: contemporary computer architecture and digital design education is still far away from how good it could be.

// chip bringup
== Undergrad Research

Near the end of my undergrad career, I got involved in some "research", which was really just helping grad students with a chip bringup.
Honestly, I didn't even help that much, and instead I was quite an annoyance, asking lots of questions, and making slow progress.
I owe a large debt to the senior grad students who patiently explained the hardware and software components of the chip they built.

Eventually, I was able to lead the bringup of SERDES links on the chip!
The goal was for the SoC's RISC-V cores to access external DRAM (hosted on a FPGA devboard) via these SERDES links.
This was designed to be much faster than using our slow parallel bus from the chip to the FPGA.
This would bring this academic SoC's performance closer to that of a real SoC which would have an integrated DDR controller and PHY.

As usual, things usually don't work out as you would like.
While the SERDES links managed to stay up and synchronized for a few seconds, eventually the clock skew calibration would drift out of phase (there was no CDR on the chip's RX) and the BER would explode.
However, we were able to run some quick tests during the time the link stayed alive, and that was sufficient to get a number.
People outside this field would be surprised and disappointed upon seeing that academic chips _barely_ work.

// power modeling (this was a bit too random to mention here)

== Motivation for Grad School

So, why even bother going to grad school?
When I was about done with my undergraduate education, I had plenty of opportunities to jump into any random SWE job in the Bay.
But, I felt I _knew nothing_ about what I just learned.
Sure, I had gone through the motions: taking a bunch of classes, building a few projects, and doing well on exams, but none of this gave me enough grounding to pursue independent research like I wanted to.

My motivation for going to graduate school was to gain an encyclopedic understanding of computer architecture and all its adjacent fields.
Unlike the common conception of graduate school as a place where you become an ultra-specialized researcher who knows little outside their speciality, the environment at Berkeley is quite different.
Our lab is a place where, through building real systems, you inevitably end up learning about every part of the stack.
It is this ability to constantly build things from scratch without any preconceived objectives (i.e. publish a paper) that grants you encyclopedic knowledge.

== Applying to Grad School

When I sat down to write my application, my high-level interest was sitting at the edge of analog and digital circuits in the context of building large digital SoCs.
I decided to write my statement of purpose (SoP) in an unorthodox way.
I planned to propose a concrete line of research based on my interests in my SoP, with the idea that a professor would really appreciate it if I knew exactly what I wanted to build.
Specifically, since I was interested in asynchronous circuits and timing closure at the time, I proposed to investigate some problems in the design methodology, physical design, automated timing analysis, and circuit design aspects of globally-asynchronous, locally-synchronous (GALS)

Of course, this backfired and instead turned off PIs who thought that this was my only specific interest, and if they weren't working on a similar idea, that I would not be interested.
Even still, I was lucky enough to have several offers from PIs in areas outside GALS implementation techniques 😆.

// starting with analog circuits and INC prelim
== The First Two Years

When I started my PhD, I had no clue what I was actually interested in, and more importantly, what was worth doing.
Whatever interest I had claimed in my SoP was from the topics I was reading at the time.
Since I had some interest in analog and RF circuits too, I decided to take classes in that area and prepare for the integrated circuits preliminary exam.

Soon, I realized that analog circuit design wasn't in my blood.
It is nice to start with some first principles (i.e. equation-based transistor models that humans can understand), pick a topology, and size the transistors.
But after that point, you do the layout, run some parasitic-extracted simulations, realize your idealized circuit models used for the first principles analysis were completely wrong, and then go crazy with parameter sweeping.
I just couldn't get with the program: this didn't feel like systematic engineering, but rather felt like trying random things until something worked.

It was obvious I should change my primary field away from integrated circuits, but I still needed to take the prelim exam.
The first time, I failed the exam, and rightly so; my skills in analog design were poor, and my interest was fading.
After passing the prelim exam (on my second attempt), I decided to move up the stack and work on projects in computer architecture.

// working through early stage research projects in my PhD
== Learning More Things

After that point, I explored a bunch of areas within computer architecture, and learned new things every time I started from scratch.
None of my explorations and projects ended in anything grand, because I didn't have any unifying vision in mind: I was exploring subjects that came to my or my advisor's attention.
I played some role in a bunch of projects including:

- Power macromodeling for random RTL blocks
- RTL and verification for a systolic GEMM accelerator (Gemmini)
- Fault injection (soft error model) and AVF estimation
- RTL design of various blocks
- Specification mining for RTL bug localization
- Hardware verification projects including fuzzing, RISC-V stimulus generation, monadic testbench API, coverage instrumentation libraries

Ultimately, these were all disconnected efforts and there wasn't a way to unify them into some grand vision.
But, every project was valuable: I learned something about each piece of the stack, and every project got me closer to my goal of encyclopedic knowledge.

// eventually coming to simulation as the king of tools
// the reality of microarchitecture simulation sampling today and the work that remains to be done
== Simulation is King

When I reflected on the random things I did in the past, one thing became clear: all computer architecture work relies on _a few fundamental tools_.
They include, a language for modeling or implementation of hardware, representative workloads that the hardware is designed to execute efficiently, and a simulation framework to estimate performance (and other VLSI metrics) of the hardware you are designing.

Of these, the place where I could make an impact, as a single student, was _simulation methodology_.
In particular, the workhorse of the hardware design loop is _RTL simulation_ and it is frequently the bottleneck when it comes to iterating on a design.
If we can improve the throughput and latency of RTL simulation, while preserving its fidelity, it would be a boon for hardware designers.

== Sampled Simulation

// Some words about the inspiration behind this project and how it came to be.
//sudden shift to sampled simulation due to higher potential impact and an uncrowded area.

In this thesis, I will describe the creation and evaluation of a framework for sampled simulation of RTL.
But none of the ideas in this thesis are _"original"_ or _"novel"_ per se.
Rather, sampling in the context of hardware simulation has a long history going back to the early 2000s.

There have been countless papers published about sampled hardware simulation (I would estimate upwards of 200 papers at "top-tier" conferences, many of which I will summarize in this thesis).
When I would express interest in working on sampling, people would often comment: "Isn't sampling already done to death?".
Of course, this just means many papers have been published, but it says nothing about how usable sampling is, how thoroughly it has been studied, or how we can deal with sampling systematically for an entire SoC.

There is a lot more work to do beyond the tools and methodologies described in this thesis; research in sampled hardware simulation is not even remotely close to done.
Taking the ideas here and extending them systematically to sampled simulation of rack-scale systems would enable pre-silicon agile design in a way that is not possible today.

// Isn't sampling done to death?
// People say this and just point to papers. But this is paper-brained nonsense.
// Sampling doesn't even exist today from my real-life perspective.
// That combined with interest from industry, made me realize that this fields isn't truly explored to its conclusion. And even after I worked on this topic, there are infinite avenues open to continued exploration. Not a hot area anymore though.

// inspiration behind the organization and writing of this thesis
== Writing Style

Finally, this thesis is written in a style inspired by two other theses.
I took direction from #link("https://www2.eecs.berkeley.edu/Pubs/TechRpts/2023/EECS-2023-275.html")[Dan Fritchman's thesis], which was written in a way that an early stage graduate student could grasp and extend.
I also appreciate #link("https://www2.eecs.berkeley.edu/Pubs/TechRpts/2023/EECS-2023-56.pdf")[Ryan Kaveh's] advice to write my thesis as if it were a tutorial to understand the history and theory of the specific line of work I explored.

#align(right)[
_Vighnesh Iyer_
]

= Acknowledgements

TBD.

= Introduction

// == The Digital Hardware Landscape
// Chip landscape overall

Digital hardware is ubiquitous.

Everywhere we look, no matter the form factor or application, nearly every system on our planet is driven by digital hardware.
This includes consumer electronics (watches, phones, laptops), IoT devices, home appliances, urban infrastructure, cars, manufacturing, and datacenters.
Underpinning the proliferation of digital hardware is the core component of any digital system: the _general-purpose microprocessor_.
Although the general-purpose processor (GPP) has seen reduced interest recently,

How have the typical mobile and datacenter SoCs and SiPs evolved over the past several decades?

== Scaling Trends

- First figure: https://www.semiconductors.org/despite-short-term-cyclical-downturn-global-semiconductor-markets-long-term-outlook-is-strong/
  - Semiconductor sales over time = high importance
- https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=10589682&tag=1 (transistors per processor over time, energy efficiency over time, vertical connection 3D density over time, technology evolution chart)
  - I need to pull these 4 figures from this link
  - From this article: https://spectrum.ieee.org/trillion-transistor-gpu
- Excellent transistor count over time graphic: https://interludeone.com/posts/2021-04-21-chips/chips.html
- Use the figures from my qual too for per-transistor cost over process growing slowly
  - Also use some of the Kurnal / HighYield die shot breakdowns for evidence of growing integration
- https://spectrum.ieee.org/hot-chips
  - Should mention this in the scaling section

=== Moore's Law

=== Dennard Scaling

=== Dark Silicon

=== Proliferation of Accelerators

== Agile Hardware Design

//- Start with the basics
//- The flow of sampled simulation, including what is required in a full system, contrast fixed with live sampling and why one might be required
//- Then actually begin with workloads and benchmark construction, make everything work with riscv and then discuss the rust benchmarking strategy and potential complications
//- Then begin with trying to understand embeddings with traces alone, starting with clustering studies using data from spike and qemu, then move to rtl simulation and finally firesim when it becomes necessary, and when using real rtl we can evaluate perf metric prediction while assuming perfect sampling methodology and attribute errors due to sampling and extrapolation vs warmup issues, also related to time sync
//- What is the impact of time sync? Compare time dependent behavior we see in spike or qemu vs what we see in rtl sim or firesim
//- Then discuss the tidalsim project itself, how it works, some results, leave out results that require very good checkpointing, discuss functional warmup models and get l1i/d working
//- then get Linux working too
//- Next is to do parameter exploration, this is just monkey stuff but it gives a lot of quantitative data
//- Then let's do the error analysis studies and quantify errors and their sources
//- Finally wrap things up somehow with some case studies about latency of evaluation of some core level parameter deltas using rtl sim, firesim, perf models and tidalsim
//- Need to present a full story and assign parts of the thesis to every step within the flow
//
//- Moore's law, dennard scaling, dark silicon, the typical plot of perf over time, accelerators on dies, reemergence of mass integration like MCM and wafer scale packaging, but even with all this, ml accelerators, the vast majority of power consumption and time per application is spent on the general purpose cores, then show geekerwan scaling on spec for apple cores, also show speedometer here, also talk about p and e cores
//- The parallelism panic at the parlab days
//
//- Scaling driven by technology, microarchitecture, compilers, and software
//- Now people claim that specialization is the key to continued scaling
//- But none of the code you run every day actually uses specialized accelerators, besides a few like video decoding
//- Look at what matters, practical performance scaling and more features happens because of improvements in general purpose compute with respect to energy efficiency and raw perf
//- See the apple scaling curves from geekerwan
//
//Refer to the typical DAC / job talks
//
//- Microprocessors dominate how we interact with digital electronics. Phones, tablets, laptops, watches, and servers in datacenters (the cloud).
//- How has microprocessors evolved over the past 50 years?
//- The very first unicore processors and operating systems
//- Moore's Law and Dennard Scaling
//- Dual core processors to counteract some poor scaling trends and improve real time performance
//- DVFS technologies for power savings and to deal with increasing process variation
//- Multicore processors continue to proliferate
//- Mixed perf/energy efficiency processors (big/little architecture)
//- The failure of the PARLAB vision (discuss the 7 dwarves as they seemed to provide opportunity for general purpose scaling machines, but it didn't pan out. they were mostly for HPC apps. when attempted to apply onto manycore systems and general applications like web browsers, they break down right away)
//- Dark silicon
//- Software engineers are dominant, we must align to what they want and accelerate their common stacks
//- Continued performance improvements of single thread performance. Process scaling and uarch improvements continue to compound every generation going from the Nehelem era to the failure of Bulldozer/Itanium and into the Zen era we see today.
//- The Apple breakthroughs on both the smartphone and laptop side (A14+ and M1+ series of chips)
//- True software optimized hardware, continued scaling of performance, Speedometer performance continues to improve every generation even as process improvements stagnate or come at an increasing cost
//- Accelerators are there, but are they the primary target of phone/tablets/laptops today? Even in the distant future? Probably not.
//- Use GPT to chart this outline and fill in any missing holes.
//- What does this portend?
//  - How does Apple do their co-design today? It is iterative over many generations of silicon. On-device tracing and trace-based simulation. Software optimizations done after the fact.
//  - Basically, the iteration loop is still very slow! True optimization of the end-to-end application with the microarchitecture is not possible, even with emulation machines.
//
//- Moore's law was not in principle just about integrated circuit scaling or cost, but rather about scaling and cost of an entire system, and those continue to scale! Bandwidth, board and package level integration, io Integration, memory integration, radio integration, more advanced cooling like in nvl72, scaling itself has not ended, specialiation is less valuable than thought, workload specialization of general purpose cores to enable software development productivity is the real key
//
//- https://dl.acm.org/doi/pdf/10.1145/3649329.3663515
//  - Invited: The Magnificent Seven Challenges and Opportunities in Domain-Specific Accelerator Design for Autonomous Systems
//
//> In the first quarter of this century, computing hardware design- ers were faced with both the limitations of technology scaling for performance [1 ], and the ensuing conflagration of on-chip power density [2]. Fortunately, the challenges of the Dark Silicon era [ 3] have transitioned into a prosperous period of specialized accelera- tor design [ 4 , 5 ]. Emerging enabling technology and tools for agile and democratized hardware design are powering an exciting land
//
//- List of Android SoCs: https://docs.google.com/spreadsheets/d/1ZvQonnQ5Yl4QmURVmj7BH4CW8aEloMqbDnWSaBGAxh4/edit?gid=0#gid=0
//  - Very interesting and useful enumeration of the core configurations in various Qualcomm, Mediatek, Samsung, Google SoCs
//  - https://www.reddit.com/r/hardware/comments/1jqfxjn/list_of_android_socs/ (very cool, need to credit this guy)

//#set page(paper: "us-letter", margin: (x: 1in, y: 1in))
//#set text(font: "Linux Libertine", size: 11pt)

//= The Enduring Reign of General-Purpose Compute

== Introduction: The Microprocessor's Ubiquitous Grasp

Microprocessors are the invisible engines of modern life. From the smartphones in our pockets and the tablets we browse on, to the laptops powering our work and the watches tracking our steps, these intricate slivers of silicon dictate our interaction with the digital world. Even the seemingly ethereal "cloud" is built upon vast datacenters packed with servers, each driven by powerful microprocessors. Understanding the evolution of these devices over the past half-century is crucial to understanding the trajectory of technology and predicting its future.

How did we get here? From humble beginnings to the complex Systems-on-Chip (SoCs) of today, the journey has been one of relentless scaling, punctuated by fundamental shifts in design philosophy driven by the very laws of physics that initially enabled explosive growth. This document explores that journey, focusing on the interplay between technological advancements, architectural innovation, and the ever-present demands of software. We will examine the golden age of scaling defined by Moore's Law and Dennard Scaling, the challenges that arose as these trends faltered, the proposed solutions like massive parallelism and hardware acceleration, and ultimately argue that despite the allure of specialization, the continued improvement of general-purpose processing remains the most critical driver of performance and user experience for the vast majority of applications we use every day.

== The Golden Age: Moore's Law and Dennard Scaling

The story of microprocessor scaling begins in the 1960s and 70s. Early microprocessors like the Intel 4004 were revolutionary but primitive by today's standards, operating on 4-bit data with clock speeds measured in kilohertz. The operating systems designed for these early machines were equally basic, often single-tasking environments.

The engine driving progress was famously articulated by Gordon Moore in 1965. *Moore's Law*, in its common interpretation, observed that the number of transistors that could be economically integrated onto a silicon chip doubled approximately every two years. This exponential growth in transistor density led to increasingly complex designs and lower costs per function.

Complementing Moore's Law was *Dennard Scaling*, described by Robert H. Dennard and colleagues in 1974. This principle observed that as transistors shrank, their power density remained roughly constant. If you scaled down the dimensions of a transistor (length, width, oxide thickness) and the operating voltage by a factor `k`, the current would also scale down by `k`. Since power is voltage times current (`P = V * I`), power consumption per transistor decreased by `k^2`. However, since Moore's Law allowed you to pack `k^2` more transistors into the same area, the power *density* (power per unit area) stayed constant. Simultaneously, the smaller transistors switched faster, leading to an increase in clock frequency, also roughly proportional to `k`.

The synergy was profound: each new process generation delivered chips that were smaller, faster, cheaper to manufacture (per function), *and* consumed roughly the same power per unit area. This virtuous cycle fueled decades of exponential growth in single-core processor performance. Performance improvements of 50% or more year-over-year were common, graphically represented by the steep upward curve familiar from countless industry presentations.

[Insert Plot: Typical Performance Scaling (Log scale Perf vs. Year, showing exponential growth)]

This era saw the rise of iconic processor families and the accompanying explosion in personal computing, driven largely by the seemingly unstoppable march of single-threaded performance improvements.

== The Cracks Appear: Hitting the Power Wall

Around the mid-2000s, the beautiful synergy of Moore's Law and Dennard Scaling began to break down. While Moore's Law continued (albeit perhaps slowing slightly), Dennard Scaling hit fundamental physical limits. As transistors became incredibly small, leakage current (power consumed even when transistors are nominally "off") became a significant portion of total power consumption. Reducing voltage further yielded diminishing returns and introduced reliability issues.

The consequence was stark: simply packing more transistors and cranking up the clock speed was no longer feasible without exceeding practical thermal limits. Processor power density began to increase dramatically with each generation, leading to the infamous "Power Wall." Clock speed increases stalled, hovering in the 3-4 GHz range for high-performance desktop processors – a plateau that persists largely to this day.

The first major architectural shift to combat this was the move to *multi-core processors*. If clock speed couldn't increase, perhaps performance could still scale by adding more processing cores to the same die. Intel's Core Duo and AMD's Athlon X2 marked the beginning of this era for mainstream computing around 2005-2006. Dual-core processors offered improved throughput for multitasking and threaded applications, providing a way to continue leveraging the increasing transistor counts delivered by Moore's Law, even if single-thread performance scaling had slowed. This also offered tangible benefits for real-time responsiveness, as background tasks could run on one core without significantly impacting foreground interaction on another.

Simultaneously, techniques like *Dynamic Voltage and Frequency Scaling (DVFS)* became crucial. DVFS allows the operating system to adjust the processor's clock speed and voltage on the fly based on the current workload. Lowering frequency and voltage during idle or low-intensity periods drastically reduces power consumption, extending battery life in mobile devices and reducing heat output in all systems. DVFS also helped manage increasing *process variation*, where manufacturing inconsistencies mean not all cores on a die (or even all transistors within a core) perform identically or have the same power characteristics. DVFS allows binning chips and running cores at frequencies appropriate to their individual capabilities and thermal envelopes.

== The Parallelism Panic and the PARLAB Vision

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

== Dark Silicon and the Rise of Heterogeneity

Even with the shift to multicore, the constraints imposed by the end of Dennard Scaling continued to tighten. Moore's Law kept delivering more transistors per chip, but the inability to power them all simultaneously due to thermal limits became increasingly apparent. This led to the concept of *Dark Silicon* – the idea that a significant fraction of a chip's silicon area would have to remain unpowered ("dark") at any given time to stay within the power budget.

If you can't power all the transistors at once, simply adding more identical general-purpose cores becomes inefficient. Why pay the area and leakage cost for cores that spend most of their time turned off? This reality spurred two major trends:

1.  *Hardware Accelerators:* Instead of more general-purpose cores, chip designers began integrating specialized hardware blocks designed to perform specific tasks *much* more efficiently (in terms of performance per watt) than a CPU could. Early examples included hardware video decoders/encoders (essential for smooth video playback without draining batteries), image signal processors (ISPs) in phone cameras, and cryptographic engines. More recently, Neural Processing Units (NPUs) or AI accelerators have become common for machine learning inference tasks. The idea is to offload power-hungry tasks from the CPU to these highly optimized units, keeping the general-purpose cores free for other work and reducing overall power consumption.

2.  *Heterogeneous Core Architectures:* Recognizing that not all tasks require maximum performance, ARM pioneered the big.LITTLE architecture, now widely adopted (e.g., Intel's Performance-cores and Efficient-cores, or P-cores and E-cores). This approach combines high-performance ("big" / P) cores designed for peak single-threaded speed with smaller, simpler, highly power-efficient ("LITTLE" / E) cores. The operating system scheduler dynamically assigns tasks to the appropriate core type: demanding foreground tasks run on the P-cores, while background tasks, idle periods, or less critical threads run on the E-cores. This allows the chip to deliver high peak performance when needed while maintaining excellent average power efficiency, effectively mitigating the Dark Silicon problem by using different *types* of silicon optimized for different operating points.

These trends marked a move away from homogenous multicore designs towards complex Systems-on-Chip (SoCs) integrating a variety of processing elements tailored for different purposes.

== The Accelerator Argument vs. Everyday Reality

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

== The Unsung Hero: Continued General-Purpose Scaling

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

== The Apple Silicon Revolution: A Case Study in General-Purpose Dominance

Apple's transition to its own silicon, starting with the A-series chips in iPhones and iPads and culminating in the M-series chips for Macs (M1, M2, M3, etc.), represents a stunning validation of the importance of general-purpose CPU performance and efficiency.

Apple's custom ARM-based cores (e.g., Firestorm, Icestorm, Blizzard, Avalanche, Everest, Sawtooth) consistently delivered leadership-class single-thread performance, often surpassing contemporary x86 offerings from Intel and AMD, while consuming significantly less power.

*Geekerwan Scaling Curves:* Independent analysis, such as the detailed benchmark comparisons by Geekerwan, graphically illustrates this leap. Plots tracking SPECint (a standard benchmark for integer CPU performance) show Apple's A-series and M-series cores achieving dramatic year-over-year gains, establishing a significant lead over competitors, sometimes even when built on an older process node. This points towards massive investments in microarchitecture.

    [Insert Plot: Geekerwan Apple CPU Scaling (SPECint vs. Year/Generation)]

*Speedometer Benchmark:* Crucially, this performance translates to real-world applications. The Speedometer benchmark, which measures web application responsiveness (a task dominated by JavaScript execution and browser rendering on the CPU), shows consistent, significant generational improvements on Apple devices, correlating strongly with their CPU advancements. This directly impacts the user's perception of speed in one of the most common computing tasks.

    [Insert Plot: Speedometer Score Scaling (Score vs. Year/Generation for Apple devices)]

*P-cores and E-cores:* Apple masterfully implements the heterogeneous P-core / E-core strategy. Their E-cores themselves are often as fast as competitors' previous-generation P-cores, while their P-cores push the boundaries of performance. This combination delivers both exceptional peak speed and remarkable battery life. However, the foundation of the user experience rests on the sheer capability of those P-cores.

Apple's success stems from a combination of factors: massive investment in CPU microarchitecture design, tight hardware-software co-design facilitated by controlling the entire ecosystem (hardware, OS, key applications), and a relentless focus on optimizing for real-world workloads rather than just synthetic benchmarks. Their chips *do* contain accelerators (GPU, NPU, video engines, etc.), but the dramatic performance advantage felt by users is largely attributable to the raw power and efficiency of their general-purpose CPU cores. They demonstrated that "true software-optimized hardware" primarily meant building incredibly capable CPUs to run the software users care about most.

== The Nature of Modern Co-Design and Future Outlook

How does a company like Apple achieve this level of hardware-software integration and performance? It's not magic, but rather a long, iterative process built over many generations of silicon.

*   *Iterative Design:* Each chip generation builds upon the lessons learned from the previous one. Designs evolve incrementally, incorporating new microarchitectural ideas and responding to bottlenecks identified in earlier products.
*   *On-Device Tracing and Simulation:* Apple heavily utilizes performance tracing on actual devices running real applications (or realistic workloads). These traces capture detailed information about instruction execution, cache misses, branch mispredictions, memory accesses, and power consumption.
*   *Trace-Based Simulation:* The collected traces are then fed into complex, slow, cycle-accurate simulators of next-generation hardware designs. This allows engineers to evaluate the impact of proposed microarchitectural changes (e.g., a larger cache, a better branch predictor) on real-world code *before* committing to silicon.
*   *Software Optimization:* While hardware is being designed, software teams (OS, compilers, key applications like Safari) work to optimize their code for existing and upcoming hardware features. However, much software optimization often happens *after* the hardware is finalized, adapting to its specific characteristics.
*Slow Iteration Loop:* Crucially, this entire co-design loop is still very slow. From initial concept to silicon shipping takes years. Even with advanced emulation platforms (FPGA-based systems that can run software on a hardware prototype), fully exploring the design space and performing true end-to-end optimization of complex applications *with* the microarchitecture in real-time is not feasible. The feedback loop involves discrete generations of hardware.

What does this portend for the future?
The evidence strongly suggests that continued investment in general-purpose CPU microarchitecture, particularly focusing on single-threaded performance and energy efficiency, remains paramount. While accelerators will play important supporting roles for specific tasks (ML, video, graphics), they are unlikely to displace the CPU from its central position in handling the vast majority of code execution in typical user-facing applications.

The focus needs to be on making the common case fast and efficient. This means building better P-cores and E-cores, improving cache hierarchies, enhancing branch prediction, and working closely with compiler and OS developers. The primary target for optimization should be the software stacks that developers actually use and the applications users actually run.

== Redefining "Scaling": The System is the Computer

Perhaps the notion that "Moore's Law is dead" or "scaling has ended" is based on too narrow a definition, focusing solely on transistor density or single-core frequency. If we consider Moore's original insight more broadly – as concerning the scaling of *capability* and *cost* of an entire computing *system* – then scaling is far from over. We are witnessing a shift towards system-level integration and innovation:

*   *Bandwidth Scaling:* Memory bandwidth continues to increase dramatically through technologies like DDR5, LPDDR5X, and High Bandwidth Memory (HBM) stacked directly on packages. Interconnect bandwidth (PCIe Gen 5/6, NVLink, Infinity Fabric) allows faster communication between components.
*   *Board and Package Level Integration:* Advanced packaging techniques like Multi-Chip Modules (MCMs), chiplets (e.g., AMD's CPU/IO dies, Intel's Foveros), 2.5D interposers, and 3D stacking allow integrating diverse components (CPU, GPU, memory, I/O) much more tightly than traditional PCBs allowed, reducing latency and power consumption. Wafer-scale packaging pushes this further.
*   *I/O Integration:* More peripheral functions are integrated directly onto the SoC or processor package, including Thunderbolt/USB4 controllers, Wi-Fi and Bluetooth radios, and network interfaces, reducing system complexity and cost.
*   *Memory Integration:* Integrating memory controllers directly onto the CPU die has been standard practice for years. Stacking DRAM directly on top of logic (HBM) or integrating it into the package brings memory even closer.
*   *Radio Integration:* Complex cellular modems, Wi-Fi, and Bluetooth radios are now routinely integrated into the main SoC package or co-packaged closely.
*   *Advanced Cooling:* As power density remains a challenge, system-level solutions like liquid cooling (even in dense server racks like Nvidia's NVL72 Grace-Hopper system) allow for higher-performing components within manageable thermal envelopes.

From this perspective, scaling continues robustly. The system *as a whole* becomes more capable, more integrated, and often more cost-effective per unit of performance or capability.

*Conclusion:* Specialization through accelerators has its place, but its value proposition for mainstream computing may be less universal than often claimed. The history of computing, particularly the recent trajectory exemplified by Apple Silicon, suggests that relentless innovation in general-purpose CPU cores (both performance and efficiency variants) remains the bedrock of user experience. The most valuable form of "specialization" might be the workload specialization *of general-purpose cores* – designing cores and cache systems that are particularly adept at running the common software stacks (web browsers, productivity apps, common runtimes) efficiently. Enabling software developer productivity on these general-purpose platforms remains the key to unlocking new features and capabilities. The future of computing likely lies in continued strong general-purpose performance, smart heterogeneity (P/E cores), targeted acceleration for high-value tasks, and massive system-level integration – a broader definition of scaling that is very much alive and well.

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

= Microarchitecture Oracle Analysis of Program Sampling

== TraceKit

== RTL Simulation Tracing

=== FireSim Tracing

=== Clustering Analysis

== Functional-Only Simulation Tracing

=== Evaluation of Time-Based Sampling

== Functional Warmup Evaluation

= Sampled Simulation Leveraging RTL Simulation

After understanding the workload characteristics based on prior work and our investigation in the prior chapter, our next step is to build a prototype of a sampled simulation framework that uses RTL simulation to estimate performance metrics.
In contrast to the traditional approach to sampled simulation, which rely on either execution or trace driven CPU performance models, we leverage a very detailed RTL simulation of a particular CPU microarchitecture.

== Embedding

== Functional Warmup Models

== Microarchitecture State Injection

== Simulator Architecture

#figure(
  image("figs/overview.svg"),
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
  image("figs/wikisort.svg"),
  caption: [An overview of the steps involved in the TidalSim flow.]
)

#figure(
  image("figs/huffbench.svg"),
  caption: [An overview of the steps involved in the TidalSim flow.]
)

= A Novel Baremetal Benchmark Construction Methodology

== Existing Benchmarks

- Embench
- Mibench
- Use bring up bench and riscv mu nn as benchmarks
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

The evaluation gap:
- big gap between microbenchmarks and real applications
- trace collection from silicon and replay on trace-driven sim can work, but it requires a long iteration cycle, which isn't ideal
- proposed solution: use the speed of sampled simulation with the fidelity of RTL to run real apps in the RTL iteration loop / during performance modeling

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

//= TidalSim: A Live Sampling Flow

= DSE Using RTL Sampled Simulation

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

