---
order: 1

title: "NEMX.jl: an open-source Julia package for NEM dispatch modelling"

speakers:
  - name: Ghulam Mohy Ud Din
    honorific: Dr
    affiliation: CSIRO

links:
  - label: Repository
    url: https://github.com/csiro/ensys-NEMX.jl
  - label: Documentation and BESS study
    url: https://csiro.github.io/ensys-NEMX.jl/dev/bess_study/
---

NEMX.jl is a Julia package for simulating dispatch in the Australian National
Electricity Market. It provides three complementary dispatch models: (1) a zonal
model that runs directly on the NEMDE/NEMWEB database and reproduces historical
dispatch prices; (2) a nodal model built on the physical Synthetic NEM Network,
also driven by NEMWEB data, which reproduces dispatch prices under a range of
network formulations from DC through convex relaxations to non-convex AC
representations; and (3) lightweight OPF/FCAS models designed for long-term,
market-informed planning studies.

The session will give an overview of the package and its capabilities, present
benchmark simulations against historical NEM outcomes, and walk through how to
set up and run the tool. It will close with a live demonstration of a BESS
dispatch investigative study, showing how NEMX.jl can be used to analyze
storage behavior and its impact on market outcomes.
