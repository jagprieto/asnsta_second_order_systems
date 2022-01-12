function [control_state_new] = control_snsta(simulation_step, state, reference, control_state, simulation_time, PARAMETERS)

    [system_dynamics_f, system_dynamics_b] = system_dynamics_f_b(state, simulation_time, PARAMETERS);  
    e = state(1) - reference(1);
    dot_e = state(2) - reference(2);
    if simulation_step > 1
        epsilon = control_state(8);
        z = control_state(3);
        epsilon_e = control_state(5);
        epsilon_s = control_state(7);
        s = control_state(9);
    else
        epsilon = 0;
        z = state(2);
        omega_c = 0.5;
        lambda_e = 2*omega_c;  
        gamma_e = 0.5/PARAMETERS.sampling_time;
        beta_e = lambda_e/gamma_e;
        epsilon_e = - (dot_e + lambda_e*e + beta_e*tanh(gamma_e*e));
        epsilon_s = 0;
        s = 0;
    end
        
    % Parameters
    omega_c_min = 2;
    omega_c_max = max(omega_c_min, 1/(10*PARAMETERS.sampling_time));
    omega_c = omega_c_min + (omega_c_max-omega_c_min)* 0.5*(1 + tanh((simulation_time - 2.5*PARAMETERS.settling_time)));
    lambda_e = 2*omega_c;  
    p2 = (5*lambda_e^2+4)/(2*lambda_e^3);
    gamma_e = 0.5/PARAMETERS.sampling_time;
    beta_e = lambda_e/gamma_e;%(PARAMETERS.DISTURBANCE_FREQUENCY*(p2*alfa+0.5))/(p3*tanh(gamma_e*mu)) %beta_gain*2*p2/(PARAMETERS.sampling_time*(2*p2+PARAMETERS.sampling_time)*gamma_e);
    kappa_e = beta_e*2/p2;

    % Adaptive cut-off sliding surface
    dot_epsilon_e = (lambda_e*lambda_e/4)*e + kappa_e*tanh(gamma_e*e);
    epsilon_e = epsilon_e + dot_epsilon_e*PARAMETERS.sampling_time;
    s = dot_e + lambda_e*e + beta_e*tanh(gamma_e*e) + epsilon_e;

    % Control    
    lambda_s = 1*lambda_e; 
    gamma_s = gamma_e;
     beta_s = beta_e;
    kappa_s = kappa_e;
    dot_epsilon_s = (lambda_s*lambda_s/4)*s + kappa_s*tanh(gamma_s*s);
    epsilon_s = epsilon_s + dot_epsilon_s*PARAMETERS.sampling_time;
    control = -1*(1/system_dynamics_b)*(system_dynamics_f + lambda_s*s + beta_s*tanh(gamma_s*s)  + epsilon_s - reference(3) + lambda_e*dot_e + beta_e*gamma_e*((sech(gamma_e*e))^2)*dot_e + dot_epsilon_e);

    control_state_new = control_state;
    control_state_new(1) = control;
    control_state_new(3) = z;
    control_state_new(5) = epsilon_e;
    control_state_new(6) = omega_c;
    control_state_new(7) = epsilon_s;
    control_state_new(8) = epsilon;
    control_state_new(9) = s;
end
