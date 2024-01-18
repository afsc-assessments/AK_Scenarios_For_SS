 
<B> ALASKA PROJECTION SCENARIOS FOR STOCK SYNTHESIS 3 FOR TIER 3 MODELS WITH PARALLEL COMPUTING </B>

 Version JAN 11, 2024

 Created by Steve Barbeaux E-mail: steve.barbeaux@noaa.gov  Phone: (206) 729-0871 
 

 In the starter.ss file you should change it to read from the converged .par file 
   1 # 0=use init values in control file; 1=use ss.par
 
 Assumes you already have the forecast parameters already specified appropriately in the forecast.ss for scenario 1, 
 Make sure there is no catch or F already specified in the forecast file.
 You will also need to make a seperate folder named PROJ and copy your final model run into the folder, 
 this folder will be the folder you point to using DIR

 DIR is the model directory (see above)
 CYR is the model current year, SYR is the start year for the model, SEXES is the number of sexes in model, fleets= the fleet number in SS for your fisheries,
 Scenario2 indicates whether you wish to have a different catch for scenario 2 (1= FmaxABC,2= F as S2_F, 3 = specified catch from a 
 formatted csv saved in the root directory named 'Scenario2_catch.csv', must have an entry for each year, season, and fleet for the years 
 that differ from Fmaxabc
 with columns "Year,Seas,Fleet,Catch_or_F"
 s4_F is the F for scenario 4, defaults to 0.75, should be 0.65 for some species check your requirments
 do_fig whether to plot figures
