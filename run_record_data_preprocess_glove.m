%% run the terminal to record the data 
clc;clear;
clear; clc; close all; 

setenv('ROS_MASTER_URI','http://togzhan-Vostro-7590:11311/');
setenv('ROS_IP','10.1.71.156');
rosinit

cd /home/togzhan/sample/real_time_data/
%%
clc
detectNode = ros2node("/detection");
% 
contact_sub = rossubscriber('/takktile/contact', 'takktile_ros/Contact');

% contact_sub = ros.Subscriber(detectNode, '/takktile/contact');

pause(2)
% contact = receive(contact_sub, 10);
% pause(2)
contact = receive(contact_sub, 10)
%%
rosshutdown
%%

%%
function cmdout = bag2csv(bagName)

str1 = 'rostopic echo /pressure_sub -b ';
str2 = ' -p > ';
str3 = split(bagName, '.');   % remove the .bag 
str5 = append(str1, bagName); % take bag name 
str5 = append(str5, str2);        % append rostopic with bag name 
str5 = append(str5, str3{1});     % take bag number for the name of csv file
str5 = append(str5, '.csv');      % add csv extension
command = str5;          
    
[status,cmdout] = system(command);% run the command in the terminal
%     command
%     status
end

function out = record_convert()

str1 = 'rosbag record /pressure_sub duration=5';
[status1, cmdout1] = system(str1);% run source bash
 
bag = dir('*.bag');
bagNames = {bag.name};
l = length(bagNames);
bagName = bagNames{l};
cmdout = bag2csv(bagName)

end