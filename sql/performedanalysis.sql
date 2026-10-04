-- ---------------------------------------------
-- RetailPulse Analysis: Business Question Queries
-- ---------------------------------------------

-- Sanity checks
SELECT COUNT(*) FROM master;
select * from master limit 5;

--Store ST006 transactions ordered by revenue
select store_id, revenue from master where store_id='ST006' order by revenue desc;

-- Bulk purchases (qty > 4)
select txn_id from master where qty>4;

--Distinct categories
select distinct category from master;

-- Total revenue per store
select store_id,sum(revenue) from master group by store_id;

--  Average transaction value per category
select category,avg(revenue) from master group by category;

-- Total revenue per city
select city,sum(revenue) from master group by city;

--Transaction count per area_type
select count(*),area_type from master group by area_type;

-- Stores with more than 2000 transactions
select store_id from master group by store_id having count(*)>2000;

--Stores with above-average revenue (subquery)
select store_id from master group by store_id having avg(revenue)>(
select avg(revenue) from master
);

--Total revenue by month
select extract(MONTH from date) as month,sum(revenue) from master group by extract(MONTH from date) order by month;

--September vs non-September revenue (initial version)
select 
sum(case
when extract(month from date) =9 then revenue else 0 end) as festival,
sum(case
when extract(month from date) !=9 then revenue else 0 end) as non_festival
from master;

--Sales vs returns per store (first attempt - revealed a data structure issue, see corrected version below)
select m.store_id,sum(m.revenue),count(r.txn_id) as r_return from master m left join returns r on m.txn_id=r.txn_id group by m.store_id;

--corrected: Sales vs returns per store, aggregated independently before joining
SELECT 
    s.store_id,
    s.total_sales,
    COALESCE(r.total_returns, 0) AS total_returns
FROM (
    SELECT store_id, SUM(revenue) AS total_sales
    FROM master
    GROUP BY store_id
) s
LEFT JOIN (
    SELECT store_id, SUM(revenue) AS total_returns
    FROM returns
    GROUP BY store_id
) r ON s.store_id = r.store_id;

-- Data coverage check (revealed dataset only spans Jan-Sep 2025)
SELECT MIN(date), MAX(date) FROM master;

--corrected: September vs average of other months (fair comparison)
select 
sum(case when extract(month from date) = 9 then revenue else 0 end) as september,
sum(case when extract(month from date) != 9 then revenue else 0 end) / 8 as avg_other_month
from master;

