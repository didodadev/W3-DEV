<cfsetting showdebugoutput="no">
<cfquery name="get_company_cat" datasource="#dsn#">
	SELECT COMPANYCAT_ID FROM COMPANY_PARTNER WHERE PARTNER_ID = #attributes.cpid#
</cfquery>
<cfquery name="GET_MEMBER_ANALYSIS_S" datasource="#DSN#">
	SELECT 
		ANALYSIS_ID,
		ANALYSIS_HEAD,
		ANALYSIS_PARTNERS	
	FROM 
		MEMBER_ANALYSIS,
		COMPANY_PARTNER
	WHERE
		MEMBER_ANALYSIS.IS_ACTIVE = 1 AND
		MEMBER_ANALYSIS.IS_PUBLISHED = 1 AND
		COMPANY_PARTNER.PARTNER_ID = #attributes.cpid# AND
		MEMBER_ANALYSIS.ANALYSIS_PARTNERS LIKE '%,#get_company_cat.companycat_id#,%'
</cfquery>
<table cellspacing="1" cellpadding="2" width="100%" border="0" class="color-row">
	<tr class="color-list" height="22">
		<td class="txtboldblue" colspan="2"><cf_get_lang dictionary_id='57560.Analiz'></td>
	</tr>
	<cfif get_member_analysis_s.recordcount>
		<cfoutput query="get_member_analysis_s">
			<cfquery name="get_member_analysis_result" datasource="#dsn#">
				SELECT
					RESULT_ID,
					PARTNER_ID
				FROM	
					MEMBER_ANALYSIS_RESULTS
				WHERE
					ANALYSIS_ID = #analysis_id# AND
					PARTNER_ID = #attributes.cpid#
			</cfquery>
			<tr class="color-row" height="22"> 
				<td><a href="#request.self#?fuseaction=member.analysis_results&analysis_id=#analysis_id#" class="tableyazi">#analysis_head#</a></td>
				<td  style="text-align:right;">
					<cfif get_member_analysis_result.recordcount>
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=member.popup_user_analysis_result&analysis_id=#analysis_id#&result_id=#get_member_analysis_result.result_id#&member_type=partner&partner_id=#get_member_analysis_result.partner_id#','medium');"><img src="/images/update_list.gif" border="0" title="<cf_get_lang dictionary_id='57766.Formu Gncelle'>"></a> 
					<cfelse>
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=member.popup_make_analysis&analysis_id=#analysis_id#&member_type=partner&member_id=#attributes.cpid#','list');"><img src="/images/plus_list.gif" title="<cf_get_lang dictionary_id='57762.Formu Doldur'>" border="0"></a>
					</cfif>	
				</td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr class="color-row"> 
			<td colspan="3"><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'>!</td>
		</tr>
	</cfif>
</table>

