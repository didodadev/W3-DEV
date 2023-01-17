<cfquery name="GET_MAIL_CAT" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		SETUP_MAIL_WARNING
	WHERE
		MAIL_CAT_ID = #attributes.id#
</cfquery>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
  <tr>
    <td class="headbold"><cf_get_lang no='1487.Mail Uyarıları'></td>
    <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_mail_cat"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
  </tr>
</table>
<table border="0" cellspacing="1" cellpadding="2" width="98%" align="center" class="color-border">
<tr>
  <td class="color-row" width="200" valign="top"><cfinclude template="../display/list_mail_cat.cfm"></td>
  <td class="color-row" valign="top">
	<cfform name="upd_mail_cat" action="#request.self#?fuseaction=settings.emptypopup_upd_mail_cat" method="post">
	<input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
	  <table>
		<tr>
			<td width="80"><cf_get_lang_main no='13.Uyarı'> *</td>    
			<td>
			<cfsavecontent variable="message"><cf_get_lang no='1506.Uyarı Adı Girmelisiniz'> !</cfsavecontent>
			<cfinput type="text" maxlength="100" name="mail_cat" style="width=175;" required="yes" message="#message#" value="#get_mail_cat.mail_cat#"></td>
		</tr>
		<tr>
			<td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
			<td><textarea style="width:175px;height:60px;" name="detail" id="detail"><cfoutput>#get_mail_cat.detail#</cfoutput></textarea></td>
		</tr>
		<tr>
		  <td colspan="2" align="right" style="text-align:right;"><cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_mail_cat&id=#attributes.id#'></td>
		</tr>
		<tr>
			<td colspan="2" align="left"><p><br/>
			<cfoutput>
			<cfif len(get_mail_cat.record_emp)>
				<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_mail_cat.record_emp,0,0)# - #dateformat(get_mail_cat.record_date,dateformat_style)#
			</cfif><br/>
			<cfif len(get_mail_cat.update_emp)>
				<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(get_mail_cat.update_emp,0,0)# - #dateformat(get_mail_cat.update_date,dateformat_style)#
			</cfif>
			</cfoutput>
			</td>
		</tr>
	  </table>
	</cfform>
  </td>
</tr>
</table>

