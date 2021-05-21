%% save all rigid
clc; clear;
a = readtable('2021-03-19-15-53-14.csv');
%%
str1 = '/home/togzhan/sample/data/rigid/';
all_accel = [];
all_accel2 = [];
all_pressure = [];
all_imu = []; 
for i = [1,2,3,4,5,6,8,9,10]
    str2 = string(i);
    str2 = append(str1, str2);
    command = string(str2);
    cd(command); %enter each directory from 1 to 10 and run the bag2csv function
    csv = dir('*.csv');
    csvNames = {csv.name}; % read csv files 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for j = 1:5
        
        [accel, accel2, pressure, imu] = splitData(csvNames{j});
        all_accel = [all_accel; accel];
        all_accel2 = [all_accel2; accel2];
        all_pressure = [all_pressure; pressure];
        all_imu = [all_imu; imu];
        
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
end
for i = 7
    str2 = string(i);
    str2 = append(str1, str2);
    command = string(str2);
    cd(command); %enter each directory from 1 to 10 and run the bag2csv function
    csv = dir('*.csv');
    csvNames = {csv.name}; % read csv files 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for j = 1:3
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        llim = 744;
        a = readtable(csvNames{j});
        a = a(1:llim, :);
        accel1 = (a(:, 71:end));
        accel1 = table2array(accel1);
        accel2 = accel1;
        channels = 4;
        for ii = 1:channels
            p{ii} = accel1(:, (1+(ii-1)*50) : (50*ii));
        end
        % converet and plot 4 channels
        for ii = 1:channels
            d = double(p{ii});
            c = transpose(d(1, :));
            for j = 2:size(d, 1)
               c = [c ; transpose(d(j, :))];
            end

            f{ii} = c;
        end
        accel = [f{1} f{2} f{3} f{4}];
        press = [a(1:llim, 5:23) a(1:llim, 27:28) b(1:llim, 29:34)];
        pressure = table2array(press);
        imu = table2array(a(:, 29:46));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         [accel, accel2, pressure, imu] = splitData2(csvNames{j});        
        all_accel = [all_accel; accel];
        all_accel2 = [all_accel2; accel2];
        all_pressure = [all_pressure; pressure];
        all_imu = [all_imu; imu];
    end
    for j = 4:5
        
        [accel, accel2, pressure, imu] = splitData(csvNames{j});
        all_accel = [all_accel; accel];
        all_accel2 = [all_accel2; accel2];
        all_pressure = [all_pressure; pressure];
        all_imu = [all_imu; imu];
        
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
end
%%
cd /home/togzhan/sample/data/rigid/
writematrix(all_accel, 'rigid_accel.csv');
writematrix(all_accel2, 'rigid_accel2.csv');
writematrix(all_pressure, 'rigid_pressure.csv');
writematrix(all_imu, 'rigid_imu.csv');
%% save all soft 
str1 = '/home/togzhan/sample/data/soft/';
all_accel = [];
all_pressure = [];
all_imu = []; 
all_accel2 = [];
for i = 1:10
    str2 = string(i);
    str2 = append(str1, str2);
    command = string(str2);
    cd(command); %enter each directory from 1 to 10 and run the bag2csv function
    csv = dir('*.csv');
    csvNames = {csv.name}; % read csv files 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for j = 1:5
        
        [accel, accel2, pressure, imu] = splitData(csvNames{j});
        all_accel = [all_accel; accel];
        all_accel2 = [all_accel2; accel2];
        all_pressure = [all_pressure; pressure];
        all_imu = [all_imu; imu];
        
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
end
clc;
%%
cd /home/togzhan/sample/data/soft/
writematrix(all_accel, 'soft_accel.csv');
writematrix(all_accel2, 'soft_accel2.csv');
writematrix(all_pressure, 'soft_pressure.csv');
writematrix(all_imu, 'soft_imu.csv');
%% read the cav files
clc; clear;
cd /home/togzhan/sample/data
csv = dir('*.csv');
csvNames = {csv.name}; % read csv files
for i = 1:length(csvNames)
    data{i} = readtable(csvNames{i});
end
%% data concat all data for one trial, 5*10 = 50 trials per class
clc;
a = table2array(data{2});
im = table2array(data{3});
p = table2array(data{4});
k = 0;
data_rigid = take_data(p, a, im);
%% 
aS = table2array(data{6});
imS = table2array(data{7});
pS = table2array(data{8});
k = 0;
data_soft = take_data(pS, aS, imS);

%% labels 0 - rigid, 1 - soft
labels = [];
for i = 1:50
    labels(i, 1) = 0;
    labels(i+50, 1) = 1;
end
%%
data_all = [data_rigid; data_soft];
data_all = [data_all labels];
%%
cd /home/togzhan/sample/data/data
writematrix(data_soft, 'data_soft.csv');
writematrix(data_all, 'data_all.csv');
writematrix(data_rigid, 'data_rigid.csv');

%% load data_all data_r data_s files for preprocessing
cd /home/togzhan/sample/data/data
data_all = readtable('data_all.csv');
data_r = readtable('data_rigid.csv');
% data_s = readtable('data_soft.csv');
%%
function [data  ] = take_data(p, a, im)
pressure = [];
data_pres = [];

data_accel = [];
acceler = [];

data_imu = [];
imu_ = [];

for i = 1:50
    pres = [];
    pressure =  transpose(p(744*(i-1)+1:744*i,:));
    for j = 1:27
        pres = [pres pressure(j,:)];
    end
    data_pres = [data_pres; pres];
    
    accel = [];
    acceler =  transpose(a(744*(i-1)+1:744*i,:));
    for k = 1:4
        accel = [accel acceler(k,:)];
    end
    data_accel = [data_accel;accel] ;
    
    imu = [];
    imu_ =  transpose(im(744*(i-1)+1:744*i,:));
    for k = 1:18
        imu = [imu imu_(k,:)];
    end
    data_imu = [data_imu; imu];
    
    data = [data_pres data_accel data_imu];
    
end
end
%%
function [accel, accel2, pressure, imu] = splitData(csvName)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure
llim = 744;
a = readtable(csvName);
a = a(1:llim, :);
accel1 = (a(:, 83:end));
accel1 = table2array(accel1);
accel2 = accel1;
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
%     subplot(2,2,i)
%     plot(f{i});
end
accel = [f{1} f{2} f{3} f{4}];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pressure 27 units 
% figure
press = [a(:, 5:23) a(:, 27:34)];
pressure = table2array(press);
% PLOT
% for i = 1:27
%     subplot(3,9,i)
%     plot(pressure(:, i))
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
imu = table2array(a(:, 35:52));
end