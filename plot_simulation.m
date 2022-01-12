
% Plot simulation 
function plot_simulation(SIMULATION_DATA, PARAMETERS)
    sampling_time_txt = num2str(PARAMETERS.sampling_time);
    sampling_time_txt = strrep(sampling_time_txt,'.','_'); 
    fig1 = figure(1);
    clf(fig1);
    subplot(3,1,1);
    plot(SIMULATION_DATA.time_history(:,1), SIMULATION_DATA.SNSTA.system_state_history(:,1) ,'-', 'Color', 'b', 'LineWidth',1.0);
    grid on;
    hold on;
    plot(SIMULATION_DATA.time_history(:,1), SIMULATION_DATA.SOSMC.system_state_history(:,1) ,'-', 'Color', 'r', 'LineWidth',1.0);
    plot(SIMULATION_DATA.time_history(:,1), SIMULATION_DATA.reference_history(:,1) ,'--', 'Color', 'k', 'LineWidth',2.0);
    ylabel('$q(t)$', 'FontSize', PARAMETERS.plot_font_size,'Interpreter','latex');
    xlabel('Time (s)', 'FontSize', PARAMETERS.plot_font_size,'Interpreter','latex');
    title('Angle [º]', 'FontSize', PARAMETERS.plot_font_size,'Interpreter','latex');
    xlim([0.0, PARAMETERS.total_time]);
%     legend(legend_texts, 'Interpreter','latex','FontSize', legend_font_size, 'Location','NorthEast'); 

    subplot(3,1,2);
    plot(SIMULATION_DATA.time_history(:,1), SIMULATION_DATA.SNSTA.system_state_history(:,2),'-', 'Color', 'b', 'LineWidth',1.0);
    grid on;
    hold on;
    plot(SIMULATION_DATA.time_history(:,1), SIMULATION_DATA.SOSMC.system_state_history(:,2) ,'-', 'Color', 'r', 'LineWidth',1.0);
    plot(SIMULATION_DATA.time_history(:,1), SIMULATION_DATA.reference_history(:,2) ,'--', 'Color', 'k', 'LineWidth',2.0);
    ylabel('$\dot{q}(t)$', 'FontSize', PARAMETERS.plot_font_size,'Interpreter','latex');
    xlabel('Time (s)', 'FontSize', PARAMETERS.plot_font_size,'Interpreter','latex');
    title('Angle rate [º/s]', 'FontSize', PARAMETERS.plot_font_size,'Interpreter','latex');
    xlim([0.0, PARAMETERS.total_time]);

    subplot(3,1,3);
    plot(SIMULATION_DATA.time_history(:,1), SIMULATION_DATA.SNSTA.control_state_history(:,1),'-', 'Color', 'b', 'LineWidth',1.0);
    grid on;
    hold on;
    plot(SIMULATION_DATA.time_history(:,1), SIMULATION_DATA.SOSMC.control_state_history(:,1) ,'-', 'Color', 'r', 'LineWidth',1.0);
    ylabel('$u(t)$', 'FontSize', PARAMETERS.plot_font_size,'Interpreter','latex');
    xlabel('Time (s)', 'FontSize', PARAMETERS.plot_font_size,'Interpreter','latex');
    title('Control', 'FontSize', PARAMETERS.plot_font_size,'Interpreter','latex');
    xlim([0.0, PARAMETERS.total_time]);

     if PARAMETERS.CREATE_PDF
         if PARAMETERS.DISTURBANCE_AMPLITUDE > 0
             if PARAMETERS.NOISE_MODULE_DB > 0
                if PARAMETERS.DISTURBANCE_TYPE == 0
                    export_fig(strcat('../MANUSCRIPT/GRAPHICS/states_disturbance_cos_with_noise_tau_',sampling_time_txt,'.pdf'), '-transparent', '-nocrop');
                else
                    export_fig(strcat('../MANUSCRIPT/GRAPHICS/states_disturbance_hf_with_noise_tau_',sampling_time_txt,'.pdf'), '-transparent', '-nocrop');
                end
            else
                if PARAMETERS.DISTURBANCE_TYPE == 0
                    export_fig(strcat('../MANUSCRIPT/GRAPHICS/states_disturbance_cos_no_noise_tau_',sampling_time_txt,'.pdf'), '-transparent', '-nocrop');
                else
                    export_fig(strcat('../MANUSCRIPT/GRAPHICS/states_disturbance_hf_no_noise_tau_',sampling_time_txt,'.pdf'), '-transparent', '-nocrop');
                end
             end
         else
            if PARAMETERS.NOISE_MODULE_DB > 0
                export_fig(strcat('../MANUSCRIPT/GRAPHICS/states_no_disturbance_with_noise_tau_',sampling_time_txt,'.pdf'), '-transparent', '-nocrop');
            else
                export_fig(strcat('../MANUSCRIPT/GRAPHICS/states_no_disturbance_no_noise_tau_',sampling_time_txt,'.pdf'), '-transparent', '-nocrop');
            end
        end
    end

    fig2 = figure(2);
    clf(fig2);
    subplot(2,1,1);
    plot(SIMULATION_DATA.time_history(:,1), SIMULATION_DATA.SNSTA.disturbance_history(:,1) ,'-', 'Color', 'k', 'LineWidth',1.0);
    grid on;
    hold on;
    ylabel('d(t) vs $\epsilon$', 'FontSize', PARAMETERS.plot_font_size,'Interpreter','latex');
    xlabel('Time (s)', 'FontSize', PARAMETERS.plot_font_size,'Interpreter','latex');
    title('Disturbance', 'FontSize', PARAMETERS.plot_font_size,'Interpreter','latex');
    xlim([0.0, PARAMETERS.total_time]);
%     legend(legend_texts, 'Interpreter','latex','FontSize', legend_font_size, 'Location','NorthEast'); 

    subplot(2,1,2);
    plot(SIMULATION_DATA.time_history(:,1), SIMULATION_DATA.SNSTA.control_state_history(:,6) ,'-', 'Color', 'b', 'LineWidth',1.0);
    grid on;
    hold on;
    ylabel('$\omega_c(t)$', 'FontSize', PARAMETERS.plot_font_size,'Interpreter','latex');
    xlabel('Time (s)', 'FontSize', PARAMETERS.plot_font_size,'Interpreter','latex');
    title('Adaptive cut-off frequency', 'FontSize', PARAMETERS.plot_font_size,'Interpreter','latex');
    xlim([0.0, PARAMETERS.total_time]);
%     legend(legend_texts, 'Interpreter','latex','FontSize', legend_font_size, 'Location','NorthEast'); 


    if PARAMETERS.CREATE_PDF
         if PARAMETERS.DISTURBANCE_AMPLITUDE > 0
             if PARAMETERS.NOISE_MODULE_DB > 0
                if PARAMETERS.DISTURBANCE_TYPE == 0
                    export_fig(strcat('../MANUSCRIPT/GRAPHICS/disturbance_and_omega_c_disturbance_cos_with_noise_tau_',sampling_time_txt,'.pdf'), '-transparent', '-nocrop');
                else
                    export_fig(strcat('../MANUSCRIPT/GRAPHICS/disturbance_and_omega_c_disturbance_hf_with_noise_tau_',sampling_time_txt,'.pdf'), '-transparent', '-nocrop');
               end
            else
                if PARAMETERS.DISTURBANCE_TYPE == 0
                   export_fig(strcat('../MANUSCRIPT/GRAPHICS/disturbance_and_omega_c_disturbance_cos_no_noise_tau_',sampling_time_txt,'.pdf'), '-transparent', '-nocrop');
                else
                  export_fig(strcat('../MANUSCRIPT/GRAPHICS/disturbance_and_omega_c_disturbance_hf_no_noise_tau_',sampling_time_txt,'.pdf'), '-transparent', '-nocrop');
                end
             end
         else
            if PARAMETERS.NOISE_MODULE_DB > 0
                export_fig(strcat('../MANUSCRIPT/GRAPHICS/disturbance_and_omega_c_no_disturbance_with_noise_tau_',sampling_time_txt,'.pdf'), '-transparent', '-nocrop');
            else
                export_fig(strcat('../MANUSCRIPT/GRAPHICS/disturbance_and_omega_c_no_disturbance_no_noise_tau_',sampling_time_txt,'.pdf'), '-transparent', '-nocrop');
            end
        end
    end


    fig3 = figure(3);
    clf(fig3);
    data_size = size(SIMULATION_DATA.time_history(:,1), 1);
    from = ceil(data_size*0.5);
    error_SNSTA = SIMULATION_DATA.reference_history(:,1) - SIMULATION_DATA.SNSTA.system_state_history(:,1);
    dot_error_SNSTA = SIMULATION_DATA.reference_history(:,2) - SIMULATION_DATA.SNSTA.system_state_history(:,2);
    error_SOSMC = SIMULATION_DATA.reference_history(:,1) - SIMULATION_DATA.SOSMC.system_state_history(:,1);
    dot_error_SOSMC = SIMULATION_DATA.reference_history(:,2) - SIMULATION_DATA.SOSMC.system_state_history(:,2);


    subplot(2,2,1);
    histogram(error_SNSTA(from:data_size), 'FaceColor','b', 'Normalization', 'probability');
    grid on;
    hold on;
    ylabel('Normalized frequency', 'FontSize', PARAMETERS.plot_font_size,'Interpreter','latex');
    xlabel('$|e(t)|$', 'FontSize', PARAMETERS.plot_font_size,'Interpreter','latex');
    title('Steady state error (ASNSTA)', 'FontSize', PARAMETERS.plot_font_size,'Interpreter','latex');

    subplot(2,2,2);
    histogram(error_SOSMC(from:data_size), 'FaceColor','r' , 'Normalization', 'probability');
    grid on;
    hold on;
    ylabel('Normalized frequency', 'FontSize', PARAMETERS.plot_font_size,'Interpreter','latex');
    xlabel('$|e(t)|$', 'FontSize', PARAMETERS.plot_font_size,'Interpreter','latex');
    title('Steady state error (SOSMC)', 'FontSize', PARAMETERS.plot_font_size,'Interpreter','latex');

   
    subplot(2,2,3);
    histogram(dot_error_SNSTA(from:data_size), 'FaceColor','b', 'Normalization', 'probability');
    grid on;
    hold on;
    ylabel('Normalized frequency', 'FontSize', PARAMETERS.plot_font_size,'Interpreter','latex');
    xlabel('$|\dot{e}(t)|$', 'FontSize', PARAMETERS.plot_font_size,'Interpreter','latex');
    title('Steady state error derivative (ASNSTA)', 'FontSize', PARAMETERS.plot_font_size,'Interpreter','latex');

    subplot(2,2,4);
    histogram(dot_error_SOSMC(from:data_size), 'FaceColor','r' , 'Normalization', 'probability');
    grid on;
    hold on;
    ylabel('Normalized frequency', 'FontSize', PARAMETERS.plot_font_size,'Interpreter','latex');
    xlabel('$|\dot{e}(t)|$', 'FontSize', PARAMETERS.plot_font_size,'Interpreter','latex');
    title('Steady state error derivative (SOSMC)', 'FontSize', PARAMETERS.plot_font_size,'Interpreter','latex');

    if PARAMETERS.CREATE_PDF
         set(gcf, 'Color', 'w');
         if PARAMETERS.DISTURBANCE_AMPLITUDE > 0
             if PARAMETERS.NOISE_MODULE_DB > 0
                if PARAMETERS.DISTURBANCE_TYPE == 0
                   export_fig(strcat('../MANUSCRIPT/GRAPHICS/histogram_disturbance_cos_with_noise_tau_',sampling_time_txt,'.pdf'), '-nocrop');
                else
                  export_fig(strcat('../MANUSCRIPT/GRAPHICS/histogram_disturbance_hf_with_noise_tau_',sampling_time_txt,'.pdf'),  '-nocrop');
                end
            else
                if PARAMETERS.DISTURBANCE_TYPE == 0
                   export_fig(strcat('../MANUSCRIPT/GRAPHICS/histogram_disturbance_cos_no_noise_tau_',sampling_time_txt,'.pdf'),  '-nocrop');
                else
                   export_fig(strcat('../MANUSCRIPT/GRAPHICS/histogram_disturbance_hf_no_noise_tau_',sampling_time_txt,'.pdf'),  '-nocrop');
                end
             end
         else
            if PARAMETERS.NOISE_MODULE_DB > 0
                 export_fig(strcat('../MANUSCRIPT/GRAPHICS/histogram_no_disturbance_with_noise_tau_',sampling_time_txt,'.pdf'),  '-nocrop');
            else
                 export_fig(strcat('../MANUSCRIPT/GRAPHICS/histogram_no_disturbance_no_noise_tau_',sampling_time_txt,'.pdf'),  '-nocrop');
            end
        end
    end


end

