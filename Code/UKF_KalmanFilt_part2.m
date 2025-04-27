clear; % Clear variables
addpath('../data')
datasetNum = 1; % CHANGE THIS VARIABLE TO CHANGE DATASET_NUM
[sampledData, sampledVicon, sampledTime, proj2Data] = init(datasetNum);
% Set initial condition
uPrev = vertcat(sampledVicon(1:9,1),zeros(6,1)); % Copy the Vicon Initial state
covarPrev = 0.1*eye(15); % Covariance constant
savedStates = zeros(15, length(sampledTime)); %Just for saving state his.
prevTime = 0;
vel = proj2Data.linearVel;
angVel2 = proj2Data.angVel;
%% Calculate Kalmann Filter
for i = 1:length(sampledTime)
    %% FILL IN THE FOR LOOP
    [covarEst,uEst] = pred_step(uPrev,covarPrev,sampledData(i).omg,sampledData(i).acc,sampledTime(i)-prevTime);
    [uCurr,covar_curr] = upd_step([vel(i,:)';angVel2(i,:)'],covarEst,uEst);
    savedStates(:,i)=uCurr;
    uPrev = uCurr;
    covarPrev = covar_curr;
    prevTime = sampledTime(i);
end

plotData(savedStates, sampledTime, sampledVicon, 2, datasetNum);