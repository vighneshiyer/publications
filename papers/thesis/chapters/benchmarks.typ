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

== Baremetal RISC-V

== Baremetal Rust

=== no_std Crates

== Rust Stdlib Microbenchmarks

== Crate Instrumentation for Function Stimulus

== Correlating Microbenchmarks with Full Application Performance

