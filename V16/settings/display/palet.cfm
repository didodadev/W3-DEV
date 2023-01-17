<!doctype html public "-//W3C//DTD HTML 4.0 Transitional//EN"> 
<html> 
<head> 
<title>Colour Picker</title> 
<meta name="Keywords" content=""> 
<meta name="Description" content=""> 
<meta name="MSSmarttagsPreventParsing" content="TRUE" /> 
<meta name="robots" content="index,follow" /> 
<script type="text/JavaScript"> 
<!-- 
var colours = new Array("#FFFFFF", "#FFCCCC", "#FFCC99", "#FFFF99", "#FFFFCC", "#99FF99", "#99FFFF", "#CCFFFF", "#CCCCFF", "#FFCCFF", "#CCCCCC", "#FF6666", "#FF9966", "#FFFF66", "#FFFF33", "#66FF99", "#33FFFF", "#66FFFF", "#9999FF", "#FF99FF", "#C0C0C0", "#FF0000", "#FF9900", "#FFCC66", "#FFFF00", "#33FF33", "#66CCCC", "#33CCFF", "#6666CC", "#CC66CC", "#999999", "#CC0000", "#FF6600", "#FFCC33", "#FFCC00", "#33CC00", "#00CCCC", "#3366FF", "#6633FF", "#CC33CC", "#666666", "#990000", "#CC6600", "#CC9933", "#999900", "#009900", "#339999", "#3333FF", "#6600CC", "#993399", "#333333", "#660000", "#993300", "#996633", "#666600", "#006600", "#336666", "#000099", "#333399", "#663366", "#000000", "#330000", "#663300", "#663333", "#333300", "#003300", "#003333", "#000066", "#330099", "#330033"); 
var divPreview; 
function mouseOver(el, Colour){ 
  divPreview.style.background = Colour; 
  document.frmColour.ColorHex.value = Colour; 
  el.style.borderColor = '#FFFFFF'; 
} 
function mouseOut(el){ 
  el.style.borderColor = '#666666'; 
} 
function mouseDown(Colour){ 
  self.parent.setColor(Colour); 
  self.parent.palette.style.visibility = 'hidden'; 
} 
function init(){ 
    divPreview = Obj("divPreview"); 
} 
function Obj(name) { 
    return document[name]||(document.all && document.all[name])||(document.getElementById && document.getElementById(name)); 
} 

//--> 
</script> 
<style type="text/css"> 
td{text-align:center;vertical-align:middle;} 
.tblPalette{cursor:pointer;background:#FFFFFF;width:100%;height:100%;line-height:1px;font-size:1px;} 
.tblPalette td{border:1px #666666 solid;} 
</style> 
</head> 

<body bgcolor="#FFFFFF" onLoad="init();" onContextMenu="return false" onDragStart="return false" onSelectStart="return false" style="margin:0px;padding:0px;"> 
<table border=0 cellspacing=0 cellpadding=0 width="100%" height="100%"> 
<tr><td valign="middle" style="width:55px;height:25px;background:#FFFFFF;"> 
<center><div name="divPreview" id="divPreview" style="height:20px;width:50px;border:1px #000000 solid;"></div></center></td> 
<td bgcolor="#FFFFFF" valign="middle" style=""><form name="frmColour" style="padding:0px;margin:0px;"> 
<input readonly type="text" name="ColorHex" id="ColorHex" value="" size=10 style="width:80px;font-size: 12px"></form></td> 
  <td bgcolor="#FFFFFF"><img src="close.gif" onClick=" self.parent.palette.style.visibility = 'hidden';" width="13" height="13" border="0" alt="Close" title='Close Palette'></td> 
</tr> 
<tr><td style="width:100%" colspan="3"> 
<script type="text/JavaScript"> 
<!-- 
code = "<table class='tblPalette' cellpadding='0' cellspacing='1' border='0'>"; 
for (i = 0;i < 70; i++){ 
    if((i)%10 == 0)code += "<tr>"; 
    code += "<td id='el_"+i+"' bgcolor="+colours[i]+" onMouseOver=\"mouseOver(this, '"+colours[i]+"');\" onMouseOut='mouseOut(this)' onClick=\"mouseDown('"+colours[i]+"');\">&nbsp;</td>\n"; 
    if((i+1)%10 == 0)code += "</tr>\n"; 
} 
document.write(code+"</table>"); 
//--> 
</script> 
</td></tr> 
</table> 

</body> 
</html>
