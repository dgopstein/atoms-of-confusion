-- Select clustered user data to be analyzed by the
-- clustered-matched-pair package I'm developing

select
  uc.userid as subject,
  t.tag as atom,
  uc.correct  = 'T' as control,
  uc2.correct = 'T' as treatment
from scrubbed_usercode uc
join code c on uc.codeid = c.id
join scrubbed_usercode uc2 on uc.userid = uc2.userid and uc2.codeid = c.pair
join codetags ct on ct.codeid = c.id
join tag t on ct.tagid = t.id
where
uc.userid < 20 AND uc.codeid < 20 AND
c.type = 'Confusing';

