%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% The Observable Approach - Estimation of Parameters 
function [mu_0, sigma_0, alpha_0, beta_0, lambda_0, mu, sigma, alpha, beta, lambda, a] = A_Observable(Z, X, num_assets, h, iter, NJ)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Estimation of parameters of the systemic-risk asset
% Optimization Algorithm (MLE)    

best_res = F_SA_MLE(Z, h, NJ);  % Sets the "best" iteration as the first

% Loops through "iter" iterations to find "best" iteration
for j = 2:iter

    res = F_SA_MLE(Z, h, NJ);

    if res(1) < best_res(1)  % Compares log-likelihood values to assert better estimation

        best_res = res;

    end

end

% SA Parameters
mu_0 = best_res(2);
sigma_0 = best_res(3);
alpha_0 = best_res(4);
beta_0 = best_res(5);
lambda_0 = best_res(6);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Estimation of OA parameters

% Initialize parameter arrays
mu = zeros(1,num_assets);
sigma = zeros(1,num_assets);
alpha = zeros(1,num_assets);
beta = zeros(1,num_assets);
lambda = zeros(1,num_assets);
a = zeros(1,num_assets);

% Loops through each ordinary asset
for i = 1:num_assets 

    X_i = X(:, i);      % Log-return of asset i
        
    % Optimization Algorithm
    best_res = F_OA_MLE(X_i, Z, [], h, NJ);  % Sets the "best" iteration as the first
    
    % Loops through "iter" iterations to find "best" iteration
    for j = 2:iter
        
        res = F_OA_MLE(X_i, Z, [], h, NJ);
        
        if res(1) < best_res(1)  % Compares log-likelihood values to assert better estimation
            
            best_res = res;
        
        end
    
    end
    
    % Stores Ordinary Asset Parameters
    mu(i) = best_res(2); 
    sigma(i) = best_res(3); 
    alpha(i) = best_res(4); 
    beta(i) = best_res(5);  
    lambda(i) = best_res(6); 
    a(i)  = best_res(7);

end

end
