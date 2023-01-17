<cfquery name="GET_VOCATION_TYPE" datasource="#DSN#" maxrows="1">
	SELECT
		VOCATION_TYPE_ID
	FROM
		CONSUMER
	WHERE
		VOCATION_TYPE_ID=#attributes.ID#
</cfquery>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td height="35" class="headbold"><cf_get_lang no='1362.Meslek Tipi Bilgisi Güncelle'></td>
    <td align="right" style="text-align:right;">
		<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_vocation_type"><img src="/images/plus1.gif" border="0" alt=<cf_get_lang_main no='170.Ekle'></a>
	</td>
  </tr>
</table>
<table width="98%" border="0" cellspacing="1" cellpadding="2" align="center" class="color-border">
<tr class="color-row">
  <td width="200" valign="top"><cfinclude template="../display/list_vocation_type.cfm">
  </td>
  <td valign="top">
	<table>
	  <cfform action="#request.self#?fuseaction=settings.emptypopup_upd_vocation_type" method="post" name="upd_vocation_type">
		<cfquery name="GET_TYPE" datasource="#dsn#">
			SELECT
				*
			FROM
				SETUP_VOCATION_TYPE
			WHERE
				VOCATION_TYPE_ID=#attributes.ID#
		</cfquery>
		<input type="hidden" name="type_id" id="type_id" value="<cfoutput>#url.id#</cfoutput>">
		<tr>
		  <td width="75"><cf_get_lang no='1079.Meslek Tipi'> *</td>
		  <td>
			<cfsavecontent variable="message"><cf_get_lang no='1080.Meslek Tipi girmelisiniz'></cfsavecontent>
			<cfinput type="Text" name="vocation_type" size="40" value="#GET_TYPE.VOCATION_TYPE#" maxlength="100" required="Yes" message="#message#" style="width:200px;">
		  </td>
		</tr>
		<tr>
		  <td><cf_get_lang no='1668.Vadeli Ödeme Limiti'></td>
		  <td>
			<input type="text" name="forward_sale_limit" id="forward_sale_limit" style="width:200px;" value="<cfif len(get_type.forward_sale_limit)><cfoutput>#Tlformat(get_type.forward_sale_limit)#</cfoutput></cfif>" onkeyup="return(FormatCurrency(this,event));">
		  </td>
		</tr>
		<tr>
		  <td><cf_get_lang_main no='217.Açıklama'></td>
		  <td>
			<cftextarea name="detail" cols="75" maxlength="200" style="width:200px;"><cfoutput>#GET_TYPE.DETAIL#</cfoutput></cftextarea>
		  </td>
		</tr>
		<tr>
		<td></td>
		  <td>
			<cfif GET_VOCATION_TYPE.recordcount>
				<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'> 
			<cfelse>
				<cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_vocation_type&type_id=#url.id#'>
			</cfif>
		  </td>
		</tr>
		<tr>
		<td colspan="2"><cf_get_lang_main no='71.Kayıt'> :
		<cfoutput>
			<cfif len(get_type.record_emp)>
				#get_emp_info(get_type.record_emp,0,0)#
				#dateformat(get_type.record_date,dateformat_style)#
			</cfif>
		</cfoutput>
		</td>
		</tr>
		<tr>
		<td colspan="2">
		<cfoutput>
			<cfif len(get_type.update_emp)>
				<cf_get_lang_main no='479.Güncelleyen'> : #get_emp_info(get_type.update_emp,0,0)#
				#dateformat(get_type.update_date,dateformat_style)#
			</cfif>
		</cfoutput>
		</td>
		</tr>
	  </cfform>
	</table>
  </td>
</tr>
</table>
<br/>
<script type="text/javascript">
	function kontrol()
	{
		if(document.upd_vocation_type.detail.value.length>200)
			{
			alert("<cf_get_lang no='1086.Açıklama 200 karakterden uzun olamaz'>");
			return false;
			}
		return true;
	}
</script>

