
## ALASKA PROJECTION SCENARIOS FOR STOCK SYNTHESIS 3 
## Version October 7, 2021
## Created by Steve Barbeaux E-mail: steve.barbeaux@noaa.gov  Phone: (206) 729-0871 
## 
##
## In the starter.ss file you should change it to read from the converged .par file 
##   1 # 0=use init values in control file; 1=use ss.par
## 
## Assumes you already have the forecast parameters already specified appropriately in the forecast.ss for scenario 1, 
## Make sure there is no catch or F already specified in the forecast file.
##
## DIR is the model directory
## CYR is the model current year, SYR is the start year for the model, SEXES is the number of sexes in model, fleets= the fleet number in SS for your fisheries,
## Scenario2 indicates whether you wish to have a different catch for scenario 2 (1= FmaxABC,2= F as S2_F, 3 = specified catch from a 
## formatted csv saved in the root directory named 'Scenario2_catch.csv', must have an entry for each year, season, and fleet for the years 
## that differ from Fmaxabc
## with columns "Year,Seas,Fleet,Catch_or_F"
## s4_F is the f for scenario 4, defaults to 0.75, should be 0.65 for some species check your requirments
## do_fig whether to plot figures
##
##


Do_AK_Scenarios<-function(DIR="C:/WORKING_FOLDER/EBS_PCOD/2022_ASSESSMENT/NOVEMBER_MODELS/GRANT_MODELS/Model19_12A/PROJ",CYR=2022,SYR=1977,FCASTY=12,SEXES=1,FLEETS=1,Scenario2=1,S2_F=0.4,s4_F=0.75,do_fig=TRUE){
	require(r4ss)
	require(data.table)
	require(ggplot2)
	require(R.utils)

	setwd(DIR) ## folder with converged model
# Define the list of scenarios
	scenarios <- list(
  		scenario_1,
  		modify_scenario(scenario_1, SPRtarget = ifelse(Scenario2 == 2, S2_F, scenario_1$SPRtarget)),  
  		modify_scenario(scenario_1, Forecast = 4, Fcast_years = c(CYR - 5, CYR - 1)),
  		modify_scenario(scenario_1, Btarget = s4_F, SPRtarget = s4_F),
  		modify_scenario(scenario_1, ForeCatch = rbind(scenario_1$ForeCatch, create_zero_catch())),
  		modify_scenario(scenario_1, Btarget = 0.35, SPRtarget = 0.35, Flimitfraction = 1.0),
  		modify_scenario(scenario_1, ForeCatch = SS_ForeCatch(SS_output(dir = getwd()), yrs = CYR:(CYR + 2))),
  		modify_scenario(scenario_1, ForeCatch = SS_ForeCatch(SS_output(dir = getwd()), yrs = CYR:(CYR + 1)))
	)

# Write the scenarios to separate directories and run them
	for (i in 1:length(scenarios)) {
  		scenario <- scenarios[[i]]
  
  # Create a directory for the scenario
  		dir_name <- paste0(getwd(), "/scenario_", i)
  		dir.create(dir_name)
  
  # Copy necessary files to the scenario directory
  		file.copy(from = getwd(), to = dir_name, recursive = FALSE)
  
  # Write the forecast file for the scenario
  		SS_writeforecast(scenario, dir = dir_name, file = "forecast.ss", writeAll = TRUE, overwrite = TRUE)
  
  # Set the working directory to the scenario directory
  		setwd(dir_name)
  
  # Run the scenario
  		run(verbose = FALSE)
	}
	
# Run the forecast scenarios	
if(SEXES==1) sex=2
    if(SEXES>1) sex=1
	
	setwd(DIR)
	mods1<-SSgetoutput(dirvec=scen[1:8])

   	# Calculate summary statistics for each scenario
	summ <- lapply(mods1[1:7], function(mod) {
  		Yr <- SYR:EYR
  		TOT <- data.table(mod$timeseries)[Yr %in% Yr]$Bio_all
  		SUMM <- data.table(mod$timeseries)[Yr %in% Yr]$Bio_smry
  		SSB <- data.table(mod$timeseries)[Yr %in% Yr]$SpawnBio / sex
  		std <- data.table(mod$stdtable)[name %like% "SSB"][3:yr1, ]$std / sex
  		F <- data.table(mod$sprseries)[Yr %in% Yr]$F_report
  		Catch <- data.table(mod$sprseries)[Yr %in% Yr]$Enc_Catch
  		SSB_unfished <- data.table(mod$derived_quants)[Label == "SSB_unfished"]$Value / sex
  		model <- scen[i]
  
  		data.table(Yr = Yr, TOT = TOT, SUMM = SUMM, SSB = SSB, std = std, F = F, Catch = Catch, SSB_unfished = SSB_unfished, model = model)
	})

# Calculate catch projections for each scenario
	Pcatch <- lapply(mods1[1:7], function(mod) {
  		Yr <- (CYR + 1):EYR
  		Catch <- data.table(mod$sprseries)[Yr %in% Yr]$Enc_Catch
  		Catch_std <- data.table(mod$stdtable)[name %like% "ForeCatch_"]$std[2:FCASTY + 1]
  		model <- scen[i]
  
		data.table(Yr = Yr, Catch = Catch, Catch_std = Catch_std, model = model)
	})

# Calculate summary statistics for scenario 8
	summ8 <- data.table(
  		Yr = SYR:EYR,
  		TOT = data.table(mods1[[8]]$timeseries)[Yr %in% Yr]$Bio_all,
  		SUMM = data.table(mods1[[8]]$timeseries)[Yr %in% Yr]$Bio_smry,
  		SSB = data.table(mods1[[8]]$timeseries)[Yr %in% Yr]$SpawnBio / sex,
  		std = data.table(mods1[[8]]$stdtable)[name %like% "SSB"][3:yr1, ]$std / sex,
  		F = data.table(mods1[[8]]$sprseries)[Yr %in% Yr]$F_report,
  		Catch = data.table(mods1[[8]]$sprseries)[Yr %in% Yr]$Enc_Catch,
  		SSB_unfished = data.table(mods1[[8]]$derived_quants)[Label == "SSB_unfished"]$Value / sex,
  		model = scen[8]
	)

# Calculate catch projections for scenario 8
	Pcatch8 <- data.table(
  		Yr = (CYR + 1):EYR,
 		Catch = data.table(mods1[[8]]$sprseries)[Yr %in% ((CYR + 1):EYR)]$Enc_Catch,
  		Catch_std = data.table(mods1[[8]]$stdtable)[name %like% "ForeCatch_"]$std[1:FCASTY],
  		model = scen[8]
	)

# Calculate 2-year projections for catch and F
	SB100 <- summ[[1]][Yr == CYR + 1]$SSB_unfished
	SB40 <- data.table(mods1[[1]]$derived_quants)[Label == "SSB_SPR"]$Value / sex
	SB35 <- data.table(mods1[[8]]$derived_quants)[Label == "SSB_SPR"]$Value / sex
	F40_1 <- summ[[1]][Yr == CYR + 1]$F
	F35_1 <- summ[[6]][Yr == CYR + 1]$F
	catchABC_1 <- Pcatch[[1]][Yr == CYR + 1]$Catch
	catchOFL_1 <- Pcatch[[6]][Yr == CYR + 1]$Catch
	F40_2 <- summ[[1]][Yr == CYR + 2]$F
	F35_2 <- summ8[Yr == CYR + 2]$F
	catchABC_2 <- Pcatch[[1]][Yr == CYR + 2]$Catch
	catchOFL_2 <- Pcatch8[Yr == CYR + 2]$Catch
	SSB_1 <- summ[[1]][Yr == CYR + 1]$SSB
	SSB_2 <- summ[[1]][Yr == CYR + 2]$SSB

	Two_Year <- data.table(
  		Yr = c((CYR + 1):(CYR + 2)),
  		SSB = c(SSB_1, SSB_2),
  		SSB_PER = c(SSB_1 / SB100, SSB_2 / SB100),
  		SB100 = rep(SB100, 2),
  		SB40 = rep(SB40, 2),
  		SB35 = rep(SB35, 2),
  		F40 = c(F40_1, F40_2),
  		F35 = c(F35_1, F35_2),
  		C_ABC = c(catchABC_1, catchABC_2),
  		C_OFL = c(catchOFL_1, catchOFL_2)
	)
# Combine summary statistics and catch projections into tables
	summ <- do.call(rbind, summ)
	Pcatch <- do.call(rbind, Pcatch)

# Create output list with SSB, CATCH, and Two_year tables
	output <- list(
  		SSB = summ,
  		CATCH = Pcatch,
  		Two_year = Two_Year
	)

# Create scenario tables for the document
	BC <- list(
  		Catch = dcast(output$SSB[Yr >= CYR], Yr ~ model, value.var = "Catch"),
  		F = dcast(output$SSB[Yr >= CYR], Yr ~ model, value.var = "F"),
  		SSB = dcast(output$SSB[Yr >= CYR], Yr ~ model, value.var = "SSB")
	)

	output$Tables <- BC
	
	if(do_fig){
		
# Calculate upper and lower confidence intervals for SSB
		summ2 <- data.table(
  			Yr = c(SYR:EYR),
  			TOT = 0,
  			SUMM = 0,
  			SSB = SB40,
  			std = 0,
  			F = 0,
  			Catch = 0,
  			SSB_unfished = SSB_unfished,
  			model = "SSB40%"
		)

		summ2 <- rbind(
  			summ2,
  			data.table(
    			Yr = c(SYR:EYR),
    			TOT = 0,
    			SUMM = 0,
    			SSB = SB35,
    			std = 0,
    			F = 0,
    			Catch = 0,
    			SSB_unfished = SSB_unfished,
    			model = "SSB35%"
  			),
  			data.table(
    			Yr = c(SYR:EYR),
    			TOT = 0,
    			SUMM = 0,
    			SSB = SSB_unfished * 0.2,
    			std = 0,
    			F = 0,
    			Catch = 0,
    			SSB_unfished = SSB_unfished,
    			model = "SSB20%"
  			),
  			summ
		)

		summ2$model <- factor(summ2$model, levels = unique(summ2$model))
		summ2$UCI <- summ2$SSB + 1.96 * summ2$std
		summ2$LCI <- summ2$SSB - 1.96 * summ2$std
		summ2[LCI < 0]$LCI <- 0

# Calculate upper and lower confidence intervals for catch projections
		Pcatch2 <- data.table(
  			Yr = c(CYR + 1:EYR),
  			Catch = Pcatch[model == "scenario_1" & Yr == EYR]$Catch,
  			Catch_std = 0,
  			model = "Catch Fmaxabc"
		)

		Pcatch2 <- rbind(
  			Pcatch2,
  			data.table(
    			Yr = c(CYR + 1:EYR),
    			Catch = Pcatch[model == "scenario_6" & Yr == EYR]$Catch,
    			Catch_std = 0,
    			model = "Catch Fofl"
  			),
  			Pcatch
		)

		Pcatch2$model <- factor(Pcatch2$model, levels = unique(Pcatch2$model))
		Pcatch2$UCI <- Pcatch2$Catch + 1.96 * Pcatch2$Catch_std
		Pcatch2$LCI <- Pcatch2$Catch - 1.96 * Pcatch2$Catch_std
		Pcatch2[LCI < 0]$LCI <- 0

## SSB_Figures
# Define the scenarios to plot
		scenarios <- unique(summ2$model)[1:10]

# Create a list to store the plots
		Figs_SSB <- list()

# Iterate over each scenario and create the plot
		for (scenario in scenarios) {
  			plot_data <- summ2[model %in% scenario]
  
  			plot <- ggplot(plot_data, aes(x = Yr, y = SSB, size = model, color = model, linetype = model, fill = model)) +
    			geom_line() +
    			theme_bw(base_size = 16) +
    			lims(y = c(0, max(summ2$UCI)), x = c(CYR - 1, EYR)) +
    			geom_ribbon(aes(ymin = LCI, ymax = UCI, linetype = model), alpha = 0.2, color = "black", size = 0.2) +
    			scale_linetype_manual(values = c(rep(1, 3), 2:8), name = "Scenarios") +
    			scale_fill_manual(values = c("dark green", "orange", "red", 2:8), name = "Scenarios") +
    			scale_color_manual(values = c("dark green", "orange", "red", 2:8), name = "Scenarios") +
    			scale_size_manual(values = c(rep(1.5, 3), rep(1, 7)), name = "Scenarios") +
    			labs(y = "Spawning biomass (t)", x = "Year", title = paste("Projections", scenario))
  
  			Figs_SSB[[scenario]] <- plot
		}
## Catch Figures
# Define the scenarios to plot
		scenarios <- unique(Pcatch2$model)[1:9]

# Create a list to store the plots
		Figs_Catch <- list()

# Create the "C_ALL" plot
		C_ALL <- ggplot(Pcatch2[model %in% scenarios], aes(x = Yr, y = Catch, size = model, color = model, linetype = model)) +
  			geom_line() +
  			theme_bw(base_size = 16) +
  			lims(y = c(0, max(Pcatch2$UCI)), x = c(CYR + 1, EYR)) +
  			scale_linetype_manual(values = c(rep(1, 2), 2:8), name = "Scenarios") +
  			scale_color_manual(values = c("dark green", "orange", 2:6, 8, 9), name = "Scenarios") +
  			scale_size_manual(values = c(rep(1.5, 2), rep(1, 7)), name = "Scenarios") +
  			labs(y = "Catch (t)", x = "Year", title = "Projections")

		Figs_Catch$C_ALL <- C_ALL

# Create the remaining plots
		for (i in 1:6) {
  			scenario <- scenarios[i]
  			plot_data <- Pcatch2[model %in% scenario]
  
  			plot <- ggplot(plot_data, aes(x = Yr, y = Catch, size = model, color = model, linetype = model, fill = model)) +
    			geom_line() +
    			theme_bw(base_size = 16) +
    			lims(y = c(0, max(Pcatch2$UCI)), x = c(CYR + 1, EYR)) +
    			geom_ribbon(aes(ymin = LCI, ymax = UCI, linetype = model), alpha = 0.2, color = "black", size = 0.2) +
    			scale_linetype_manual(values = c(rep(1, 2), i + 1), name = "Scenarios") +
    			scale_fill_manual(values = c("dark green", "orange", i + 1), name = "Scenarios") +
    			scale_color_manual(values = c("dark green", "orange", i + 1), name = "Scenarios") +
    			scale_size_manual(values = c(rep(1.5, 2), rep(1, 7)), name = "Scenarios") +
    			labs(y = "Catch (t)", x = "Year", title = paste("Projections Scenario", i + 1))
  
  			Figs_Catch[[paste0("C_", i)]] <- plot
		}

	output$FIGS <- list(Figs_SSB, Figs_Catch)
    }
 
	return(output)
}


#profiles_M23.1.0.d<-Do_AK_Scenarios(DIR="C:/WORKING_FOLDER/EBS_PCOD_work_folder/2023_ASSESSMENT/NOVEMBER_MODELS/2023_MODELS/Model_23.1.0.d2/PROJ",CYR=2023,SYR=1977,SEXES=1,FLEETS=c(1),Scenario2=1,S2_F=0.4,do_fig=TRUE)

