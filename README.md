MCMPC
=====

Monte Carlo Simulations of uncertainty

MCM stands for the Monte Carol Method, a numerical technique to that enables solution of complex problems by perfomring simple numerical calculations repeditively to determine a stochastic solution.

PC stands for photoconductance, referring to a measurement technique commonly used in the photovoltaic research to determine the rates of recombination in silicon. 

This software can calculate the recombination in silicon form PC meaasrements where it employs the Monte Carlo method in order to estimate the uncertainty of the measurement.

This code is object orientated

Si, is a method holding calculation functions and constants that represent the properties of silicon. 

MCM_PC_setting is a method pertaining to the system settings for the measurement. This includes waht mode the measurement is in, and selects the models used by the calculation for mobility, intrinsic recombination and so on. 

MCM_PC_meas, short for measurement holds data on an individual measurement. 

MCM_cal uses the methods MCM_PC_setting and MCM_PC_meas in order to calculate the recombination of the sample with uncertainty. 

PCdat enables data extraction from a spreadsheet. You can call objname = PCdat it will allow you to select a file (it saves the path and file name to the objet). Then if you call objname = objname.getxls it will save the data to the object.

The data can then be called objname.datname.

This will only wokr on the .xls SS at the moment I am having issues wiht the xlsm SSS
