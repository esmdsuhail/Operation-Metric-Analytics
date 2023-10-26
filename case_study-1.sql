use Job_data_analysis;
select * from job_data;
describe job_data;
alter table job_data change column ds ds date;

select ds, count(job_id)/sum(time_spent)*3600 as job_rwper_hr 
from job_data
where ds between '2020-11-01' and '2020-11-30'
group by ds;

select ds, count(event)/sum(time_spent) as throughput
from job_data
group by ds
order by ds desc;

with rlavg as
(
select ds, count(event)/sum(time_spent) as tpt
from job_data
group by ds
)
select ds, avg(tpt) over(order by ds rows between 6 preceding and current row) as rllavg
from rlavg
group by ds;


select distinct language as lang , count(language)/30 as percentage
from job_data
group by lang;

select job_id, count(*) as dup
from job_data
group by job_id;

select actor_id, count(*) as dup
from job_data
group by actor_id;

