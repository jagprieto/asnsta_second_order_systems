
function [SIMULATION_DATA, PARAMETERS] = run_simulation(PARAMETERS)
    % Simulation time
    simulation_time = 0:PARAMETERS.sampling_time:PARAMETERS.total_time-PARAMETERS.sampling_time;
    PARAMETERS.simulation_steps = size(simulation_time, 2) + 1;
     
    % Prepare simulation data
    SIMULATION_DATA = {};
    SIMULATION_DATA.time_history = zeros(PARAMETERS.simulation_steps,1);
    SIMULATION_DATA.reference_history = zeros(PARAMETERS.simulation_steps,3);
  
    % SOSMC control
    SIMULATION_DATA.SOSMC = {};
    SIMULATION_DATA.SOSMC.system_state = PARAMETERS.initial_state;    
    SIMULATION_DATA.SOSMC.system_state_history = zeros(PARAMETERS.simulation_steps, PARAMETERS.system_order);
    nc = 15;
    SIMULATION_DATA.SOSMC.control_state = zeros(1, nc);    
    SIMULATION_DATA.SOSMC.control_state_history = zeros(PARAMETERS.simulation_steps, nc);
    SIMULATION_DATA.SOSMC.disturbance_history = zeros(PARAMETERS.simulation_steps,PARAMETERS.system_order);
    SIMULATION_DATA.SOSMC.disturbance_state = zeros(1,PARAMETERS.system_order);
   
    % SNSTA control
    SIMULATION_DATA.SNSTA = {};
    SIMULATION_DATA.SNSTA.system_state = PARAMETERS.initial_state;    
    SIMULATION_DATA.SNSTA.system_state_history = zeros(PARAMETERS.simulation_steps, PARAMETERS.system_order);
    nc = 15;
    SIMULATION_DATA.SNSTA.control_state = zeros(1, nc);    
    SIMULATION_DATA.SNSTA.control_state_history = zeros(PARAMETERS.simulation_steps, nc);
    SIMULATION_DATA.SNSTA.disturbance_history = zeros(PARAMETERS.simulation_steps,PARAMETERS.system_order);
    SIMULATION_DATA.SNSTA.disturbance_state = zeros(1,PARAMETERS.system_order);
   
    % Run simulation
    simulation_time = 0.0;
    for simulation_step = 1:PARAMETERS.simulation_steps
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %------------- Save Global Data -------------% 
        SIMULATION_DATA.time_history(simulation_step) = simulation_time;
        reference = system_reference(simulation_time, PARAMETERS);
        SIMULATION_DATA.reference_history(simulation_step, :) = reference;

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %---------------------------------------------------------------------------------------------------------------------% 
        %------------------------------------------------------ SNSTA --------------------------------------------------------% 
        %---------------------------------------------------------------------------------------------------------------------% 
        if PARAMETERS.NOISE_MODULE_DB > 0
            % Add noise
            SIMULATION_DATA.SNSTA.system_state(1) = awgn(SIMULATION_DATA.SNSTA.system_state(1), PARAMETERS.NOISE_MODULE_DB, "measured");  
            SIMULATION_DATA.SNSTA.system_state(2) = awgn(SIMULATION_DATA.SNSTA.system_state(2), PARAMETERS.NOISE_MODULE_DB, "measured");  
        end

        %------------- Save data -------------% 
        SIMULATION_DATA.SNSTA.system_state_history(simulation_step, :) = SIMULATION_DATA.SNSTA.system_state; 
                
        %------------- Disturbance -------------%
        [disturbance_snsta, SIMULATION_DATA.SNSTA.disturbance_state] = disturbance(SIMULATION_DATA.SNSTA.system_state, SIMULATION_DATA.SNSTA.disturbance_state, simulation_time, PARAMETERS);
        SIMULATION_DATA.SNSTA.disturbance_history(simulation_step, :) = disturbance_snsta;
        
        %------------- Control -------------%
        SIMULATION_DATA.SNSTA.control_state = control_snsta(simulation_step, SIMULATION_DATA.SNSTA.system_state, reference, SIMULATION_DATA.SNSTA.control_state, simulation_time, PARAMETERS);
           
        %------------- Save data -------------% 
        SIMULATION_DATA.SNSTA.control_state_history(simulation_step, :) = SIMULATION_DATA.SNSTA.control_state; 
        
        %------------- Roll dynamics with fin control -------------% 
        SIMULATION_DATA.SNSTA.system_state = system_dynamics(SIMULATION_DATA.SNSTA.system_state, SIMULATION_DATA.SNSTA.control_state(1), disturbance_snsta, simulation_time, PARAMETERS);
           
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %---------------------------------------------------------------------------------------------------------------------% 
        %------------------------------------------------------ SOSMC --------------------------------------------------------% 
        %---------------------------------------------------------------------------------------------------------------------% 
        if PARAMETERS.NOISE_MODULE_DB > 0
            % Add noise
            SIMULATION_DATA.SOSMC.system_state(1) = awgn(SIMULATION_DATA.SOSMC.system_state(1), PARAMETERS.NOISE_MODULE_DB, "measured");  
            SIMULATION_DATA.SOSMC.system_state(2) = awgn(SIMULATION_DATA.SOSMC.system_state(2), PARAMETERS.NOISE_MODULE_DB, "measured");  
        end
      
        %------------- Save data -------------% 
        SIMULATION_DATA.SOSMC.system_state_history(simulation_step, :) = SIMULATION_DATA.SOSMC.system_state; 
        
        %------------- Disturbance -------------%
        [disturbance_stw, SIMULATION_DATA.SOSMC.disturbance_state] = disturbance(SIMULATION_DATA.SOSMC.system_state, SIMULATION_DATA.SOSMC.disturbance_state, simulation_time, PARAMETERS);
        SIMULATION_DATA.SOSMC.disturbance_history(simulation_step, :) = disturbance_stw;
        
        %------------- Control -------------%
        SIMULATION_DATA.SOSMC.control_state = control_SOSMC(simulation_step, SIMULATION_DATA.SOSMC.system_state, reference, SIMULATION_DATA.SOSMC.control_state, simulation_time, PARAMETERS);
           
        %------------- Save data -------------% 
        SIMULATION_DATA.SOSMC.control_state_history(simulation_step, :) = SIMULATION_DATA.SOSMC.control_state; 
        
        %------------- Roll dynamics with fin control -------------% 
        SIMULATION_DATA.SOSMC.system_state = system_dynamics(SIMULATION_DATA.SOSMC.system_state, SIMULATION_DATA.SOSMC.control_state(1), disturbance_stw, simulation_time, PARAMETERS);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Update time
        simulation_time = simulation_time + PARAMETERS.sampling_time;
    end
end