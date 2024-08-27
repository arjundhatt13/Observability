%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parameter Mapping as explained in Section 3.3 of the paper
function [mu_0_tilde, sigma_0_tilde, alpha_0_tilde, beta_0_tilde, lambda_0_tilde, mu_tilde, sigma_tilde, alpha_tilde, beta_tilde, lambda_tilde, rho_tilde] = H_Parameter_Mapping(mu_0, sigma_0, alpha_0, beta_0, lambda_0, mu, sigma, alpha, beta, lambda, a)

% Given in Section 3.3 of the paper

sigma_0_tilde = sigma_0;
mu_0_tilde = mu_0 + sigma_0^2 / 2;
lambda_0_tilde = lambda_0;
alpha_0_tilde = alpha_0 / sigma_0;
beta_0_tilde = beta_0 / sigma_0;

sigma_tilde = sqrt(sigma.^2 + a.^2 * sigma_0.^2);
mu_tilde = mu + a .* mu_0 + sigma_tilde.^2 ./ 2;
lambda_tilde = lambda;
alpha_tilde = alpha ./ sigma;
beta_tilde = beta ./ sigma;
rho_tilde = sigma_0 .* a ./ sigma_tilde;

