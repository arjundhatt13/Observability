%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Testing of the Observable Approach
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Inputs
% Basket of Assets
SA_ticker = 'SPY';  % Systemic Asset
OA_tickers = {'AAPL', 'AMZN', 'BEKE', 'BRK-B', 'MDGL', 'SQQQ', 'TQQQ', 'TSLA'};  % Ordinary Assets

% Historical Data Period
start_date = datetime(2021, 04, 26);
end_date = datetime(2023, 04, 26);

% Other
iter = 5;           % Amount of MLE iterations
NJ = 20;            % Maximum amount of jumps in any given time-step (MLE)
h = 1/252;          % Discretized time-step


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Scrapes Data
% Calls Empirical Data Scraper Helper
SA_prices = H_Empirical_Data_Scraper(SA_ticker, start_date, end_date, '1d').AdjClose; % Systemic Risk Asset Data

num_assets = size(OA_tickers, 2);  % Calculate number of assets
t = size(SA_prices,1);  % Calculate number of trading days

OA_prices = zeros(t, num_assets);  % Initializes a t x n matrix which will store ordinary asset data

% Scrapes Ordinary Assets Data
for i = 1:length(OA_tickers)

    temp_data = H_Empirical_Data_Scraper(OA_tickers{i}, start_date, end_date, '1d').AdjClose;

    OA_prices(:,i) = temp_data;

end

% Convert price data to Log-Returns
X = diff(log(OA_prices));       % Ordinary Assets Log-Returns
Z = diff(log(SA_prices));       % Systemic Asset Log-Returns


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Function Calls
% Calls Observable Approach
[mu_0, sigma_0, alpha_0, beta_0, lambda_0, mu, sigma, alpha, beta, lambda, a] = A_Observable(Z, X, num_assets, h, iter, NJ);


% Calls Parameter Mapping Function
[mu_0_tilde, sigma_0_tilde, lambda_0_tilde, alpha_0_tilde, beta_0_tilde, mu_tilde, sigma_tilde, lambda_tilde, alpha_tilde, beta_tilde, rho_tilde] = F_Parameter_Mapping(mu_0, sigma_0, alpha_0, beta_0, lambda_0, mu, sigma, alpha, beta, lambda, a);

% Calls Parameter Display Helper
res = H_Parameter_Display([], [], OA_prices, OA_tickers, mu_0_tilde, sigma_0_tilde, alpha_0_tilde, beta_0_tilde, lambda_0_tilde, mu_tilde, sigma_tilde, alpha_tilde, beta_tilde, lambda_tilde, rho_tilde, num_assets)