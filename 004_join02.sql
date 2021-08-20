create temporary table tmp1 as
select big_area_name, small_area_name, count(hotel_id)-1 as hotel_cnt
from hotel_tb
group by big_area_name, small_area_name
order by big_area_name, small_area_name;


create temporary table tmp2 as
select small_area_name,
case when hotel_cnt >= 20
then small_area_name
else big_area_name end as join_area_id
from tmp1;


create temporary table tmp3 as
select hotel_id, join_area_id from hotel_tb
inner join tmp2
on hotel_tb.small_area_name=tmp2.small_area_name
order by hotel_id;


create temporary table tmp4 as
select small_area_name as join_area_id, hotel_id as rec_hotel_id
from hotel_tb
union
select big_area_name as join_area_id, hotel_id as rec_hotel_id
from hotel_tb
order by rec_hotel_id;


select hotel_id, rec_hotel_id from tmp3
inner join tmp4
on tmp3.join_area_id=tmp4.join_area_id
and tmp3.hotel_id != tmp4.rec_hotel_id
limit 10;



別解

--（図4.7）
with tmp1 as (
select small_area_name, 
case when
count(hotel_id) >= 20
then
small_area_name
else
big_area_name
end as join_area_id
from hotel_tb
group by small_area_name, big_area_name
order by small_area_name), 

tmp2 as (
select hotel_id, join_area_id
from tmp1
inner join hotel_tb as t
on tmp1.small_area_name=t.small_area_name
order by hotel_id),

--（図4.8）
tmp3 as (
select hotel_id as rec_hotel_id, small_area_name as join_area_id
from hotel_tb
union
select hotel_id as rec_hotel_id, big_area_name as join_area_name
from hotel_tb)

--（図4.9）
select hotel_id, rec_hotel_id
from tmp2
inner join tmp3
on tmp2.join_area_id=tmp3.join_area_id
order by hotel_id;