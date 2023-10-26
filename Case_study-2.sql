use metric_spike;

#Task_1
select week(occurred_at) as week_num , count(distinct user_id) as actv_usr
from events
where event_type = 'engagement'
group by week_num;

#Task_2
with actvusr as
(
select distinct date(created_at) as date, count(distinct user_id) as actv_usr
from users 
group by date
)
select date, actv_usr,sum(actv_usr) over(order by date rows between unbounded preceding and current row) as user_grwth
from actvusr;

#Task_3
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

#Task_4
SELECT 
    WEEK(occurred_at) AS week,
    device,
    COUNT(DISTINCT user_id) AS actv_usr
FROM
    events
where event_type = 'engagement'
GROUP BY week , device;


#Task_5
select week(occurred_at) as week,
	count(case when action = 'sent_weekly_digest' then user_id else null end)as sent,
    count(case when action = 'email_open' then user_id else null end)as open,
    count(case when action = 'email_clickthrough' then user_id else null end)as click_through,
    count(case when action = 'sent_reengagement_email' then user_id else null end)as reengagement,
    count(user_id) as no_usr
    from email_events
    group by week;