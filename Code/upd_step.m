function [uCurr,covar_curr] = upd_step(z_t,covarEst,uEst)
%% BEFORE RUNNING THE CODE CHANGE NAME TO upd_step
    %% Parameter Definition
    %z_t - is the sensor data at the time step
    %covarEst - estimated covar of the  state
    %uEst - estimated mean of the state
    R = 0.15*eye(3);
    Rb2c = rotx(pi)*rotz(pi/4);
    Pc2b = -Rb2c'*[-0.04;0;-0.03];
    Sb2c = [0,-Pc2b(3),Pc2b(2);Pc2b(3),0,-Pc2b(1);-Pc2b(2),Pc2b(1),0];
    C = [Rb2c,-Rb2c*Sb2c];

   %Computing Sigma Points
    n=15;
    alpha = 0.001;
    beta=2;
    k=1;
    lambda = (n+k)*(alpha^2)-n;
    c = sqrt(n+lambda);
    X = zeros(n,2*n+1);
    X(:,1)=uEst;
    rt_sig = chol(covarEst)';
    for i=1:n
        X(:,2*i) = uEst-c*rt_sig(:,i);
        X(:,2*i+1) = uEst+c*rt_sig(:,i);
    end

    %Propogate sigma points for Z
    Z = zeros(3,2*n+1);
    for i=1:2*n+1
        Rb2w = rotz(X(6,i))*roty(X(5,i))*rotx(X(4,i));
        Z(:,i) = C*[Rb2w'*X(7:9,i);Rb2c'*z_t(4:6)];
    end

    %Update step
    z = Z(:,1)*(lambda/(n+lambda));
    for i=2:2*n+1
        z = z+(Z(:,i)/(2*(n+lambda)));
    end

    Ct =  ((lambda/(n+lambda))+(1-alpha^2 + beta))*(X(:,1)-uEst)*(Z(:,1)-z)';
    for i=2:2*n+1
        Ct =  Ct+ ((X(:,i)-uEst)*(Z(:,i)-z)'/(2*(n+lambda)));
    end

    St = ((lambda/(n+lambda))+(1-alpha^2 + beta))*(Z(:,1)-z)*(Z(:,1)-z)';
    for i=2:2*n+1
        St =  St+ ((1/2*(n+lambda))*(Z(:,i)-z)*(Z(:,i)-z)');
    end
    St=St+R;
    Kt = Ct/(St);

    uCurr = uEst+Kt*(z_t(1:3)-z);
    covar_curr = covarEst - Kt*St*Kt';
end

