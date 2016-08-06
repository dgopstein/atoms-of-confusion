select
  u.name,
  sum(case when uc.correct='T' then 1 else 0 end) as n_correct,
  count(*) as n_questions
  --,n_correct / n_questions as correctness
from scrubbed_usercode uc
join user u on u.id = uc.userid
group by uc.userid;
