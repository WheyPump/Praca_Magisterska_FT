% Record data from the BLDC motor controller with automatic conditions change
% This script logs IMU and phase-current data from the STM32 via UART while automatically changing
clear all;

%% Helpers
% Inventer open swith faults type - to understand what's going on, look at these numbers in binary
numbers_one_or_zero_fault = [0,1,2,4,8,16,32];
num_two = [3,5,6,9,10,12,17,18,20,24,33,34,36,40,48];
num_three = [11,13,14,19,21,22,25,26,28,35,37,38,41,42,44,49,50,52];

%% Parameters to change by user
% logger_port_name  - COM port name (e.g., 'COM7')
% esc_port_name  - COM port name (e.g., 'COM6')
% record_duration_sec - Duration of data recording in seconds

record_duration_sec = 15; % seconds
esc_port_name = 'COM6';
logger_port_name = 'COM7';
speeds = [7000];
faults = numbers_one_or_zero_fault;

%% Deafault parameters
base_path = '../dataset'; % Base directory where data folders will be created
user_folder_name = sprintf('inverter_%02d_faults_duration_%03ds', length(faults), record_duration_sec); % A custom name for your experiment/run
current_date_str = datestr(now,'yyyymmdd');
output_folder = fullfile(base_path, sprintf('%s_%s', user_folder_name, current_date_str));

%% Main script to record data with automatic conditions change
ser = serialport(esc_port_name, 38400);

disp(ser.Port);
pause(1);

function set_speed(ser, speed)
    frame = uint8([0xC9, 0x00, 0x00, 0xC0, 0x08, 0x00, 0xA9, 0x01, 0x06, ...
                   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]);

    if speed < 0
        frame(13) = 0xFF;
        frame(14) = 0xFF;

        new_speed = uint16(0xFFFF + speed - 1);

        frame(11) = bitand(new_speed, 255);      % Low byte
        frame(12) = bitshift(new_speed, -8);     % High byte
    else
        frame(11) = bitand(speed, 255);          % Low byte
        frame(12) = bitshift(speed, -8);         % High byte
    end

    write(ser, frame, "uint8");
end

function set_delay_zero(ser)
    frame = uint8([0x69, 0x00, 0x00, 0x00, 0x08, 0x00, 0xD1, 0x1D, 0x00, 0x00]);
    write(ser, frame, "uint8");
end

function set_fault(ser, fault)
    frame = uint8([0x69, 0x00, 0x00, 0x00, 0x08, 0x00, 0x51, 0x1D, fault, 0x00]);
    write(ser, frame, "uint8");
end

start_code_A = uint8([0x85, 0xFF, 0xFF, 0xBF]);
start_code_B = uint8([0x05, 0xC7, 0x01, 0x14]);
start_code_C = uint8([0x06, 0x00, 0x00, 0x60]);
ACK          = uint8([0x29, 0x00, 0x00, 0xE0, 0x39, 0x00]);
start_code_D = uint8([0x29, 0x00, 0x00, 0xE0, 0x19, 0x00]);

list_start_codes = {start_code_A, start_code_B, start_code_C, ACK};

for i = 1:length(list_start_codes)
    write(ser, list_start_codes{i}, "uint8");
    pause(0.2);
end

set_delay_zero(ser);
pause(1);
set_fault(ser, 0);
pause(1);
set_speed(ser, 5000);
pause(1);
write(ser, start_code_D, "uint8");
pause(10);



% Common parameters
time_val = 5;
delay_val = 5;

% Creating the events array
k = 1;
for s = 1:length(speeds)
    for f = 1:length(faults)
        events(k).time  = time_val;
        events(k).type  = faults(f);
        events(k).speed = speeds(s);
        events(k).delay = delay_val;
        k = k + 1;
    end
end

% Checking
%disp(events(1:5))   % preview of the first 5 events
%disp(['Total events: ', num2str(length(events))])

%selected_events = [events(5),events(12),events(60),events(91),events(114),events(131),events(135)];
%events = selected_events;
for i = 1:length(events)
    disp([num2str(i),'/',num2str(length(events))]);
    set_speed(ser, events(i).speed);
    pause(events(i).delay);
    set_fault(ser, events(i).type);
    pause(events(i).time);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    record_data(output_folder, logger_port_name, record_duration_sec, events(i).speed, events(i).type);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    disp("===============");
    pause(2)
end

set_speed(ser, 0);
pause(1)
clear ser;
