<style type="text/css">
#divCont{width:100%; height:150; overflow:hidden; clip:rect(0,300,150,0); visibility:hidden}
#divText{position:absolute; top:0; left:0;font-family:verdana;font-size:11px;}
</style>
<script type="text/javascript" language="JavaScript">
function checkBrowser(){
	this.ver=navigator.appVersion
	this.dom=document.getElementById?1:0
	this.ie5=(this.ver.indexOf("MSIE 5")>-1 && this.dom)?1:0;
	this.ie4=(document.all && !this.dom)?1:0;
	this.ns5=(this.dom && parseInt(this.ver) >= 5) ?1:0;
	this.ns4=(document.layers && !this.dom)?1:0;
	this.bw=(this.ie5 || this.ie4 || this.ns4 || this.ns5)
	return this
}
bw=new checkBrowser()

/* KAYMA HIZI*/
var speed=20

/*Sets variables to keep track of what's happening*/
var loop, timer

/*Object constructor*/
function makeObj(obj,nest){
    nest=(!nest) ? '':'document.'+nest+'.'
	this.el=bw.dom?document.getElementById(obj):bw.ie4?document.all[obj]:bw.ns4?eval(nest+'document.'+obj):0;
  	this.css=bw.dom?document.getElementById(obj).style:bw.ie4?document.all[obj].style:bw.ns4?eval(nest+'document.'+obj):0;
	this.scrollHeight=bw.ns4?this.css.document.height:this.el.offsetHeight
	this.clipHeight=bw.ns4?this.css.clip.height:this.el.offsetHeight
	this.up=goUp;this.down=goDown;
	this.moveIt=moveIt; this.x; this.y;
    this.obj = obj + "Object"
    eval(this.obj + "=this")
    return this
}
function moveIt(x,y){
	this.x=x;this.y=y
	this.css.left=this.x
	this.css.top=this.y
}

/*Makes the object go up*/
function goDown(move){
	if(this.y>-this.scrollHeight+oCont.clipHeight){
		this.moveIt(0,this.y-move)
			if(loop) setTimeout(this.obj+".down("+move+")",speed)
	}
}
/*Makes the object go down*/
function goUp(move){
	if(this.y<0){
		this.moveIt(0,this.y-move)
		if(loop) setTimeout(this.obj+".up("+move+")",speed)
	}
}

/*Calls the scrolling functions. Also checks whether the page is loaded or not.*/
function scroll(speed){
	if(loaded){
		loop=true;
		if(speed>0) oScroll.down(speed)
		else oScroll.up(speed)
	}
}

/*Stops the scrolling (called on mouseout)*/
function noScroll(){
	loop=false
	if(timer) clearTimeout(timer)
}
/*Makes the object*/
var loaded;
function scrollInit(){
	oCont=new makeObj('divCont')
	oScroll=new makeObj('divText','divCont')
	oScroll.moveIt(0,0)
	oCont.css.visibility='visible'
	loaded=true;
}
</script>

<body onLoad="scrollInit()">
      <table WIDTH="98%" CELLSPACING="1" CELLPADDING="2" CLASS="color-border" align="center">
        <tr CLASS="color-list" HEIGHT="22">
          <td BACKGROUND="/images/webhaber.jpg" class="formbold">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cf_get_lang no='123.WORKCUBE WEBHABER'></td>
        </tr>
        <tr CLASS="color-row"> 
            <td VALIGN="top">

<div style="text-align:right;">
<a href="#" onMouseOver="scroll(-2)" onMouseOut="noScroll()">
<img src="/images/listele_up.gif" border="0"></a>
</div>
<br/>
<div id="divCont" style="left: 10"> 
  <div id="divText">
		<cfoutput>
				deneme<br/> 
				deneme<br/> 
				deneme<br/> 
				deneme<br/> 
				deneme<br/> 
				deneme<br/> 
				deneme<br/> 
				deneme<br/> 
				deneme<br/> 
				deneme<br/> 
				deneme<br/> 
		</cfoutput> 
	</div>
</div>
<div style="text-align:right;">
<a href="#" onMouseOver="scroll(2)" onMouseOut="noScroll()">
<img src="/images/listele_down.gif" border="0"></a>
</div>
            </td>          
		  </tr>
      </table>

</body>
