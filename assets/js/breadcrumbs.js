var path = "";
var pathurl = "";
var pathtext = "";
var href = document.location.href;
var s = href.split("/");
for (var i=2;i<(s.length);i++) {
	if (s[i].substring(0,6) != "index."){
		if (i==2){
			pathtext = "home";
		}else{
			path+="<li><a href=\""+pathurl+"/\">"+pathtext+"</a></li> &raquo; ";
			pathtext = s[i];
			while(pathtext.indexOf("-")>0){pathtext=pathtext.replace("-", " ");}
			if (pathtext.indexOf(".")>0){pathtext=pathtext.substring(0,pathtext.indexOf("."));}
		}	
		pathurl=href.substring(0,href.indexOf("/"+s[i])+s[i].length+1);
	}
}
path+="<li>"+pathtext+"</li>";
document.writeln("<ul class=breadcrumbs>"+path+"</ul>");