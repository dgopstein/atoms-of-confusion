select t.tag as atom, uc.codeid as codeid, uc.userid as userId, uc.correct||uc2.correct as response,
CASE WHEN uc.correct||uc2.correct = 'TT' THEN 1 ELSE 0 END as TT,
CASE WHEN uc.correct||uc2.correct = 'TF' THEN 1 ELSE 0 END as TF,
CASE WHEN uc.correct||uc2.correct = 'FT' THEN 1 ELSE 0 END as FT,
CASE WHEN uc.correct||uc2.correct = 'FF' THEN 1 ELSE 0 END as FF
from usercode uc
join code c on uc.codeid = c.id
join usercode uc2 on uc.userid = uc2.userid and uc2.codeid = c.pair
join codetags ct on ct.codeid = c.id
join tag t on ct.tagid = t.id
where c.type = 'Confusing'
group by t.id, uc.userid;

--add_CONDITION_atom                 : 1 - (p:6.04e-03, es:0.23)  (108   6  20  12)
--add_PARENTHESIS_atom               : 1 - (p:9.64e-05, es:0.32)  (105   4  25  11)
--move_POST_INC_DEC_atom             : 1 - (p:5.19e-11, es:0.54)  ( 75   4  54  13)
--move_PRE_INC_DEC_atom              : 1 - (p:4.02e-04, es:0.29)  ( 82  11  35  18)
--replace_CONSTANTVARIABLE_atom      : 0 - (p:1.00e+00, es:0.00)  (142   2   2   0)
--remove_INDENTATION_atom            : 1 - (p:8.49e-07, es:0.41)  ( 70  13  53  10)
--replace_MACRO_atom                 : 1 - (p:2.22e-12, es:0.65)  ( 53   2  55   6)
--replace_Mixed_Pointer_Integer_Arithmetic: 0 - (p:7.63e-01, es:0.02)  ( 67  21  23  35)
--replace_Ternary_Operator           : 1 - (p:2.43e-08, es:0.46)  (109   1  34   1)
--replace_Arithmetic_As_Logic        : 0 - (p:2.48e-01, es:0.10)  (133   4   8   1)
--replace_Comma_Operator             : 1 - (p:5.54e-05, es:0.33)  ( 53  17  50  26)
--move_Preprocessor_Directives_Inside_Statements: 1 - (p:1.37e-14, es:0.64)  ( 39   5  73  28)
--Constant Assignment                : 1 - (p:5.70e-13, es:0.60)  ( 59   6  68  13)
--Logic as Control Flow              : 1 - (p:5.89e-11, es:0.54)  ( 32  12  72  30)
--Re-purposed variables              : 1 - (p:9.37e-03, es:0.22)  ( 54  15  33  44)
--Swapped subscripts                 : 1 - (p:5.36e-07, es:0.41)  ( 70   6  40  30)
--Dead, unreachable, repeated        : 0 - (p:5.88e-02, es:0.16)  (138   1   6   1)
--Literal encoding                   : 1 - (p:7.51e-20, es:0.75)  ( 35   2  89  20)
--Curly braces                       : 1 - (p:3.19e-03, es:0.24)  ( 77  13  33  23)
--Type conversion                    : 1 - (p:9.61e-08, es:0.44)  ( 75  10  52   9)
--Indentation                        : 0 - (p:2.23e-01, es:0.10)  (102  13  20  11)

--add_CONDITION_atom                 1 0 - (p:4.39e-01, es:0.09)  ( 49   6   9   9)
--add_PARENTHESIS_atom               1 1 - (p:1.16e-02, es:0.30)  ( 45   4  15   9)
--move_POST_INC_DEC_atom             1 1 - (p:7.12e-06, es:0.53)  ( 35   3  28   7)
--move_PRE_INC_DEC_atom              1 1 - (p:1.07e-03, es:0.38)  ( 40   5  22   6)
--replace_CONSTANTVARIABLE_atom      0 0 - (p:5.64e-01, es:0.07)  ( 70   2   1   0)
--remove_INDENTATION_atom            1 1 - (p:2.57e-04, es:0.43)  ( 38   6  27   2)
--replace_MACRO_atom                 1 1 - (p:4.46e-05, es:0.48)  ( 47   2  22   2)
--replace_Mixed_Pointer_Integer_Arithtetic0 0 - (p:5.64e-01, es:0.07)  ( 34  12  15  12)
--replace_Ternary_Operator           1 1 - (p:1.08e-04, es:0.45)  ( 58   0  15   0)
--replace_Arithmetic_As_Logic        0 0 - (p:1.00e+00, es:0.00)  ( 67   3   3   0)
--replace_Comma_Operator             1 0 - (p:2.73e-01, es:0.13)  ( 22  12  18  21)
--move_Preprocessor_Directives_InsidetStatements1 1 - (p:2.56e-12, es:0.82)  ( 24   0  49   0)
--Constant Assignment                1 1 - (p:2.10e-06, es:0.56)  ( 21   5  35  12)
--Logic as Control Flow              1 1 - (p:1.57e-03, es:0.37)  ( 17  10  30  16)
--Re-purposed variables              1 1 - (p:6.04e-03, es:0.32)  ( 26   6  20  21)
--Swapped subscripts                 1 1 - (p:8.77e-05, es:0.46)  ( 33   3  23  14)
--Dead, unreachable, repeated        0 0 - (p:1.57e-01, es:0.17)  ( 71   0   2   0)
--Literal encoding                   1 1 - (p:2.07e-06, es:0.56)  ( 25   2  28  18)
--Curly braces                       1 1 - (p:6.71e-03, es:0.32)  ( 37   5  18  13)
--Type conversion                    1 1 - (p:2.53e-08, es:0.65)  ( 21   5  44   3)
--Indentation                        0 0 - (p:4.05e-01, es:0.10)  ( 51   8   5   9)
