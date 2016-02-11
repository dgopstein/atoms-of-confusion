.headers on
.mode column

--select uc.userid, uc.codeid, c.type, c.pair, uc2.*
--from usercode uc
--join code c on uc.codeid = c.id
--join usercode uc2 on uc.userid = uc2.userid and uc2.codeid = c.pair and uc2.timestamp < uc.timestamp
--where c.type = 'Confusing' and uc.userid = 1 limit 10;

--select uc.userid, uc.codeid, c.type, uc.timestamp, (uc2.timestamp < uc.timestamp) as ord, uc2.timestamp, uc2.codeid, uc.correct
--from usercode uc
--join code c on uc.codeid = c.id
--join usercode uc2 on uc.userid = uc2.userid and uc2.codeid = c.pair
--where c.type = 'Confusing' and uc.userid = 1 limit 10;

select uc2.timestamp < uc.timestamp, uc.correct, count(*)
-- ,t.tag -- By Atom
from usercode uc
join code c on uc.codeid = c.id
join usercode uc2 on uc.userid = uc2.userid and uc2.codeid = c.pair
join codetags ct on c.id = ct.codeid join tag t on ct.tagid = t.id
where c.type = 'Confusing'
group by uc2.timestamp < uc.timestamp, uc.correct
-- ,ct.tagid -- By Atom
;

select userid, codeid, timestamp, (
 SELECT count(*)
 FROM usercode t WHERE t.timestamp < uc.timestamp 
) as rank from usercode uc where userid = 1 order by rank;
