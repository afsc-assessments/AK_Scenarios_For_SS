 <B>Alaska Projection Scenarios for Stock Synthesis...</B>  
 
 Version October 7, 2021  
 Created by Steve Barbeaux E-mail: steve.barbeaux@noaa.gov  Phone: ‪(206) 526-4211‬  
 
 This function performs the 7 Alaska projection scenarios for Stock Synthesis 3 models. It runs the scenarios, saves them to the working directory and produces stock figures for the projections. This function could use some work on generalization and making the figures a bit more ready for the assessment. 
 

 In the starter.ss file you should change it to read from the converged .par file   
   1 # 0=use init values in control file; 1=use ss.par  
 
 Assumes you already have the forecast parameters already specified appropriately in the forecast.ss for scenario 1,   
 Make sure there is no catch or F already specified in the forecast file.  

 DIR is the model directory  
 CYR is the model current year, SYR is the start year for the model, SEXES is the number of sexes in model, fleets= the fleet number in SS for your fisheries,  
 Scenario2 indicates whether you wish to have a different catch for scenario 2 (1= FmaxABC,2= F as S2_F, 3 = specified catch from a   
 formatted csv saved in the root directory named 'Scenario2_catch.csv', must have an entry for each year, season, and fleet for the years   
 that differ from Fmaxabc with columns "Year,Seas,Fleet,Catch_or_F"  
 do_fig whether to plot figures  
 
 Example:  
 Do_AK_Scenarios(DIR="C:/WORKING_FOLDER/2021 Stock Assessments/2021 Pacific cod/Models/Model19.1",CYR=2021,SYR=1977,FCASTY=15,SEXES=1,FLEETS=c(1:3),Scenario2=1,S2_F=0.4,do_fig=TRUE)
 
