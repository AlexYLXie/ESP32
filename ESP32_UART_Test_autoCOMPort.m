clear 
close all
clc

% Setting Uart COM port
s_list = serialportlist("available");
s = serialport(s_list(end),115200);

% Basic setting of sensor
s_rate = 500;
t_window = 10;
% t = 1/s_rate : 1/s_rate : 10;
raw_data = [];
plot_period = 0.1;  % period of plot waveform (sec)
idx = 1;
d = datetime('now','Format','y-MMM-d_HH-mm-ss');
log_file_path = './temp_'+ string(d) + '.txt';

fileID = fopen(log_file_path,'w');
fprintf(fileID,'Time, Raw (V)\n');

% Start collecting UART data
figure(1);
while 1
    d = datetime('now','Format','y-MMM-d HH:mm:ss'); % Get current time
    temp = char(read(s,7,"string"));
    % raw_data = Data_shift(raw_data, shift);
    raw_data(idx) = str2double(temp(2:5))/4096*3.3;
    fprintf(fileID,'%s, %.3d\n',d, raw_data(idx));
    idx = idx+1;

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
end

