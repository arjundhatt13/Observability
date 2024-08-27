%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Display Results
function res = H_Parameter_Display(SA_prices, SA_ticker, OA_prices, OA_tickers, mu_0, sigma_0, alpha_0, beta_0, lambda_0, mu, sigma, alpha, beta, lambda, rho, num_assets)

% Greeks
str_mu = sprintf('%c', 956);
str_sigma = sprintf('%c', 963);
str_alpha = sprintf('%c', 945);
str_beta = sprintf('%c', 946);
str_lambda = sprintf('%c', 955);
str_rho = sprintf('%c', 961);

% SA Parameter Table
if isempty(SA_prices)
    SA_parameter_table = cell(2, 5);
    SA_parameter_table(1,:) = {[str_mu char(8320)], [str_sigma char(8320)], [str_alpha char(8320)], [str_beta char(8320)], [str_lambda char(8320)] };
    SA_parameter_table(2,:) = {mu_0, sigma_0, alpha_0, beta_0, lambda_0};

else
% SA Parameter Table
    SA_parameter_table = cell(2, 7);
    SA_parameter_table(1,:) = {'Ticker', ['S' char(8320) '(0)'], [str_mu char(8320)], [str_sigma char(8320)], [str_alpha char(8320)], [str_beta char(8320)], [str_lambda char(8320)] };
    SA_parameter_table(2,:) = {SA_ticker, SA_prices(1), mu_0, sigma_0, alpha_0, beta_0, lambda_0};

end


% OA Parameter Table
OA_parameter_table = cell(num_assets + 1, 8);
OA_parameter_table(1,:) = {'Ticker', 'S(0)', str_mu, str_sigma, str_alpha, str_beta, str_lambda, str_rho};
OA_parameter_table(2:end, 1) = OA_tickers;

OA_parameter_table(2:end, 2) = num2cell(OA_prices(1,:));
OA_parameter_table(2:end, 3) = num2cell(mu);
OA_parameter_table(2:end, 4) = num2cell(sigma);
OA_parameter_table(2:end, 5) = num2cell(alpha);
OA_parameter_table(2:end, 6) = num2cell(beta);
OA_parameter_table(2:end, 7) = num2cell(lambda);
OA_parameter_table(2:end, 8) = num2cell(rho);


% Display Tables
disp(SA_parameter_table)
disp(OA_parameter_table)

% Blank return
res = "";

end
