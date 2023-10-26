# Operation-Metric-Analytics
Analyzing the company's end-to-end operation and identifying areas for improvement

## Table of content
- [Project Description](#Project-description)
- [Data](#Data-Source)
- [Tools](#Tools)
- [Data Analysis](#Data-Analysis)
    - [Case study-1](#Case-Study-1)
    - [Case Study-2](#Case-Study-2)
- [Conclusion](#conclusion)

  
### Project description
In this project, my role was a lead data analyst at a company like Microsoft, and using advanced SQL skills I needed to investigate changes in key metrics which is a crucial aspect of the investigation metrics which again is a part of operation analysis. In this operation analysis, we need to engage with the stakeholders and perform root cause analysis, and some actionable insights need to be provided by using SQL queries to detect anomalies and correlate them with events or changes in strategy.

### Data source 
There are two datasets are divided into two case studies which are case Study-1 Dataset.csv (Job_data) and Case Study-2 Dataset.csv (investigating metric spike) consisting of three tables Users, Events, Email_Events. These data should be cleaned and restructured as they need to be  loaded into the SQL. The first dataset is easily loaded using the wizard of MySQL but as the second dataset has more rows it is done through the SQL query “Load data infile” function. Later the SQL queries were used to analyse the data.

### Tools
- MYSQL for data analysis  Case_study-1[Click Here](https://drive.google.com/file/d/1CLo97lZ44IrkE02mR4r9S_ojAVnBFmm2/view?usp=sharing),  Case_study-2[Click Here](https://drive.google.com/file/d/1BmUC-AFKoYXydq3oi6EFrv4MiFDI6qKZ/view?usp=sharing)
- MS Excel and Tableau for Charts  Case_study-1[Click Here](https://docs.google.com/spreadsheets/d/1AVK1dbL-TUO_rzyOqkQ3AftBhK5Wjgvz/edit?usp=sharing&ouid=105843925605549140071&rtpof=true&sd=true),  Case_study-2[Click Here](https://docs.google.com/spreadsheets/d/1IAQuoxCU-9J3pdhDiZitvfnpn7EUL6tu/edit?usp=sharing&ouid=105843925605549140071&rtpof=true&sd=true)
- MS PowerPoint for data report  Case_study-1[Click Here](https://docs.google.com/presentation/d/1lIU3IHR3TdHiEgupzFjf9t8o05kSmIlA/edit?usp=sharing&ouid=105843925605549140071&rtpof=true&sd=true),  Case_study-2[Click Here](https://docs.google.com/presentation/d/1_gu7NyvIhbpYheMsLG9yFIrc4a5e6UpZ/edit?usp=sharing&ouid=105843925605549140071&rtpof=true&sd=true)

### Data analysis
#### Case Study 1: Job Data Analysis
1.	Calculate the number of jobs reviewed per hour for each day in November 2020.


![image](https://github.com/esmdsuhail/Operation-Metric-Analytics/assets/142283402/a1bd5543-d8c1-495e-8ce8-d57eac30bda2)

Most of the jobs reviewed were on the day of 28th November with 218 

```SQL
select ds, count(job_id)/sum(time_spent)*3600 as job_rwper_hr 
from job_data
where ds between '2020-11-01' and '2020-11-30'
group by ds;
```


2.	Calculate the 7-day rolling average of throughput (number of events per second). Additionally, explain whether you prefer using the daily metric or the 7-day rolling average for throughput, and why.


![image](https://github.com/esmdsuhail/Operation-Metric-Analytics/assets/142283402/db88f047-61f0-4a3f-8c42-d450ffc94b99)

7 day rolling average is the best option than daily as the metric changes daily which could be the complete opposite of previous data if coming to 7 day rolling could get some meaningful data and also decision-making can be easy

```SQL
with rlavg as
(
select ds, count(event)/sum(time_spent) as tpt
from job_data
group by ds
)
select ds, avg(tpt) over(order by ds rows between 6 preceding and current row) as rllavg
from rlavg
group by ds;
```


3.	Calculate the % share of each language over the last 30 days.


![image](https://github.com/esmdsuhail/Operation-Metric-Analytics/assets/142283402/90be7f74-8258-4488-a9a4-173d6de9c343) 

The Persian language has the highest share among all the languages with 33% and the rest share an equal percentage 

```SQL
select distinct language as lang , count(language)/30 as percentage
from job_data
group by lang;
```


4.	Display duplicate rows from the job_data table.


![image](https://github.com/esmdsuhail/Operation-Metric-Analytics/assets/142283402/327d4dad-c043-4a4b-a244-b4be921886e6) ![image](https://github.com/esmdsuhail/Operation-Metric-Analytics/assets/142283402/a0a88028-ef41-4127-b2b6-f014f5151a16)
These are the two cases where we can see duplicates in the given dataset 

```SQL
select job_id, count(*) as dup
from job_data
group by job_id;
```
```SQL
select actor_id, count(*) as dup
from job_data
group by actor_id;
```
#### Case Study 2: Investigating Metric Spike
1.	Calculate the weekly user engagement
![image](https://github.com/esmdsuhail/Operation-Metric-Analytics/assets/142283402/1958f55b-4d01-420a-a07b-87913830a05d)

The engagement of the users from the start to 30th gradually increases and after that drastically decreases to 104 in week 35.

```SQL
select week(occurred_at) as week_num , count(distinct user_id) as actv_usr
from events
where event_type = 'engagement'
group by week_num;
```


2.	Calculate the user growth for the product.
![image](https://github.com/esmdsuhail/Operation-Metric-Analytics/assets/142283402/62459a92-7a5f-447b-b6a4-b38233a6bfac)

There is an increase in the users for the product but the user stays active only for certain dates still the growth of users increases towards the end of the data.


```SQL
with actvusr as
(
select distinct date(created_at) as date, count(distinct user_id) as actv_usr
from users 
group by date
)
select date, actv_usr,sum(actv_usr) over(order by date rows between unbounded preceding and current row) as user_grwth
from actvusr;
```


3.	Calculate the weekly retention of users based on their sign-up cohort. 
![image](https://github.com/esmdsuhail/Operation-Metric-Analytics/assets/142283402/3e54c75d-0a8e-4121-8cbc-f57679f74e5e)

The retention rates of users are very high for those who joined earlier and this decreases with time.

```SQL
select frst_wk,
	      sum(case when wknm = 0 then 1 else 0 end) as week_0,
	      sum(case when wknm = 1 then 1 else 0 end) as week_1,
        sum(case when wknm = 2 then 1 else 0 end) as week_2,
        sum(case when wknm = 3 then 1 else 0 end) as week_3,
        sum(case when wknm = 4 then 1 else 0 end) as week_4,
        sum(case when wknm = 5 then 1 else 0 end) as week_5,
        sum(case when wknm = 6 then 1 else 0 end) as week_6,
        sum(case when wknm = 7 then 1 else 0 end) as week_7,
        sum(case when wknm = 8 then 1 else 0 end) as week_8,
        sum(case when wknm = 9 then 1 else 0 end) as week_9,
        sum(case when wknm = 10 then 1 else 0 end) as week_10,
	    	sum(case when wknm = 11 then 1 else 0 end) as week_11,
        sum(case when wknm = 12 then 1 else 0 end) as week_12,
        sum(case when wknm = 13 then 1 else 0 end) as week_13,
        sum(case when wknm = 14 then 1 else 0 end) as week_14,
        sum(case when wknm = 15 then 1 else 0 end) as week_15,
        sum(case when wknm = 16 then 1 else 0 end) as week_16,
        sum(case when wknm = 17 then 1 else 0 end) as week_17,
        sum(case when wknm = 18 then 1 else 0 end) as week_18,
        sum(case when wknm = 19 then 1 else 0 end) as week_19
from(
select a.user_id,a.lngwk,b.fst_wk as frst_wk,
	a.lngwk-fst_wk as wknm from
(
select user_id, week(occurred_at) as lngwk 
from events
group by user_id, lngwk)a,
(
select user_id, min(week(occurred_at))as fst_wk
from events
group by user_id)b
where a.user_id = b.user_id
)as with_wknm
group by frst_wk
order by frst_wk;
```


4.	Calculate the weekly engagement per device
![image](https://github.com/esmdsuhail/Operation-Metric-Analytics/assets/142283402/4203d234-995c-4989-adb2-57127492a17a)

The MacBook Pro has the highest engagement of users and this continues with the Lenovo ThinkPad, MacBook Air, iPhone5, and others.

```SQL
SELECT 
    WEEK(occurred_at) AS week,
    device,
    COUNT(DISTINCT user_id) AS actv_usr
FROM
    events
where event_type = 'engagement'
GROUP BY week , device;
```
5.	Calculate the email engagement metrics
![image](https://github.com/esmdsuhail/Operation-Metric-Analytics/assets/142283402/12934401-2f13-4bb1-b21d-16f13f163d5b)

The email engagement metric shows a positive trend line till the week of 34 and falls at the week of 35.
We can say that almost 70% of the mail services are being properly sent and are being engaged.

```SQL
select week(occurred_at) as week,
	count(case when action = 'sent_weekly_digest' then user_id else null end)as sent,
    count(case when action = 'email_open' then user_id else null end)as open,
    count(case when action = 'email_clickthrough' then user_id else null end)as click_through,
    count(case when action = 'sent_reengagement_email' then user_id else null end)as reengagement,
    count(user_id) as no_usr
    from email_events
    group by week;
```
### Conclusion
This project stands as a testament to using advanced SQL skills to enhance operational efficiency and understanding of critical business metrics. It also reveals the key insights and learning that emphasize proficiency in crafting SQL queries. The metric analysis of this project showcases the ability to derive actionable insights that empower the organization to make informed decision-making and continuous improvement. 






