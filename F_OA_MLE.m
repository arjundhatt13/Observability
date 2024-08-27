%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Observable Ordinary Asset - MLE
function res = F_OA_MLE(X_i, Z, a_i, h, NJ)

% Initialize DataSet
DataSet.X = X_i;
DataSet.Z = Z;
DataSet.number = length(Z);


%%% How we handle the optimization wrt a_i depends on the approach we use

% Observable Approach
if isempty(a_i) 
    % Define Objective Function
    F = @(sol) object_fun_MLE(DataSet, sol(1), sol(2), sol(3), sol(4), sol(5), sol(6), h, NJ);     

    % Parameter Bounds
    lb = [-inf; eps; -inf; eps; eps; -1 + eps];
    ub = [inf; inf; inf; inf; inf; 1 - eps];
    initial = eps + rand(6,1);



    % Optimization Options (Using constrained optimization)
    options = optimoptions('fmincon', 'Display', 'off', 'Algorithm', 'interior-point');
    [sol, fval] = fmincon(F, initial, [], [], [], [], lb, ub, [], options);
    
    % Parameters
    mu = sol(1);
    sigma = sol(2);
    alpha = sol(3);
    beta = sol(4);
    lambda = sol(5);
    a_i = sol(6);
    
    % Optimization Solution
    res = [fval mu sigma alpha beta lambda a_i];

% Unobservable Approach
else
    % Define Objective Function
    F = @(sol) object_fun_MLE(DataSet, sol(1), sol(2), sol(3), sol(4), sol(5), a_i, h, NJ);     

    % Initial Guess
    initial = eps + rand(1, 5); 

    % Parameter Bounds
    lb = [-inf; eps; -inf; eps; eps];
    ub = [inf; inf; inf; inf; inf];


    % Optimization Options (Using constrained optimization)
    options = optimoptions('fmincon', 'Display', 'off', 'Algorithm', 'interior-point');
    [sol, fval] = fmincon(F, initial, [], [], [], [], lb, ub, [], options);
    
    % Parameters
    mu = sol(1);
    sigma = sol(2);
    alpha = sol(3);
    beta = sol(4);
    lambda = sol(5);
    
    % Optimization Solution
    res = [fval mu sigma alpha beta lambda a_i];

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Objective Function (MLE)

function result = object_fun_MLE(DS, mu, sigma, alpha, beta, lambda, a_i, h, NJ)

theory = zeros(1, DS.number); % Initializes theoretical log-likelihood array

% Parameter Adjustments
mu_ = mu * h;
sigma_ = sigma * sqrt(h);
lambda_ = lambda * h;

% Loops through all the trading days
for i = 1:DS.number

    theory(i) = theor_pdf(DS.X(i), DS.Z(i), mu_, sigma_, alpha, beta, lambda_, a_i, NJ);
    
    % Correction for outliers in data
    if theory(i) < eps
        
        theory(i) = eps;
    
    end

end

result = -sum(log(theory)); % First converts to log-likelihood, and then takes the negative sum (goal is thereby to minimize negative sum)

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Conditional PDF
% Given in Section 2.2.2 of the paper
function result = theor_pdf(x, z, mu_, sigma_, alpha, beta, lambda_, a_i, NJ)

% Case with no jumps
result = normpdf(x, a_i .* z + mu_, sigma_);
cumprob = 1; prob = 1; % Used to normalize probabilities

for l = 1:NJ
    
    temp = normpdf(x, a_i .* z + mu_ + alpha * l, sqrt(sigma_^2 + beta^2 * l)); % Normal conditional probability of observing j jumps
    
    prob = prob * lambda_ / l;  % Poisson probability of l jumps
    cumprob = cumprob + prob;
    result = result + temp * prob;
    
end 

result = result / cumprob;

end

end