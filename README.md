Predicting the direction of S&P500 Stock price using Machine Learning S&P 500 (GSPC)

This project aims at creating a machine learning model to predict the direction of the S&P500 index price based on historical data, ticker symbol: GSPC. 

Project Steps 
•	Download data using the yfinance package in python
•	Explore, clean, and visualize the data using pandas
•	Create and train an initial machine learning model 
•	Generate a back testing system to be more precise in the accuracy measurement
•	Improve the accuracy of the model

Tools:
Python:
•	Pandas
•	YFinance
•	OS
•	Sklearn 
•	RandomForestClassifier

Questions
1.	Given the fact that Machine Learning is designed and used for predicting market price fluctuations or price forecasting, among other things, can it be a reliable tool?
2.	Could we get an accurate prediction on the direction of the price solely on historical data?
3.	can a model be created to predict more accurate outcomes or results?
4.	would I use this model to trade in the S&P500?
   
Hypothesis
1.	I would say that Machine Learning is a reliable tool. 
2.	It would be kind of hard to get an accurate prediction solely on historical data, other factors would have to be considered.
3.	Technology is always improving; so, I would say yes.
4.	Yes, because Machine Learning algorithms are being used to generate pricing forecasts that are more reliable and more accurate.
   
Downloading the data
I downloaded the historical data of the S&P500 from yahoo finance by loading a package called yfinance into Jupiter notebook, this package calls the yahoo API to download daily stock and index prices. In this case I did not implement a ROCCC approach to determine the credibility of the data.
Nonetheless, I’m providing yahoo finance S&P500 index historical data website as reference: S&P 500 (^GSPC) Historical Data - Yahoo Finance
Using the history method in python, I decided to take a look at all the historical data starting 12-30-1927 where there was only a 90-stock index, up to March 14,2024 to find out if there is an overall upswing or downswing trend on the market. 
Cleaning and visualizing the data.

I then proceeded to visualize and clean the data using pandas; I first plotted the data in the data frame to have a better look at the trend, here we can see the trading dates on the x-axis, and the closing price on the y-axis; it is obvious that the overall trend of the index fund is in an upswing position since late 1980, which means that we would’ve been better off buying some stock in early 1990, or even in 2009 or 2010.

To create the initial machine learning model, I used the Open, High, Low, Close, and Volume columns, the Dividends and Stock Split columns are more suitable for individual stocks; therefore, I decided to eliminate them. 

Setting up the machine learning target 
Rather than looking for the MSE (mean squared error) precision as my target, my goal here is to try to find accuracy in the direction of the price (my target); in other words, will the price go up or down?
I created a column called Future Price, here I took the Close column and set all the prices back 1 day on the Future Price column; for instance, the 1928 1-3 Close price is now the price on the 1927 12-30 Future Price column, and so on. 
I then set up my target based on this future price; this is in fact, the purpose of the project, what is the direction of the price? Is the future price greater than today’s Close price?

Here we have a Target column with a 1 on the 1927-12-30 row indicating the price went up (Future Price is > today’s close price), and 0 when the price went down.
When it comes to stock market data, some of the old data may not be as useful in making predictions because of drastic changes that could happen when trying to make the prediction; therefore, I removed all data prior 1990, I chose this year because if you take a look at the line chart, the trend started to go up dramatically during this particular time. To make the changes, I used panda’s loc method.
Training an initial machine learning model.

I have now set up my data, and to train the first machine learning model I used a ‘random forest classifier’, this allowed me to train a lot of individual decision trees with randomized parameters and uses averaging to improve the predictive accuracy.
I placed all the rows into the training set, except the last 100 rows, I placed these last 100 rows into the test set; this is a simple baseline model which is the easiest way to do the split. For the predictors, I created a list with the needed columns to predict the target.

A very important part of this Machine Learning model is to measure the accuracy of the prediction; in other words, what percentage of the time when I expected the market to go up, did it really go up? for this, I used precision_score, I calculated the precision score using the actual target and the predicted target.
In this case I got a precision score (the market only went up) of around 61% which is ok but not the best, the score can always be improved. If the score was less than .5, the prediction is bad, and I would be better off trading against the model (doing the opposite of what it tells me to do).

Generating a back test system
It is crucial to know that the algorithm can handle lots of different situations; therefore, it must be able to test across multiple years of data, this can provide assurance that it will work in the future. 

I started off by creating a prediction function, given the fact that a trading year has about 250 days, the start value will be set at 2500 (10 yrs.) and the step value at 250. This is created because when you back test, you want to have a certain amount of data to train your first model.
I then went ahead and back tested the sp500 data with the model and predictors I created earlier. 
in this case I predicted the market would go down 3521 days and would go up 2596 days.
Across all these predictions, a bit more than 6,000 trading days, I was about 53% accurate; therefore, when I said the market would go up, it went up 53% of the time.

Is this percentage good or not?
Well, as a benchmark, I looked at the percentage of days where the market went up, that is, the value_counts of the target divided by the number of rows total, this gave me target percentages.
In the 6,000 plus days I was looking at, the sp500 went up 53.5% percent of days and went down 46.5% of days. This is not good, I would have been better off day trading than using this algorithm; as a matter of fact, this algorithm performed a bit worse than just the natural percentage of days that the stock market went up; nonetheless, now that I have back testing, I gained a lot more confidence in the model and my ability to test it.

Adding extra predictors to the model
Would adding more predictors improve the accuracy of the model?
To answer the question, I had to create a variety of rolling averages (means) within a horizon of 2 days, 5 days, 60 days, 1 yr, and 4 yrs., these inputs helped me determine if the stock would go up or down; in other words, the algorithm calculated the mean Close price in the last 2 trading days, the last 5 trading days, the last 60 trading days, the last year, and the last 4 years, and then I looked at the ratio between today's Closing price and the Closing price in those periods.
Improving the model.

I slightly modified the model by changing some of the parameters, I increased the number of estimators to 200, and the min-sample split was reduced to 50. The goal here is to have a bit more control over how the algorithm defines what becomes a 1 (up) and what becomes a 0 (down); therefore, I went ahead and used the predict_proba method.

I also set the threshold to 0.6 instead of the default threshold of 0.5, this simply means that if there is a 60% chance that the price will go up or down the model will return a 1 or 0; I simply injected more confidence into the model. This in turn, reduces the total number of trading days; in other words, it reduces the number of days that it predicts the price will go up, and it will increase the chance that the price will go up on those days. 
I then went ahead and ran the back test again, but this time I passed in the new predictors. Notice that I got rid of the Open, High, Low, Close, and Volume columns, the reason is that those are just absolute numbers, which means that they are not very informative to the model; as a matter of fact, the ratios are the most informative part since they use percentage instead of using absolute values and allow the model to use information of multiple candles as well.

Results

1.Given the fact that Machine Learning is designed and used for predicting market price fluctuations or price forecasting, among other things, can it be a reliable tool for this case?
While not infallible, Machine Learning provides important insights into future market or price movements. based on the ability for Machine Learning to provide a result solely on time series data and historical prices of the index, I would say that it can be used just to get a sense of the directionality of the market as in this model.

2.Could we get an accurate prediction on the direction of the price solely on historical data?
It is hard to get an accurate prediction on the direction of the market, to be close to accurate a lot of factors such as technical, fundamental, and sentimental analysis along with macro factors such as federal fund rate, price indices, unemployment, real estate, inflation, etc. would have to be considered.

3.can a model be created or improved to predict more accurate outcomes or results?
Yes, the model can always be improved, one can build quite a bit on this model and get far by using different data such as hourly data, minute by minute data, macro-economic factors, technical and fundamental analysis, etc., the algorithm can also be improved by tweaking random forest parameters and the prediction threshold, more predictors can be added as well, and so on.

4. would I use this model to trade in the S&P500? 
Absolutely not, even though the model predicted 57.3% of the days the market would go up, it reflects a good result considering I only worked with historical prices of the index and time series data; however, using this model for purposes of trading the market would not be recommended.

Conclusion

Even though the results were not favorable, the model has some predictive value, the market went up 57.3% of the days, which is better than the baseline where it shows that the market went up about 53% of the days. Machine Learning can be reliable to some extent for market price directionality prediction, but it must be combined with domain expertise, data quality, multiple external factors, and potential limitations.
