# VEPopulationSim

This module integrates the PopulationSim component of ActivitySim into VisionEval,
replacing the VESimHouseholds module in VERSPM.

It contains a sample model with a PopulationSim setup.

It was produced through the VisionEval Pooled Fund Phase 2 contract, Task 5.3 (2023)

To use:

1. Build and install with RStudio into ve-lib (installed VisionEval R library)
2. Start VisionEval and installModel("VERSPM","popsim")
3. Install PopulationSim following their instructins
4. Open the Conda environment and "activate popsim"
5. In the Conda environment, change into models/VERSPM-popsim directory "inputs/snap_populationsim/PopulationSim_Model
6. Run "python run_populationsim.py"
7. Go back to VisionEval and do "mod <- openModel("VERSPM-popsim")"
8. "mod$run()"
9. "mod$extract()"

