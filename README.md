 # Alaska Projection Scenarios for Stock Synthesis

Version: January 18,2024

Created by Steve Barbeaux  
E-mail: steve.barbeaux@noaa.gov  
Phone: ‪(206) 526-4211‬

This function performs the 7 Alaska projection scenarios for Stock Synthesis 3 models. It runs the scenarios, saves them to the working directory, and produces stock figures for the projections. However, please note that this function could use some work on generalization and making the figures more suitable for assessment purposes.

## Usage

In the `starter.ss` file, make sure to change it to read from the converged `.par` file:
  1 # 0=use init values in control file; 1=use ss.par  
 
Assumptions:
- You have already specified the forecast parameters appropriately in the `forecast.ss` file for scenario 1.
- There is no catch or F already specified in the forecast file.

Parameters:
- `DIR`: Model directory
- `CYR`: Model current year
- `SYR`: Start year for the model
- `SEXES`: Number of sexes in the model
- `fleets`: The fleet number in SS for your fisheries
- `Scenario2`: Indicates whether you wish to have a different catch for scenario 2 (1 = FmaxABC, 2 = F as S2_F, 3 = specified catch from a formatted CSV saved in the root directory named 'Scenario2_catch.csv', must have an entry for each year, season, and fleet for the years that differ from Fmaxabc with columns "Year, Seas, Fleet, Catch_or_F")
- `do_fig`: Whether to plot figures

Example usage:
```R
Do_AK_Scenarios(DIR = "C:/WORKING_FOLDER/2021 Stock Assessments/2021 Pacific cod/Models/Model19.1", CYR = 2021, SYR = 1977, FCASTY = 15, SEXES = 1, FLEETS = c(1:3), Scenario2 = 1, S2_F = 0.4, do_fig = TRUE)
