%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Conduct Tests Comparing Approaches
warning('off')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Test Settings

num_tests = 1000;  % Amount of test iterations

SA_ticker = 'SPY';  % Systemic Asset

iter = 5;  % Amount of MLE iterations
NJ = 10;  % Maximum amount of jumps in any given time-step (MLE)
h = 1/252;  % Discretized time-step


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Testing

testing_matrix = zeros(num_tests, 8);  % Matrix which stores test data

% Calculates K-Score for each Asset
for i = 1:num_tests
    i
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Input Parameters


    %%%%%%%%%%%%% Randomizes the amount of assets

    % S&P 500 stocks with historical data since 2019
    OA_ticker_list = {'MMM','ABT','MO','AEP','ADM','BA','BMY','CPB','CAT','CVX','CMS','KO','CL','COP','ED','CSX','CVS','DE','DTE','ETN','EIX','ETR','EXC','XOM','F','GE','GD','GIS','HAL','HIG','HSY','HON','IBM','IP','KMB','KR','LMT','MRO','MRK','MSI','NSC','NOC','OXY','PEP','PFE','PPG','PG','PEG','RTX','SPGI','SLB','SO','UNP','XEL','SHW','CMI','EMR','CLX','NEM','MCD','LLY','BAX','BDX','JNJ','GPC','HPQ','WMB','JPM','IFF','AXP','BAC','CI','DUK','TAP','NEE','DIS','WFC','INTC','TGT','TXT','WY','WBA','AIG','FDX','PCAR','ADP','MAS','GWW','WMT','SNA','SWK','BF-B','AAPL','CAG','BBWI','T','VZ','LOW','PHM','HES','HAS','BALL','APD','NUE','RVTY','CNP','TJX','DOV','PH','ITW','MDT','SYY','MMC','AVY','HD','PNC','C','NKE','ECL','GL','ORCL','K','ADSK','AEE','AMGN','LIN','IPG','MS','COST','CSCO','EMN','KEY','MSFT','LUV','UNH','MU','PARA','BSX','GLW','AMAT','BK','DRI','L','ALL','FITB','AON','AZO','ADBE','CAH','SCHW','EFX','APA','PGR','HBAN','KLAC','YUM','FE','TFC','CINF','OMC','NTRS','BEN','MAR','COF','MCO','RF','WM','PAYX','AES','DHR','CCL','MCK','AFL','NTAP','BBY','VMC','QCOM','PNW','ADI','USB','ROK','A','SBUX','DVN','EOG','NI','INTU','MET','SYK','CTAS','TXN','FI','ZBH','COR','PPL','NVDA','EQR','WAT','SPG','EBAY','EA','GS','PFG','PRU','UPS','ELV','TRV','CMCSA','DGX','VLO','STT','MKC','GEN','PLD','BIIB','MTB','VTRS','GILD','TMO','TPR','LH','DHI','STZ','TSN','PSA','AMP','LEN','AMZN','EL','VRSN','GOOG','BXP','KIM','JNPR','CME','CBRE','FIS','CTSH','AVB','RL','CHRW','HST','AIZ','DFS','AKAM','MCHP','ICE','EXPE','EXPD','J','AMT','DOC','PM','ISRG','CTRA','MA','DVA','IVZ','CF','FAST','CRM','LHX','APH','NDAQ','WEC','SJM','WYNN','RSG','IRM','WELL','HRL','VTR','ORLY','PWR','WDC','ES','FMC','BKNG','ROST','V','ROP','NRG','BRK-B','OKE','KMX','CB','JCI','TT','FFIV','NFLX','EW','BLK','CMG','FCX','MPC','ACN','MOS','TEL','XYL','BWA','DLTR','CCI','PSX','KMI','MNST','LRCX','STX','LYB','PNR','MDLZ','DG','HUM','GRMN','APTV','ABBV','REGN','GM','ZTS','NWSA','DAL','AME','VRTX','ALLE','META','MHK','TSCO','ESS','GOOGL','AVGO','MLM','URI','UHS','RCL','HCA','SWKS','HSIC','EQIX','AAL','O','QRVO','JBHT','KHC','PYPL','UAL','NWS','VRSK','HPE','SYF','CHD','WTW','EXR','CFG','FRT','AWK','UDR','CNC','HOLX','ULTA','GPN','DLR','LKQ','AJG','TDG','ALB','LNT','FTV','MTD','CHTR','COO','HWM','D','MAA','IDXX','INCY','CBOE','REG','SNPS','SRE','AMD','ARE','RJF','IT','ALGN','ANSS','EG','HLT','BKR','AOS','MGM','PKG','RMD','IQV','SBAC','CDNS','NCLH','HII','TTWO','MSCI','EVRG','BR','CPAY','CPRT','ANET','ROL','FTNT','KEYS','JKHY','FANG','LW','CE'};

    % Randomize number of assets and assets selected
    num_assets = randi([1, 10]); % Between 1 - 10 assets

    OA_tickers = OA_ticker_list(randi([1, length(OA_ticker_list)], 1, num_assets)); % Random stocks from OA_ticker_list

    % Randomizes the length and start of time period
    period_length = randi([182, 750]); % Between 0.5-2 Years 
    
    period_start = randi([0, 2046 - period_length]); % Amount of days since Jan 1st, 2019

    start_date = datetime(2019, 01, 01) + days(period_start);
    end_date = start_date + days(period_length);

    %%%%%%%%%%%%% Randomizes the length and start of time period
    [kstest_score, t1, t2, OBS_KS_mean, UNOBS_KS_mean] = TA_Approach(SA_ticker, OA_tickers, start_date, end_date, h, iter, NJ);
    
    %%%%%%%%%%%%% Randomizes the length and start of time period
    testing_matrix(i, 1) = num_assets;
    testing_matrix(i, 2) = period_length;
    testing_matrix(i, 3) = days(start_date - datetime(2019, 01, 01));
    testing_matrix(i, 4) = kstest_score;
    testing_matrix(i, 5) = t1;
    testing_matrix(i, 6) = t2;
    testing_matrix(i, 7) = OBS_KS_mean;
    testing_matrix(i, 8) = UNOBS_KS_mean;


end
 


