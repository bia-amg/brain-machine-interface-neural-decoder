%% Made by Little Clopaths Team - Imperial College London
% Team members: Beatriz R.F. Teixeira, Carolina Gomes, Elias Rabbat and
% Kevin Wang

function [decodedPosX, decodedPosY, newModelParameters] = positionEstimator(past_current_trial, modelParameters)

N = length(past_current_trial.spikes);
lda_par=2;
lda_angle=1:8;
[T,angle] = size(past_current_trial);
X0 = zeros(T*angle,98); 
X1 = zeros(T*angle,98); 
X2 = zeros(T*angle,98);
    if N==320
        section=1;
        len = 0;
        for times=1:1:T
            for a=1:angle
                len = len+1;
                X0(len,:) = mean(past_current_trial(times,a).spikes(:,1:N),2); 
                X1(len,:) = mean(past_current_trial(times,a).spikes(:,1:200),2); 
                X2(len,:) = mean(past_current_trial(times,a).spikes(:,200:320),2); 
            end
        end
        X = [X0,X1,X2]';
        N=size(X,2);
        Wknn=modelParameters.LDA1.Wknn;
        Xmean=modelParameters.LDA1.Xmean;
        LDAmean=modelParameters.LDA1.LDAmean;
        A_knn=Wknn'*(X-Xmean);
        pred_knn=zeros(1,size(A_knn,2));
        err_knn=zeros(1,size(A_knn,2));
        for n=1:size(A_knn,2)
            test_knn=A_knn(:,n);
            [err0_knn,ind0_knn]=mink(sum((abs(test_knn-LDAmean)).^lda_par),1);
        end

        er_knn=err0_knn(1);
        train_knn=lda_angle(ind0_knn(1));
        [~,~,temp_knn]=mode(train_knn);
        er_knn=er_knn(ismember(train_knn,temp_knn{1}'));
        train_knn=train_knn(ismember(train_knn,temp_knn{1}'));
        [temper,temp_knn]=min(er_knn);
        pred_knn(1,n)=train_knn(temp_knn);
        err_knn(1,n)=temper;
        pred_angle=pred_knn;
    
    elseif N==440
        section=2;
        len = 0; 
        X3 = zeros(T*angle,98); 
        for times=1:1:T
            for a=1:1:angle
                len = len+1;
                X0(len,:) = mean(past_current_trial(times,a).spikes(:,1:N),2); 
                X1(len,:) = mean(past_current_trial(times,a).spikes(:,1:200),2);
                X2(len,:) = mean(past_current_trial(times,a).spikes(:,200:320),2); 
                X3(len,:) = mean(past_current_trial(times,a).spikes(:,320:440),2); 
            end
        end
        X = [X0,X1,X2,X3]';
           
        Wknn=modelParameters.LDA2.Wknn;
        Xmean=modelParameters.LDA2.Xmean;
        LDAmean=modelParameters.LDA2.LDAmean;
        A_knn=Wknn'*(X-Xmean);
        vec_knn=1;
        pred_knn=zeros(length(vec_knn),size(A_knn,2));
        err_knn=zeros(length(vec_knn),size(A_knn,2));
        for n=1:size(A_knn,2)
                test_knn=A_knn(:,n);
                [err0_knn,ind0_knn]=mink(sum((abs(test_knn-LDAmean)).^lda_par),max(vec_knn));
        end
        er_knn=err0_knn(1);
        train_knn=lda_angle(ind0_knn(1));
        [~,~,temp_knn]=mode(train_knn);
        er_knn=er_knn(ismember(train_knn,temp_knn{1}'));
        train_knn=train_knn(ismember(train_knn,temp_knn{1}'));
        [temper,temp_knn]=min(er_knn);
        pred_knn(1,n)=train_knn(temp_knn);
        err_knn(1,n)=temper;
        pred_angle=pred_knn;
    
    elseif N==560
        section=3;
        len = 0;
        X3 = zeros(T*angle,98);
        X4 = zeros(T*angle,98);  
        for times=1:1:T
            for a=1:1:angle
                len = len+1;
                X0(len,:) = mean(past_current_trial(times,a).spikes(:,1:N),2); 
                X1(len,:) = mean(past_current_trial(times,a).spikes(:,1:200),2); 
                X2(len,:) = mean(past_current_trial(times,a).spikes(:,200:320),2);
                X3(len,:) = mean(past_current_trial(times,a).spikes(:,320:440),2);
                X4(len,:) = mean(past_current_trial(times,a).spikes(:,440:560),2);
            end
        end
            
        X = [X0,X1,X2, X3, X4]';
%         X=X';
        Wknn=modelParameters.LDA3.Wknn;
        Xmean=modelParameters.LDA3.Xmean;
        LDAmean=modelParameters.LDA3.LDAmean;
        A_knn=Wknn'*(X-Xmean);
        vec_knn=1;
        pred_knn=zeros(length(vec_knn),size(A_knn,2));
        err_knn=zeros(length(vec_knn),size(A_knn,2));
        for n=1:size(A_knn,2)
            test_knn=A_knn(:,n);
            [err0_knn,ind0_knn]=mink(sum((abs(test_knn-LDAmean)).^lda_par),max(vec_knn));

        end
        er_knn=err0_knn(1);
        train_knn=lda_angle(ind0_knn(1));
        [~,~,temp_knn]=mode(train_knn);
        er_knn=er_knn(ismember(train_knn,temp_knn{1}'));
        train_knn=train_knn(ismember(train_knn,temp_knn{1}'));
        [temper,temp_knn]=min(er_knn);
        pred_knn(1,n)=train_knn(temp_knn);
        err_knn(1,n)=temper;
        pred_angle=pred_knn;
    else       
        pred_angle = modelParameters.pred_angle;
    end 
    modelParameters.pred_angle = pred_angle;

    %% PCR regressor testing
    N = length(past_current_trial.spikes);
    if N>560
        N = 560;
    end
    dt = 20;
    len = 1;
    [T,angle] = size(past_current_trial); 
    X0 = zeros(T*angle,98); 
    lin_reg_avg = zeros(T*angle,98);
    lin_reg_total = zeros(T*angle,N/dt*98);
    for times=1:T
        for a=1:angle
            lin_reg_fr = zeros(98,length(0:dt:N)-1);
            for u=1:98
                data = past_current_trial(times,a).spikes(u,1:N);
                data(data==0) = NaN; 
                counter = histcounts([1:N].*data,(0:dt:N)+1);
                lin_reg_fr(u,:) = counter/dt;
            end
            lin_reg_avg(len,:) = mean(lin_reg_fr,2); 
%             lin_reg_reshape = reshape(lin_reg_fr,size(lin_reg_fr,1)*size(lin_reg_fr,2),1);
            lin_reg_total(len,:) = reshape(lin_reg_fr,size(lin_reg_fr,1)*size(lin_reg_fr,2),1); 
            len = len+1;
        end
    end
        lin_reg_bin=320:20:(length(lin_reg_total)/98);
        decodedPosX= modelParameters.LINREG(pred_angle,lin_reg_bin).x_coeff;
        decodedPosY= modelParameters.LINREG(pred_angle,lin_reg_bin).y_coeff;
      newModelParameters = modelParameters;
    