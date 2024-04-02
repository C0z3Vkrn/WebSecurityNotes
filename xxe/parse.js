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
