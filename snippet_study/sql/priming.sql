.headers on
.mode column

--select uc.userid, uc.codeid, c.type, c.pair, uc2.*
--from scrubbed_usercode uc
--join code c on uc.codeid = c.id
--join scrubbed_usercode uc2 on uc.userid = uc2.userid and uc2.codeid = c.pair and uc2.timestamp < uc.timestamp
--where c.type = 'Confusing' and uc.userid = 1 limit 10;

--select uc.userid, uc.codeid, c.type, uc.timestamp, (uc2.timestamp < uc.timestamp) as ord, uc2.timestamp, uc2.codeid, uc.correct
--from scrubbed_usercode uc
--join code c on uc.codeid = c.id
--join scrubbed_usercode uc2 on uc.userid = uc2.userid and uc2.codeid = c.pair
--where c.type = 'Confusing' and uc.userid = 1 limit 10;

--select uc2.timestamp < uc.timestamp, uc.correct, count(*)
---- ,t.tag -- By Atom
--from scrubbed_usercode uc
--join code c on uc.codeid = c.id
--join scrubbed_usercode uc2 on uc.userid = uc2.userid and uc2.codeid = c.pair
--join codetags ct on c.id = ct.codeid join tag t on ct.tagid = t.id
--where c.type = 'Confusing'
--group by uc2.timestamp < uc.timestamp, uc.correct
---- ,ct.tagid -- By Atom
--;


--.mode csv
--select count(*), correct, (s.r2 - s.r1) / 5 as distance from (
--  select uc.userid, uc.codeid, uc.correct --, uc.timestamp
--  , (SELECT count(*) r FROM scrubbed_usercode t WHERE t.timestamp < uc.timestamp) r1
--  , (SELECT count(*) r FROM scrubbed_usercode t WHERE t.timestamp < uc2.timestamp) r2
--  from scrubbed_usercode uc
--  join code c on uc.codeid = c.id
--  join scrubbed_usercode uc2 on uc.userid = uc2.userid and uc2.codeid = c.pair
--  join codetags ct on c.id = ct.codeid join tag t on ct.tagid = t.id
--  where c.type = 'Confusing' order by r1
--) s
--GROUP BY correct, distance
--order by distance
--;

.mode csv
select (uc2.rank - uc.rank) as distance,
SUM(CASE WHEN uc.correct = 'T' THEN 1 ELSE 0 END) as Ts,
SUM(CASE WHEN uc.correct = 'F' THEN 1 ELSE 0 END) as Fs
  from scrubbed_usercode uc
  join code c on uc.codeid = c.id
  join scrubbed_usercode uc2 on uc.userid = uc2.userid and uc2.codeid = c.pair
  join codetags ct on c.id = ct.codeid join tag t on ct.tagid = t.id
  where c.type = 'Confusing'
GROUP BY distance
order by distance
;
