# Nextgen HDL (Mixed-Abstraction HDLs and Other Aspects of HDL Design)

## Reviewer Comments

### Reviewer A

#### Paper summary

An argument for thinking about HDL innovation at a variety of abstraction levels, with a story for integrating designs/simulations across levels

#### Comments for authors

The paper identifies a valuable problem area and sketches a few directions within it. The payoff of language changes (from subsections of Section 3) makes sense, though it seems that those aspects fall at different levels of expected conceptual research contributions to address them.

Some code examples, following the authors' latest favorite ideas, might help make this concrete for our audience.

### Reviewer B

#### Paper summary

This is an "essay"-style position paper that poses a set of challenges in the design of HDLs and tools that use them. A main topic is mixing different HDLs that work at different levels of abstraction, and implementing simulations that embrace that heterogeneity.

#### Comments for authors

While it's a disparate list of many different topics in HDL design and implementation, I am excited about this paper because it makes so many good points that I have not seen crystallized elsewhere. The arguments are at their strongest when they are covering the problems of integrating heterogeneous HDLs; there is clearly a need (all of a sudden) for interoperation between design languages at many different levels of abstraction, and the community has clearly not found the key to smoothly integrating them, especially during simulation. I am especially emphatic about the need to provide simulation and verification tools that do not embrace "Verilog simulation as truth"; it is a wonderful vision to have many different simulators interacting directly, instead of relying on all of them to use Verilog as a least-common-denominator target. This topic seems like a great focus for discussion at the workshop.

Things are little more diffuse in Section 3, which is about HDL design more broadly (not about heterogeneous integration specifically). Still, the paper poses good questions that don't have clear answers. For example, I'm personally partial to the question, "how would we design a synthesis tool from scratch, without the need to 'infer' high-level semantics from flat Verilog code?" That is, what would synthesis look like if it were unshackled from the need to support behavioral specifications in the Verilog mode? There is no obvious answer, but it's a question worth asking---and not one that I've seen put quite so clearly before.

So despite the somewhat scattershot notion of these points, I'm interested to see what kinds of discussions these questions can get going at the workshop.

### Reviewer C

#### Paper summary

The abstract argues the composition of hardware descriptions from multiple abstraction levels and discusses several design questions related to such an approach.

#### Comments for authors

The talk will benefit the computer architecture audience if it can provide sufficient background information on different hardware abstraction levels. Even though I am not fully convinced of the practicality of having one DSL embedding multiple abstractions, I would appreciate a comprehensive synthesis of knowledge about the pros and cons of different hardware abstractions.

### Reviewer D

#### Comments for authors

Submission examines the future of HDL design and implementation. Authors argue for: HDLs that target IRs with a formally defined semantics that can be composed together with other IRs; mixed abstraction HDLs and corresponding mixed abstraction simulation. The also discuss the need for identifying how/what hardware primitives should be modeled in an HDL (e.g., SRAMs, modules). In general, I felt the abstract asked interesting questions regarding the future of HDL design and implementation. However, I wish there and been some more details outlining how these questions will be addressed, i.e., a more clear research plan. Would be great to include these in a final talk.

### Reviewer E

#### Paper summary

The paper discusses the issues related to having mixed-abstraction HDLs.

#### Comments for authors

The discussion focuses on design and possibly synthesis through correct-by-construction lowering, and also simulation by treating simulation as an abstraction level. Are there any considerations related to formal verification?

## Things to Fix / Include in Talk

- In the talk, start with a description of the different abstraction levels and where each one is used and the strengths and weaknesses of each one
    - Consider simulation throughput, verification ease, QoR of final product, tunability / optimizability
- A clear research plan wasn't presented - I know this is an issue, so I have to make some concrete API proposals in the talk (especially wrt how HLS-style blocks could be interfaced with in RTL (e.g. via decoupled interfaces) and how event driven blocks would interface with RTL (e.g. via sensitivity specifications))
