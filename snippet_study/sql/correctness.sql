select t.tag as atom, t.tag||'_'||uc.codeid as question, uc.codeid as qid, c.type,
SUM(CASE WHEN uc.correct = 'T' THEN 1 ELSE 0 END) as T,
SUM(CASE WHEN uc.correct = 'F' THEN 1 ELSE 0 END) as F,
count(*) as total
from scrubbed_usercode uc
join code c on uc.codeid = c.id
join codetags ct on ct.codeid = c.id
join tag t on ct.tagid = t.id
group by t.id, qid;
