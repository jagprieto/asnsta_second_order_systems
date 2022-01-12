
function [f, b] = system_dynamics_f_b(state, simulation_time, PARAMETERS)
    R = 1 - 0.1*sin(5*simulation_time);
    dot_R = -0.5*cos(5*simulation_time);
    b = 1/(PARAMETERS.m*R^2);
    f = -2*(dot_R/R)*state(2) - PARAMETERS.g*sin(state(1))/R;
end