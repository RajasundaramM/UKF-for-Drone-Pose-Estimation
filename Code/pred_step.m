 function [covarEst,uEst] = pred_step(uPrev,covarPrev,angVel,acc,dt)
%% BEFORE RUNNING THE CODE CHANGE NAME TO pred_step
    %% Parameter Definition
    % uPrev - is the mean of the prev state
    %covarPrev - covar of the prev state
    %angVel - angular velocity input at the time step
    %acc - acceleration at the timestep
    %dt - difference in time 
    
    %Choosing Sigma Points
    n_x=15;
    n_q=12;
    alpha = 0.001;
    beta=2;
    k=1;
    n = n_x+n_q;
    Q = 0.001*eye(n_q);
    u_aug = [uPrev;zeros(n_q,1)];
    covar_aug = zeros(n);
    covar_aug(1:n_x,1:n_x)=covarPrev;
    covar_aug(n_x+1:n,n_x+1:n) =dt*Q;
    rt_sig = chol(covar_aug)';
    lambda = (alpha)^2*(n+k)-n;
    X_aug = zeros(n,2*n+1);
    X_aug(:,1) = u_aug;
    c = sqrt(n+lambda);
    for i=1:n
        X_aug(:,2*i) = u_aug-c*rt_sig(:,i);
        X_aug(:,2*i+1) = u_aug+c*rt_sig(:,i);
    end

    %Propogation through f
    Y = zeros(n_x,2*n+1);
    for i=1:2*n+1
        x_dot = zeros(n_x,1);
        x_dot(1:3) = X_aug(7:9,i);
        x_dot(10:n_x) = X_aug(22:n,i);
        R = rotz(X_aug(6,i))*roty(X_aug(5,i))*rotx(X_aug(4,i));
        G = [cos(X_aug(5,i))*cos(X_aug(6,i)),-sin(X_aug(4,i)),0;cos(X_aug(5,i))*sin(X_aug(6,i)),cos(X_aug(4,i)),0;-sin(X_aug(5,i)),0,1];
        x_dot(4:6) = (G\R)*(angVel-X_aug(10:12,i)-X_aug(16:18,i));
        x_dot(7:9) = [0;0;-9.8] + R*(acc-X_aug(13:15,i)-X_aug(19:21,i));

        Y(1:9,i)=X_aug(1:9,i)+dt*x_dot(1:9);
        Y(10:n_x,i) = X_aug(10:n_x,i)+x_dot(10:n_x);
    end

    %Copmuting Predicted Mean and Covar
    uEst = Y(:,1)*(lambda/(n+lambda));
    for i=2:2*n+1
        uEst=uEst+(Y(:,i)/(2*(n+lambda)));
    end

    covarEst = ((lambda/(n+lambda))+(1-alpha^2+beta))*(Y(:,1)-uEst)*(Y(:,1)-uEst)';
    for i=2:2*n+1
        covarEst = covarEst + ((Y(:,i)-uEst)*(Y(:,i)-uEst)'/(2*(n+lambda)));
    end
end



