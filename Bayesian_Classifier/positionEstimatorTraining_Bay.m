%% Made by Little Clopaths Team - Imperial College London
% Team members: Beatriz R.F. Teixeira, Carolina Gomes, Elias Rabbat and
% Kevin Wang
function  [modelParameters] = positionEstimatorTraining_Bay(trainingData)

%% Training the Linear Regression Classifier
[T,angle] = size(trainingData);
dt = 20; 
N = 560; 
range = 320:dt:N; 
% Data pre-processing
len = 1;
X0 = zeros(T*angle,98); 
lin_reg_total = zeros(T*angle,N/dt*98);
for times=1:1:T
    for a=1:1:angle
        fr = zeros(98,length(0:dt:N)-1);
        for n=1:1:98
            data = trainingData(times,a).spikes(n,1:N);
            data(data==0) = NaN; 
            counter = histcounts([1:1:N].*data,0:dt:N); 
            fr(n,:) = counter/dt;
        end
        X0(len,:) = mean(fr,2);
        lin_reg_reshape = reshape(fr,size(fr,1)*size(fr,2),1);
        lin_reg_total(len,:) = lin_reg_reshape; 
        len = len+1;
    end
end

data_cell = struct2cell(trainingData); 
max_length = @(x) length(x); 
dim = cellfun(max_length,data_cell);
dim = squeeze(dim(3,:,:)); 

max_time = max(dim,[],'all');

% [T,angle] = size(trainingData); 
mean_x = zeros(angle,max_time); 
mean_y = zeros(angle,max_time);
x = zeros(T,angle,max_time);
y = zeros(T,angle,max_time);
    for a = 1:angle
        for times = 1:T
            x_coordinate = trainingData(times,a).handPos(1,:);
            y_coordinate = trainingData(times,a).handPos(2,:);
            x(times,a,:) = [x_coordinate x_coordinate(end)*ones(1,max_time-length(x_coordinate))];
            y(times,a,:) = [y_coordinate y_coordinate(end)*ones(1,max_time-length(y_coordinate))];
        end
        mean_x(a,:) = squeeze(mean(x(:,a,:),1))';
        mean_y(a,:) = squeeze(mean(y(:,a,:),1))';
    end
    
 for a = 1:angle
    for bin = 1:length(range)
        lin_reg_parameters(a,bin).x_coeff = mean_x(a,range(bin)); 
        lin_reg_parameters(a,bin).y_coeff = mean_y(a,range(bin));
    end
 end
modelParameters.LINREG = lin_reg_parameters;
modelParameters.pred_angle = [];

% Training the Bayesian Classifier
Y=repmat([1:1:8]',T,1);  
model = fitcnb(X0,Y,'DistributionNames','kernel'); 

modelParameters.model = model;
modelParameters.pred_angle = [];
end
