clear all; close all; clc;
load monkeydata_training.mat


%2D Hand positions across N trials - 1 PLOT



figure
 for k=1:8

        test=trial(:,k).handPos;

        x_position=test(1,:);
        y_position=test(2,:);
        title('Y hand position');
        subplot(2,1,1)
        plot(x_position,'LineWidth',1.5);
        ylabel('X Arm Position (mm)')
        xlim([0 700]);
        xline(320,'r--');
        xline(560,'b--');
        hold on;
     
        title('X hand positon');
        subplot(2,1,2);
        plot(y_position,'LineWidth',1.5);
        ylabel('Y Arm Position (mm)')
        xlim([0 700]);
        xline(320,'r--');
        xline(560,'b--');
        hold on;
 end
 %legend('k=1','k=2','k=3','k=4','k=5','k=6','k=7','k=8'); %uncomment for
 %figure caption
 xlabel('Time (s)');
 