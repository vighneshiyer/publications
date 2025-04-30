#heading([Preface], numbering: none)

The topic of this thesis is quite out of left field to be honest.

// undergraduate experience
#heading([Undergrad Time], depth: 2, numbering: none)

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
#heading([Undergrad Teaching], depth: 2, numbering: none)

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
#heading([Undergrad Research], depth: 2, numbering: none)

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

#heading([Motivation for Graduate School], depth: 2, numbering: none)

So, why even bother going to grad school?
When I was about done with my undergraduate education, I had plenty of opportunities to jump into any random SWE job in the Bay.
But, I felt I _knew nothing_ about what I just learned.
Sure, I had gone through the motions: taking a bunch of classes, building a few projects, and doing well on exams, but none of this gave me enough grounding to pursue independent research like I wanted to.

My motivation for going to graduate school was to gain an encyclopedic understanding of computer architecture and all its adjacent fields.
Unlike the common conception of graduate school as a place where you become an ultra-specialized researcher who knows little outside their speciality, the environment at Berkeley is quite different.
Our lab is a place where, through building real systems, you inevitably end up learning about every part of the stack.
It is this ability to constantly build things from scratch without any preconceived objectives (i.e. publish a paper) that grants you encyclopedic knowledge.

#heading([Applying to Graduate School], depth: 2, numbering: none)

When I sat down to write my application, my high-level interest was sitting at the edge of analog and digital circuits in the context of building large digital SoCs.
I decided to write my statement of purpose (SoP) in an unorthodox way.
I planned to propose a concrete line of research based on my interests in my SoP, with the idea that a professor would really appreciate it if I knew exactly what I wanted to build.
Specifically, since I was interested in asynchronous circuits and timing closure at the time, I proposed to investigate some problems in the design methodology, physical design, automated timing analysis, and circuit design aspects of globally-asynchronous, locally-synchronous (GALS)

Of course, this backfired and instead turned off PIs who thought that this was my only specific interest, and if they weren't working on a similar idea, that I would not be interested.
Even still, I was lucky enough to have several offers from PIs in areas outside GALS implementation techniques.

// starting with analog circuits and INC prelim
#heading([The First Two Years], depth: 2, numbering: none)

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
#heading([Learning More Things], depth: 2, numbering: none)

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
#heading([Simulation is King], depth: 2, numbering: none)

When I reflected on the random things I did in the past, one thing became clear: all computer architecture work relies on _a few fundamental tools_.
They include, a language for modeling or implementation of hardware, representative workloads that the hardware is designed to execute efficiently, and a simulation framework to estimate performance (and other VLSI metrics) of the hardware you are designing.

Of these, the place where I could make an impact, as a single student, was _simulation methodology_.
In particular, the workhorse of the hardware design loop is _RTL simulation_ and it is frequently the bottleneck when it comes to iterating on a design.
If we can improve the throughput and latency of RTL simulation, while preserving its fidelity, it would be a boon for hardware designers.

#heading([Sampled Simulation], depth: 2, numbering: none)
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
#heading([Writing Style], depth: 2, numbering: none)

Finally, this thesis is written in a style inspired by two other theses.
I took direction from #link("https://www2.eecs.berkeley.edu/Pubs/TechRpts/2023/EECS-2023-275.html")[Dan Fritchman's thesis], which was written in a way that an early stage graduate student could grasp and extend.
I also appreciate #link("https://www2.eecs.berkeley.edu/Pubs/TechRpts/2023/EECS-2023-56.pdf")[Ryan Kaveh's] advice to write my thesis as if it were a tutorial to understand the history and theory of the specific line of work I explored.

#align(right)[
_Vighnesh Iyer_
]
