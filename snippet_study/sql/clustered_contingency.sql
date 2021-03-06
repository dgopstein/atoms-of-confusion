select t.tag as atom,
uc.userid as userId,
min(c.id) as q1,
max(c.id) as q2,
SUM(CASE WHEN uc.correct||uc2.correct = 'TT' THEN 1 ELSE 0 END) as TT,
SUM(CASE WHEN uc.correct||uc2.correct = 'TF' THEN 1 ELSE 0 END) as TF,
SUM(CASE WHEN uc.correct||uc2.correct = 'FT' THEN 1 ELSE 0 END) as FT,
SUM(CASE WHEN uc.correct||uc2.correct = 'FF' THEN 1 ELSE 0 END) as FF
from scrubbed_usercode uc
join code c on uc.codeid = c.id
join scrubbed_usercode uc2 on uc.userid = uc2.userid and uc2.codeid = c.pair
join codetags ct on ct.codeid = c.id
join tag t on ct.tagid = t.id
where c.type = 'Confusing'
group by atom, uc.userid
order by q1, q2;
