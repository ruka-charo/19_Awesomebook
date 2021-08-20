create temporary table tmp2 as                                                                                  
select cus.customer_id, mst.year_num, mst.month_num, mst.month_first_day, mst.month_last_day
from customer_tb as cus
cross join month_mst2 as mst;


select tmp2.customer_id, tmp2.year_num, tmp2.month_num, sum(coalesce(rsv.total_price, 0)) as total_price_month
from tmp2
left join reserve_tb as rsv
on tmp2.customer_id=rsv.customer_id
and tmp2.month_first_day <= rsv.checkin_date
and tmp2.month_last_day >= rsv.checkin_date
where tmp2.month_first_day >= '2017-01-01'
and tmp2.month_last_day <= '2017-03-31'
group by tmp2.customer_id, tmp2.year_num, tmp2.month_num                              
order by customer_id, year_num, month_num
limit 10;