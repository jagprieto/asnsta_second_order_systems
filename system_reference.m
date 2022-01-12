function [reference] = system_reference(simulation_time, PARAMETERS)
   reference = zeros(2,1);
   PARAMETERS.REFERENCE_FREQUENCY;
   reference(1) = 0.5*sin(PARAMETERS.REFERENCE_FREQUENCY*simulation_time);
   reference(2) = PARAMETERS.REFERENCE_FREQUENCY*0.5*cos(PARAMETERS.REFERENCE_FREQUENCY*simulation_time);
   reference(3) = -(PARAMETERS.REFERENCE_FREQUENCY^2)*0.5*sin(PARAMETERS.REFERENCE_FREQUENCY*simulation_time);
end