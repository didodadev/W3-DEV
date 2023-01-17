<cfsetting showdebugoutput="no">
<cfquery name="GET_OPP_PLUS" datasource="#DSN3#">
	SELECT OPP_PLUS_ID, MAIL_SENDER, PLUS_SUBJECT, MAIL_SENDER, PLUS_CONTENT FROM OPPORTUNITIES_PLUS WHERE OPP_PLUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#opp_plus_id#">
</cfquery>
<cf_box id="my_opp_upd">
	<cfform name="upd_opp_plus#get_opp_plus.opp_plus_id#" method="post" action="#request.self#?fuseaction=objects2.emptypopup_add_opp_plus">
		<input type="hidden" name="is_upd" id="is_upd" value="">
		<input type="hidden" name="is_del" id="is_del" value="">
		<input type="hidden" name="email" id="email" value="">
		<input type="hidden" name="opp_plus_id" id="opp_plus_id" value="<cfoutput>#get_opp_plus.opp_plus_id#</cfoutput>">
		<table cellspacing="0" cellpadding="0" border="0" width="400" height="100%">
			<tr>
				<td width="60"><cf_get_lang_main no='16.E-Mail'> *</td>
				<td class="txtbold">
					<input type="text" name="emails" id="emails" style="width:300px;" value="<cfoutput>#get_opp_plus.mail_sender#</cfoutput>">
				</td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='68.Baslik'>*</td>
				<td><input type="text" name="opp_header" id="opp_header" style="width:300px;" value="<cfoutput>#get_opp_plus.plus_subject#</cfoutput>"></td>
			</tr>
			<tr>
				<td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
				<td colspan="2">		 
					<textarea name="plus_content" id="plus_content" style="width:300px; height:100px;"><cfoutput>#get_opp_plus.plus_content#</cfoutput></textarea>
				</td>    
			</tr>
			<tr>
			  <td></td>
			  <td height="35">
				 <input type="button" value="Güncelle" onClick="upd_plus<cfoutput>#get_opp_plus.opp_plus_id#</cfoutput>(1);">
				 <input type="button" value="Güncelle ve Mail Gönder" onclick="upd_plus<cfoutput>#get_opp_plus.opp_plus_id#</cfoutput>(2);">
				 <input type="button" value="Sil" onClick="upd_plus<cfoutput>#get_opp_plus.opp_plus_id#</cfoutput>(3);"> 
			  </td>
			</tr>
		</table>
		<div id="SHOW_UPD_MESSAGE"></div>
	</cfform>
</cf_box>
<script type="text/javascript">
	function upd_plus<cfoutput>#get_opp_plus.opp_plus_id#</cfoutput>(type){
	if(type == 1)
		document.upd_opp_plus<cfoutput>#get_opp_plus.opp_plus_id#</cfoutput>.is_upd.value = 1;
	else if(type == 2)
	{
		document.upd_opp_plus<cfoutput>#get_opp_plus.opp_plus_id#</cfoutput>.email.value = 1;
		document.upd_opp_plus<cfoutput>#get_opp_plus.opp_plus_id#</cfoutput>.is_upd.value = 1;
	}
	else 	
		document.upd_opp_plus<cfoutput>#get_opp_plus.opp_plus_id#</cfoutput>.is_del.value = 1;
	var aaa = document.upd_opp_plus<cfoutput>#get_opp_plus.opp_plus_id#</cfoutput>.emails.value;
	if (((aaa == '') || (aaa.indexOf('@') == -1) || (aaa.indexOf('.') == -1) || (aaa.length < 6)))
	{ 
		alert("<cf_get_lang_main no='1072.Geçerli Bir Mail Adresi Giriniz'> !");
		return false;
	}
	var bbb = document.upd_opp_plus<cfoutput>#get_opp_plus.opp_plus_id#</cfoutput>.emails.value;
	if (((bbb == '') || (bbb.indexOf('@') == -1) || (bbb.indexOf('.') == -1) || (bbb.length < 6)))
	{
		alert("<cf_get_lang_main no='1072.Geçerli Bir Mail Adresi Giriniz'> !");
		return false;
	}
	if(document.upd_opp_plus<cfoutput>#get_opp_plus.opp_plus_id#</cfoutput>.opp_header.value == '')
	{
		alert("<cf_get_lang no='42.Konu Alanı Dolu Olmalıdır'>");
		return false;
	}
	if(type==1)
	{
		AjaxFormSubmit('upd_opp_plus<cfoutput>#get_opp_plus.opp_plus_id#</cfoutput>','SHOW_UPD_MESSAGE','1','Güncelleniyor..','Güncellendi.','<cfoutput>#request.self#?fuseaction=objects2.emptypopup_list_opportunity_plus&opp_id=#attributes.opp_id#</cfoutput>','SHOW_LIST_PAGE')
	}
	else if(type==2)
	{
		AjaxFormSubmit('upd_opp_plus<cfoutput>#get_opp_plus.opp_plus_id#</cfoutput>','SHOW_UPD_MESSAGE','1','E-mail Gönderiliyor..','E-mail Gönderildi.','<cfoutput>#request.self#?fuseaction=objects2.emptypopup_list_opportunity_plus&opp_id=#attributes.opp_id#</cfoutput>','SHOW_LIST_PAGE')
	}
	else
	{
		AjaxFormSubmit('upd_opp_plus<cfoutput>#get_opp_plus.opp_plus_id#</cfoutput>','SHOW_UPD_MESSAGE','1','Siliniyor..','Silindi..','<cfoutput>#request.self#?fuseaction=objects2.emptypopup_list_opportunity_plus&opp_id=#attributes.opp_id#</cfoutput>','SHOW_LIST_PAGE')
	}
}

</script> 


