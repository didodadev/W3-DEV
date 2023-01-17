<cfinclude template="../query/get_member_analysis_s.cfm">
<table cellspacing="1" cellpadding="2" width="98%" border="0" class="color-border">
	<tr class="color-header"  height="22">
		<td class="form-title" style="cursor:pointer;" onClick="gizle_goster(perform);"><cf_get_lang dictionary_id ='58799.Analizler'></td>
	</tr>
	<tr class="color-row" id="perform" height="20">
		<td>
		<table cellspacing="1" cellpadding="2" width="100%" border="0">
	<cfif get_member_analysis.recordcount>
		<cfoutput query="get_member_analysis">
			<cfinclude template="../query/get_member_analysis_result.cfm">
			<tr class="color-row" height="22"> 
				<td><a href="#request.self#?fuseaction=member.analysis_results&analysis_id=#analysis_id#" class="tableyazi">#analysis_head#</a></td>
				<td align="center">
					<cfif get_member_analysis_result.recordcount>
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=member.popup_user_analysis_result&analysis_id=#analysis_id#&result_id=#get_member_analysis_result.result_id#&member_type=partner&partner_id=#get_member_analysis_result.partner_id#','medium','popup_user_analysis_result');"><img src="/images/update_list.gif" border="0" title="<cf_get_lang dictionary_id='57766.Formu Güncelle'>"></a> 
					<cfelse>
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=member.popup_make_analysis&analysis_id=#analysis_id#&member_type=partner&member_id=#attributes.pid#','list','popup_make_analysis');"><img src="/images/plus_list.gif" title="<cf_get_lang dictionary_id='57762.Formu Doldur'>" border="0"></a>
					</cfif>	
				</td>
			</tr>
		</cfoutput>
	<cfelse>
			<tr class="color-row"> 
				<td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
			</tr>
	</cfif>
		</table>
		</td>
	</tr>
</table>
