%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Observable Systemic Asset - MLE
function res = F_SA_MLE(Z, h, NJ)

% Initialize DataSet
DataSet.Z = Z;
DataSet.number = length(Z);

% Define Objective Function
F = @(sol) object_fun_MLE(DataSet, sol(1), sol(2), sol(3), sol(4), sol(5), h, NJ);     

% Initial Guess
initial = eps + rand(1, 5); 

% Optimization Bounds
lb = [-inf; eps; -inf; eps; eps];
ub = [inf; inf; inf; inf; inf];

% Optimization (Using unconstrained optimization)
options = optimoptions('fmincon', 'Display', 'off', 'Algorithm', 'interior-point');
[sol, fval] = fmincon(F, initial, [], [], [], [], lb, ub, [], options);

% Parameter manipulation to ensure bounds are respected
mu_0 = sol(1);
sigma_0 = sol(2);
alpha_0 = sol(3);
beta_0 = sol(4);
lambda_0 = sol(5);

% Optimization Solution
res = [ fval mu_0 sigma_0 alpha_0 beta_0 lambda_0];

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Objective Function (MLE)

function result = object_fun_MLE(DS, mu_0, sigma_0, alpha_0, beta_0, lambda_0, h, NJ)

theory = zeros(1, DS.number);  % Initializes theoretical log-likelihood array

% Parameter Adjustments
mu_ = mu_0 * h;
sigma_ = sigma_0 * sqrt(h);
lambda_ = lambda_0 * h;

% Loops through all the trading days
for i = 1:DS.number
        
    theory(i) = theor_pdf(DS.Z(i), mu_, sigma_, alpha_0, beta_0, lambda_, NJ);
    
    % Correction for outliers in data
    if theory(i) < eps
        
        theory(i) = eps;
    
    end

end

result = -sum(log(theory));  % First converts to log-likelihood, and then takes the negative sum (goal is thereby to minimize negative sum)

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Theoretical PDF
% Given in Section 2.2.1 of the paper
function result = theor_pdf(x, mu_, sigma_, alpha_0, beta_0, lambda_, NJ)

% Case with no jumps
result = normpdf(x, mu_, sigma_);
cumprob = 1; prob = 1; % Used to normalize probabilities

% Loops through 1:NJ jumps
for l = 1:NJ
  
    temp = normpdf(x, mu_ + alpha_0 * l, sqrt(sigma_^2 + beta_0^2*l)); % Normal probability of observing j jumps
  
  prob = prob * lambda_/l;  % Poisson probability of l jumps
  cumprob = cumprob + prob;
  result = result + temp * prob; 

end 

result = result / cumprob;

end
