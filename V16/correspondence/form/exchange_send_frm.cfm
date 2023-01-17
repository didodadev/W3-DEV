<cfsetting showdebugoutput="no">
<cfparam name="URL.folder" default="Gelen Kutusu">
<cfparam name="URL.mail_id" default="">
<cfparam name="URL.islem" default="">
<cfset msgFrom = "">
<cfset msgTo = "">
<cfset msgCc = "">
<cfset msgBcc = "">
<cfset msgSubject = "">
<cfset message = "">
<cfset msgTimeReceived  = "">

<cfset URL.folder = URLDecode(URL.folder)>
<cfset URL.mail_id = URLDecode(URL.mail_id)>

<cfinclude template="../display/exchange_conn.cfm">

<cfif URL.islem is "forward" or URL.islem is "reply" or URL.islem is "replyAll">
  <cfoutput>
    <cfexchangemail action="get" folder="#URL.folder#" name="mail_content" connection="sample">
      <cfif not URL.mail_id is "">
        <cfexchangefilter name="uid" value="<#URL.mail_id#>">
      </cfif>
    </cfexchangemail>
  </cfoutput>
  <cfset meetingData=evaluate("mail_content")>
  <cfquery dbtype="query" name="theResponses">
	SELECT * FROM meetingData
  </cfquery>
  <cfif theResponses.recordcount gt 0>
    <cfoutput>
      <cfloop query="theResponses">
        <cfset msgFrom =  replace(FROMID,'"','','all') >
        <cfset msgTo = replace(TOID,'"','','all')>
        <cfset msgCc = replace(CC,'"','','all')>
        <cfset msgBcc = replace(BCC,'"','','all')>
        <cfset msgSubject = replace(SUBJECT,'"','','all')>
		<cfset msgSubject = replace(msgSubject,"'","",'all')>
        <cfset message = HTMLMESSAGE>
        <cfset msgTimeReceived  = TIMERECEIVED>
      </cfloop>
    </cfoutput>
  </cfif>
</cfif>

<iframe name="form_submit" id="form_submit" width="100%" height="100%" style="display:none;position:absolute;" frameborder="0" scrolling="no"></iframe>
<table width="100%" border="0" cellpadding="3" cellspacing="0">
	<form name="FrmCompose" id="FrmCompose" method="post" action="index.cfm?fuseaction=correspondence.emptypopup_exchange_send_mail" target="form_submit">
		<input type="hidden" name="folder" id="folder" value="<cfoutput>#URL.folder#</cfoutput>"/>
		<input type="hidden" name="islem" id="islem" value="send" />  
		<tr>
			<td nowrap="nowrap" valign="top">
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td width="103" height="25" valign="center" nowrap ><a tabindex="13" href="#" onclick="sendFormMail()" style="cursor:pointer"> <img id="imgSend" name="imgSend" alt="İleti Gönder" height="16" width="16" border="0" align="absmiddle" src="/images/exchange/send.gif" style="cursor:pointer">&nbsp; <cf_get_lang dictionary_id="58743.Gönder"> </a> </td>
						<td width="87" valign="center" nowrap ><a tabindex="14" href="javascript:openMail()" style="cursor:pointer"> <img id="imgCancel" name="imgCancel" alt="İptal" height="16" width="16" border="0" align="absmiddle" src="/images/exchange/cancel.gif" style="cursor:pointer">&nbsp; <cf_get_lang dictionary_id="58506.İptal"> </a> </td>
						<td width="100%" valign="center" nowrap><a tabindex="14" href="javascript:ShowHideMessageOptions();" style="cursor:pointer"></a> </td>
					</tr>
				</table>
				<table width="100%" border="0" cellpadding="0" cellspacing="0" background="/images/exchange/msglist_bar_bg.gif" style='display:none; background-repeat:repeat-x; padding-bottom: 2px;'>
				  <tr>
					<td><table border="0" cellpadding="0" cellspacing="0">
						<tr>
						  <td nowrap valign="center">&nbsp; <cf_get_lang dictionary_id="30493.İleti
							Önceliği">:&nbsp;
							<select name="ddlPriority" id="ddlPriority" tabindex="17" style="width:70px">
							  <option value="1"><cf_get_lang dictionary_id="30492.Yüksek"></option>
							  <option selected="selected" value="3"><cf_get_lang dictionary_id="32287.Normal"></option>
							  <option value="5"><cf_get_lang dictionary_id="30491.Düşük"></option>
							</select>
						  </td>
						  <td NOWRAP valign="top"><IMG src="/images/exchange//msgcompose_bar_spacer.gif" border="0"></TD>
						  <td nowrap valign="center">
							<label for="chkNotify"><cf_get_lang dictionary_id="30490.İleti Okunduğunda Beni Bilgilendir">.</label>
						  </td>
						</tr>
					  </table></td>
				  </tr>
				</table>
				<table width="100%" cellpadding="0" cellspacing="0" border="0" style="border:solid 1px silver" bgcolor="#dce9f5">
				  <tr>
					<td><table width="100%" cellpadding="0" cellspacing="0" border="0">
						<tr>
						  <td width="100" TabIndex="-1" colspan="2"><cf_get_lang dictionary_id="46789.Kimden">:</td>
						  <td><select name="msgFrom" id="msgFrom" tabindex="1" style="width:245px">
							  <option selected="selected" value="<cfoutput>#session.mailbox_username#</cfoutput>"><cfoutput>#session.mailbox_username#</cfoutput></option>
							</select></td>
						</tr>
						<tr>
						  <td width="25"><a href="#" tabindex="-1"><img src="/images/exchange/addcontact.gif" border="0"></a> </td>
						  <td width="100"><a href="javascript:ShowAddressBook('txtMsgTo')" tabindex="2"><cf_get_lang dictionary_id="57924.Kime">..:</a> </td>
						  <td><input name="msgTo" type="text" size="100" id="txtMsgTo" tabindex="3" value="<cfif URL.islem is "reply"><cfoutput>#msgFrom#</cfoutput><cfelseif URL.islem is "replyAll"><cfoutput>#msgFrom#,#msgCc#</cfoutput></cfif>" class="ME_Input" style="width:90%;" /></td>
						</tr>
						<tr>
						  <td width=25><a href="#" tabindex="-1"><img src="/images/exchange/addcontact.gif" border=0></a></td>
						  <td width="100"><a href="javascript:ShowAddressBook('txtMsgCc')" tabindex="4"><cf_get_lang dictionary_id="57556.Bilgi">..:</a></td>
						  <td><input name="msgCc" type="text" size="100" id="txtMsgCc" tabindex="5" class="ME_Input" style="width:90%;" /></td>
						</tr>
						<tr>
						  <td width="25"><a href="#" tabindex="-1"><img src="/images/exchange/addcontact.gif" border=0></a></td>
						  <td width="100"><a href="javascript:ShowAddressBook('txtMsgBcc')" TabIndex="6"><cf_get_lang dictionary_id="33107.Gizli">..:</A></td>
						  <td><input name="msgBcc" type="text" size="100" id="txtMsgBcc" tabindex="7" class="ME_Input" style="width:90%;" /></td>
						</tr>
						<tr>
						  <td width="100" tabindex="-1" colspan="2"><cf_get_lang dictionary_id="57480.Konu">:</td>
						  <td><input name="msgSubject" type="text" value="<cfif URL.islem is "reply" or URL.islem is "forward"><cfoutput>RE : #msgSubject#</cfoutput></cfif>" size="100" id="txtMsgSubject" tabindex="8" class="ME_Input" ostyle="width:90%;" /></td>
						</tr>
						<tr>
						  <td width="100" colspan="2"><input type="button" value="Ekler" onclick="window.open('http://<cfoutput>#cgi.HTTP_HOST#</cfoutput>/index.cfm?fuseaction=correspondence.emptypopup_exchange_upd_attachment_frm','upload','menubar=0,location=0,status=0,scrollbars=0, width=300,height=300')" TabIndex="9"></td>
						  
						  <td id="uploads_div"><input type="text" name="uploads_name" id="uploads_name" style="color:#0000FF; background-color:#dce9f5; border:solid 1px #dce9f5; width:100%"/></td>
						</tr>
					  </table></td>
				  </tr>
				</table>
				<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="2">
				  <tr>
					<td>
					<cfif not URL.islem is "new">
						<cfset msg = "----Orjinal Mesaj----<br/>Kimden : #msgFrom#<br/>Kime : #msgTo# <br/>Gönderme Trh : #DateFormat(msgTimeReceived,"dd mmm yyyy")# #TimeFormat(msgTimeReceived,"HH:mm:ss")#<br/>Konu : #msgSubject#<br/><br/>#message#">
						<cfset msg = "<br/><br/><br/><table width=100%><tr><td bgcolor='##4242FF' width=5></td><td>"&msg&"</td></tr></table>">
					<cfelse>
						<cfset msg = "">
					</cfif>
					<cfscript>
						fckEditor = createObject("component", "fckeditor.fckeditor");
						fckEditor.instanceName="message";
						fckEditor.basePath="/fckeditor/";
						fckEditor.value=msg;
						fckEditor.width="100%";
						fckEditor.height="335";
						// ... additional parameters ...
						fckEditor.create(); // create instance now.
					 </cfscript>
					 
					</td>
				  </tr>
				</table>
			</td>
		</tr>
	</form>	
</table>
</body>
</html>
<script language="javascript">
	function sendFormMail(){	
		document.forms['FrmCompose'].submit();
		document.getElementById('form_submit').style.display='block';
	}
	
	function ShowAddressBook()
	{
		var curToAddresses = extractMails(document.getElementById('txtMsgTo').value);
		var curCcAddresses = extractMails(document.getElementById('txtMsgCc').value);
		var curBccAddresses = extractMails(document.getElementById('txtMsgBcc').value);
		
		Features = new String("left="+(window.screen.availWidth/2 - 700/2)+",top="+(window.screen.availHeight/2 - 450/2) + ",height=450,width=700,status=0,center=yes,location=0,directories=0,toolbar=no,menubar=0,scrollbars=0,resizable=1");
		window.open('http://<cfoutput>#cgi.HTTP_HOST#</cfoutput>/index.cfm?fuseaction=correspondence.emptypopup_exchange_contacts&FieldTo=txtMsgTo&FieldCc=txtMsgCc&FieldBcc=txtMsgBcc&Source=Contacts' + '&AddressesTo=' + curToAddresses + '&AddressesCc=' + curCcAddresses + '&AddressesBcc=' + curBccAddresses, 'Test', Features);
	}
	
	function extractMails(address){
		var obj = address.split(";");
		var len = obj.length;
		
		tmpAddress = "";
		for (var i=0;i<len;i++){
			var ind1 = obj[i].indexOf('<');
			var ind2 = obj[i].indexOf('>');
			
			var middleAddress = "";
			if (ind1<0 || ind2<0)
				middleAddress = obj[i];
			else
				middleAddress = obj[i].substr(ind1+1,ind2-ind1-1);
				
			tmpAddress += middleAddress + ';';
		}
		
		tmpAddress = tmpAddress.substr(0,tmpAddress.length-1);
								
		return tmpAddress;
	}
	
</script>

