 <B>ALASKA SCENARIOS FOR SINGLE SEX WITH NO B20% CUTOFF...</B>  
 
 Version October 7, 2021  
 Created by Steve Barbeaux E-mail: steve.barbeaux@noaa.gov  Phone: (206) 729-0871   
 

 In the starter.ss file you should change it to read from the converged .par file   
   1 # 0=use init values in control file; 1=use ss.par  
 
 Assumes you already have the forecast parameters already specified appropriately in the forecast.ss for scenario 1,   
 Make sure there is no catch or F already specified in the forecast file.  

 DIR is the model directory  
 CYR is the model current year, SYR is the start year for the model, SEXES is the number of sexes in model, fleets= the fleet number in SS for your fisheries,  
 Scenario2 indicates whether you wish to have a different catch for scenario 2 (1= FmaxABC,2= F as S2_F, 3 = specified catch from a   
 formatted csv saved in the root directory named 'Scenario2_catch.csv', must have an entry for each year, season, and fleet for the years   
 that differ from Fmaxabc  
 with columns "Year,Seas,Fleet,Catch_or_F"  
 do_fig whether to plot figures  
 
