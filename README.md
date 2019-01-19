# THE ICONIC customer behavior analysis report
#### Olsen.Zheng@outlook.com


## Purpose of the document

Based on the customer behavior data, this document shall be read as an report indicating my analysis process as well as an execution manual of the code appended.

## Analysis structure

The aim of the task is to infer the customers' genders based on the given consuming behavior data, to archieve this, the following analysis steps will be carried out:

* **High level analysis:** Analysis focusing on some overall consumption features whose result can be seen as a rough profile and can give direction or clue to the following modelling and prediction work. This is a **SQL** based analysis upon the give SQLite data file.
* **Data cleaning:** This step is to do a basic data quality check then find the corrent the corrupted data, and furtherly pickup the valuable fields those shall be used the in the following prediction model.
* **Model choose and build:** Chose and build an unsupervised learning model to predict customer gender, model accuracy and performance to be the key point to consider and neccessary optimization will also be taken into account.
* **Conclusion and suggestion:** A conclusion based on the previous analysis result will be given, as well as a suggention of some missing but meaningful features   that may help improve the prediction accuracy.
*  **Summary:** An executive summary including key situation and analysis result will be given for business analysts and decision makers for further analysis and action.

The following parts of this documents will be also unfolded as the above structure.

## High level analysis
The following SQL based analysis are taken out with the result given too.

1. What was the total revenue to the nearest dollar for customers who have paid by credit card?

	*sql code:*
	
	```	
		select sum(a.revenue) from customers a
		where a.cc_payments=1
	```
	
	*result:* 50,372,281.74
	
	In the data dictionary, the four *xx_payments* columns are said to be the Number of times paid by such way, however from the data they are like a boolean flag indicating whether the customer ever used such payment way.
	

2. What percentage of customers who have purchased female items have paid by credit card?


	*sql code:*
	
	```	
		select 
		(
			select count(1) from customers a where 
			female_items>0 and cc_payments=1
		)*1.0/
		(
			select count(1) from customers a where female_items>0
		)
	```
	
	*result:* 65.43%
	
3. What was the average revenue for customers who used either iOS, Android or Desktop?


	*sql code:*
	
	```	
		select avg(revenue) from customers a where 
			desktop_orders + ios_orders + android_orders>0	
	```
	
	*result:* 1,484.89

4. We want to run an email campaign promoting a new mens luxury brand. Can you provide a list of customers we should send to?
	
	The idea is to select top 20% (due to 20/80 rule) customers who:
	
	1) are more interested in male items (male_items>female_items)
	
	2) are willing to buy expensive items, or have high per item revenue

	*sql code:*
	
	```	
		select distinct customer_id from customers a order by 
				case when male_items>female_items then 0 else 1 end,
				revenue/items desc		
		limit ((select count(distinct customer_id) from customers) *0.2)
	```
	
	*result:* 9000 or so results so omited here
