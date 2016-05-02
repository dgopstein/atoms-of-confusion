-- Remove results from users who took negative time
delete from usercode where userid in (select id from user u where u.duration < 0);

