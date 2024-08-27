%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Auxillary Function for Approach Testing
function [kstest_score, t1, t2, OBS_KS_mean, UNOBS_KS_mean] = TA_Approach(SA_ticker, OA_tickers, start_date, end_date, h, iter, NJ)


%%%%%%%%%%%%%%%%%%%%%%%%%%%% Scrape Data
% Systemic Asset
SA_prices = H_Empirical_Data_Scraper(SA_ticker, start_date, end_date, '1d').AdjClose;  % Systemic Asset Data

% Ordinary Assets
num_assets = size(OA_tickers, 2);  % Calculate number of assets
t = size(SA_prices,1);  % Calculate number of trading days

OA_prices = zeros(t,num_assets);  % Initializes a t x n matrix which will store ordinary asset data

% Scrape Ordinary Asset Data
for i = 1:length(OA_tickers)

    temp_data = H_Empirical_Data_Scraper(OA_tickers{i}, start_date, end_date, '1d').AdjClose;

    OA_prices(:,i) = temp_data;

end

% Convert price data to Log-Returns
X = diff(log(OA_prices));       % Ordinary Assets Log-Returns
Z = diff(log(SA_prices));       % Systemic Asset Log-Returns


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Estimate Model Parameters
%%%% Observable Approach
t1 = tic;
[OBS_mu_0, OBS_sigma_0, OBS_alpha_0, OBS_beta_0, OBS_lambda_0, OBS_mu, OBS_sigma, OBS_alpha, OBS_beta, OBS_lambda, OBS_a] = A_Observable(Z, X, num_assets, h, iter, NJ);
t1 = toc(t1);

% Calls Parameter Mapping Function
[OBS_mu_0_tilde, OBS_sigma_0_tilde, OBS_alpha_0_tilde, OBS_beta_0_tilde, OBS_lambda_0_tilde, OBS_mu_tilde, OBS_sigma_tilde, OBS_alpha_tilde, OBS_beta_tilde, OBS_lambda_tilde, OBS_rho_tilde] = F_Parameter_Mapping(OBS_mu_0, OBS_sigma_0, OBS_alpha_0, OBS_beta_0, OBS_lambda_0, OBS_mu, OBS_sigma, OBS_alpha, OBS_beta, OBS_lambda, OBS_a);


%%%% Unobservable Approach
t2 = tic;
[UNOBS_mu_0, UNOBS_sigma_0, UNOBS_alpha_0, UNOBS_beta_0, UNOBS_lambda_0, UNOBS_mu, UNOBS_sigma, UNOBS_alpha, UNOBS_beta, UNOBS_lambda, UNOBS_a] = A_Unobservable(X, num_assets, h, iter, NJ);
t2 = toc(t2);

% Calls Parameter Mapping Function
[UNOBS_mu_0_tilde, UNOBS_sigma_0_tilde, UNOBS_alpha_0_tilde, UNOBS_beta_0_tilde, UNOBS_lambda_0_tilde, UNOBS_mu_tilde, UNOBS_sigma_tilde, UNOBS_alpha_tilde, UNOBS_beta_tilde, UNOBS_lambda_tilde, UNOBS_rho_tilde] = F_Parameter_Mapping(UNOBS_mu_0, UNOBS_sigma_0, UNOBS_alpha_0, UNOBS_beta_0, UNOBS_lambda_0, UNOBS_mu, UNOBS_sigma, UNOBS_alpha, UNOBS_beta, UNOBS_lambda, transpose(UNOBS_a));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% KS Test

% KS Test for Observable Assumption
OBS_KS_k = zeros(num_assets, 1);

for i = 1:num_assets

    OBS_KS_k(i) = F_KS_Test( X(:, i), OBS_mu_0_tilde, OBS_sigma_0_tilde, OBS_alpha_0_tilde, OBS_beta_0_tilde, OBS_lambda_0_tilde, OBS_mu_tilde(i), OBS_sigma_tilde(i), OBS_alpha_tilde(i), OBS_beta_tilde(i), OBS_lambda_tilde(i), OBS_rho_tilde(i), h, NJ);

end

% KS Test for Unobservable Assumption
UNOBS_KS_k = zeros(num_assets, 1);

for i = 1:num_assets

    UNOBS_KS_k(i) = F_KS_Test(X(:, i), UNOBS_mu_0_tilde, UNOBS_sigma_0_tilde, UNOBS_alpha_0_tilde, UNOBS_beta_0_tilde, UNOBS_lambda_0_tilde, UNOBS_mu_tilde(i), UNOBS_sigma_tilde(i), UNOBS_alpha_tilde(i), UNOBS_beta_tilde(i), UNOBS_lambda_tilde(i), UNOBS_rho_tilde(i), h, NJ);
    
end


% KS Score Metric given in Section 4.1.3 of the paper
kstest_score = sum(double((OBS_KS_k < UNOBS_KS_k))) / num_assets;
OBS_KS_mean = mean(OBS_KS_k);
UNOBS_KS_mean = mean(UNOBS_KS_k);



end