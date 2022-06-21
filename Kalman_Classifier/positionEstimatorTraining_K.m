%% Made by Little Clopaths Team - Imperial College London
% Team members: Beatriz R.F. Teixeira, Carolina Gomes, Elias Rabbat and
% Kevin Wang
function [modelParameters] = positionEstimatorTraining(trainingData)

[T,A] = size(trainingData);

% Variable initialisation
matrix_X = zeros(4, 12000);
matrix_Y = zeros(4, 12000);
matrix_YH = zeros(98,12000);
counter= 0;
   
for time = 1:T
    for angle = 1:A
        for t = 180:20:length(trainingData(time, angle).spikes)
            counter = counter + 1;
            matrix_X(1:2, counter) = trainingData(time, angle).handPos(1:2, t-20);
            matrix_X(3:4, counter) = (trainingData(time, angle).handPos(1:2, t-20) - trainingData(time, angle).handPos(1:2, t-40))/0.02;
            matrix_Y(1:2, counter) = trainingData(time, angle).handPos(1:2, t);
            matrix_Y(3:4, counter) = (trainingData(time, angle).handPos(1:2, t) - trainingData(time, angle).handPos(1:2, t-20))/0.02;
            matrix_YH(:, counter) = mean(trainingData(time, angle).spikes(:, t-179:t-100), 2);
        end     
    end
end
matrix_X = matrix_X(:, 1:counter); % remove extra zero elements
matrix_XH = matrix_X(:, 1:counter);
matrix_Y = matrix_Y(:, 1:counter);

% Saving model parameters
modelParameters.AVG = mean(matrix_YH(:, 1:counter), 2);
modelParameters.STDEV = std(matrix_YH(:, 1:counter), [], 2);


matrix_YH = (matrix_YH(:, 1:counter) - modelParameters.AVG)./modelParameters.STDEV;
matrix_YH(isnan(matrix_YH)) = 0;
matrix_YH(isinf(matrix_YH)) = 0;

% Performing PCA
C = cov(matrix_YH');
[V_eig,D] = eig(C);
[~,I] = maxk(abs(diag(D)), 97);
modelParameters.PCA = V_eig(:, I);
matrix_YH = (matrix_YH'*modelParameters.PCA)'; 

[A,B,V] = svds(matrix_X, 4); 
modelParameters.A = matrix_Y*(V/B)*A';
[A,B,V] = svds(matrix_XH, 4);
modelParameters.H = matrix_YH*(V/B)*A';

modelParameters.cov1 = (matrix_Y - modelParameters.A*matrix_X)*(matrix_Y - modelParameters.A*matrix_X)'/(length(matrix_Y));
modelParameters.cov2 = (matrix_YH - modelParameters.H*matrix_XH)*(matrix_YH - modelParameters.H*matrix_XH)'/(length(matrix_YH)); 
  
end

