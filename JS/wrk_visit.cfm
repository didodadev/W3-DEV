var _wgifpath="http://<cfoutput>#cgi.HTTP_HOST#</cfoutput>/web_services/wrk_visit.cfm";
var vdt,vref="-",vdm,vacct,vrand,doc=document,loc=doc.location;
function workcubeTracker(page) {
	if (loc.protocol == "file:") return;
	var pg=loc.pathname+loc.search;
	if (page && page!="") pg=strEscape(page,1);
	vref=doc.referrer;
 	if (!vref || vref=="") { vref="-"; }
	else {
  		vdm=doc.domain;
	}
	vrand=Math.round(Math.random()*2147483647);
	vdt=new Date();
	
	var s="";
	s+="&rand="+vrand;
	if (doc.title && doc.title!="") s+="&title="+strEscape(doc.title);
	if (loc.hostname && loc.hostname!="") s+="&host="+strEscape(loc.hostname);
	s+="&ref="+vref;
	s+="&pg="+pg;
	
	var i=new Image(1,1);
	i.src=_wgifpath+"?"+s;
	i.onload=function() {wrkVoid();}
}

function wrkVoid() {return;}

function strEscape(s,u) {
 if (typeof(encodeURIComponent) == 'function') {
  if (u) return encodeURI(s);
  else return encodeURIComponent(s);
 } else {
  return escape(s);
 }
}

workcubeTracker();
