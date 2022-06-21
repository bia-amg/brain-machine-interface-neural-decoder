clear all; close all; clc;
load monkeydata_training.mat 

%2D Hand positions across N trials - multiple subplots
    
fig = figure;
for k=1:8
    test=trial(:,k).handPos;

   
    x_position=test(1,:);
    y_position=test(2,:);
 
  
    subplot(8,2,k);
    plot(x_position,'LineWidth',1.5);
    xlim([0 700]);
    hold on;
    xline(320,'r--');
    xline(560,'k--');
    subplot(8,2,k+8);
    plot(y_position,'LineWidth',1.5);
    xlim([0 700]);
    hold on;
    xline(320,'r--');
    xline(560,'k--');

end


