<cfinclude template="../query/get_opportunity_currencys.cfm">
<cfquery name="GET_OPP_CURRENCY_ID" datasource="#DSN3#" maxrows="1">
	SELECT
		OPP_CURRENCY_ID
	FROM
		OPPORTUNITIES
	WHERE
		OPP_CURRENCY_ID = #opportunity_currency_id#
</cfquery>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
  <tr>
    <td align="left" class="headbold"><cf_get_lang no='633.Fırsat Durum Kategorisi Güncelle'></td>
    <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_opportunity_currency"><img border="0" align="absmiddle" src="/images/plus1.gif" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
  </tr>
</table>
<table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
	<tr class="color-row" valign="top">
		<td width="200"><cfinclude template="../display/list_opportunity_currency.cfm"></td>
		<td>
			<table border="0">
				<cfform name="upd_opportunity_currency" method="post" action="#request.self#?fuseaction=settings.emptypopup_opportunity_currency_upd">
				<input type="hidden" name="opportunity_currency_id" id="opportunity_currency_id" value="<cfoutput>#opportunity_currency_id#</cfoutput>">
					<cfquery name="CAT" datasource="#DSN3#">
						SELECT 
							OPP_CURRENCY_ID, 
                            OPP_CURRENCY, 
                            RECORD_EMP, 
                            RECORD_DATE, 
                            RECORD_IP, 
                            UPDATE_EMP, 
                            UPDATE_DATE, 
                            UPDATE_IP 
						FROM 
							OPPORTUNITY_CURRENCY 
						WHERE 
							OPP_CURRENCY_ID = #opportunity_currency_id#
					</cfquery>
				<tr>
					<td width="100"><cf_get_lang_main no='68.Başlık'>*</td>
					<td>
						<cfsavecontent variable="message"><cf_get_lang_main no='647.Başlık girmelisiniz'></cfsavecontent>
						<cfinput type="text" name="opportunity_currency" value="#cat.opp_currency#" required="Yes" message="#message#" maxlength="20" style="width:150px;">
					</td>
				</tr>
				<tr height="35">
					<td></td>
					<td>
						<cfif get_opp_currency_id.recordcount>
							<cf_workcube_buttons is_upd='1' is_delete='0'>
						<cfelse>
							<cfif opportunity_currency_id lte -1>
								<cf_workcube_buttons is_upd='1' is_delete='0'>
							<cfelse>
								<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_opportunity_currency_del&opportunity_currency_id=#opportunity_currency_id#'>
							</cfif>
						</cfif>
					</td>
				</tr>
				<tr>
					<td colspan="3" align="left"><p><br/>
						<cfoutput>
							<cfif len(cat.record_emp)>
								<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(cat.record_emp,0,0)# - #dateformat(cat.record_date,dateformat_style)#
							</cfif>
							<cfif len(cat.update_emp)>
								<br/><cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(cat.update_emp,0,0)# - #dateformat(cat.update_date,dateformat_style)#
							</cfif>
						</cfoutput>
					</td>
				</tr>
				</cfform>
			</table>
		</td>
	</tr>
</table>
