clc;
clear('all');
rng('default');
warning('off','all');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SIMULATION CONFIGURATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PARAMETERS = {};
PARAMETERS.CREATE_PDF = false;
PARAMETERS.system_order = 2; 
PARAMETERS.simulation_type = 1;
PARAMETERS.sampling_time =  1e-3;
PARAMETERS.settling_time = 1.0;
PARAMETERS.total_time = 10.0;
PARAMETERS.plot_font_size = 12.0;
PARAMETERS.DISTURBANCE_AMPLITUDE = 5.15;
PARAMETERS.DISTURBANCE_FREQUENCY = 3.75;
PARAMETERS.DISTURBANCE_TYPE = 1;
PARAMETERS.REFERENCE_FREQUENCY = 56*pi/180.0;
PARAMETERS.NOISE_MODULE_DB = 0;
PARAMETERS.m = 1.0;
PARAMETERS.g = 9.81;
PARAMETERS.initial_state = [1.30, 4.56];
SIMULATION_DATA = run_simulation(PARAMETERS);
plot_simulation(SIMULATION_DATA, PARAMETERS);
PARAMETERS