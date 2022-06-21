clear all; close all; clc;
load monkeydata_training.mat


%3D Hand positions across N trials

figure

N=100; % all trials

for k=1:8

    test=trial(:,k).handPos;

    for n=1:N
        x_position=trial(n,k).handPos(1,:);
        y_position=trial(n,k).handPos(2,:);
        z_position=trial(n,k).handPos(3,:);
        
   
        
        plot3(x_position,y_position,z_position);
        hold on;
        drawnow % needs to be included, otherwise by default
        % the hold on command flattens the 3D graph to 2D
     
    end
    hold on
    
    xlabel('X position');
    ylabel('Y position');
    zlabel('Z position');
    figure_caption{n}=[num2str(n)];
end

