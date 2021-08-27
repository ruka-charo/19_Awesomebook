with tmp1 as (
select c.customer_id, r.reserve_id, r.hotel_id,
age, sex,
date_part('year', reserve_datetime) as reserve_year, 
date_part('month', reserve_datetime) as reserve_month,
coalesce(count(reserve_id), 0) as reserve_cnt,
m.*

from customer_tb as c
cross join month_mst as m
inner join reserve_tb as r
on c.customer_id = r.customer_id

where year_num <= 2017
and month_last_day <= '2017-03-31'
group by c.customer_id, r.reserve_id, r.hotel_id,
age, sex, reserve_year, reserve_month,
m.year_num, m.month_num, m.month_first_day, m.month_last_day)

select tmp1.*
case when reserve_cnt >= 1 then 'True'
else 'False'
end as reserve_flag
from tmp1
where customer_id='c_1'
and reserve_id='r2';