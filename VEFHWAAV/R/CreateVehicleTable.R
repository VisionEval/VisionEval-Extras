#====================
#CreateVehicleTable.R
#====================
#
#<doc>
#
## CreateVehicleTable Module
#### September 10, 2018
#
#This module creates a vehicle table and populates it with household ID and geography fields.
#
### Model Parameter Estimation
#
#This module has no estimated parameters.
#
### How the Module Works
#
#This module initializes the 'Vehicle' table and populates it with the household ID (HhId), vehicle ID (VehID), Azone ID (Azone), Marea ID (Marea), and vehicle access type (VehicleAccess) datasets. The Vehicle table has a record for every vehicle owned by the household. If there are more driving age persons than vehicles in the household, there is also a record for each driving age person for which there is no vehicle. The VehicleAccess designation is Own for each vehicle owned by a household. The designation is either LowCarSvc or HighCarSvc for each record corresponding to difference between driving age persons and owned vehicles. It is LowCarSvc if the household is in a Bzone having a low level of car service and HighCarSvc if the Bzone car service level is high.
#
#</doc>


#=============================================
#SECTION 1: ESTIMATE AND SAVE MODEL PARAMETERS
#=============================================
#This module initializes the 'Vehicle' table and populates it with the
#household ID (HhId), vehicle ID (VehID), Azone ID (Azone), Marea ID (Marea),
#and vehicle access type (VehicleAccess) datasets. The Vehicle table has a
#record for every vehicle owned by the household. If there are more driving age
#persons than vehicles in the household, there is also a record for each driving
#age person for which there is no vehicle. The VehicleAccess designation is Own
#for each vehicle owned by a household. The designation is either LowCarSvc or
#HighCarSvc for each record corresponding to difference between driving age
#persons and owned vehicles. It is LowCarSvc if the household is in a Bzone
#having a low level of car service and HighCarSvc if the Bzone car service level
#is high.


#================================================
#SECTION 2: DEFINE THE MODULE DATA SPECIFICATIONS
#================================================

#Define the data specifications
#------------------------------
CreateVehicleTableSpecifications <- list(
  #Level of geography module is applied at
  RunBy = "Region",
  #Specify new tables to be created by Inp if any
  #Specify new tables to be created by Set if any
  NewSetTable = items(
    item(
      TABLE = "Vehicle",
      GROUP = "Year"
    )
  ),
  #Specify input data
  Inp = items(
    item(
      NAME =
        items(
          "HighCarSvcCost",
          "LowCarSvcCost",
          "ShdCarSvcCost",
          "UnShdCarSvcCost"),
      FILE = "azone_carsvc_characteristics.csv",
      TABLE = "Azone",
      GROUP = "Year",
      TYPE = "currency",
      UNITS = "USD",
      NAVALUE = -1,
      SIZE = 0,
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = "",
      UNLIKELY = "",
      TOTAL = "",
      DESCRIPTION =
        items(
          "Average cost in dollars per mile for travel by shared car service exclusive of the cost of fuel, road use taxes, and carbon taxes (and any other social costs charged to vehicle use).",
          "Average cost in dollars per mile for travel by unshared car service exclusive of the cost of fuel, road use taxes, and carbon taxes (and any other social costs charged to vehicle use).",
          "Average cost in dollars per mile for travel by high service level car service exclusive of the cost of fuel, road use taxes, and carbon taxes (and any other social costs charged to vehicle use).",
          "Average cost in dollars per mile for travel by low service level car service exclusive of the cost of fuel, road use taxes, and carbon taxes (and any other social costs charged to vehicle use)."
        )
    ),
    item(
      NAME = "AveCarSvcVehicleAge",
      FILE = "azone_carsvc_characteristics.csv",
      TABLE = "Azone",
      GROUP = "Year",
      TYPE = "time",
      UNITS = "YR",
      NAVALUE = -1,
      SIZE = 0,
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = "",
      UNLIKELY = "",
      TOTAL = "",
      DESCRIPTION = "Average age of car service vehicles in years"
    ),
    item(
      NAME =
        items(
          "LtTrkCarSvcSubProp",
          "AutoCarSvcSubProp"),
      FILE = "azone_carsvc_characteristics.csv",
      TABLE = "Azone",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "proportion",
      NAVALUE = -1,
      SIZE = 0,
      PROHIBIT = c("NA", "< 0", "> 1"),
      ISELEMENTOF = "",
      UNLIKELY = "",
      TOTAL = "",
      DESCRIPTION =
        items(
          "The proportion of light-truck owners who would substitute a less-costly car service option for owning their light truck",
          "Th proportion of automobile owners who would substitute a less-costly car service option for owning their automobile"
        )
    ),
    item(
      NAME =
        items(
          "LowCarSvcDeadheadProp",
          "HighCarSvcDeadheadProp"),
      FILE = "azone_carsvc_characteristics.csv",
      TABLE = "Azone",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "proportion",
      NAVALUE = -1,
      SIZE = 0,
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = "",
      UNLIKELY = "> 1",
      TOTAL = "",
      DESCRIPTION =
        items(
          "The deadhead proportion for low service level car service calculated using deadhead mileage divided by fare mileage",
          "The deadhead proportion for high service level car service calculated using deadhead mileage divided by fare mileage"
        )
    ),
    item(
      NAME =
        items(
          "ShdCarSvcDeadheadFactor",
          "UnShdCarSvcDeadheadFactor"),
      FILE = "azone_carsvc_characteristics.csv",
      TABLE = "Azone",
      GROUP = "Year",
      TYPE = "double",
      UNITS = "multiplier",
      NAVALUE = -1,
      SIZE = 0,
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = "",
      UNLIKELY = "> 2",
      TOTAL = "",
      DESCRIPTION =
        items(
          "The deadhead adjustment factor for shared car service to adjust deadheading in car services",
          "The deadhead  adjustment factor for unshared car service to adjust deadheading in car services"
        )
    )
  ),
  #Specify data to be loaded from data store
  Get = items(
    item(
      NAME =
        items("HhId",
              "Azone",
              "Bzone",
              "Marea"),
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "character",
      UNITS = "ID",
      PROHIBIT = "",
      ISELEMENTOF = ""
    ),
    item(
      NAME = items(
        "NumLtTrk",
        "NumAuto"),
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "vehicles",
      UNITS = "VEH",
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = ""
    ),
    item(
      NAME = items(
        "NumAVLvl3Vehicles",
        "NumAVLvl5Vehicles"),
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "vehicles",
      UNITS = "VEH",
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = ""
    ),
    item(
      NAME = "Vehicles",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "vehicles",
      UNITS = "VEH",
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = ""
    ),
    item(
      NAME = "DrvAgePersons",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "people",
      UNITS = "PRSN",
      PROHIBIT = c("NA", "< 0"),
      ISELEMENTOF = ""
    ),
    item(
      NAME = "CarSvcLevel",
      TABLE = "Household",
      GROUP = "Year",
      TYPE = "character",
      UNITS = "category",
      PROHIBIT = "",
      ISELEMENTOF = c("Low", "High")
    )
  ),
  #Specify data to saved in the data store
  Set = items(
    item(
      NAME =
        items("HhId",
              "VehId",
              "Azone",
              "Bzone",
              "Marea"),
      TABLE = "Vehicle",
      GROUP = "Year",
      TYPE = "character",
      UNITS = "ID",
      NAVALUE = -1,
      PROHIBIT = "",
      ISELEMENTOF = "",
      DESCRIPTION =
        items("Unique household ID",
              "Unique vehicle ID",
              "Azone ID",
              "Bzone ID",
              "Marea ID")
    ),
    item(
      NAME = "VehicleAccess",
      TABLE = "Vehicle",
      GROUP = "Year",
      TYPE = "character",
      UNITS = "category",
      NAVALUE = "NA",
      PROHIBIT = "",
      ISELEMENTOF = c("Own", "LowCarSvc", "HighCarSvc"),
      SIZE = 10,
      DESCRIPTION = "Identifier whether vehicle is owned by household (Own), if vehicle is low level car service (LowCarSvc), or if vehicle is high level car service (HighCarSvc)"
    ),
    item(
      NAME = "Type",
      TABLE = "Vehicle",
      GROUP = "Year",
      TYPE = "character",
      UNITS = "category",
      NAVALUE = -1,
      PROHIBIT = "NA",
      ISELEMENTOF = c("Auto", "LtTrk"),
      SIZE = 5,
      DESCRIPTION = "Vehicle body type: Auto = automobile, LtTrk = light trucks (i.e. pickup, SUV, Van)"
    ),
    item(
      NAME = "AVLvl",
      TABLE = "Vehicle",
      GROUP = "Year",
      TYPE = "character",
      UNITS = "category",
      NAVALUE = "NA",
      PROHIBIT = "",
      ISELEMENTOF = c("L0", "L3", "L5"),
      SIZE = 2,
      DESCRIPTION = "Identifier for level of automation of vehicles"
    )
  )
)

#Save the data specifications list
#---------------------------------
#' Specifications list for CreateVehicleTable module
#'
#' A list containing specifications for the CreateVehicleTable module.
#'
#' @format A list containing 5 components:
#' \describe{
#'  \item{NewSetTable}{table to be created}
#'  \item{RunBy}{the level of geography that the module is run at}
#'  \item{Inp}{model inputs to be saved to the datastore}
#'  \item{Get}{module inputs to be read from the datastore}
#'  \item{Set}{module outputs to be written to the datastore}
#' }
#' @source CreateVehicleTable.R script.
"CreateVehicleTableSpecifications"
visioneval::savePackageDataset(CreateVehicleTableSpecifications, overwrite = TRUE)


#=======================================================
#SECTION 3: DEFINE FUNCTIONS THAT IMPLEMENT THE SUBMODEL
#=======================================================
#This function initializes the 'Vehicle' table and populates it with the
#household ID (HhId), vehicle ID (VehID), Azone ID (Azone), Marea ID (Marea),
#and vehicle access type (VehicleAccess) datasets. The Vehicle table has a
#record for every vehicle owned by the household. If there are more driving age
#persons than vehicles in the household, there is also a record for each driving
#age person for which there is no vehicle. The VehicleAccess designation is Own
#for each vehicle owned by a household. The designation is either LowCarSvc or
#HighCarSvc for each record corresponding to difference between driving age
#persons and owned vehicles. It is LowCarSvc if the household is in a Bzone
#having a low level of car service and HighCarSvc if the Bzone car service level
#is high.

#Main module function to create vehicle table with HhId and Azone datasets
#-------------------------------------------------------------------------
#' Create vehicle table and populate with HhId and Azone datasets.
#'
#' \code{CreateVehicleTable} create the vehicle table and populate with HhId
#' and Azone datasets.
#'
#' This function creates the 'Vehicle' table in the datastore and populates it
#' with HhId and Azone datasets.
#'
#' @param L A list containing the components listed in the Get specifications
#' for the module.
#' @return A list containing the components specified in the Set
#' specifications for the module.
#' @name CreateVehicleTable
#' @import visioneval
#' @export
CreateVehicleTable <- function(L) {
  #Initialize the output list
  Out_ls <- initDataList()
  #Calculate number of vehicles accessed (owned and car service)
  NumOwned_Hh <- L$Year$Household$Vehicles
  NumCarSvc_Hh <- L$Year$Household$DrvAgePersons - NumOwned_Hh
  NumCarSvc_Hh[NumCarSvc_Hh < 0] <- 0
  NumVeh_Hh <- NumOwned_Hh + NumCarSvc_Hh
  NumLtTrk_Hh <- L$Year$Household$NumLtTrk
  NumAuto_Hh <- L$Year$Household$NumAuto
  NumAVLvl5_Hh <- L$Year$Household$NumAVLvl5Vehicles
  NumAVLvl3_Hh <- L$Year$Household$NumAVLvl3Vehicles
  NumAVLvl0_Hh <- NumVeh_Hh - NumAVLvl5_Hh - NumAVLvl3_Hh
  #Create a vehicle table
  Out_ls$Year$Vehicle <- list()
  attributes(Out_ls$Year$Vehicle)$LENGTH <- sum(NumVeh_Hh)
  #Add household ID to table
  HhId_Ve <- rep(L$Year$Household$HhId, NumVeh_Hh)
  Out_ls$Year$Vehicle$HhId <- HhId_Ve
  attributes(Out_ls$Year$Vehicle$HhId)$SIZE <- max(nchar(HhId_Ve))
  #Add vehicle ID to table
  Out_ls$Year$Vehicle$VehId <-
    paste(HhId_Ve, unlist(sapply(NumVeh_Hh[ NumVeh_Hh > 0], function(x) 1:x)), sep = "-")
  attributes(Out_ls$Year$Vehicle$VehId)$SIZE <- max(nchar(Out_ls$Year$Vehicle$VehId))
  #Add Azone ID to table
  Out_ls$Year$Vehicle$Azone <- rep(L$Year$Household$Azone, NumVeh_Hh)
  attributes(Out_ls$Year$Vehicle$Azone)$SIZE <- max(nchar(Out_ls$Year$Vehicle$Azone))
  #Add Bzone ID to table
  Out_ls$Year$Vehicle$Bzone <- rep(L$Year$Household$Bzone, NumVeh_Hh)
  attributes(Out_ls$Year$Vehicle$Bzone)$SIZE <- max(nchar(Out_ls$Year$Vehicle$Bzone))
  #Add Marea ID to table
  Out_ls$Year$Vehicle$Marea <- rep(L$Year$Household$Marea, NumVeh_Hh)
  attributes(Out_ls$Year$Vehicle$Marea)$SIZE <- max(nchar(Out_ls$Year$Vehicle$Marea))
  
  #Add vehicle ownership or car service designation
  assignVehAccess <- function(NumOwn, NumCarSvc, CarSvcLevel) {
    c(rep("Own", NumOwn), rep(CarSvcLevel, NumCarSvc))
  }
  CarSvcLevel_Hh <- paste0(L$Year$Household$CarSvcLevel, "CarSvc")
  Out_ls$Year$Vehicle$VehicleAccess <-
    unlist(mapply(assignVehAccess, NumOwned_Hh, NumCarSvc_Hh, CarSvcLevel_Hh))
  #Assign vehicle type designation
  assignVehType <- function(NumLtTrk, NumAuto, NumCarSvc) {
    c(rep("LtTrk", NumLtTrk), rep("Auto", NumAuto), rep("Auto", NumCarSvc))
  }
  Out_ls$Year$Vehicle$Type <-
    unlist(mapply(assignVehType, NumLtTrk_Hh, NumAuto_Hh, NumCarSvc_Hh))
  #Assign automation level designation
  assignVehAutomation <- function(NumLvl5, NumLvl3, NumLvl0) {
    c(rep("L5", NumLvl5), rep("L3", NumLvl3), rep("L0", NumLvl0))
  }
  Out_ls$Year$Vehicle$AVLvl <-
    unlist(mapply(assignVehAutomation, NumAVLvl5_Hh, NumAVLvl3_Hh, NumAVLvl0_Hh))
  #Return the outputs list
  Out_ls
}


#===============================================================
#SECTION 4: MODULE DOCUMENTATION AND AUXILLIARY DEVELOPMENT CODE
#===============================================================
#Run module automatic documentation
#----------------------------------
documentModule("CreateVehicleTable")

#Test code to check specifications, loading inputs, and whether datastore
#contains data needed to run module. Return input list (L) to use for developing
#module functions
#-------------------------------------------------------------------------------
# #Load packages and test functions
# library(filesstrings)
# library(visioneval)
# library(ordinal)
# source("tests/scripts/test_functions.R")
# #Set up test environment
# TestSetup_ls <- list(
#   TestDataRepo = "../Test_Data/VE-RSPM",
#   DatastoreName = "Datastore.tar",
#   LoadDatastore = TRUE,
#   TestDocsDir = "verspm",
#   ClearLogs = TRUE,
#   # SaveDatastore = TRUE
#   SaveDatastore = FALSE
# )
# setUpTests(TestSetup_ls)
# #Run test module
# TestDat_ <- testModule(
#   ModuleName = "CreateVehicleTable",
#   LoadDatastore = TRUE,
#   SaveDatastore = FALSE,
#   DoRun = FALSE
# )
# L <- TestDat_$L
# R <- CreateVehicleTable(L)
#
# #Run test module
# TestDat_ <- testModule(
#   ModuleName = "CreateVehicleTable",
#   LoadDatastore = TRUE,
#   SaveDatastore = TRUE,
#   DoRun = TRUE
# )
