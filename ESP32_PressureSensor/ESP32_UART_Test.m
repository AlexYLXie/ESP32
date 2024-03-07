clear
close all
clc

prompt = "Total data collection time (s): ";
total_data_collectiontime = input(prompt,'s');
% Preparation for MatPlot
figure(1);
x = 0; y = 0;
plot(x, y)
xlabel('Time (sec)')
ylabel('Pressure (Volt)')
xlim([0, 10])
drawnow
disp('Preparing for data collection, please wait...')
% Setting Uart COM port
% Auto Setting  COM port
s_list = serialportlist("available");
fprintf('Connected to %s\n Start collection...\n', s_list(end))
s = serialport(s_list(end),115200);
temp = char(read(s,7,"string"));
if isempty(temp) 
    clear s
    prompt = "Please key in the COM port of ESP32 device: ";
    COM = input(prompt,'s');
end
% Basic setting of sensor
s_rate = 500;
t_window = 10;
raw_data = [];
plot_period = 0.1;  % period of plot waveform (sec)
max_period = s_rate*60*10; % Max period (10 min) of data collection time
idx = 1;
T_idx = 1;
Td = datetime('now','Format','y-MMM-d_HH-mm-ss');
log_file_path = './logfile/log_'+ string(Td) + '.txt';

fileID = fopen(log_file_path,'w');
fprintf(fileID,'Time, Raw (V),\n');

% Preparation for UART if 1st char == P
for i = 1:7
    temp = char(read(s,1,"string"));
    if temp(1) == 'P'
        read(s,6,"string");
        break
    end
end
% Start collecting UART data
figure(1);
if isempty(total_data_collectiontime)
    while 1
        d = datetime('now','Format','y-MMM-d HH:mm:ss'); % Get current time
        temp = char(read(s,7,"string"));
        % raw_data = Data_shift(raw_data, shift);
        if temp(1) == 'P'
            raw_data(idx) = str2double(temp(2:5))/4096*3.3;
            fprintf(fileID,'%s, %.3f,\n',d, raw_data(idx));
            idx = idx+1;
            T_idx = T_idx + 1;
        
            if mod(idx, s_rate*plot_period) == 0
                t = 1/s_rate : 1/s_rate : length(raw_data)/s_rate;
                plot(t, raw_data)
                xlim([0, 10])
                drawnow
            end
        
            if idx >= s_rate * t_window
                idx = 1;
                raw_data = [];
            end
        elseif T_idx >= max_period
                break
        else
            for i = 1:7
                temp = char(read(s,1,"string"));
                if temp(1) == 'P'
                    read(s,6,"string");
                    break
                end
            end
        end
    end
else
    while T_idx <= s_rate*str2double(total_data_collectiontime)
        d = datetime('now','Format','y-MMM-d HH:mm:ss'); % Get current time
        temp = char(read(s,7,"string"));
        % raw_data = Data_shift(raw_data, shift);
        if temp(1) == 'P'
            raw_data(idx) = str2double(temp(2:5))/4096*3.3;
            fprintf(fileID,'%s, %.3f,\n',d, raw_data(idx));
            idx = idx+1;
            T_idx = T_idx + 1;
        
            if mod(idx, s_rate*plot_period) == 0
                t = 1/s_rate : 1/s_rate : length(raw_data)/s_rate;
                plot(t, raw_data)
                xlim([0, 10])
                drawnow
            end
        
            if idx >= s_rate * t_window
                idx = 1;
                raw_data = [];
            end
        else
            for i = 1:7
                temp = char(read(s,1,"string"));
                if temp(1) == 'P'
                    read(s,6,"string");
                    break
                end
            end
        end
    end
end
clear s % close serial port
fclose(fileID);
disp('End collection...')
% Plot whole collection 
fileID = fopen(log_file_path,'r');
OG_str = fscanf(fileID, '%s');
OG_array = strsplit(OG_str, ',');
data_array = OG_array([4:2:length(OG_array)-1]);
raw = [];
for i = 1:length(data_array)
    raw(i) =  str2num(cell2mat(data_array(i)));
end
t = 1/s_rate : 1/s_rate : length(raw)/s_rate;
plot(t, raw)
xlabel('Time (sec)')
ylabel('Pressure (Volt)')
saveas(gcf, './logfile/log_'+ string(Td) +'.png')