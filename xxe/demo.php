<?php
libxml_disable_entity_loader(false);
$xmlfile = file_get_contents('php://input');

/*将xml格式的payload当作通过POST协议, 做为字符串传给xmlfile*/
$dom = new DOMDocument();
/*将xml字符串解析为数组*/
$dom->loadXML($xmlfile, LIBXML_NOENT | LIBXML_DTDLOAD);
$creds = simplexml_import_dom($dom);
/*查看外部实体类, 泄露flag*/
var_dump($creds);
?>