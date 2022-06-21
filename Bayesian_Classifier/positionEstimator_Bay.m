%% Made by Little Clopaths Team - Imperial College London
% Team members: Beatriz R.F. Teixeira, Carolina Gomes, Elias Rabbat and
% Kevin Wang

function [decodedPosX, decodedPosY, newModelParameters] = positionEstimator_Bay(past_current_trial, modelParameters)

N = length(past_current_trial.spikes);
    if N==320 || N==400 || N==480 || N==560
        model=modelParameters.model;
        pred_angle = predict(model, X0);
        modelParameters.pred_angle=pred_angle;
    else
        pred_angle = modelParameters.pred_angle;
    end

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

    lin_reg_bin = length(lin_reg_total)/98-(320/dt-1);
    decodedPosX= modelParameters.LINREG(pred_angle,lin_reg_bin).x_coeff;
    decodedPosY= modelParameters.LINREG(pred_angle,lin_reg_bin).y_coeff;
    newModelParameters = modelParameters;
end
    