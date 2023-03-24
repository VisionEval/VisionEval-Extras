# VisionEval AV Package

This module implements a protoype module from a design developed in the FHWA / Intelligent
Transportation Systems Joint Program Office (FHWA/ITS JPO) project on Automated Vehicle Scenario
Planning Models (Phase 2). It provides an add-on package that can be built with R tools or RStudio,
along with a sample model showing how to use the individual modules.

This package is unsupported by the VisionEval team (but was developed with their cooperation and
support) and is provided "as is". Iquiries regarding the module and its further development may be
directed to [VisionEval Info](mailto:info@visioneval.org?subject=VEFHWAAV%20Module).

To use the package with VisionEval, open the VisionEval runtime or developer environment in RStudio,
navigate to this directory and set it as a Package project in the RStudio build menu, then choose
"Build and Install". Any method for building an R package should work. The resulting package should
be installed in the "ve-lib" directory of the VisionEval installation.

The package includes replacements for the following modules:
* AssignCarSvcAvailability
* AssignVehicleOwnership
* CreateVehicleTable
* AssignVehicleAge
* AdjustVehicleOwnership
* CalculateRoadDvmt
* CalculateRoadPerformance
* CalculateMpgMpkwhAdjustments
* CalculateVehicleOperatingCost
* BudgetHouseholdDvmt

One additional module is newly created:
* CVAVOrientation

The package also includes the prototype model as an "av" variant of "VERSPM" model.

Under VisionEval 3.0, with the package built from this directory and installed into ve-lib, the
sample model can be installed using this instruction:

```
avModel <- installModel("VERSPM","av")
```

See the forthcoming project report for additional details (link will be provided here upon
publications). Contact [VisionEval Info](mailto:info@visioneval.org?subject=VEFHWAAV%20Module)
for more information.
