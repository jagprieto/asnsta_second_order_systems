function [disturbance, disturbance_state_new] = disturbance(state, disturbance_state, simulation_time, PARAMETERS)
    disturbance_state_new = disturbance_state;
    disturbance = PARAMETERS.DISTURBANCE_AMPLITUDE*cos(PARAMETERS.DISTURBANCE_FREQUENCY*simulation_time);
    if PARAMETERS.DISTURBANCE_TYPE  > 0
        disturbance = disturbance + 0.83*PARAMETERS.DISTURBANCE_AMPLITUDE*sin(2.85*PARAMETERS.DISTURBANCE_FREQUENCY*simulation_time - 0.14);
        disturbance = disturbance + 1.23*PARAMETERS.DISTURBANCE_AMPLITUDE*cos(1.72*PARAMETERS.DISTURBANCE_FREQUENCY*simulation_time + 0.26);          
        disturbance = disturbance + 0.65*PARAMETERS.DISTURBANCE_AMPLITUDE*sin(1.91*PARAMETERS.DISTURBANCE_FREQUENCY*simulation_time + 0.36)*exp(cos(2.21*PARAMETERS.DISTURBANCE_FREQUENCY*simulation_time + 0.13)); 
        if (simulation_time > 0.3*PARAMETERS.total_time) && (simulation_time < 0.7*PARAMETERS.total_time)
            disturbance = disturbance + 2.75*PARAMETERS.DISTURBANCE_AMPLITUDE + 1.34*PARAMETERS.DISTURBANCE_AMPLITUDE*cos((23.4*PARAMETERS.DISTURBANCE_FREQUENCY*simulation_time) + 0.46) - 1.21*PARAMETERS.DISTURBANCE_AMPLITUDE*sin((8.12*PARAMETERS.DISTURBANCE_FREQUENCY*simulation_time) - 0.13);
        elseif (simulation_time > 0.8*PARAMETERS.total_time)%  && (simulation_time < 0.8*PARAMETERS.total_time)
            disturbance = disturbance - 3.5*PARAMETERS.DISTURBANCE_AMPLITUDE;
        end
    end
end