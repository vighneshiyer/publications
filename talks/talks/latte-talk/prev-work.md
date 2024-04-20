
# Previous work

---

## Heterocl Notes

### Overview of Heterocl and what it does
- Heterocl decouples the algorithmic specification (functionality) from the hardware optimizations (tiling, loop unrolling, data types)
- Heterocl dialect produces intermediate representations based off of the algorithmic spec and the optimizations
- MLIR backend will emit code specific to different types of target devices (FPGA, CPU, GPU)

### Heterocl imperative style algorithm specification
- Heterocl can specify the algorithm in a imperative manner.

```python
import heterocl as hcl

hcl.init()

A = hcl.placeholder((10,), "A")

# Heterocl can specify algorithms in a imperative style
def insertion_sort(A):
    # Introduce a stage.
    with hcl.Stage("S"):
        # for i in range(1, A.shape[0])
        # We can name the axis
        with hcl.for_(1, A.shape[0], name="i") as i:
            key = hcl.scalar(A[i], "key")
            j = hcl.scalar(i-1, "j")
            # while(j >= 0 && key < A[j])
            with hcl.while_(hcl.and_(j >= 0, key < A[j])):
                A[j+1] = A[j]
                j.v -= 1
            A[j+1] = key.v

# During create_schedule, users can add HW optimizations
s = hcl.create_schedule([A], insertion_sort)
print(hcl.lower(s))

# Builds the correct binary according to the backend device
f = hcl.build(s)

import numpy as np

hcl_A = hcl.asarray(np.random.randint(50, size=(10,)))

print('Before sorting:')
print(hcl_A)

f(hcl_A)

print('After sorting:')
np_A = hcl_A.asnumpy()
print(np_A)
```

### Compute Customization

- Hardware customization is important in hardware applications. HeteroCL
provides a clean abstraction that can capture different types of hardware
customization. Typical hardware customization includes compute customization,
data type customization, and memory customization. In this tutorial, we will
focus on compute customization. We can categorize compute customization into
two types: loop transformation and parallelism. We will introduce them
respectively. This is also where ``hcl.create_schedule`` comes in. We will
use a single two-stage computation to demonstrate some of the customization
primitives.

```python
import heterocl as hcl

hcl.init()

A = hcl.placeholder((10, 100), "A")

def two_stage(A):
    B = hcl.compute(A.shape, lambda x, y: A[x, y] + 1, "B")
    C = hcl.compute(A.shape, lambda x, y: B[x, y] + 1, "C")
    return C

s = hcl.create_schedule([A], two_stage)
s_B = two_stage.B

##############################################################################
# Note that we can get the stage by accessing the properties of the function
# that defines the algorithm `two_stage`. To access the stage in this way, you
# **need to name the stages**.
#
# This is the generated IR without applying any hardware customization.

print(hcl.lower(s))

##############################################################################
# We can take a look at the dataflow graph to visualize the relation between
# stages.
try:
    s.dataflow_graph(plot=True)
except:
    pass

##############################################################################
# Loop Transformation
# -------------------
# Applying loop transformations to our application can potentially increase
# the parallelism inside our program. HeteroCL provides several loop
# transformation primitives.
#
# ``reorder``
# ~~~~~~~~~~~
# The first primitive we introduce here is loop reordering. With this primitive,
# we can redefine the order of a loop nest. For example,

s[s_B].reorder(s_B.axis[1], s_B.axis[0])
```

### Instantiating modules

- It is important for users to define a hardware module. The main reason is
that by reusing the defined hardware module, we can reduce the resource
usage of the design. To define a module, what we need to do is to define a
Python function. Then, apply the function with a decorator. Within the
decorator, we need to specify the shapes of the arguments. Following we show
an example of defining a hardware module that return the maximum value of
two tensors with a given index.

- To use the module, it is just like a normal Python call. There is nothing
special here. Following we show an example of finding the element-wise
maximum value of four tensors.

```python
import heterocl as hcl
import numpy as np

hcl.init()

def maximum(A, B, C, D):

    @hcl.def_([A.shape, B.shape, ()])
    def find_max(A, B, x):
        with hcl.if_(A[x] > B[x]):
            hcl.return_(A[x])
        with hcl.else_():
            hcl.return_(B[x])

    max_1 = hcl.compute(A.shape, lambda x: find_max(A, B, x), "max_1")
    max_2 = hcl.compute(A.shape, lambda x: find_max(C, D, x), "max_2")
    return hcl.compute(A.shape, lambda x: find_max(max_1, max_2, x), "max_o")

##############################################################################
# We can first inspect the generated IR. You can see that for each computation,
# we reuse the same module to find the maximum.

A = hcl.placeholder((10,), "A")
B = hcl.placeholder((10,), "B")
C = hcl.placeholder((10,), "C")
D = hcl.placeholder((10,), "D")

s = hcl.create_schedule([A, B, C, D], maximum)
print(hcl.lower(s))

##############################################################################
# Finally, let's run the algorithm and check the results

f = hcl.build(s)

a = np.random.randint(100, size=(10,))
b = np.random.randint(100, size=(10,))
c = np.random.randint(100, size=(10,))
d = np.random.randint(100, size=(10,))
o = np.zeros(10)

hcl_A = hcl.asarray(a)
hcl_B = hcl.asarray(b)
hcl_C = hcl.asarray(c)
hcl_D = hcl.asarray(d)
hcl_O = hcl.asarray(o, dtype=hcl.Int())

f(hcl_A, hcl_B, hcl_C, hcl_D, hcl_O)
```

### Summary and thoughts
- The abstraction is strictly higher than RTL (and even Calyx), but rather strictly limited to the HLS territory. In that sense, it is hard to say that this is what we are looking for.
    - The hardware is generated from the algorithmic description as well as some user defined annotations which basically corresponds to HLS pragmas.
    - Although they provide APIs to generate "modules", these modules aren't RTL level constructs. Rather they are software functions that are reused throughout the algorithmic description. These functions (or what they call "modules") can act as hints to the compiler to reuse the generated hardware structures from the function to save resources.
- Pros
    - I think it came up with a cleaner API compared to system-C in that it separated out the algorithmic description from the compiler hints for HW generation. It is definitely much better than just inserting pragmas everywhere in your C++ code.
    - As the pragmas (or compiler hints) are separated from the functional description, it may be easier to investigate the differences in the generated RTL from different compiler hints. However, there is a question on how generalizable this approach would be. That is, their main (and only) target is ML accelerators. Hence, they only need to specify a handful of knobs to the designer. Once you try to generalize this to more than just ML accelerators, you will want more fine-grained control over the generated design, which will basically make you add tags (pragmas) everywhere.
    - The testcode is simple : it is almost like writing software tests.
    - Seems like this is highly inspired by Halide where it separate the algorithmic description from the scheduling decision.
- Cons
    - The imperative code seems needlessly verbose and also hard to read with a bunch of (seemingly needless) strings getting passed around.
- What we can learn from this example is that for the HLS level abstraction, we do not want to introduce syntax augmentations. It is good to utilize the host language libraries, but we want the code writing to be as close to writing host language as possible.

---

## MyHDL notes
- Embedded DSL in python.
- Uses the `generator` concept to describe HW. The `generator` here is something different from Chisel `generator`.
- Basically, a generator is a python object that supports the iterator protocol.
```python
def generator():
    for i in range(5):
        yield i

g = generator()
g.next() // 0
g.next() // 1
```
- One nice thing is that they support hardware friendly types : bit-types. Need to support bit-slicing, bit-indexing etc. (Jerry was having a lot of pain trying to do this in C++).
- They support co-simulation of their design with Verilog, but it basically looks like a hacked up DPI function call into python.
    - On the high level, we want to have models that can be simulated with the RTL.
    - Similarily to the HLS argument above, we want the models to be written entirely (or mostly) in using the native host language. However, when we simulate the design, we may want a separate compiler and linker for models (and HLS code) that generates binaries compatible with RTL simluation.
    - So in the end we want a language that is a mix of type 1 and type 2 languages. However we need to limit the scope of type 2 languages to only certain cases.
    - Vighesh notes : This is a type-2 style HDL
        - Type 1 : eDSL. The biggest benefit is that you can leverage the existing host languages tools! (Chisel)
        - Type 2 : Write your code as if you are writing code in the host language, use the host language's parser, but have a separate compiler backend that interprets the AST. (PyHDL)
        - Type 3 : Standalone DSL. Basically, build your own language including the compiler. A lot of work and cannot leverage the existing tools of the host language such as package manager, build system, lsp etc. (Filament)

---

## Magma (Standford's thing)
- eDSL in python. Very similar to Chisel, but also kind of ugly. After looking at some of their examples, it almost feels like using a statically typed host language is a necessity for eDSLs to make it explicit which part is the DSL vs the host language.
- Just look at this mess. Whenever you have to construct a HW primitive you have to do `m.IO`, `m.ClockIO` etc.
- Also I think this is me being a bit biased towards Chisel, but `@=` doesn't look as good as `:=`.
```python
def make_FIFO(data_in_type, data_out_type, depth):
    class FIFO(m.Circuit):
        io = m.IO(data_in=data_in_type, data_out=data_out_type)
        io += m.ClockIO()

        addr_width = m.bitutils.clog2(depth)

        buffer = mantle.RAM(2**addr_width, io.data_in.data.flat_length())

        # pack data into bits
        buffer.WDATA @= m.as_bits(io.data_in.data)

        # unpack bits into tuple
        io.data_out.data @= m.from_bits(data_out_type.data, buffer.RDATA)

        read_pointer = mantle.Register(addr_width + 1)
        write_pointer = mantle.Register(addr_width + 1)
        buffer.RADDR @= read_pointer.O[:addr_width]
        buffer.WADDR @= write_pointer.O[:addr_width]

        full = \
            (read_pointer.O[:addr_width] == write_pointer.O[:addr_width]) \
            & \
            (read_pointer.O[addr_width] != write_pointer.O[addr_width])

        empty = read_pointer == write_pointer
        write_valid = io.data_in.valid & ~full
        read_valid = io.data_out.ready & ~empty

        io.data_in.ready @= ~full

        buffer.WE @= write_valid
        write_pointer.I @= mantle.mux([
            write_pointer.O, m.uint(write_pointer.O) + 1
        ], write_valid)

        io.data_out.valid @= read_valid

        read_pointer.I @= mantle.mux([
            read_pointer.O, m.uint(read_pointer.O) + 1
        ], read_valid)
    return FIFO
```
- They have something called `higher order circuits` which tries to "embed" functional programming concepts. This wouldn't have been necessary if they used a more expressive host language like Scala...
- Their IR : [debugging-magma](https://magma.readthedocs.io/en/latest/debugging/).
    - The serialization format is a json file containing the connections and declarations of the modules which is very hard to read.
- Their paper related to magma / agile HW design flow : [stanford-agile-hw-design](https://www.google.com/url?sa=t&source=web&rct=j&opi=89978449&url=https://cs.stanford.edu/~niemetz/publications/2020/DAC2020.pdf&ved=2ahUKEwj8sPuv3aSFAxVarYkEHfEHBz8QFnoECCcQAQ&usg=AOvVaw0Drx4InmeHpGCLJFwH2iCx)
    - They write their algorithms in Halide and compile it down to their own IR (CoreIR). As this stage the IR is unmapped to a certain HW platform. They have three DSLs that specify how the PEs, memories, and interconnects look like for a particular CGRA. Then, by using compilers for each of these DSLs, they generate rewrite rules which can be applied to the unmapped CoreIR. At this point, the CoreIR can be nicely mapped to the backing CGRA. Finally, by running PnR on the mapped CoreIR, we have a CGRA bitstream.
    - I can see that given a CGRA platform, they can use this framework to quickly test different hardware configurations as they only need to specify the PE, memory and interconnect information in their specification DSL.
    - Also, these DSLs abstract away the concept of `BitVector` which enables them to use the specification for various use cases.
        - When the abstract type `BitVector` is evaluated in python, it serves as a functional model.
        - When it is magmas `Bit` type, it can generate verilog.
        - When it is `SMTBitVector`, it constructs a SMT formula.
    - This methodology is possible because they are targetting a particular backend (CGRA). Their specification language has an 1-1 correspondence with the CGRA primitives. While this is okay for their use case, the flexibility of the design can be limited when targetting ASICs.
    - In summary, this approach looks more like a "separation of abstractions" rather than "mixed abstractions". They specify the HW level information in their DSL and lower the algorithmic level description into HW using the rewrite rules generated from the DSLs.

---

## Dahlia

- Problem that it is trying to solve : HLS generated RTL can be unpredictable when tweaking parameters.
- By encoding timing information about when a shared resource is accessed in the type-system, the compiler can reason about whether a design can shared resources during compile time. On the other hand, traditional HLS compilers have to solve this resource scheduling problem without any timing annotations which makes the generated RTL suboptimal.
    - They mainly focus on the BRAM ports that the compute units have to share.
    - The compiler rejects all cases when there are multiple accesses to a single memory array.
    - They have an edge in terms of compute utilization. That is, given the same amount of compute, using Dahlia will provide you with a higher quality RTL compared to when using raw HLS as it restricts the design space to ones that are close to paretto optimal.
- They have a custom compiler written in scala which emits C++ code annotated by pragmas.
- Kind of similar to Filament in that it encodes timing information about a circuit in the type-system and tries doing something smart during static compile time. However, Dahlia makes more sense than Filament. Dahlia is making the user add hints in the frontend language so that the compiler has more information during compile time. Filament is shifting the complexity of what has to be done during runtime (hazard check) to compile time.
- HLS got better. Would this still be a problem right now? Perhaps, but would have to double check.

---

## Calyx
- The motivation of this project is that various domain specific HLS frontend languages will have to build its own custom compiler. They provide an intermediate language (IL) that domain specific HLS can all target. This enables the new HLS designers to build custom compilers quickly without creating their own IL.
- One benefit of their approach (describing the control flow as an imperative language), is that they can reuse a lot of software optimization techniques such as optimizing out shared resources.
- It has been 4 years now since Calyx came out. However, there is no frontend that targets it. What is the problem here? First of all, there hasn't been enough research on domain specific HLS. Then why is this the case?
- Apart from ML, building an accelerator can be an one off thing. Hence, I have a feeling that there is no incentive to build a new HLS frontend for a particular domain if you just want to build your own accelerator and be done with it.
- We have to compare the cost function of the two scenarios below.
    - Effort of building a frontend + compiler that targets Calyx / easier to optimize the generated HW once the compiler framework is built.
    - Describing the HW in HLS or RTL level without building your own framework / harder to optimize PPA as HLS tools can generate crazy HW, or the iteration time is long.
- I think their argument of various domain specific languages targetting Calyx is a bit far fetched. Also, I'm not sure whether if getting humans to write HW in the Calyx abstraction is a good idea (with the current API). If the APIs are clean enough, I think it would be better to incrorporte this as a frontend language rather than a IL.

---

## Towards Automatic High-Level Code Deployment on Reconfigurable Platforms: A Survey of High-Level Synthesis Tools and Toolchains
- It explains some problems of HLS and does a through survey of the field.
- Taxonomy of existing HLS flows
    1. Direct HLS implementation
        - A designer will understand the HLL code and hand write the entire HLS implementation from scratch.
        - There is little or no code reuse from the HLL code.
        - The designer has to learn the algorithm by heart and also needs in-depth knowledge about the backing HW platform in order to write efficient HLS code.
    2. Semi-automated HLS implementation
        - A designer looks into HLL code and hand tunes (refactor, annotate, restructure) the code. The modified code is passed on to a synthesis engine which will generate HLS code.The HLS is feed into the backend HLS tool to generate RTL.
        - There is quite a lot of code reuse compared to the "direct HLS implementation" method.
        - However, the designer has to be knowledgeable about the synthesis engine as well as the backing HW platform in order to generate high quality RTL.
    3. DSL based HLS implementation
        - A designer will write code in a DSL which has a custom compiler that can target the synthesis engine in the semi-automated approach or directly emit HLS.
        - The domains that support DSLs are fairly limited to linear algebra and image processing kernels.
        - The DSL provides a better abstraction for the designer to work with as it hides the low level HW requirements from the designer.
        - Although the paper classified dataflow based HLS as a separate category, I think it falls into this category to a certain degree.
- Existing problems with HLS is that the compiler has a hard time inferring hardware structures from the high level language (HLL) code. This is because a lot of the times algorithms written in HLL is optimized to run on CPUs (basically the description of the algorithm doesn't contain any notion of parallelism). This results in engineers rewriting/refactoring the original code to help the compiler generate HW.
    - How would we be able to express parallelism in HLL?
    - What kind of tools do we have to build in order to help the compiler extract parallelism out from sequential code? Also, how do we help the compiler identify compute intensive parts of the code?
    - Dynamic memory allocation and recursion is banned from HLS tools. Is this a fundamental limitation or simply an engineering issue? With some constraints, I think the HLS tools should be able to generate efficient(?) HW for these as well.
    - I assume dictionary type datastructures follows the above arguement as well.

---

<!-- - I guess there is a question of whether code hoisting and loop fission should be done by human or by the compiler. -->
