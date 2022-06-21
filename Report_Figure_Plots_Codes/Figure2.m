pcq2clc; clear all; close all;
load('/Users/KevinWang/Desktop/Little_Clopaths/monkeydata_training.mat');
spike = zeros(98,1000);
for i = 1:100
    for q = 1:8
        sizem = size(trial(i,q).spikes);
        rem = 1000-sizem(2);
        spike = spike + cat(2,trial(i,q).spikes,zeros(98,rem));
    end
end

count = 1;
for a = 0:249
    for b = 1:98
        spikecountavg(b,count) = sum(spike(b,a*4+1:a*4+4));
    end
    count = count + 1;
end

spikecountpersec = spikecountavg./0.004./800;
gaussian5 = smoothdata(spikecountpersec(94,:),'gaussian',5);
gaussian10 = smoothdata(spikecountpersec(94,:),'gaussian',10);

figure();
hold on
plot([0.004:0.004:0.7],spikecountpersec(94,1:175),'red');
plot([0.004:0.004:0.7],gaussian5(1:175),'blue');
plot([0.004:0.004:0.7],gaussian10(1:175),'black');
hold off
xlabel('Time (s)','fontsize',12);
ylabel('Spike Density (spikes/s)','fontsize',12);
title('Pre-filtering Spike density vs Time for 1 neural unit over 8 reaching angles','fontsize',12);
legend('spike count','gaussian smoothing bin = 5', 'gaussian smoothing bin = 10','fontsize',12);


% count = 1;
% for a = 1:1000
%     for b = 1:round(spike(94,a)/800/0.004)
%         spikehist(count) = 0.001*a;
%         count = count + 1;
%     end
% end
% 
% figure();
% hold on
% histogram(spikehist,250);
% xlabel('Time (s)');
% ylabel('Spike Density (spikes/s)');
% title('Spike Density vs Time before filtering for 1 neural unit over 8 reaching angles');
% plot([0.004:0.004:1],gaussian);
% hold off

