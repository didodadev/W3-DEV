<cfquery name="RESOURCE_PARTNER_ID" datasource="#DSN#">
	SELECT
		RESOURCE_ID
	FROM
		COMPANY
	WHERE
		RESOURCE_ID = #url.resource_id#
</cfquery>

<cfquery name="GET_PAR_RESOURCE" datasource="#DSN#">
	SELECT
		*
	FROM
		COMPANY_PARTNER_RESOURCE
	WHERE
		RESOURCE_ID = #url.resource_id#
</cfquery>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td height="35" class="headbold"><cf_get_lang no='697.Kurumsal Üye Kaynağı Güncelle'></td>
    <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_partner_resorce"><img src="/images/plus1.gif" border="0" alt=<cf_get_lang_main no='170.Ekle'>></a></td>
  </tr>
</table>

	<table width="98%" border="0" cellspacing="1" cellpadding="2" align="center" class="color-border">
	  <tr class="color-row">
	  	<td width="200" valign="top"><cfinclude template="../display/list_partner_resource.cfm"></td>
	 	<td valign="top">
		<table>
		<cfform name="resource" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_partner_resource">
		<input type="Hidden" name="resource_id" id="resource_id" value="<cfoutput>#url.resource_id#</cfoutput>">
		  <tr>
			<td width="75"><cf_get_lang_main no='68.Başlık'> *</td>
			<td>
			  <cfsavecontent variable="message"><cf_get_lang_main no='647.Başlık girmelisiniz'>!</cfsavecontent>
			  <cfinput type="text" name="PARTNER_RESOURCE" size="40" value="#get_par_resource.resource#" maxlength="50" required="Yes" message="#message#" style="width:200px;">
			</td>
		  </tr>
		  <tr> 
			<td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
			<td><textarea name="detail" id="detail" style="width:200px;height:60px;" maxlength="100" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="Maksimum Karakter Sayısı : 100"><cfoutput>#get_par_resource.detail#</cfoutput></textarea></td>
		  </tr>
		  <tr>
		  	<td></td>
			<td height="35">
			  <cfif resource_partner_id.recordcount>
			  	<cf_workcube_buttons is_upd='1' is_delete='0'>
			  <cfelse>
				<cf_workcube_buttons is_upd='1' is_delete='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_partner_resource&resource_id=#URL.RESOURCE_ID#'>
			  </cfif>
			</td>
		  </tr>
		  <tr>
			<td colspan="2">
			  <cf_get_lang_main no='71.Kayıt'> : 
			  <cfoutput>
				<cfif len(get_par_resource.record_emp)>#get_emp_info(get_par_resource.record_emp,0,0)#</cfif>
				<cfif len(get_par_resource.record_date)>#dateformat(get_par_resource.record_date,dateformat_style)#</cfif>
				<cfif len (get_par_resource.update_emp)>
					<br/>
					<cf_get_lang_main no='479.Güncelleyen'> :
					#get_emp_info(get_par_resource.update_emp,0,0)#
					#dateformat(get_par_resource.update_date,dateformat_style)#
				</cfif>
			  </cfoutput>
			</td>
		  </tr>		  
		  </cfform>
		</table>
		</td>
	  </tr>
	</table>
