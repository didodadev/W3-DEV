<cfsetting showdebugoutput="no">
<cf_box id="my_opp_add">
<cfform  name="add_opp_plus" action="#request.self#?fuseaction=objects2.emptypopup_add_opp_plus" method="post">
	<input type="hidden" name="is_add" id="is_add" value="1" />
	<input type="hidden" name="email" id="email" value="" />
	<input type="hidden" name="opp_id" id="opp_id" value="<cfoutput>#attributes.opp_id#</cfoutput>">
	<table cellspacing="0" cellpadding="0" border="0" width="400">
		<tr>
			<td width="60"><cf_get_lang_main no='16.E-Mail'>*</td>
			<td class="txtbold"><input type="text" name="emails" id="emails" style="width:300px;" value=""></td>
		</tr>
		<tr>
			<td valign="top"><cf_get_lang_main no='68.Konu'>*</td>
			<td colspan="2"><input type="text" name="opp_header" id="opp_header" style="width:300px;" value=""></td>
		</tr>	
		<tr>
			<td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
			<td colspan="2"><textarea name="plus_content" id="plus_content" style="width:300px; height:100px;"></textarea></td>
		</tr>
		<tr>
			<td></td>
			<td height="35">
				<input type="button" value="<cf_get_lang_main no ='49.Kaydet'>" onClick="add_plus(1);">
				<cfsavecontent variable="message"><cf_get_lang no='1561.Kaydet ve Mail Gönder'></cfsavecontent>
				<input type="button" value="<cfoutput>#message#</cfoutput>" onClick="add_plus(2);">
			</td>
		</tr>
	</table>
	<div id="SHOW_MESSAGE_"></div>
</cfform>
</cf_box>
<script type="text/javascript">
	function add_plus(_type_)
	{
		var aaa = document.getElementById("emails").value; 
		if (((aaa == '') || (aaa.indexOf('@') == -1) || (aaa.indexOf('.') == -1) || (aaa.length < 6)))
		{ 
			alert("<cf_get_lang no='29.Geçerli Bir Mail Adresi Giriniz'> !");
			return false;
		}
		if (document.getElementById("opp_header").value == '')
		{
			alert("<cf_get_lang no='42.Konu Alanı Dolu Olmalıdır'>!");
			return false;
		}
		if(_type_==1)	
			AjaxFormSubmit('add_opp_plus','SHOW_MESSAGE_','1','Kaydediliyor..','Kaydedildi','<cfoutput>#request.self#?fuseaction=objects2.emptypopup_list_opportunity_plus&opp_id=#attributes.opp_id#</cfoutput>','SHOW_LIST_PAGE')
		else 
		{
			document.getElementById("email").value = true; 
			AjaxFormSubmit('add_opp_plus','SHOW_MESSAGE_','1','E-mail Gönderiliyor.','Gönderildi','<cfoutput>#request.self#?fuseaction=objects2.emptypopup_list_opportunity_plus&opp_id=#attributes.opp_id#</cfoutput>','SHOW_LIST_PAGE')
		}
	}
</script> 
