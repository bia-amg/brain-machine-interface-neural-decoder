clear all; close all; clc;
load monkeydata_training.mat


n=1 %number of trials
k=8 %reaching angle
ilimit=98 %total number of neural units



test=trial(:,k).spikes; %averaged over trials
% 1st PLOT - 98 Neural UNITS per reaching angle


for k=1:8 %loop across all reaching angles
    test=trial(:,k).spikes; %averaged over trials
    figure
    for i=1:ilimit
         hold on
         subplot(98,1,i);
         plot(test(i,:));%add colour parameter for different colours
         set(gca,'xtick',[],'ytick',[])
         hold off
    end
     xlabel('Time (s)');
end 
