%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% READ ME

%%%%%%%%%%%%%%%%%%%%%%%% The files are labelled as following:

%%%%%%% A_ = Observable and Unobservable Approaches 

% A_Observable = The calculation of (unmapped) model parameters using the
% Observable Approach given in Section 3.1 of the paper.

% A_Unobservable = The calculation of (unmapped) model parameters using the
% Unobservable Approach given in Section 3.2 of the paper.

%%%%%%% F_ = Functions (Mathematical) 

% F_KS_Test = The calculation of the KS statistic using the
% Kolmogorov-Smirnov Test given in Section 4.1.3 of the paper.

% F_OA_MLE = The optimization routine for the estimation of idiosyncratic 
% factor (unmapped) parameters discussed in Section 3.0 of the paper.

% F_Parameter_Mapping = The mapping of parameters as discussed in Section 
% 3.3 of the paper.

% F_SA_MLE = The optimization routine for the estimation of systemic factor 
% (unmapped) parameters discussed in Section 3.0 of the paper.

%%%%%%% H_ = Helpers (Non-Mathematical)

% H_Empirical_Data_Scraper = Scrapes historical asset empirical
% data from yfinance.

% H_Parameter Display = Displays the parameters of the model in tabular
% form.

%%%%%%% T_ = Testing (Scripts)

% T_Approach = Contains the code for collecting data which can be used for 
% an empirical study comparing the two approaches. The actual data analysis
% is conducted in the R code provided.

% T_Observable = Contains the code for estimating the model parameters
% under the Observable Approach. Estimates, maps, and displays these
% parameters. 

% T_SRA = Contains the code for collecting data which can be used for 
% an empirical study comparing systemic assets. The actual data analysis
% is conducted in the R code provided.

% T_Unobservable = Contains the code for estimating the model parameters
% under the Unobservable Approach. Estimates, maps, and displays these
% parameters.

%%%%%%% TA_ = Testing Auxillary (Called by T_ scripts)

% TA_Approach = Actually facilitates the testing of approaches called upon 
% in T_Approach by calling appropriate functions.

% TA_SRA = Actually facilitates the testing of systemic assets called upon 
% in T_SRA by calling appropriate functions.


%%%%%%%%%%%%%%%%%%%%%%%% Thanks for reading! 
% Feel free to reach out to dhat4960@mylaurier.ca if you have any further 
% questions about the code or if you want to offer me a quant job ...
% preferably the latter :)