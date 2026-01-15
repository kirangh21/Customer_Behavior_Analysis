
--q1.---- Compare revenue as per demographics


(select  gender,sum(purchase_amount_usd )as Revenue
from customer
group by gender); 

-- Q2. customers used discount still purchased more than avg purchase amt 

select customer_id,purchase_amount_usd,59.7 as avg
from customer
where discount_applied = 'Yes' 
and 
purchase_amount_usd >
(select avg(purchase_amount_usd) from customer )


---q3. top 5 products with highest average review rating

select item_purchased,
round(avg(review_rating::numeric),2) as Avg_product_rating 
from customer
group by item_purchased
order by avg(review_rating) desc
limit 5

--Q4. Compare avg purcahse amt b/w Standard and exxpress shipping

select shipping_type,
avg(purchase_amount_usd) as avg_purchase_Amt
from customer
where shipping_type in ('Standard','Express')
group by shipping_type

----Business should invest more time and effort in express shippingtype

---Q5.Do subscribed customers spend more ? Compare avg spend and total revenue

select subscription_status,
count(customer_id) as total_customer,
round(avg(purchase_amount_usd),2) as avg_spend,
round(sum(purchase_amount_usd),2) as total_revenue
from customer
group by 
subscription_status

--- avg spend is more in non subscribers and so is total_revenues

---Q5, 5 products that have highest percentage of purchases with discounts applied


SELECT 
    item_purchased AS product,
    (100.0 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) AS discount_rate
FROM customer
GROUP BY item_purchased;


---****---Q7. segment customers into new, returning and Loyal based on their total no.
---of previous purchases  and show count of each segment.(Customer Segmentation)

select * from customer

with customer_type as
(
select customer_id,previous_purchases, case when previous_purchases = 1  then 'New'
											when previous_purchases between 2 and 10 then 'Returning'
											when previous_purchases > 10 then 'Loyal' end as Segment
from customer)


select segment,count(*) as count
from customer_type
group by segment

---Q8. top 3 most purchased products within each category

with product_cat as (
select category,item_purchased,count(*) as Quantity,
row_number() over(partition by category order by count(*) desc) as Rnk
from customer
group by category,item_purchased
)

select * from product_cat where rnk <= 3

--Q9.are customer who are repeat buyers (more than 5 previous purchase) also likely to subscribe?

 select subscription_status,count(1) as Count
 from 
(select *,case when previous_purchases > 5 then 1 else 0 end as repeat_buyers
from customer) a 
where repeat_buyers = 1
group by subscription_status

------Q10. Revenue by age group 

select age_group, sum(purchase_amount_usd) as Revenue
from customer
group by age_group order by revenue desc 
											