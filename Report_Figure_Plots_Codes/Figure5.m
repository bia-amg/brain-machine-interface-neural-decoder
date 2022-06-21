clear all; close all; clc;
load monkeydata_training.mat

% Plot - Peri-stimulus time histograms


k=1; %reaching angle
ilimit=6 %5 neural units
test=trial(:,k).spikes; %averaged over trials

for i=2:ilimit
   
    number_data_intervals=10;

    
    delta_t=round(size(test(i,:),2)/number_data_intervals);
    number_bins=round(size(test(i,:),2)/delta_t);
    
    heights=ones(1,number_bins);
    start=1;
    counter=0;
    index=1;
    
    
    while (start<=size(test(i,:),2)-delta_t)
        for x=start:start+delta_t
            if test(i,x) == 1
                counter=counter+1;
            end
        end
        heights(1,index)=counter/number_bins;
        start=start+(delta_t-1);
        counter=0;
        index=index+1;
    end
    
   
    hold on
    subplot(5,1,i-1);
    set(gca,'xtick',[],'ytick',[])
    bar(heights);
    hold off

end