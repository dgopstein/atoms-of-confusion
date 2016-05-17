-- Remove results from users who didn't finish the test

delete from usercode where userid in (select id from user u join usercode uc on uc.userid = u.id where u.score = -1);
delete from user where score = -1;

