%% read the bag file and convert to csv
clc;clear;
str1 = '/home/togzhan/sample/data/rigid/';
runBag2csv(str1);

str2 = '/home/togzhan/sample/data/soft/';
runBag2csv(str2);
%%
% save the sensor data separately
save_each_sensor
str1 = '/home/togzhan/sample/data/rigid/';
minL1 = save_each_sensor(str1);

str2 = '/home/togzhan/sample/data/soft/';
minL2 = save_each_sensor(str2);

%% function
function status = bag2csv(bagNames)

str1 = 'rostopic echo /pressure_sub -b ';
str2 = ' -p > ';

for i = 1%:length(bagNames)
    
    str3 = split(bagNames{i}, '.');   % remove the .bag 
    str5 = append(str1, bagNames{i}); % take bag name 
    str5 = append(str5, str2);        % append rostopic with bag name 
    str5 = append(str5, str3{1});     % take bag number for the name of csv file
    str5 = append(str5, '.csv');      % add csv extension
    command = str5;          
    
    [status,cmdout] = system(command);% run the command in the terminal
    command
    status
end

end

function command =runBag2csv(str1) 
for i = 1%:10
    str2 = string(i);
    str2 = append(str1, str2);
    command = string(str2);
    cd(command); %enter each directory from 1 to 10 and run the bag2csv function
    bag = dir('*.bag');
    bagNames = {bag.name};
    bag2csv(bagNames); 
end
end

function [accel, pressure, imu] = splitData(csvName)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
a = readtable(csvName);
accel1 = (a(:, 83:end));
accel1 = table2array(accel1);
channels = 4;
for i = 1:channels
    p{i} = (accel1(:, 1+(i-1)*50: 50*i));
end
% converet and plot 4 channels
for i = 1:channels
    d = double(p{i});
    c = transpose(d(1, :));
    for j = 2:size(d, 1)
       c = [c ; transpose(d(j, :))];
    end

    f{i} = c;
    % PLOT
    subplot(2,2,i)
    plot(f{i});
end
accel = [f{1} f{2} f{3} f{4}];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pressure 27 units 
figure
press = [a(:, 5:22) a(:, 25:35)];

pressure = table2array(press);
% PLOT
for i = 1:27
    subplot(3,9,i)
    plot(pressure(:, i))
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
imu = table2array(a(:, 35:52));
end

function minL = save_each_sensor(str1)
minL = 1000;
for i = 1:10
    str2 = string(i);
    str2 = append(str1, str2);
    command = string(str2);
    cd(command); %enter each directory from 1 to 10 and run the bag2csv function
    csv = dir('*.csv');
    csvNames = {csv.name}; % read csv files 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for j = 1:5
        
        [accel, pressure, imu] = splitData(csvNames{j});
        %     save variables as csv separately
%         str4 = append('accel_', csvNames{j});
%         str5 = append('pressure_', csvNames{j});
%         str6 = append('imu_', csvNames{j});
%         
%         writematrix(accel, str4);
%         writematrix(pressure, str5);
%         writematrix(imu, str6);
%         
%         
        if(minL > length(pressure))
            minL = length(pressure);
        end
        
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
end
end