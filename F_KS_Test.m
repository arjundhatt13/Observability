%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% KS_Test
function ksstat = F_KS_Test(X, mu_0, sigma_0, alpha_0, beta_0, lambda_0, mu_i, sigma_i, alpha_i, beta_i, lambda_i, rho_i, dt, NJ)

% Initialize matrix to store cdf values evaluated at X
KS_cdf = zeros(length(X), 2);
KS_cdf(:, 1) = X;
    
% Calculates the CDF at all timepoints
for i = 1:length(X)
        
    KS_cdf(i, 2) = theor_cdf(X(i), mu_0, sigma_0, alpha_0, beta_0, lambda_0, mu_i, sigma_i, alpha_i, beta_i, lambda_i, rho_i, dt, NJ);
    
    % Corrects for outliers
    if isnan(KS_cdf(i, 2)) || isinf(KS_cdf(i, 2)) || KS_cdf(i, 2) < eps 
        
        KS_cdf(i, 2) = 0;

    elseif KS_cdf(i, 2) > 1 - eps

        KS_cdf(i, 2) = 1;
    
    end


end

% KS Test results
[~, ~, ksstat] = kstest(X, 'CDF', KS_cdf, 'Alpha', 0.01);

end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Theoretical CDF
function result = theor_cdf(x, mu_0, sigma_0, alpha_0, beta_0, lambda_0, mu_i, sigma_i, alpha_i, beta_i, lambda_i, rho_i, dt, NJ)

cumprob = 0;
result = 0;

% j is the total amount of jumps
for j = 0:NJ

    % j_0 is the amount of jumps from systemic asset
    for j_0 = 0:j  
        
        j_i = j - j_0; % Amount of jumps from ordinary asset

        temp = normcdf(x, ...
                      (mu_i - sigma_i^2) * dt + (rho_i * sigma_i * alpha_0 * j_0) + (sqrt(1 - rho_i^2) * sigma_i * alpha_i * j_i), ...
                      sigma_i * sqrt( dt + rho_i^2 * beta_0^2 * j_0 + (1-rho_i^2) * beta_i ^ 2 * j_i));   % CDF Evaluation
        
        prob = ((lambda_0 * dt) ^ j_0 * exp(-lambda_0 * dt) / factorial(j_0))... 
            * ((lambda_i * dt) ^ j_i * exp(-lambda_i * dt) / factorial(j_i)); % Poisson Probability
            
        cumprob = cumprob + prob;
        
        result = result + temp * prob;
    
    end     

end 

result = result / cumprob;

end
