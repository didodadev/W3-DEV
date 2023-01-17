<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"><head>
<style>
	<!--
	.skin1 {
		cursor:default;
		font:menutext;
		position:absolute;
		text-align:left;
		width:180px;
		background-color:white;
		border:1 solid buttonface;
		visibility:hidden;
		border:2 outset buttonhighlight;
	}
	
	.skin1 table{
		font-size: 9pt;
		width:100%;
		font-family:Arial, Helvetica, sans-serif;
	}

	.skin1 table th{
		width:20px;
		height:20px;
		text-align:center;
		background-color:#8cb5e7;
	}
	
	.skin1 table td{
		height:20px;
	}
		
	.skin1 table a{
		display:block;	
		height:20px;
		margin-left:5px;
	}
	
	.skin1 table a:hover{
		display:block;	
		height:20px;
		text-decoration:none;
	}	
	
	.skin1 table img{
		width:15px;
	}	
	-->
</style>

<SCRIPT LANGUAGE="JavaScript1.2">

var menuskin = "skin1"; // skin0, or skin1
var display_url = 0; // Show URLs in status bar?
function showmenuie5(event) {
	
	var rightedge = document.body.clientWidth-event.clientX;
	var bottomedge = document.body.clientHeight-event.clientY;
	
	if (rightedge < ie5menu.offsetWidth)
	ie5menu.style.left = document.body.scrollLeft + event.clientX - ie5menu.offsetWidth + 'px';
	else
	ie5menu.style.left = document.body.scrollLeft + event.clientX + 'px';
	
	if (bottomedge < ie5menu.offsetHeight)
	ie5menu.style.top = document.body.scrollTop + event.clientY - ie5menu.offsetHeight + 'px';
	else
	ie5menu.style.top = document.body.scrollTop + event.clientY + 'px';
	
	ie5menu.style.visibility = "visible";
return false;
}

function hidemenuie5() {
	ie5menu.style.visibility = "hidden";
}
function highlightie5() {
	if (event.srcElement.className == "menuitems") {
		event.srcElement.style.backgroundColor = "highlight";
		event.srcElement.style.color = "white";
		
	if (display_url)
		window.status = event.srcElement.url;
	}
}
function lowlightie5() {
	if (event.srcElement.className == "menuitems") {
		event.srcElement.style.backgroundColor = "";
		event.srcElement.style.color = "black";
		window.status = "";
   }
}
function jumptoie5() {
	if (event.srcElement.className == "menuitems") {
		if (event.srcElement.getAttribute("target") != null)
		window.open(event.srcElement.url, event.srcElement.getAttribute("target"));
	else
		window.location = event.srcElement.url;
   }
}

function showmenuie5_2(event) {
	
	var rightedge = document.body.clientWidth-event.clientX;
	var bottomedge = document.body.clientHeight-event.clientY;

	if (rightedge < ie5menu_2.offsetWidth)
	ie5menu_2.style.left = document.body.scrollLeft + event.clientX - ie5menu_2.offsetWidth;
	else
	ie5menu_2.style.left = document.body.scrollLeft + event.clientX;
	
	if (bottomedge < ie5menu_2.offsetHeight)
	ie5menu_2.style.top = document.body.scrollTop + event.clientY - ie5menu_2.offsetHeight;
	else
	ie5menu_2.style.top = document.body.scrollTop + event.clientY;
	
	ie5menu_2.style.visibility = "visible";
return false;
}

function hidemenuie5_2() {
	ie5menu_2.style.visibility = "hidden";
}
//  End -->
</script>

</head>

<cfparam name="URL.mailbox_id" default="">
<cfset session.mailbox_id = "">	

<cfif URL.mailbox_id is "">
	<cfquery name="EXCHANGE_SETTINGS" datasource="#dsn#">
		SELECT
			SETTING_ID
		FROM
			EXCHANGE_SETTINGS
		WHERE 
			USER_ID = #session.ep.userid#
	</cfquery>
	
	<cfif EXCHANGE_SETTINGS.recordcount gt 0>
		<cfoutput query="EXCHANGE_SETTINGS" maxrows="1">
			<cfset session.mailbox_id = #SETTING_ID#>		
		</cfoutput>
	<cfelse>
		<cfset session.mailbox_id = "">	
		<script language="javascript">
			alert('Bağlantı Sağlanamadı!\nHerhangi bir kullanıcı tanımlanmamıştır.');
			window.location = '<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.welcome';
		</script>		
		<cfabort>		
	</cfif>
<cfelse>
	<cfset session.mailbox_id = URL.mailbox_id>
</cfif>

<table width="100%" height="100%" cellspacing="1" style="border:solid 1px #a7caed" bgcolor="#dce9f5">
  <tr>
    <td valign="top" id="folders" width="15%" bgcolor="white"><cfinclude template="exchange_folders.cfm"></td>
    <td width="5" style="border:solid 1px #a7caed">&nbsp;</td>
    <td valign="top" id="mails" width="25%" bgcolor="white"></td>
    <td width="5" style="border:solid 1px #a7caed">&nbsp;</td>
    <td valign="top" id="mail_content" bgcolor="#FFFFFF"></td>
  </tr>
</table>

<!--- menu interface area --->
<div id="ie5menu_2" onMouseover="highlightie5()" onMouseout="lowlightie5()" onClick="jumptoie5();">
	<table cellspacing="0" cellpadding="0">	
		<tr onmouseover="this.style.backgroundColor='#fedb90'" onmouseout="this.style.backgroundColor=''">
			<th></th>
			<td><a href="#" onclick="deleteSilinmisKlasor()"><cf_get_lang dictionary_id="54792.Silinmiş Öğeler Klasörünü Boşalt"></a></td>
		</tr>			
	</table>
</div>

<div id="ie5menu" onMouseover="highlightie5()" onMouseout="lowlightie5()" onClick="jumptoie5();">
	<table cellspacing="0" cellpadding="0">
		<tr onmouseover="this.style.backgroundColor='#fedb90'" onmouseout="this.style.backgroundColor=''">
			<th></th>
			<td><a href="#" onclick="openMail()"><cf_get_lang dictionary_id="48969.Aç"></a></td>
		</tr>
		<tr onmouseover="this.style.backgroundColor='#fedb90'" onmouseout="this.style.backgroundColor=''">
			<th></th>
			<td><a href="#" onclick="replyMail();"><cf_get_lang dictionary_id="51094.Yanıtla"></a></td>
		</tr>
		<tr onmouseover="this.style.backgroundColor='#fedb90'" onmouseout="this.style.backgroundColor=''">
			<th></th>
			<td><a href="#" onclick="forwardMail();"><cf_get_lang dictionary_id="54809.Yönlendir"></a></td>
		</tr>	
		<tr onmouseover="this.style.backgroundColor='#fedb90'" onmouseout="this.style.backgroundColor=''">
			<th><img src="images/exchange/delete.gif" /></th>
			<td><a href="#" onclick="deleteMail()"><cf_get_lang dictionary_id="51300.Mailleri Sil"></a></td>
		</tr>		
		<tr onmouseover="this.style.backgroundColor='#fedb90'" onmouseout="this.style.backgroundColor=''">
			<th><img src="images/exchange/unread.gif" /></th>
			<td><a href="#" onclick="signUnread()"><cf_get_lang dictionary_id="54823.Okunmadı Olarak İşaretle"></a></td>
		</tr>		
		<tr>
			<th></th>
			<td><hr /></td>
		</tr>
		<tr onmouseover="this.style.backgroundColor='#fedb90'" onmouseout="this.style.backgroundColor=''">
			<th><img src="images/exchange/down.gif"/></th>
			<td><a href="#" onclick="setPriority(1)"><cf_get_lang dictionary_id="54824.Düşük Öncelik"></a></td>
		</tr>
		<tr onmouseover="this.style.backgroundColor='#fedb90'" onmouseout="this.style.backgroundColor=''">
			<th></th>
			<td><a href="#" onclick="setPriority(2)"><cf_get_lang dictionary_id="47864.Normal"></a></td>
		</tr>
		<tr onmouseover="this.style.backgroundColor='#fedb90'" onmouseout="this.style.backgroundColor=''">
			<th><img src="images/exchange/exclamation.gif"/></th>
			<td><a href="#" onclick="setPriority(3)"><cf_get_lang dictionary_id="54825.Yüksek Öncelik"></a></td>
		</tr>
		<tr>
			<th></th>
			<td><hr /></td>
		</tr>				
		<tr onmouseover="this.style.backgroundColor='#fedb90'" onmouseout="this.style.backgroundColor=''">
			<th></th>
			<td><a href="#" onclick="moveCopy()"><cf_get_lang dictionary_id="54826.Mailleri Taşı/Kopyala"></a></td>
		</tr>							
	</table>
</div>

<script language="JavaScript1.2">
	function deleteSilinmisKlasor(){
		AjaxPageLoad('index.cfm?fuseaction=correspondence.emptypopup_exchange_islem&islem=delSilinmis','mail_content',1);	
	}
		
	ie5menu.className = menuskin;
	ie5menu_2.className = menuskin;
	document.body.onmousedown = function(){return false};
	document.body.onmouseup = function(){hidemenuie5();hidemenuie5_2();return false};
	document.oncontextmenu=new Function("return false;")
</script>
