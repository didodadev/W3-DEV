<cfsetting showdebugoutput="no">
<cfparam name="URL.folder" default="Gelen Kutusu">
<cfset URL.folder = URLDecode(URL.folder,"utf-8")>

<cfinclude template="exchange_conn.cfm">
<cfexchangemail action="get" connection="wrk_exchange_connection" name="mails">
  <cfexchangefilter name="folder" value="#attributes.folder#">
</cfexchangemail>

<cfset meetingData=evaluate("mails")>

<cfquery dbtype="query" name="theResponses">
	SELECT * FROM meetingData
</cfquery>

<cfexchangeConnection action="close" connection="wrk_exchange_connection">

<script language="javascript">
	function funcisOrder(){		
		var isOrd = document.getElementById('isOrder');
		if (!isOrd.checked){
			document.getElementById('order').style.display = 'block';
			isOrd.checked = 'checked';
		}else{
			document.getElementById('order').style.display = 'none';
			isOrd.checked = '';
		}	
	}
	
	function arama(){
		var arapanel = document.getElementById('arama');
		
		if (arapanel.style.display=='none')
			arapanel.style.display = 'block';
		else
			arapanel.style.display = 'none';
	}
	
	<cfset adres = "folder="&URL.folder>
	
	function aramaYap(){
		var arastr = document.getElementById('ara').value;
		var typestr = document.getElementById('type').selectedIndex;
		
		if (arastr==''){
			alert("<cf_get_lang dictionary_id='54778.Aranacak ifadeyi giriniz'>");
			return;
		}
		
		order = document.getElementById('order');
		orderText = order.options[order.selectedIndex].text;

		AjaxPageLoad('index.cfm?fuseaction=correspondence.emptypopup_exchange_mails_list&<cfoutput>#adres#</cfoutput>&ara='+arastr+'&type='+typestr+'&order='+order.selectedIndex+'&direction='+siralamaSekli,'mails_list',1);		
	}

	var siralamaSekli = "desc";
	function selectOrder(){

		order = document.getElementById('order');		
		orderText = order.options[order.selectedIndex].text;		

		if (siralamaSekli=="asc"){
			siralamaSekli = "desc";
			document.getElementById('siralamaPanel').innerHTML =" ("+orderText+" Göre) Sırala <img src='/images/exchange/arrowup.gif' border='0'/>";
		}else{
			siralamaSekli = "asc";
			document.getElementById('siralamaPanel').innerHTML =" ("+orderText+" Göre) Sırala <img src='/images/exchange/arrowdown.gif' border='0'/>";
		}
		
		AjaxPageLoad('index.cfm?fuseaction=correspondence.emptypopup_exchange_mails_list&<cfoutput>#adres#</cfoutput>&order='+order.selectedIndex+'&direction='+siralamaSekli,'mails_list',1);	
	}
	
	function getAllAddress(){
		order = document.getElementById('order');
		orderText = order.options[order.selectedIndex].text;
		orderIndex = order.orderIndex;
				
		var arastr = document.getElementById('ara').value;
		var typestr = document.getElementById('type').selectedIndex;
		
		if (arastr!='')
			return '<cfoutput>#adres#</cfoutput>&ara='+arastr+'&type='+typestr+'&order='+order.selectedIndex+'&direction='+siralamaSekli;
		else
			return '<cfoutput>#adres#</cfoutput>&order='+order.selectedIndex+'&direction='+siralamaSekli;
	}
</script>

<cfif theResponses.recordcount gt 0>
    <cfoutput>   
		<table style="border:solid 1px ##a7caed" bgcolor="##dce9f5" width="100%" height="40">
		  <tr height="22">
			<td width="25"><a href="javascript:newMail()"><img src="/images/exchange/compose.gif" border="0" title="Yeni Mail"/></a></td>
			<td width="25"><a href="javascript:replyMail()"><img src="/images/exchange/reply.gif" title="Yanıtla" border="0" /></a></td>
			<td width="25"><a href="javascript:replyAllMail()"><img src="/images/exchange/reply_all.gif" title="Tümünü Yanıtla" border="0" /></a></td>
			<td width="25"><a href="javascript:forwardMail()"><img src="/images/exchange/forward.gif" title="İlet" border="0" /></a></td>
			<td width="25"><a href="javascript:deleteMail()" ><img src="/images/exchange/delete.gif" title="Sil" border="0" /></a></td>
			<td width="25"><a href="javascript:arama()"><img src="/images/exchange/search.gif" title="Arama" border="0" /></a></td>
			<td  style="text-align:right;">
				<input type="checkbox" name="isOrder" value="1" id="isOrder" style="display:none" />
				<select name="order" id="order" style="display:none; font-size:8pt;" onchange="selectOrder()">
					<option value="0"><cf_get_lang dictionary_id="46953.Önem"></option>
					<option value="1"><cf_get_lang dictionary_id="54785.Okunma Durumu"></option>
					<option value="2"><cf_get_lang dictionary_id="51070.Gönderen"></option>
					<option value="3"><cf_get_lang dictionary_id="57480.Konu"></option>
					<option value="4" selected="selected"><cf_get_lang dictionary_id="54787.Alınma Tarihi"></option>
				</select>
			</td>
			<td  style="text-align:right;"><a href="javascript:"><img src="/images/exchange/orderedlist.gif" border="0" onclick="funcisOrder()"/></a></td>
		  </tr>  
		  <tr>
			<td colspan="10">
			<a href="javascript:selectOrder()" name="siralamaPanel" id="siralamaPanel"><cf_get_lang dictionary_id="54790.Alınma Tarihine Göre Sırala"> <img src="/images/exchange/arrowup.gif" border="0"/></a>
			</td>
		  </tr>
		</table>
		<div id="arama" style="display:none; position:absolute;border:solid 1px ##a7caed; background-color:##dce9f5; width:100%" align="center">
			<form id="mails_panel" name="mails_panel">
				<input type="text" name="ara" id="ara"  value=""/> 
				<select name="type" id="type">
					<option value="0"><cf_get_lang dictionary_id="51070.Gönderen"></option>
					<option value="1"><cf_get_lang dictionary_id="57480.Konu"></option>
				</select>
				<input type="button" value="Ara" onclick="aramaYap()"/>
				<input type="button" value="Kapat" onclick="arama()"/>
			</form>
		</div>	  
	</cfoutput>
	<div id="sonuc" align="center" style="position:absolute; display:none; width:100%"></div>
	<div id="mails_list"><cfinclude template="exchange_mails_list.cfm"></div>
<cfelse>
  <table width="100%">
    <tr>
      <td align="center"><strong><cf_get_lang dictionary_id="54791.Mail Bulunamadı">!</strong></td>
    </tr>
  </table>
</cfif>
<script language="javascript">
	var keyDown = null;
	var preSelected = null
	var currentSelected = null
	var selectedID = null;
	var secili = '#95c9d6';
	var uzerinde = '#e3ebf2';
	
	var tbl = document.getElementById('table_list');
	document.onkeydown = function(e) { if (!e) e = window.event; if (e.ctrlKey) keyDown = "ctrl"; if (e.shiftKey) keyDown = "shift";};
    document.onkeyup = function(e) { keyDown = null; preSelected=null;currentSelected = null};

	function mouseclick(obj,uid,index,event){
		var start,end;	
		selectedID = uid;
		
		if (keyDown == "ctrl"){
			var chk = document.getElementById('chk_'+index);
			if (chk.checked){
				chk.checked=''
				document.getElementById('table_'+index).style.backgroundColor = '';
			}else{
				chk.checked='checked';
				document.getElementById('table_'+index).style.backgroundColor = secili;
			}
			preSelected = index;
		}else if (keyDown == "shift"){
			if (preSelected == null) preSelected = index;
			currentSelected = index;
			
			var trs = tbl.childNodes[0].childNodes;
			for (var i=0;i<trs.length;i++){
				document.getElementById('table_'+i).style.backgroundColor='';
				document.getElementById('chk_'+i).checked='';
			}
					
			if (preSelected!=null){
				start = Math.min(preSelected,currentSelected);
				end = Math.max(preSelected,currentSelected);
				for (var i=start;i<=end;i++){
					document.getElementById('chk_'+i).checked='checked';
					document.getElementById('table_'+i).style.backgroundColor=secili;
				}
			}
			
			currentSelected = null;
		}else{ // shift ya da ctrl kullanılmadıysa					
			if (event.button==1)
				openMail();	
			else if (event.button==2){
				var chk = document.getElementById('chk_'+index);
				var tr = document.getElementById('table_'+index);
				document.getElementById('table_'+index).style.backgroundColor=secili;
				if (chk.checked)
					return;		
			}
			
			try{
				var trs = tbl.childNodes[0].childNodes;
				for (var i=0;i<25;i++){
					document.getElementById('table_'+i).style.backgroundColor='';
					document.getElementById('chk_'+i).checked='';
				}
			}catch(err){}

			document.getElementById('table_'+index).style.backgroundColor=secili;
			document.getElementById('chk_'+index).checked='checked';
			preSelected = index;			
		}		
	}
	
	function mouseover(obj){
		obj.style.cursor='hand';
		if (obj.style.backgroundColor!=secili)
			obj.style.backgroundColor=uzerinde;
	}

	function mouseout(obj){
		obj.style.cursor='';
		if (obj.style.backgroundColor!=secili){
			obj.style.backgroundColor='';
		}
	}

	function deleteMail(){
		var form = document.forms['mails_form'];
		form.action = "index.cfm?fuseaction=correspondence.emptypopup_exchange_islem";
		form.islem.value = "del";
		AjaxFormSubmit('mails_form','sonuc',true,'bekle','basarili',false,false,true); 
	}
	
	function signUnread(){
		var form = document.forms['mails_form'];
		form.action = "index.cfm?fuseaction=correspondence.emptypopup_exchange_islem";
		form.islem.value = "unread";
		AjaxFormSubmit('mails_form','sonuc',true,'bekle','basarili',false,false,true); 
	}	
	
	function setPriority(priorityValue){
		var form = document.forms['mails_form'];
		form.action = "index.cfm?fuseaction=correspondence.emptypopup_exchange_islem&pvalue="+priorityValue;
		form.islem.value = "priority";
		form.pvalue.value = priorityValue;
		AjaxFormSubmit('mails_form','sonuc',true,'bekle','basarili',false,false,true); 
	}
	
	function moveCopy(){
		var form = document.forms['mails_form'];
		form.action = "index.cfm?fuseaction=correspondence.emptypopup_exchange_moveCopy";			
		window.open('', 'myNewWin', 'width=350,height=400,status=no,resizable=no,scrollbars=no,menubar=no');
		form.target="myNewWin";
		document.mails_form.submit();
		
	}	
	
	function openMail(){
		AjaxPageLoad('index.cfm?fuseaction=correspondence.emptypopup_exchange_mail_content&folder=<cfoutput>#URLEncodedFormat(URL.folder)#</cfoutput>&mail_id='+selectedID,'mail_content',1);
	}

	function replyAllMail(){
		AjaxPageLoad('index.cfm?fuseaction=correspondence.emptypopup_exchange_send_frm&islem=replyAll&folder=<cfoutput>#URLEncodedFormat(URL.folder)#</cfoutput>&mail_id='+selectedID,'mail_content',1);
	}
			
	function replyMail(){
		AjaxPageLoad('index.cfm?fuseaction=correspondence.emptypopup_exchange_send_frm&islem=reply&folder=<cfoutput>#URLEncodedFormat(URL.folder)#</cfoutput>&mail_id='+selectedID,'mail_content',1);
	}
	
	function forwardMail(){
		AjaxPageLoad('index.cfm?fuseaction=correspondence.emptypopup_exchange_send_frm&islem=forward&folder=<cfoutput>#URLEncodedFormat(URL.folder)#</cfoutput>&mail_id='+selectedID,'mail_content',1);
	}
	
	function newMail(){
		AjaxPageLoad('index.cfm?fuseaction=correspondence.emptypopup_exchange_send_frm&islem=new&folder=<cfoutput>#URLEncodedFormat(URL.folder)#</cfoutput>','mail_content',1);
	}		
</script>
