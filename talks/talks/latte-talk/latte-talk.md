# Latte Chipyard/FireSim vision talk
#Research/notes/HW-IR

# Title : PL for HW, a Simulator centric Approach.

---

# Talks [p1]
- [x] Prepare for latte talk
    - [x] Send Rachit abstract, title and bio of all the presenters
- [x] Prior work
    - [x] PyHDL
    - [x] Dahlia
- [ ] API sketch
    - [x] systemc docs
    - [x] calyx motivation
    - [x] catapault design methodology
    - [ ] Calyx & frontend tutorial
    - [ ] Talk to sophia and amelia about HLS & circt
- [ ] Slides

---

## Talk Outline Sketch

This talk should be about introducing the real world problems that HW designers face, and how we think PL techniques can be applied to solve these goals.
Even for the API design, I shouldn't focus too much on the engineering aspect. I should just suggest a rough sketch of what we (as HW designers) want so that the PL people can concretize it.

- Focus on the 'next paradigm shift' - this should be the topic of our talk
    - "The Next Paradigm Shift of Hardware and SoC Design Methodology"
    - At a high level, we need to make it clear that this is the *hardware designer* perspective (NOT the PL person perspective)
    - We should claim right away that we aren't PL people, so we are just proposing ideas from our side

- What is the current paradigm?
    - In terms of ergonomics, performance, agility, **beauty**, correctness
    - What can we do in the current paradigm? What are the limitations?

- old paradigm
    - wrt people, language, organization
    - people: highly specialized, don't interact much, lots of people needed
    - organization: teams are separated by function rather than design block
    - language: json on top of macros on top of macros on top of rtl, single abstraction at a time, messy and ugly interop, custom hacks for silicon flow vs FPGA flow vs emulator flow
    - tools: long iteration times, ugly APIs, build scripts on top of build scripts, everything is custom per company for no obvious reason (just historical in nature)
    - flow: hand written cobweb of integrations, boundary bugs are common
- new paradigm
    - single person can tackle end-to-end development of a block

- what do PL people want from the tools they build?
- what do HW people want wrt new PL innovations?

- What could be possible if we had magical tools?
    - What is the new paradigm?
    - What could the new paradigm enable that is hard or impossible now?

- How have we tried to move towards that paradigm in the past?
    - Here is where we discuss Chisel, FIRRTL, Firesim, Chipyard
    - We can go deep into Chipyard/Chisel for a small example of SoC design.
    - Then work from other groups (Calyx, Filament, SpinalHDL, HeteroCL, PyMTL)
    - Why haven't these moved us into the new paradigm yet? What is still difficult? What just isn't beautiful?

- What are the magical tools we would like to have?
    - Let this motivate the things we will discuss in the vision/proposal part of the talk
    - How do the magical tools allow us to move towards the new paradigm?

- Now comes the vision, we want to split it into a few sections
    - The frontend design language + the new design/verification/modeling methodology
        - Incremental-first
        - Mixed-abstraction for both design and modeling (consider that each hardware domain is suitable for a different abstraction. But, even within a hardware domain, there are specific )
        - Leveraging host-language type system for ...
    - The IR + the new simulation backends/synthesis backends that it enables to support the above methodology
        - Take inspiration from LNAST (graph native in-memory representation) + FIRRTL (in terms of passes and FireSim) + Circt dialects (the closest we have to mixed-abstraction today, but they don't support interaction semantics)
        - I think we need to think carefully about why existing IRs are not sufficient. We should come up with some points by talking to those who use Circt (Amelia / Kevin).
        - Also needs to support the same features as the frontend (incremental pass application, aggressive caching, mixed abstractions + semantics for their interaction, encoding of host language types to some degree for semantics preservation)
    - The SoC generator framework that can be built on top of these
    - The other tools that can be built (early fast PPA iteration, synthesis)

- PL people are good at defining semantics and making them clear
- HW arch people are good at knowing what matters and would help us
- Consider how to describe nested multi abstraction circuits
  - Consider the impact of an HLS top vs an RTL top and nested tops

- Jerry's advice:
  - What matters: iteration time + **number of iterations** - both of them matter
  - Making the developer more clever is more impactful than improving the iteration time itself

---

## Frontend language

### Incremental compilation and cacheing.
- One huge benefit of EDSLs : you can just use the package manager for the host language.

### Multiple abstractions.
#### What are the existing abstractions out there?
- Gate level : Lets not deal with this right now...
- RTL : Explicitly defining registers and wires (e.g., Verilog, S-Verilog, Chisel). 
- Calyx : The data flow is defined explicitly in terms of registers and wires, while the control flow is defined in a imperative manner. During compile time, the control flow is unrolled into an FSM. Rachit presents Calyx as a IR, but I feel like it is closer to a frontend.
- HLS : The functionality of the circuit is defined in an imperative language, and the hardware is generated by a compiler (System-C). When writing code, the hardware structures are abstracted away from the designer. It is the compilers job to generate high quality hardware.
- Domain specific HW DSL : Stellar

#### Simulation perspective : Even mixing the above three abstractions seems difficult as the most efficient simulation approach is different from each other.
- For RTL, the simulation is performed by performing cycle-by-cycle updates of the state.
- For Calyx, simulation can be done by "executing" the control flow and updating the states within the control flow scope.
- For HLS, the simulation is done in a transaction based manner. 
- As we can see, as we go up the abstraction level, the simulation update rules become more sparse and allows us to skip more parts of the design per simulation step. Hence, it wouldn't be a good idea to blindly lower everything into RTL level and simulate the entire thing. Assuming that the abstractions are mixed in a coarse grained manner, we would want to simulate each abstraction separately. Or, perhaps, would it still be beneficial to perform cross-module optimizations even if we have to lower parts of the design written in a higher level abstraction? And once we want to run this on some FPGA or emulator, how are we going to map this onto these platforms?
- Example where this would be useful : GPU has a lot of FP units which can slow down simulation speed significantly. We can swap out the FP units with a C model.

#### But again, what is the motivation of doing this? In what practical scenarios would this be useful?
- What about building accelerators?
    - I would have functional models.
    - Try to insert pragmas in the right places to get HLS working.
    - See if the resource consumption of the generated HW makes sense?
    - If I see any places where I think the resource consumption is bloated, I will try using a lower level abstraction like Calyx for example.
    - Would need to repeat the above steps until we meet the PPA goals.
    - But is mixed abstraction support in the "frontend language" required for this? Why can't all this complexity be shifted and automated by the compiler?
- Why can't we write cores with this approach?
    - There are just way to many floating parts in a core. It is easier to make every interface latency insensitive as it reduces the scope that the compiler has to reason about. However, once you remove that constraint, I think the complexity of the compiler will explode. Almost a intrinsic issue.
    - We need to understand why the HLS compiler generated RTL is suboptimal and improve upon that (how close is the generated RTL's quality with a hand-tuned version?)
        - What types of hints can the frontend language pass on to the compiler so that it generates RTL with a better PPA?
        - We would need a highly hand-tuned design of come RTL piece and compare it with the HLS generated version.
<!-- - Apart from incremental design, are there other places where having mixed abstractions would be helpful? -->
- Need to think of a concrete example and try to come up with APIs -> Start with L2 cache for example.
    - [x] Look at heterocl, see how their API looks like and think about the limitations (especially in terms of ergonomics)
    - [x] Look into other open source HLS frameworks
        - Calyx, XLS, Spatial, Dahlia, Vivado HLS [FPGA HLS Today: Successes, Challenges, and Opportunities](https://dl.acm.org/doi/full/10.1145/3530775), Catapult
- At the end of the day, we are making claims about ergonomics & beauty of the code because this is a programming language. Need to be brave and confident about making these claims. It isn't like Chisel added new features to verilog. However, I already experienced the power of meta-programming and it may be difficult to explain how much mental energy is saved by this in words.

<!-- - Lets say you want to build a core (I'm using a core as an example because all these HLS-ish languages in academia only focuses on accelerators but that's boring). -->
<!-- - So with just RTL, it is very difficult to perform incremental implementation. -->
<!-- - Idealy, we always need to start from a functional model (to me, this is the most compelling case there having a ergonomic DPI call is useful). -->
<!-- - We already have `SpikeAsATile`. How would I write a core by starting off of this? -->
<!-- - Okay, the first thing I would build is the frontend. I would need to replace the instruction fetch logic in spike's `processor_t` with RTL. -->
<!-- - Then I would try to build the backend by ripping out the `processor_t` entirely and replacing that with RTL. -->
<!-- - I would need to do a real evaluation on this by integrating RISC-V mini by using this approach. Even though it might take longer than just writing RTL, I think I'll have better ideas of how this API should look like (hopefully). -->
<!-- - In summary, I think having multi-abstractions is valuable when we can perform this type of incremental implementation to tackle the high NRE cost. However, the interfaces between these abstractions as well as simulation methods must be thought carefully. -->

#### API perspective
- When we mix abstractions, things can become weird. I guess the below is a highly contrived example showing a case where a `if` statement means different things in Calyx and Chisel. However, assuming that we have coarse-grained mix of abstractions, we can come up with a clean API for this as long as the interface between the abstractions are clearly defined (e.g., `Module` vs `CalyxModule` that both defined explicit IO ports).
- For HLS, we need a way of specifying the input and output ports of the design and force the compiler to generate the corresponding interface. Also, the HLS compiler expects C++. Personally, I don't want parts of the codebase to be C++ and other parts to be in Scala. I think adding a bunch of languages in the frontend will inevitably lead to a messy build system.
```scala
// Chisel
class StupidExample(add: Boolean) extend Module {
  val io = IO(new Bundle {
    val x = Input(UInt(32.W))
    val y = Input(UInt(32.W))
    val z = Output(UInt(32.W))
  })
  if (add) { // This if means : generate different circuits during compile time
    io.z := io.x + io.y
  } else {
    io.z := io.x - io.y
  }
}

// Calyx
class FakeCalyxSyntax extends Module {
  val io = IO(new Bundle {
    val x = Input(UInt(32.W))
    val y = Input(UInt(32.W))
    val z = Output(UInt(32.W))
    val add = Input(Bool())
  })
  if (io.add) { // This if is essentially a mux.
    io.z := io.x + io.y
  } else {
    io.z := io.x - io.y
  }
}
```
- What should the interface between these abstractions be? How fine-grained do we want the abstractions to be interleaved in? Are there any value in having a super-fine grained abstraction interleaving, or would it be good enough to interleave different abstractions in the module level?
- I think at this point, it is clear that we can't apply this methodology to parts of the SoC that must meet a strict PPA constraint like a core. For accelerators or periphery devices, I think coarse grained interleaving is good enough.
- Assuming a coarse-grained interleaving of abstractions, we can assume that different abstractions don't share state and they interface with each other on the I/O boundary.
- **Questions that has to be answered**
    - What is the interleaving granularity of the abstractions? Line by line vs module level?
        - We probably want fine-grained interleaving between these abstractions.
        - If we were to only support module level interleaving, we might end up creating needless submodules which will make the code dirty.
    - How would the code for each abstraction look like?
        - HLS
            - We want it to resemble the native host language code as much as possible so that it is easy to port software code as HLS code.
            - What is the correct way of providing compiler hints? Pragmas? Annotations? No hints?
            - I think Dahlia's approach of encoding timing/memory port conflict information as types is pretty neat (neat as in the code looks clean). However, naively using their work isn't desired as we want to target multiple backend tools, not just vivado.
        - Calyx
        - RTL
            - Is Chisel-style metaprogramming layer is sufficient? I think to a certain degree it is. However, I think we need to define new arithmetic data types in scala that are hardware friendly. For instance, we would need a `BinaryTree` primitive as this structure appears frequently in hardware.
    - How would the glue-code between abstractions look like?
        - This seems tricky. Assuming that we want fine-grained (line-by-line) interleaving of the abstractions, what if different abstractions want to share a hardware structure? Would there be cases where this would ever happen?
    - How should the testbench API look like?
    - Overall compilation process?

#### API design attempt 1
- Just look at SystemC's FIFO implementation and come up with a API that does similar things, except much cleaner.
- Limitations of SystemC
    - Have to wrap verilog in a SystemC wrapper or lower SystemC into verilog to simulate both things at the same time.
    - Syntax is ugly in general
    - The way it encodes the timing (`wait(N, SC_SEC)`) is too convoluted. Why can't is use something simple like a `tick`?
    - Should not need to put a `while(true)` whenever you are expressing simulation semantics
    - Synthesizeable statements vs non-synthesizeable statements are not separated clearly. There should be separate constructs for each of these statements, and the type-system should be able to validate whether the composition of these statements are valid or not.
- Vivado HLS
    - However, even for such a simple circuit like the FIR filter, there are many "code restructuring" that has to be done for the backend tools to generate efficient HW.
        - Code Hoisting : Changing the code structure to remove `if-else` statements. These statements will generate extra control logic.
        - Loop Fission : When a for loop performs multiple operations (lets say computing the sum & shifting the values in a shift register array), writing separate for loops can potentially improve performance as the compiler can perform optimizations separately. Conversely, there may be cases when merging loops together improves the generated HW quality.
        - Loop Unrolling : Classic compiler optimizations. Helps the compiler to extract out more parallelism. Can be achieved by adding pragmas.
        - Loop Pipelining : Pipeline data between loop iterations for higher throughput. Can also be achieved by adding pragmas.
        - Bitwidth Opt : Depending on the datatype that you use (`int`, `unsigned`, `float`, `double`, `char`, ...), the generated HW can differ.
    - Other optimizations
        - Matmul : You can bank the memory elements by allocating separate BRAMS.
        - Huffman : I don't think this chapter introduces new HLS optimization black magic. However, the reduction in the implementation complexity is quiet impressive. Both my Chisel huffman compressor and their example implements the same algorithm (canonical huffman compression where the compressor simply tell the decompressor builds the encoding table based on a standardized canonical format). Their implementation is around 200 lines of Vivado HLS. My implementation is around 1500 lines of Chisel.
    - Among the above optimizations, apart from "bitwidth opt", the rest of the optimizations seems like a limitation/requirement of the backend compiler.
    - The bitwidth optimization can be dealt with by having width inference during elaboration time.
    - One caveat of Vivado HLS is that it requires someone that is highly experienced in HLS to insert in the close to optimal pragmas. The parameters of each pragmas (e.g., pipeline stages, array counts, loop unrolling amount etc) is emperical and ad-hoc in nature. Would there be a way of the compiler providing very quick hints to the designer so that they can tune these parameters with more ease? Also, I think these parameters knobs should be propagated from the top level module instead of each individual macros defining the values in an ad-hoc fashion.
- Centrifuge
    - Add HLS flows into CY/FSIM for accelerator design.
    - Built RTL translation layer that interfaces with the good old RoCC interface, and exposes simpler interface to the HLS side. This interface is fixed. So to run FireSim simulations, it has to lower the HLS into verilog and blackbox it into the CY/FSIM flow.
        - Interface is inflexible because there is no way of passing down parameters about the interface from the CY/FSIM side (the SoC generator framework) to these HLS tools. By having a frontend language that can incorporate several flows, we can (hopefully) streamline this process.
        - Complicates the build flow.
    - HLS side uses Vivado HLS to generate RTL.
    - Can test accelerator functionality in isolation. Once that is done, can generate RTL to perform integration tests.
- APIs for SystemC like transaction level language
    - Need to categorize the interactions that occur during simulation.
        - `peek`, `poke`, `tick`
        - Need a clean way of abstracting away the `thread` primitive in SystemC. In my understanding, adding new SystemC threads doesn't add more simulation threads. Rather, it is emulating concurrency on a single thread and used to indicate that operations can be done in parallel within the generated HW.
        - I have a feeling that the `event` and `wait` APIs can easily make the code messy and confusing. Maybe we want a golang style `channel` like abstraction for this.
- APIs for Vivado HLS like imperative style language.
    - Width inference to alleviate the users from having to perform bitwidth opt
    - Need a way of systematically setting the compiler hints so that they aren't scattered through the codebase (basically, we need a better way of implementing pragmas).
    - Want very fast compiler feedback (almost like a HLS lsp) so that designers can reason about the generated HW structure and the parameters.
- Various abstractions, seamless interoperability
    - Different compilers deal with different abstractions within the design.
    - For instance, you may want to build your memloaders & memwriters in RTL but, the dictionary logic of the compressor in HLS
    - Need module level boundaries
    - Embedding lower level abstractions in a higher level abstraction isn't really practical.
    - Embedding higher level abstractions in lower level requires a concrete interface -> IO ports

### Using type-systems
- Yes, we all know that statically typed languages are nice to work with. But we should think of what we would want to encode as types and what we would not want.
- Types that I think chisel is missing : More HW primitive types such as boolean, one hot encoding, decoupled interfaces, clock and reset. What is the purpose of these types? To make sure that there are no erroneous hardware connections and to pass down these types to the IR.
- Value of encoding the latency of each module like Filament???
    - Don't want to verify the functionality during compile time anyways.
    - The types of bugs and their causes are way to diverse so we need to perform runtime dv even though we can completely rule out one type of bug. So it isn't solving any productivity issue.
    - Even if we use the latency to synthesize assertions for each hardware instance, I think these assertions can only encode trivial relationships, forcing the designer to write complicated assertions by hand anyways.
    - Well, we could use this information during compile time to come up with better static schedules for simulation (although the gains will be marginal), or even use this as hints to generate higher performance RTL for HLS.
- I think we need to clearly separate the errors that we want to check during compile time vs runtime.
    - Static compile time : Bitwidth (overflow), checking for backpressure leakage, parameter validity, comb loops. These traits aren't specific to a certain hardware design, but rather generic properties that have to hold if it is a digital circuit. Also, some of these shouldn't even be checked by the host language compiler. Like the backpressure bug & the comb loop detection should be checked by the DSL's compiler.
    - Runtime : Specific functionalities of the circuit should be strictly checked during runtime. You may want to add properties that should be satisfied during runtime and generate assertions during compile time, but this need not be in the form of types anyways.
- Other types that we may not be thinking about and why it would be useful
    - Would it be possible if we encode the clock and power domain as types? Can the compiler automatically generate monitoring units (or the power token exchange circuitry) as HW during compile time? But for power, how would we specify the power envelope, technology, and frequency such that it can generate the correct collateral? Would it simply be passed to the compiler as flags?

### Miscellaneous
- OOP: We discussed this briefly, but we are able to add additional HW logic by inheriting the parent class. However, I'm not sure if this is a good idea or not. Lets say that you have a `Queue` and want to make it into a `FlowQueue`. I feel like passing arguements (`Queue(flow=true)`) and having an `if` statement to generate additional RTL is cleaner than having a separate class `FlowQueue`.
- One nit thing I don't like about Chisel is the implicit clock thing. I think this makes the clock domains very opaque and sort of constrains how the top level module has to be written (basically it has to be a RawModule associated with a LazyRawModule containing a diplomatic clock node -> don't worry about the words in this sentence.).
- Width trunc/inference? Should wire widths be infered during compile time or explicitly stated by the designer? In my experience, I had cases where the infered wire width caused bugs. However, this can make the code overly verbose.
```scala
val a = Reg(UInt(32.W))
val b = Reg(UInt(32.W))
val c = a + b  // c is 32 bits wide
val d = a +& b // c is 33 bits wide
```
- Would it make sense to allow operation overloading in a HDL? I think this isn't really necessary as users can defined functions for commonly used hardware patterns (after all, operator overloading is just function definitions).
- When embedding new languages on top of this language (Stellar for example) what

### API design attempt 2
- Lets simplify the problem for now. That is, lets just think about HLS (C++) and RTL. Also, lets just consider integrating these abstractions in the RTL simulation level.
- What is the current way of integrating these two abstractions in Chisel? : DPI + blackboxing
- What are the problems of the above approach?
    - It becomes manual and tedious.

---

## FIRRTL (IR)

### Pitfalls
- In-memory representation of FIRRTL (SSA) isn't efficient.
    - One example where having a AST style in-memory representation is inefficient is the combinational loop detection pass. To detect combinational loops, we have to first traverse the entire AST to construct a connectivity graph, and traverse the graph again to find strongly connected components. However, if the native in-memory representation is graph based, we would only have to traverse the IR once.

- No incremental compilation support (although we can blame the language frontend & the rtl generation framework for this)
    - Diplomacy is a serious brain damage when you want to perform incremental compilation

- As FIRRTL doesn't target a specific backend, it blasts away all the semantics, resulting in poor ASIC QoR results while making the pass writing easier. However, as mentioned above, this results in suboptimal HW resource usage. In case of FPGAs for example, you would want to minimize the multi-ported register file usage as it doesn't map nicely to LUTs. In case of ASICs, you would want to preserve higher level semantics such as one-hot encoding, priority mux etc so that the synthesis tool can infer these structures.
    - It would be even better if we have a full vertically integrated stack where the synthesis tool doesn't have to reconstruct these higher level semantics at all. One question to ask here is : how much time does the synthesis tool spend performing semantic reconstruction vs actual mapping of the RTL to the netlist.

- The issues with CIRCT : **TODO**

### Vision : RTL simulation throughput is king. Also need a way of performing early PPA estimation

#### Fast simulation compilation vs simulation throughput
- Recently there has been a lot of work on improving RTL simulation throughput (Repcut, ESSENT, Archilator, Parendi, Khronos, ASH, FireSim). All of these simulators suffer from high compile times except archilator. A highly productive design environment will need to have very short turnaround times from RTL writing to compilation to simulation. For instance, even though Repcut provides users with signficant RTL simulation speedup, it is unreasonable to use it if the compile time takes hours as it becomes on par with FireSim bitstream builds.
    - The performance of graph traversals are crucial ([The Hunt for the Missing Data Type](https://www.hillelwayne.com/post/graph-types/)). This can be enabled by having a efficient in-memory represenation of the circuit. The above article explains that the graph representation and traversal algorithm can affect the graph processing time significantly.
    - Also, we need to utilize both cacheing and incremental compilation. ([LiveSim](https://ieeexplore.ieee.org/document/9238634)). Although, LiveSim's approach of having separate C++ files for each module and linking them during compile time enables fast incremental compilation of the simulation binary, it loses the opportunity to perform cross-module optimizations. We would need to investigate how much simulation performance is getting compromised by this approach.
    - Furthermore, we also need to think of how we can encode the microarchitectural semantics in the frontend language so that the  compiler can generate higher performance simulations. For instance, NoC router node boundaries are latency insensitive (credit based flow control). How do we use this uarch semantic to better partition the simulator into multiple cores or reduce inter-thread synchronization overhead? Similarily, for points in the design that require fixed point iteration (... when would we want this again though..?) can we encode this information in the language so that the compiler can do something smart (I'm spit-balling here)?
    - Use SIMT to multithread duplicate modules.
    - One more detail to consider is : do we want to support 4 state simulation or just 2 state simulation?

#### Better QoR vs ease of pass-writing
- As mentioned above, FIRRTL blasts away all the circuit semantics during lowering which leads to suboptimal QoR. Even the decoupled interfaces supported by Chisel are an example of where semantics are erased during compile time. On the other hand, if we were to preserve all of the circuit semantics, the number of IR primitives will blow up, making pass writing a nightmare. It seems like there is a fundamental tradeoff between these two axeses.
- So the question becomes, how can we get help from the host language to make pass writing easy while also having a rich set of IR primitives? What are the optimal set of circuit primitives that we want to introduce?
- Or actually, during the initial design phase (running simulation to get funct right), does having an ASIC optimal circuit represenation even matter? In this case it seems better if we can aggressively remove the semantics (as long as we aren't using them for simulation optimizations) and make the compilation speed faster. It is only when we want to place the RTL onto some physical platform when QoR matters. In these scenarios, we would probably just want to pass the high level IR represenation directly to the backend tools and trust them to do the job for us (the tools will perform optimizations such as DCE and CP anyways).
- Some other utility features that we would like
    - Writing passes on a flattened netlist, but the changes are made to the hierarchical module structure.
    - Parallelizing the passes. Should the pass-writer be writing parallel code? This would be way to painful. The description of the passes (what the passes should be doing) vs how the passes are applied to the circuit should be separated.
<!-- - I should probably spend some more time reading the monadic composition part of FP in scala. Might be relevant to this...??? -->

#### Early PPA estimation via incremental refinement
- Current power models use RTL traces to train a model for a particular design point. Mixed traditional/ML models to deal with parameter changes.
- Still bottlenecked by RTL simulation throughput to get traces, when we don't even care about simulation power in the cycle level granularity.
- The main bottleneck of performing early power estimation is the synthesis step that maps your RTL into gates. Hence, to perform fast power estimation, what we really want is a very quick synthesis tool. This can be achieved by performing incremental synthesis on your design. So the overall steps will look like this.
    1. Run synthesis to obtain the netlist of your initial design.
    2. Make changes to your RTL.
    3. Use incremental synthesis to update your netlist. Normally, updating your RTL will affect the nearby gates as well, but this isn’t a big issue here. As we mentioned above, we only care about the big trends when performing runtime power estimation and supposedly, these small patches to your RTL won’t affect this big trend anyways (i.e., it is okay to have some error). This step can be achieved by something similar to LiveSim. You can add patches during link time by compiling your new design as a shared library.

 - So the initial steps of this process would be to obtain a gate level netlist using ABC which is a open-source synthesis tool, and applying the technology specific power-draw information of each gate to obtain a power draw estimation.
   - [ABC: A System for Sequential Synthesis and Verification](https://people.eecs.berkeley.edu/~alanmi/abc/) 
   - [berkeley-abc/abc: ABC: System for Sequential Logic Synthesis and Formal Verification](https://github.com/berkeley-abc/abc)
   - The above applies for area estimation as well

#### Miscellaneous things to consider
- Do we want random initialization of the signals or deterministic initialization?
- How do we treat reset, and clock signals? These are different from other signals in that they have high fan-out unlike most other signals. This results in a high skew in the circuit graph. Is is possible to utilize these skews to perform graph traversals more efficiently? Need to perform more in-depth analysis of the graph characteristic to come up with a efficient in-memory datastructure.
- Debuggability of the IR and passes when using SSA vs graph representation is something that we haven't been considering. To be honest, debugging FIRRTL passes (and I imagine the design of the IR itself) is easier than a graph based representation as humans can "read" the generated IR. However, if we have a graph based IR, we need a systematic way of checking for equality of the IR with the original design. Also we need a nice way of diffing and visualizing the previous graph with the new graph.

---

## SoC Generator Framework **TODO**
- Need to be easy to configure : cache coherent vs non-coherent systems, NoC vs Xbar ...
- Top level configuration file instead of having "configuration fragments" that generate RTL
    - The topology of the SoC should be generated programatically.
    - However, I do think that diplomacy has some nice features : it is easier to attach things to the bus and don't worry too much about setting the parameters. So we may want to explictly set connections where we want diplomatic connections. Or rather, should the framework be able to fire assertions when the configuration is wrong?
    ```python
    params = SINGLE_PARAMETER_OBJECT
    tile0 = generate_tile(params.tile_params)
    bus0  = generate_bus(params.bus_params)
    l2    = generate_l2(params.l2_params)

    bus0.attach_master(tile0)
    bus0.attach_slave(l2)
    ```
- Diplomacy good and bad
- A unified testharness for various target platforms : abstract out the host platform specific details so that things targetting different platforms can share the same interface.
    - One obvious use case of this would be to take checkpoints on FireSim and restore that checkpoint in software RTL simulation for higher debuggability. Applies for assertions and print messages as well. Currently these methods are implemented in an ad-hoc fashion according to the platform it will be running on.
    - Makes checkpointing and restore easy.
    - Streamlines the tapeout-brinup procedure.

---

## Fast and flexible RTL Simulation **TODO**
- How can we use RTL simulation like an arch-model?
    - How can we integrate C++ models into the simulation? We basically want the models and RTL to live together when running simulations. We can link the C++ models into the RTL by having some DPI interface. However, DPIs are ugly, prone to errors. Furthermore, once you have bit level information that you have to get right in the model, the complexity of the model quickly becomes as almost as high as writing RTL. How do we have a single view of what is going on in between the RTL and the model? Currently RTL generates waveforms while models generate print messages. This also enables us to introduce concepts that only applied to arch models such as `if-else` analysis. For simple things (e.g., infinite cache capacity) this can be done purely in the RTL level. For other things (oracle policy), we need the ability to seamlessly integrate models into RTL blocks.
    - Is there a way to use our SoC generation framework and turn that into something like RAMP gold where we have more modeling flexibility?
    - This is basically not a good idea.

- What would we learn if we can perform a in-depth profiling of verilator running on a HW platform. What would we be able to learn? Would it teach us anything about new HW augmentations for RTL simulation or do we already understand the characters of this workload very well (i.e., high I-cache pressure, high BP pressure, high CC traffic when scaling to multicore systems).
    - Using perf to profile verilator would be the first thing to do.

- We definitely want something that has both fast simulation perf as compilation perf. Something that is better than VCS/Verilator in both ways. Performance-wise I think having FireSim is still beneficical for long running workloads or system level analysis.

- LiveSim type simulation platform where we can checkpoint and restore state in the SoC.

- Why can't we build a fixed function accelerator for RTL simulation?
    - RTL simulation is essentially a graph traversal problem.
    - Edges represents wires, nodes represents combinational logic, registers or SRAMs.
    - On every cycle, we traverse the graph to update the nodes containing state.
    - Of coarse this would limit the simulated designs to be synchronous circuits, but that limitation also applies to recent fast RTL simulation techniques as well.
    - Is there anything that I'm missing here? Is there a reason on why people just build MIMD style emulation platforms instead of a grid of fixed function graph traversal/update units?
        - I guess if you can split the code into a lot of cores such that the instructions all fit in each core's I-cache then there won't be a huge difference compared to fixed function accelerators as the workload isn't really compute bound anyways.
        - It would be more memory latency bound, and having a good prefetcher would probably buy us more performance gains rather than adding fixed function execution units.
        - But there are a bunch of graph traversal accelerators out there. Where is the speedup coming from for those guys? What are they even comparing against?
            - [Graphicionado](https://ieeexplore.ieee.org/document/7783759)
            - They compare against 16 core xeons (32 threads) running a SOTA software graph processing framework.
            - Used C++ for evaluation of their accelerators, so need to take the results with a grain of salt.
            - Just by skimming this paper, it isn't really clear to me where the speedup is comming from. My guess is that small nit optimizations added up.

## What would be the graven proto-type that we would build? **TODO**
- I think building a emulation platform is a good one but we already faced some limitations.
    - The biggest limitation is that people aren't simply interested in this even though building the platform will require team effort.
    - We would need one or two RTL engineers that can write RTL for the platform.
    - One engineer who will pipeclean the FPGA side of things (the FPGA flow as well as the host interaction).
    - One or two compiler designers.
    - Still, I would say this ties in very well and brings in all the stuff from above into one single framework...
    - It also fills in the gap that FireSim is currently missing : build time. So having a simulation framework that can fill in the gap in between software RTL simulation and FireSim would be valuable.

- Another prototype that we can sell would be the agile development environment itself. Something like Chipyard and Firesim but simply much more usable due to all the improvements that we made.
    - However, we would need to perform a certain amount of application driven HW design and build new IP using the new framework as a demonstration. Of course the application has to be interesting and relevant now and in the future. Datacenter/mobile devices seems like a good target (as mentioned in the Parlab book).
    - ?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????



## Abstract : ** TODO **

- compilation speed
- simulation speed
- modeling flexibility

## Background
- Background on chisel/firrtl and how that lead to rocketchip
- Chipyard and FireSim intro

## Chisel (Frontend)

## Calyx Integration Challenges
- Example designs don't have ports. They just feed in data using magic memory. I had to come up with a new example where the module had explicit ports. But this isn't a true integration challenge if they had better examples in their repo.
- Debugging Calyx using the stepwise debugger thing was very confusing and difficult. Hard to see how time is advancing through this. Why can't we just have waveforms?
    - However, the waveforms weren't that much helpful either (although still better than the stepwise debugging thing) because the generated verilog was almost impossible to read.
    - In general, having a clean (and unified if possible) way of debugging stuff when integrating modules would be nice. That is, currently, these DSLs are debugged using custom interpretters, not waveforms (as looking at waveforms of generated RTL isn't a good strategy). However, you have to look at the waveforms during the integration process. So what ends up happening is, you look at waveforms for the inputs and outputs signals, go back to the stepwise debugger and try to recreate the inputs and outputs there. So you are essentially bouncing back and forth between two debuggers.
- Hard to DRY out shared parameters btw the module & CY. Same with the port definitions. We had to define the same interface in CY & Calyx. This can become worse if the SoC wants to propagate parameters to the external project (e.g., bus width, burst length etc).
- Another (minor) annoyance is the naming of the module. The module name has to be the same as the Chisel blackbox module name or else it will result in an chisel elaboration error.
- To make integration easier, the interface boundary specification should be more explicit for Calyx generated verilog. That is, there should be assertions in the integration boundary generated by external projects to prevent undefined behaviors that occur due to implicit assumptions made by the compiler.
- Simulation semantics caused a bug during the integration process. Specifically, the integrated Calyx module started fireing an assertion even though the input signals were exactly the same between the Calyx testbench and the integrated version. The only difference was that when running the integrated version, I was using VCS. Basically the problem was how Verilator (and Icarus verilog) schedules the simulation vs VCS.


## Our vision vs CIRCT
- Three main points of our vision : incremental + mixed abstraction + semantics preserving

### CIRCT
- Incrementalism : more of an logistical/engineering effort. Although we can say that our thing will support incrementalism throughout the stack (i.e. including the backend tools), they can also support that as well (more of an engineering challenge)
- Mixed abstraction : they can support mixed abstraction, but it isn't different from the current paradigm in that they are lowering everything to verilog. Basically, they don't have a runtime interop to schedule interactions between abstractions while we do.
- Semantics preservation
    - They straight up don't preserve abstraction semantics (they just lower aggressively)
    - In theory, they can preserve circuit semantics (logistical issue) and we would have to assume the existence of backend tools that can ingest those circuits for a fair comparison.
- However, I think we can argue that we are designing our languages with vertical integration in mind, while these circt people aren't. I'm not sure if this is something okay to say though...
