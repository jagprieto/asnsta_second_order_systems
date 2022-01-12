function [control_state_new] = control_SOSMC(simulation_step, state, reference, control_state, simulation_time, PARAMETERS)

    % Disturbance estimation
    [system_dynamics_f, system_dynamics_b] = system_dynamics_f_b(state, simulation_time, PARAMETERS);

    % Parameters
    k = 0.1;
    alfa = 0.3;
    rho1 = 0.4;
    rho2 = 0.5; %0.5714;
    if PARAMETERS.DISTURBANCE_AMPLITUDE  > 0
        a = 25;
    else
        a = 12;
    end    
    b = 8.66;
    h = 2; 
    n = 1.1*(h^2)*((alfa+1)^2)/4;
    p = 1.1*((h^2)*(k^2)*((alfa+3)^2)) /(4*n-(h^2)*((alfa+1)^2));
    [system_dynamics_f, system_dynamics_b] = system_dynamics_f_b(state, simulation_time, PARAMETERS);  
    
    e = state(1) - reference(1);
    epsilon = state(2) - reference(2);

    int_s = control_state(2);
    dot_int_s = (a*((abs(e))^rho1)*sign(e) + b*((abs(epsilon))^rho2)*sign(epsilon));
    int_s = int_s + dot_int_s*PARAMETERS.sampling_time;
    s = epsilon + int_s;
    
    gamma = control_state(3);
    dot_gamma = -n*sign(s)*((abs(s))^alfa) -p*s;
    gamma = gamma + dot_gamma*PARAMETERS.sampling_time;
    u_s = -h*sign(s)*(abs(s))^((alfa+1)/2) - k*s + gamma;
    control = -system_dynamics_f - dot_int_s - a*((abs(e))^rho1)*sign(e) - b*((abs(epsilon))^rho2)*sign(epsilon) + u_s;
    control = control/system_dynamics_b;


    % Update control state
    control_state_new = control_state;
    control_state_new(1) = control;
    control_state_new(2) = int_s;
    control_state_new(3) = gamma;
    control_state_new(7) = epsilon;
end
