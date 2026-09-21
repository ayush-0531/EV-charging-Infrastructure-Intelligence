create database ev_db ;

use ev_db ;

select * from indian_ev_stations_simplified;

alter table Indian_EV_Stations_Simplified 
rename to EV_stations;

select * from ev_stations;



-- Which states have the highest number of EV charging stations?

select state , count(`station name`) as total_stations 
from ev_stations 
group by state 
order by total_Stations desc ;
-- kerala have the highest number of charging stations (724),


-- Which cities have the highest number of EV charging stations?

select city,state, count(`station name`) as total_stations
 from ev_Stations 
group by city , state 
order by  total_stations desc;
-- from the total 283 cities thiruvananthapuram has the highest EV station count as 36 ,


-- Which cities have the highest and lowest installed charging capacity (total Power in kW)?

with adding as (select city ,state , sum(`power (kW)`) as total_capacity
from ev_stations
group by city , state
) , ranking as (
select city , state , total_capacity , dense_rank() over ( order by total_capacity desc) as maximum , 
dense_Rank() over (order by total_capacity asc) minimum 
from adding
)
select city , state , total_capacity 
from ranking 
where maximum = 1 or minimum = 1
order by total_capacity desc;

-- or

with adding as (select city ,state , sum(`power (kW)`) as total_capacity
from ev_stations
group by city , state
) 
select * from adding 
where total_capacity = (select max(total_capacity) from adding) or 
total_capacity  = (select min(total_Capacity) from adding);
-- found Thiruvananthapuram  has the highest installed power capacity of 1163.6 kW and the Neriyamangalam , Guruvayoor has
-- the lowest installed power capacity of 3.3 kW .



select * from ev_stations;

-- Which EV charging operators have the highest number of charging stations?
select operator , count(`station name`) as total_stations 
from ev_stations
group by operator
order by total_stations desc ;
-- chargemod(IN) has the highest number (354) charging stations 


-- Which operators have the highest total installed charging capacity (kW)?
select operator , sum(`power (kW)`) as total_capacity 
from ev_stations
group by operator 
order by total_capacity desc;
-- chargemod(IN) hase the highest total capacity of 9767 kW , inrespective of other operators


-- Which states are dominated by a single EV charging operator?
select state , operator , count(`station name`) as total_stations
from ev_stations
group by state , operator
order by state , total_stations desc ;
-- the states which have more number of ev stations like kerala have total of 734 , where two operators are dominating which are
-- chargemod(IN) with 354 stations and go ec(in) with 191 station, and in tamil nadu have total of 40 stations is dominated by zeon charging with 39 stations 
 

-- Is there a relationship between the number of charging stations and the total installed 
-- charging capacity across cities?
select city , count(`station name`) as total_stations , round(sum(`power (kW)`),2) as total_capacity 
from ev_stations
group by city 
order by total_stations desc , total_capacity desc ;
-- not found a strong relation but yes somehow it is related on some points where station count is high power capacity is also high


-- Which connector types are most commonly used across EV charging stations, 
-- and what share of the recorded stations does each connector type represent?

select `connector type`  , count(`station name`) as total_stations , round((count(`station name`) / (select count(`station name`) from ev_stations ) ),3)*100 as share_
from ev_stations
group by `connector type`
order by total_stations desc;
-- CCS(Type2) is the most commonly used connector type accross ev stations with a 64% share .


-- Is there an association between connector type and usage type?
select * from ev_Stations;

select  `connector type` ,`usage type`, count(`station name`) as total_stations
from ev_stations
group by  `connector type` , `usage type` 
order by total_stations desc ;


-- Which operators have the highest average charging capacity per station?
select * from ev_stations;

select operator , count(`station name`) as station_counts , round(avg(`power (kW)`),2) as average_capacity
from ev_Stations
group by operator 
order by average_capacity desc ;
-- stati1(IN) has the highest average power capacity of 49.48 with 5 stations only , 
-- but chargemid(IN) has the average capacity of 27.59 with 354 stations.


-- Which usage types have the highest average charging capacity per station?

select `usage type` , count(`station name`) as station_counts , round(avg(`power (kW)`),2) as average_capacity
from ev_Stations
group by `usage type`
order by average_capacity desc ;
-- public usage type has the highest average 34.73 with 58 station sbut public membership required has the average of 30.08 with 714 stations


-- Which cities have a high number of charging stations but relatively low average charging capacity per station?
select city , count(`station name`) as counts , round(avg(`power (kW)`),2) as average_capacity
from ev_stations
group by city 
order by counts desc , average_capacity asc ;
-- Thiruvananthapuram has the highers number of stations(36) with an average power capacity of 32.32 which approx similar to our overall average .
-- also as per the received output we are not find any city having good amount of stations and less in power capacity all have a approx same average

select city , count(`station name`) as counts , round(avg(`power (kW)`),2) as average_capacity
from ev_stations
group by city 
order by  average_capacity desc , counts asc ;
-- mainly in Miduthuru their are 2 stations and average powe capacity is 90 
-- Koduvally their are 3 stations and average power capacity is 67.33


-- Which connector types have the highest average installed charging capacity per station?

select `connector type` , round(avg(`power (kW)`),2) as average_capacity
from ev_Stations
group by `connector type`
order by average_Capacity desc ;
-- CHAdeMO has the highest installed average power capacity per station 41.11 kW.


-- Which connector types contribute the most to the total installed charging capacity across all stations?

select `connector type` , round(sum(`power (kW)`),2) as average_capacity
from ev_Stations
group by `connector type`
order by average_Capacity desc ;
-- CCS (Type 2) contribute the most of the total installed charging capacity which is 19893.4 