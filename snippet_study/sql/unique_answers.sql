--select uc.userid, t.tag, uc.codeid as c_id, uc2.codeid as nc_id, uc.correct as c_correct, uc2.correct as nc_correct
--from usercode uc
--join code c on uc.codeid = c.id
--join usercode uc2 on uc.userid = uc2.userid and uc2.codeid = c.pair
--join codetags ct on ct.codeid = c.id
--join tag t on ct.tagid = t.id
--where c.type = 'Confusing' and uc.userid = 1 limit 10;

--select uc.codeid as c_id, uc2.codeid as nc_id, t.tag as atom,
--SUM(CASE WHEN uc.correct = 'T' THEN 1 ELSE 0 END) as c_correct,
--SUM(CASE WHEN uc2.correct = 'T' THEN 1 ELSE 0 END) as nc_correct 
--from usercode uc
--join code c on uc.codeid = c.id
--join usercode uc2 on uc.userid = uc2.userid and uc2.codeid = c.pair
--join codetags ct on ct.codeid = c.id
--join tag t on ct.tagid = t.id
--where c.type = 'Confusing'
--group by t.id, c_id;


select t.tag as atom, t.tag||'_'||uc.codeid as question, uc.codeid as c_id, uc2.codeid as nc_id,
COUNT(distinct(uc.answer)) as C_unique,
COUNT(distinct(uc2.answer)) as NC_unique,
SUM(CASE WHEN uc.correct  = 'T' THEN 1 ELSE 0 END) as C_correct,
SUM(CASE WHEN uc2.correct = 'T' THEN 1 ELSE 0 END) as NC_correct
from usercode uc
join code c on uc.codeid = c.id
join usercode uc2 on uc.userid = uc2.userid and uc2.codeid = c.pair
join codetags ct on ct.codeid = c.id
join tag t on ct.tagid = t.id
--where c.type = 'Confusing'
group by t.id, c_id
order by C_correct + NC_correct;
