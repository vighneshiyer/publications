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

- https://www.computer.org/csdl/magazine/co/2025/05/10970203/260SofoD9a8 (Embench IOT 2.0 and DSP 1.0: Modern Embedded Computing Benchmarks)
  - https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=10970203
  - https://github.com/embench/embench-dsp/tree/rc1/src/fir_f32_taps256_n1
  - https://github.com/embench/embench-iot/tree/master (only 2/4 of the new 2.0 benchmarks are here)

== Baremetal RISC-V

== Baremetal Rust

=== no_std Crates

== Rust Stdlib Microbenchmarks

== Crate Instrumentation for Function Stimulus

== Correlating Microbenchmarks with Full Application Performance

