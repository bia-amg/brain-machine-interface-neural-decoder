%% Made by Little Clopaths Team - Imperial College London
% Team members: Beatriz R.F. Teixeira, Carolina Gomes, Elias Rabbat and
% Kevin Wang

function [decodedPosX, decodedPosY, modelParameters] = positionEstimator_K(past_current_trial, modelParameters)

if length(past_current_trial.spikes) <= 320
    modelParameters.x_train = [past_current_trial.startHandPos; 0; 0]; 
    modelParameters.p_train = zeros(size(modelParameters.cov1));
end
    % Kalman Filter using the test data
    measured = mean(past_current_trial.spikes(:, end-165:end-100), 2);
    measured = (measured - modelParameters.AVG)./(modelParameters.STDEV);
    measured(isnan(measured)) = 0;
    measured(isinf(measured)) = 0;
    measured = (measured'*modelParameters.PCA)';

    % Prediction using the filter
    x_initial = modelParameters.A * modelParameters.x_train;
    p_initial = modelParameters.A * modelParameters.p_train * modelParameters.A' + modelParameters.cov1;


    % Updating the parameters
    Kgain = p_initial*modelParameters.H'/(modelParameters.H*p_initial*modelParameters.H' + modelParameters.cov2); 
    x_new_pred = x_initial + Kgain*(measured - modelParameters.H*x_initial);
    p_new_pred = (eye(size(Kgain, 1)) - Kgain * modelParameters.H)*p_initial;

    decodedPosX = x_new_pred(1); 
    decodedPosY = x_new_pred(2);
    
    modelParameters.p_train = p_new_pred;
    modelParameters.x_train = x_new_pred;
   
end

