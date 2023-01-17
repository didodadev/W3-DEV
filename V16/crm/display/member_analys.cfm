<cfquery name="GET_COMPANY" datasource="#dsn#">
	SELECT COMPANYCAT_ID FROM COMPANY WHERE COMPANY_ID = #attributes.cpid#
</cfquery>
<cfinclude template="../query/get_member_analysis_s.cfm">
<table cellspacing="0" cellpadding="0" width="100%" border="0">
<tr>
  <td>
	<table cellspacing="1" cellpadding="2" width="100%" border="0">
	  <tr class="color-header"  height="22">
		<td class="form-title" style="cursor:pointer;" onClick="gizle_goster(perform);" height="35"><cf_get_lang_main no ='1387.Analizler'></td>
	  </tr>
	  <tr class="color-row" id="perform" height="20">
		<td>
		<table cellspacing="1" cellpadding="2" width="100%" border="0">
		<cfif get_member_analysis_s.recordcount>
			<cfoutput query="get_member_analysis_s">
				<cfinclude template="../query/get_member_analysis_result.cfm">
				<cfif ListFind(analysis_partners, get_company.companycat_id)>
					  <tr class="color-row" height="20"> 
						<td><a href="#request.self#?fuseaction=crm.analysis_results&analysis_id=#analysis_id#" class="tableyazi">#analysis_head#</a></td>
						<td align="center" width="15">
						<cfif get_member_analysis_result.RecordCount>
							<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=crm.popup_user_analysis_result&analysis_id=#analysis_id#&result_id=#get_member_analysis_result.result_id#&member_type=partner&partner_id=#get_member_analysis_result.partner_id#','medium');"><img src="/images/update_list.gif" border="0" title="<cf_get_lang no='156.Formu Güncelle'>"></a> 
						<cfelse>
							<cfquery datasource="#dsn#" name="get_one_partner_id" maxrows="1">
								SELECT PARTNER_ID FROM COMPANY_PARTNER WHERE COMPANY_ID = #attributes.CPID#
							</cfquery>
						<cfif get_one_partner_id.RecordCount>
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=crm.popup_make_analysis&analysis_id=#analysis_id#&member_type=partner&member_id=#get_one_partner_id.PARTNER_ID#','list');"><img src="/images/plus_list.gif" border="0"></a>
						</cfif>
					</cfif>	
					</td>
				  </tr>
				</cfif>
			</cfoutput>
		  <cfelse>
		  <tr class="color-row"> 
			<td height="20" colspan="3"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
		  </tr>
		</cfif>
		</table>
		</td>
	  </tr>
	</table>
  </td>
</tr>
</table>
