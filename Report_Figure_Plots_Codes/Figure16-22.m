clear all; close all; clc;
load monkeydata_training.mat

%2D Hand positions across N trials - 1 PLOT

for k=1:8
    figure
    
    test=trial(:,k).handPos;
    
    x_position=test(1,:);
    y_position=test(2,:);
    subplot(2,1,1)
    plot(x_position,'LineWidth',1.5);
    ylabel('X Arm Position (mm)')
    xlim([0 700]);
    
    hold on;
    
    subplot(2,1,2);
    plot(y_position,'LineWidth',1.5);
    ylabel('Y Arm Position (mm)')
    xlim([0 700]);
    
    hold on;
    
    
    xlabel('Time (s)');

end 
     