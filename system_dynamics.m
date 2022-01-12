function [state_new] = system_dynamics(state, control, disturbance, simulation_time, PARAMETERS)
    [f, b] = system_dynamics_f_b(state, simulation_time, PARAMETERS);  
    dx2 = f + b*control + disturbance;
    x2 = state(2) + dx2*PARAMETERS.sampling_time;
    x1 = state(1) + x2*PARAMETERS.sampling_time;
    state_new = state;
    state_new(1) = x1;
    state_new(2) = x2;
end