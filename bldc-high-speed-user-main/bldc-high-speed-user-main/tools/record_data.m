function record_data(output_folder, port_name, duration_s, used_speed, used_fault)
% LOG_MOTOR_DATA - function logs data from STM32 and saves to a TXT file
%
% INPUTS:
%   output_folder - folder where the output file will be saved
%   port_name    - name of the serial port, e.g. 'COM7'
%   duration_s   - duration of the function in seconds
%   used_fault  - type of fault (integer 0-63) used in file name generation. Fault must be applied in MotorPilot or use record_auto_conditions_data.m
%   used_speed   - used motor speed in RPM. Reference speed must be applied in MotorPilot or use record_auto_conditions_data.m

%% Serial port setup
hSerial = serialport(port_name, 2250000, 'Timeout', 5, 'Parity', 'none');
configureTerminator(hSerial,'CR/LF');
pause(0.5);

%% Prepare file for writing
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end
file_name = fullfile(output_folder, sprintf('bldc_high_speed_fault%s_speed%d_%s.txt', ...
    num2str(used_fault), used_speed, datestr(now,'yyyy-mm-dd-HH-MM-SS')));
hFile = fopen(file_name, 'a');
fprintf(hFile,'curr_u,curr_v,curr_w,acc_x,acc_y,acc_z,gyro_x,gyro_y,gyro_z\r\n');

%% Prepare buffer variables
vibrations_axis_samples = 80;
currents_axis_samples = 1600;

accelerometer_x_vector = zeros(1,vibrations_axis_samples);
accelerometer_y_vector = zeros(1,vibrations_axis_samples);
accelerometer_z_vector = zeros(1,vibrations_axis_samples);
gyroscope_x_vector = zeros(1,vibrations_axis_samples);
gyroscope_y_vector = zeros(1,vibrations_axis_samples);
gyroscope_z_vector = zeros(1,vibrations_axis_samples);
current_u_vector = zeros(1,currents_axis_samples);
current_v_vector = zeros(1,currents_axis_samples);
current_w_vector = zeros(1,currents_axis_samples);

%% Main loop
t_start = tic;
while toc(t_start) < duration_s
    % Wait for byte synchronization
    correct_byte_num = 0;
    dataIncoming = 0;
    while dataIncoming == 0
        try
            test_byte = read(hSerial,1,'uint8');
            if correct_byte_num == 0 && test_byte == 1
                correct_byte_num = 1;
            elseif correct_byte_num == 1 && test_byte == 100
                correct_byte_num = 2;
            elseif correct_byte_num == 2 && test_byte == 200
                correct_byte_num = 3;
            elseif correct_byte_num == 3 && test_byte == 1
                dataIncoming = 1;
            else
                correct_byte_num = 0;
            end
        catch
            disp("Re-synchronizing frame")
        end
    end

    % Read data
    text = read(hSerial, 5282,'int16');

    if ~(text(5281) == 7880 && text(5282) == -14321)
        warning('Invalid UART data');
        continue;
    end

    % Split data
    n_accelerometer_x_vector = text(1:80);
    n_accelerometer_y_vector = text(81:160);
    n_accelerometer_z_vector = text(161:240);
    n_gyroscope_x_vector = text(241:320);
    n_gyroscope_y_vector = text(321:400);
    n_gyroscope_z_vector = text(401:480);
    n_current_u_vector = text(481:2080);
    n_current_v_vector = text(2081:3680);
    n_current_w_vector = text(3681:5280);

    % Write to TXT file in the same format as original
    for k=1:length(n_current_u_vector)
        if mod(k-1,20) == 0
            fprintf(hFile, '%d,%d,%d,',n_current_u_vector(k),n_current_v_vector(k),n_current_w_vector(k));
            idx = floor(0.95 + k/20);
            fprintf(hFile,'%d,%d,%d,',n_accelerometer_x_vector(idx),n_accelerometer_y_vector(idx),n_accelerometer_z_vector(idx));
            fprintf(hFile,'%d,%d,%d\r\n',n_gyroscope_x_vector(idx),n_gyroscope_y_vector(idx),n_gyroscope_z_vector(idx));
        else
            fprintf(hFile, '%d,%d,%d\r\n',n_current_u_vector(k),n_current_v_vector(k),n_current_w_vector(k));
        end
    end
end

fclose(hFile);
hSerial = [];
disp(['Data saved in file: ', file_name]);
end
