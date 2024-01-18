 
<B> ALASKA PROJECTION SCENARIOS FOR STOCK SYNTHESIS 3 FOR TIER 3 MODELS WITH PARALLEL COMPUTING </B>

 Version JAN 11, 2024

 Created by Steve Barbeaux E-mail: steve.barbeaux@noaa.gov  Phone: (206) 729-0871 
 

 In the starter.ss file you should change it to read from the converged .par file <br>
   1 # 0=use init values in control file; 1=use ss.par
 
Assumes you already have the forecast parameters already specified appropriately in the forecast.ss for scenario 1, <br>
Make sure there is no catch or F already specified in the forecast file.<br>
You will also need to make a seperate folder named PROJ and copy your final model run into the folder, this folder will be the folder you point to using DIR <br>
<b>DIR</b> is the model directory (see above)<br>
<b>CYR</b> is the model current year, <br>
<b>SYR</b> is the start year for the model, <br>
<b>SEXES</b> is the number of sexes in model,<br> 
<b>fleets</b>= the fleet number in SS for your fisheries, <br>
<b>Scenario2</b> indicates whether you wish to have a different catch for scenario 2 (1= FmaxABC,2= F as <b>S2_F</b>, 3 = specified catch from a formatted csv saved in the root directory named 'Scenario2_catch.csv', must have an entry for each year, season, and fleet for the years that differ from Fmaxabc with columns "Year,Seas,Fleet,Catch_or_F" <br>
<b>s4_F</b> is the F for scenario 4, defaults to 0.75, should be 0.65 for some species check your requirments <br>
<b>do_fig</b> whether to plot figures
