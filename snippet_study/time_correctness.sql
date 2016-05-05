-- Group by Question
-- select t.tag||'_'||uc.codeid, c.type,  
-- SUM(CASE WHEN uc.correct = 'T' THEN 1 ELSE 0 END) as correct,
-- SUM(CASE WHEN uc.correct = 'F' THEN 1 ELSE 0 END) as incorrect,
-- SUM(CASE WHEN uc.correct = 'T' THEN 1.0 ELSE 0.0 END) /
-- max(SUM(CASE WHEN uc.correct = 'F' THEN 1.0 ELSE 0.0 END), 1.0) as ratio,
-- avg(uc.duration)
-- from usercode uc
-- join code c on uc.codeid = c.id
-- join codetags ct on ct.codeid = c.id
-- join tag t on ct.tagid = t.id
-- group by ct.codeid;

-- Group by user
-- select uc.userid, c.type,  
-- SUM(CASE WHEN uc.correct = 'T' THEN 1 ELSE 0 END) as correct,
-- SUM(CASE WHEN uc.correct = 'F' THEN 1 ELSE 0 END) as incorrect,
-- SUM(CASE WHEN uc.correct = 'T' THEN 1.0 ELSE 0.0 END) /
-- count(*) as ratio,
-- avg(uc.duration) as duration
-- from usercode uc
-- join code c on uc.codeid = c.id
-- join codetags ct on ct.codeid = c.id
-- join tag t on ct.tagid = t.id
-- group by uc.userid, c.type;

-- correctness over time
select uc.rank,
SUM(CASE WHEN uc.correct = 'T' THEN 1 ELSE 0 END) as correct,
SUM(CASE WHEN uc.correct = 'F' THEN 1 ELSE 0 END) as incorrect,
SUM(CASE WHEN uc.correct = 'T' THEN 1.0 ELSE 0.0 END) /
count(*) as ratio,
avg(uc.duration) as duration
from usercode uc
join code c on uc.codeid = c.id
join codetags ct on ct.codeid = c.id
join tag t on ct.tagid = t.id
group by uc.rank;
