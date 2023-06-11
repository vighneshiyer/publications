# FP for HW (eDSLs for HW Design and Verification)

## Bora's Notes

- [x] Intro: 'past few decades' - be more precise
- [x] "regular program in the host language" -> "that represents a flow graph"
- [x] "turns that representation into output" -> "emits the output code"
- [x] "language's type system, set of libraries" -> "rich set of libraries"
- [x] Use sans serif font on the figure of simcommand thread scheduling
- [x] JVM -> Java Virtual Machine
- [x] "See the example in Figure 2" -> "See an example"
- [x] describe figure 2 in more detail - beyond the caption
- [x] "cycle skipping", "thread order" - add hyphens
- [x] "parametric fuzzing, figure 6" - describe in detail
- [x] "lets you describe" -> "lets one describe"
- [x] Add NSF Chipyard + DARPA RTML to acks

## Reviewer Comments

### Reviewer A

#### Paper summary

Three new Scala EDSLs are presented, for different aspects of hardware development.

#### Comments for authors

I think this audience will not be surprised that Scala EDSLs can support the domains sketched in this paper, but it's good to read about some of the design details, and workshop attendees may be interested in adopting these languages.

### Reviewer B

#### Paper summary

The abstract describes an eDSL to assist hardware debugging with functionalities including testbench description, stimulus generation, and control flow compilation.

#### Comments for authors

The abstract describes a useful tool for hardware debugging. A small demo may make the talk fun and engaging.

### Reviewer C

#### Paper summary

This paper reports on three different Scala-embedded DSLs that are not Scala (and not even really HDLs at all). The eDSLs are:

1. One for writing testbenches in an imperative style that work as coroutines inside of the simulator instead of OS/JVM threads, as in most testbench frameworks.
2. One for expressing random test input generators that are parameterized on the source of randomness.
3. An imperative-style eDSL for generating FSMs.

#### Comments for authors

There are some interesting ideas in here that are clearly in scope for a workshop that is focused on both language design and hardware implementation. I think the main risk with this talk is that it is really three ideas in one, which means that there may not be enough time/space to give each of the ideas the level of treatment they deserve. There is one cross-cutting notion encoded in the paper, which is essentially that "eDSLs are useful, and not just for the core hardware description itself, as in Chisel." However, I think this message may be pretty uncontroversial among the PLARCH audience; embedded DSLs have revealed their utility many times in many scenarios.

To address the three ideas separately:

1. I found the simulation-thread DSL perhaps the most exciting because it seems to address a serious "self-inflicted wound" in many testing/simulation frameworks: the testbench runs in a separate thread (or threads) from the simulation, and synchronization between the two is extremely costly. It seems like the idea here is to essentially express your testbench as a coroutine and then invoke that as part of the simulation process, without any actual OS/JVM inter-thread synchronization. I think this discussion could be expanded to be as clear as possible about where the performance benefit comes from: exactly what is being eliminated (just synchronization?) and how (by including the same computation that would otherwise have been done separately into the same thread as the core RTL simulation?).
2. The test-generation proposal seems to hinge on parameterizing test generators on their source of randomness. It's not clear, however, if there are other benefits beyond just this parameterization. For this specific idea, I'm not sure you need an eDSL---you could also write the generator in a "normal" way in the host language and just pass in an object that represents the RNG. It also reminds me of many QuickCheck-descended property-based testers, such as Hypothesis for Python, that already try to carefully control the randomness source during either generation or test-case reduction as a way to explore the space of possible test inputs.
3. The embedded DSL for FSM generation is interesting; it is indeed the case that the logic for many FSMs would be better expressed as an imperative program than as RTL-style assignments. I can very much see this being integrated productively as a library in Chisel or other embedded HDLs.

### Reviewer D

#### Comments for authors

Paper advocates for leveraging embedded DSLs in aspects of hardware design and verification beyond HDLs. The authors present case studies using eDSLs to write APIs for RTL test-benches, test stimulus generation, and control-flow to FSM compilation. The work is pertinent to future hardware design. I felt the abstract could have done a better job at attributing the observed benefits in each case study fundamentally to the features of embedded DSLs. I would be great to highlight this sentiment in a final talk.

#### Reviewer E

#### Paper summary

The paper presents embedded e-DSLs for use in verification - specifically SimCommand and chisel-recipes.

#### Comments for authors

Does SimCommand address anything else besides a more efficient fork-join? Is there any connection between SimCommand and chisel-recipes besides being two embedded DSLs for hardware design? Not sure how to read Figure 4 for this.

## What I Should Fix / Clarify

- Fix all of Bora's suggestions
- The reviewer comments were really good - I think they understood the paper and also understood that this audience is already receptive to the ideas therein and it isn't worth preaching to the choir without a clear message.
    - In the talk, focus more on the value of embedded DSLs over other HDL implementation approaches (custom compiler, AST transforms, freestanding DSLs)
    - Make it clear that these are 3 eDSLs that aren't directly tied to each other, other than all being useful for hardware design and verification. The only tie-together is that they are all eDSLs in the same host language as the HDL and that makes re-use of data structures / functions easier + unifies the code base and build system. This would be harder with other HDL implementation approaches and in many cases would entail building a new general-purpose language from scratch (which is usually a bad idea).
- Also make the case for Scala as a good host language for eDSLs - powerful macro system for rewriting and source instrumentation, implicits (context functions), good IDE support and tooling, strong and advanced type system w/ GADT support, familiar syntax
- Make the case that the parametric stimgen API need not be implemented in a functional manner as the reviewer notes - but the API becomes more ergonomic to work with as a Random monad provides a clean interface for staging randomness and can be also used for stimulus embedding in a cleanly separated manner (interpreter from description)
    - Mention that a hybrid API is often useful - Gen-style generators for top-level generation, declarative generators / constraints for hard and small CSPs
    - Mention that our interpreter can also mark bytes with how they are used (this would be tougher without the right primitives and without a core Random datatype)
    - Also, our interpreter will eventually handle both declarative and imperative generators with parametric bytestreams
