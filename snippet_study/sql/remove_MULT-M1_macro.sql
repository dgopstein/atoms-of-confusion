-- There was an issue where one of our questions (39, 40) erroneously called its macro
-- MULT instead of M1. We ended up changing the name of the macro on 4/17, but only after several
-- subjects had already taken the test. To make matters worse there was a period before 4/17
-- where the question referenced both macro names. Here we remove every response to one of
-- those invalid questions

select *
--delete
from scrubbed_usercode WHERE codeid in (39, 40) and userid in (select id from user where lastlogin < '2016-04-18 00:00:00');

