-- UPDATE usercode SET correct='T' WHERE codeid = 3 AND answer = ;

--UPDATE usercode SET correct='T' WHERE (codeid, answer) in 

select * from usercode WHERE codeid ||','|| answer in (

--UPDATE usercode SET correct='T' WHERE codeid ||','|| answer in (
'3,true\n',
'9,ture',
'13,3 5+',
'18,flase 1',
'24,5, 3',
'51,2butnestedternariesarepainincarnate',
'61,2 1 guessing',
'62,2.0 1.0',
'68,abcdefasbcdef',
'68,abcefabcdef',
'91,e justrememberedhowthisworksyay',
'98,"2''',
'104,%c g',
'108,null',
'109,%d 3'
);
