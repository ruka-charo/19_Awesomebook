--表を一時保存
create temporary table tmp_1 as
with tmp1 as (
select
customer_id, age, sex, 
cast(floor(age/10)*10 as text) as age_rank
from customer_tb),

tmp2 as (
select customer_id, sex,
case when age_rank >= '60' then '60以上'
else age_rank
end as age_cat
from tmp1),

tmp3 as (
select r.reserve_id, r.people_num, r.total_price,
c.customer_id, c.sex, c.age_cat,
h.base_price,
date_part('year', checkin_date) as checkin_year
from reserve_tb as r
left join tmp2 as c
on r.customer_id = c.customer_id
left join hotel_tb as h
on r.hotel_id = h.hotel_id)

select * from tmp3
where checkin_year = '2016';


--クロス集計表に変換(予約人数)
with tmp4 as (
select sex, age_cat,
count(distinct customer_id) as people_sum
from tmp_1
group by sex, age_cat)

select sex,
max(case when age_cat = '10' then people_sum else 0 end) as age_10,
max(case when age_cat = '20' then people_sum else 0 end) as age_20,
max(case when age_cat = '30' then people_sum else 0 end) as age_30,
max(case when age_cat = '40' then people_sum else 0 end) as age_40,
max(case when age_cat = '50' then people_sum else 0 end) as age_50,
max(case when age_cat = '60以上' then people_sum else 0 end) as age_60以上
from tmp4
group by sex;


--合計予約回数
with tmp5 as (
select sex, age_cat,
count(reserve_id) as reserve_sum
from tmp_1
group by sex, age_cat)

select sex,
max(case when age_cat = '10' then reserve_sum else 0 end) as age_10,
max(case when age_cat = '20' then reserve_sum else 0 end) as age_20,
max(case when age_cat = '30' then reserve_sum else 0 end) as age_30,
max(case when age_cat = '40' then reserve_sum else 0 end) as age_40,
max(case when age_cat = '50' then reserve_sum else 0 end) as age_50,
max(case when age_cat = '60以上' then reserve_sum else 0 end) as age_60以上
from tmp5
group by sex;


--平均予約人数
with tmp6 as (
select sex, age_cat,
cast((sum(people_num)*1.0 / count(reserve_id))as float4) as people_avg
from tmp_1
group by sex, age_cat)

select sex,
max(case when age_cat = '10' then people_avg else 0 end) as age_10,
max(case when age_cat = '20' then people_avg else 0 end) as age_20,
max(case when age_cat = '30' then people_avg else 0 end) as age_30,
max(case when age_cat = '40' then people_avg else 0 end) as age_40,
max(case when age_cat = '50' then people_avg else 0 end) as age_50,
max(case when age_cat = '60以上' then people_avg else 0 end) as age_60以上
from tmp6
group by sex;


--平均予約単価
with tmp7 as (
select sex, age_cat,
cast((sum(total_price)*1.0 / sum(people_num))as float4) as price_avg
from tmp_1
group by sex, age_cat)

select sex,
max(case when age_cat = '10' then price_avg else 0 end) as age_10,
max(case when age_cat = '20' then price_avg else 0 end) as age_20,
max(case when age_cat = '30' then price_avg else 0 end) as age_30,
max(case when age_cat = '40' then price_avg else 0 end) as age_40,
max(case when age_cat = '50' then price_avg else 0 end) as age_50,
max(case when age_cat = '60以上' then price_avg else 0 end) as age_60以上
from tmp7
group by sex;
