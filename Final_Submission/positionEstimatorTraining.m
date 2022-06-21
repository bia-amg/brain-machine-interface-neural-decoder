%% Position estimator training code made by Little Clopaths Team - Imperial College London
% Team members: Beatriz R.F. Teixeira, Carolina Gomes, Elias Rabbat and
% Kevin Wang
function  [modelParameters] = positionEstimatorTraining(trainingData)
  
L=size(trainingData,1);

for section=1:3
    [T,angle] = size(trainingData);
    N=560;
    len = 0;
    X0 = zeros(T*angle,98);
    X1 = zeros(T*angle,98); 
    X2 = zeros(T*angle,98); 
    if section >= 2
        X3 = zeros(T*angle,98); 
    end
    if section == 3
        X4 = zeros(T*angle,98);
    end
    for times=1:T
        for a=1:angle
            len = len+1;
            X0(len,:) = mean(trainingData(times,a).spikes(:,1:N),2); 
            X1(len,:) = mean(trainingData(times,a).spikes(:,1:200),2);
            X2(len,:) = mean(trainingData(times,a).spikes(:,200:320),2);
            if section >= 2
                X3(len,:) = mean(trainingData(times,a).spikes(:,320:440),2);
            end
            if section == 3
            	X4(len,:) = mean(trainingData(times,a).spikes(:,440:560),2);
            end
        end
    end
    if section == 2
        x = [X0, X1, X2, X3];
    elseif section == 3
        x = [X0, X1, X2, X3, X4];
    else
        x = [X0, X1, X2];
    end
    X=x';
    Y=repmat([1:8]',T,1)';
    components_pca=175;
    N=size(X,2);
    Xmean=mean(X,2);
    input_pca=X-Xmean;
    S=input_pca'*input_pca/N;
    [output_pca,L]=eig(S);
    N=min(N,size(output_pca,2));
    [~,ind]=maxk(diag(L),N);
    output_pca=input_pca*output_pca(:,ind);
    output_pca=output_pca./sqrt(sum(output_pca.^2));
    c=unique(Y');
    input_lda=zeros(size(X,1),length(c));
    Xmean=mean(X,2);
    for im_id=1:length(c)
        input_lda(:,im_id)=mean(X(:,Y==c(im_id)),2);
    end
    scatter_1_lda=(input_lda-Xmean)*(input_lda-Xmean)';
    scatter_2_lda=(X-Xmean)*(X-Xmean)';
    scatter_3_lda=scatter_2_lda-scatter_1_lda;
    components_lda=components_pca;
    [w_lda,L] = eig((output_pca(:,1:components_lda)'*scatter_3_lda*output_pca(:,1:components_lda))^-1*output_pca(:,1:components_lda)'*scatter_1_lda*output_pca(:,1:components_lda));
    [~,ind]=maxk(diag(L),components_lda);
    Wknn=output_pca(:,1:components_lda)*w_lda(:,ind);
    W=Wknn'*(X-Xmean); 
    LDAmean=zeros([size(W,1) 8]);
    for k=1:8
        LDAmean(:,k)=mean(W(:,Y==k),2);
    end
    Parameters.Wknn=Wknn;
    Parameters.Xmean=Xmean;
    Parameters.LDAmean=LDAmean;

if section==1
   modelParameters.LDA1=Parameters;
elseif section ==2
   modelParameters.LDA2=Parameters;
else
   modelParameters.LDA3=Parameters;
end
end

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
            xdata=trainingData(times,a).spikes(1:98,:);
            ydata=trainingData(times,a).handPos(1:2,:);
            x_coordinate = trainingData(times,a).handPos(1,:);
            y_coordinate = trainingData(times,a).handPos(2,:);
            x(times,a,:) = [x_coordinate x_coordinate(end)*ones(1,max_time-length(x_coordinate))];
            y(times,a,:) = [y_coordinate y_coordinate(end)*ones(1,max_time-length(y_coordinate))];
        end
        mean_x(a,:) = squeeze(mean(x(:,a,:),1))';
        mean_y(a,:) = squeeze(mean(y(:,a,:),1))';
    end


% modelParameters.xdata=trainingData(1:80,1:8).spikes;
% modelParameters.ydata=trainingData(1:80,1:8).handPos;
 for a = 1:angle
    for bin = 1:length(range)
        lin_reg_parameters(a,bin).x_coeff = mean_x(a,range(bin)); 
        lin_reg_parameters(a,bin).y_coeff = mean_y(a,range(bin));
    end
 end
modelParameters.LINREG = lin_reg_parameters;
modelParameters.pred_angle = [];
modelParameters.trainingdata=trial;
    
end