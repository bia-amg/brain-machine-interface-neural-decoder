clear all; close all; clc;
load monkeydata_training.mat


%PLOT - ZOOMED IN 5 NEURAL UNITS FROM 1ST REACHING ANGLE

k=1 %reaching angle
test=trial(:,k).spikes; %averaged over trials


ilimit=6
figure
for i=2:ilimit
     hold on
     subplot(5,1,i-1);
     plot(test(i,:),'b');
     hold off
end