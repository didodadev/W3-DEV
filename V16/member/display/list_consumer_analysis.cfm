<cfsetting showdebugoutput="no">
<cfinclude template="../query/get_consumer_analysis_s.cfm">
<div id="analysis" style="z-index:1;overflow:auto;">
    <table>
        <cfif get_consumer_analysis_s.recordcount>
            <cfoutput query="get_consumer_analysis_s">
                <cfinclude template="../query/get_consumer_analysis_result.cfm">
                <tr height="20">
                    <td><a href="#request.self#?fuseaction=member.analysis_results&analysis_id=#analysis_id#" class="tableyazi">#analysis_head#</a></td>
                    <td align="center">
                        <cfif get_consumer_analysis_result.recordcount>
                            <cfif not listfindnocase(denied_pages,'member.popup_user_analysis_result')><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=member.list_analysis&event=upd-result&analysis_id=#analysis_id#&result_id=#get_consumer_analysis_result.result_id#&member_type=consumer&consumer_id=#attributes.cid#','medium','popup_upd_member_analysis_result');"><img src="/images/update_list.gif" border="0" title="<cf_get_lang dictionary_id='57766.Formu Güncelle'>"></a></cfif>
                        <cfelse>
                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=member.popup_add_member_analysis_result&analysis_id=#analysis_id#&member_type=consumer&consumer_id=#attributes.cid#','list','popup_add_member_analysis_result');"><img src="/images/plus_list.gif" title="<cf_get_lang dictionary_id='57762.Formu Doldur'>" border="0"> </a>
                        </cfif>
                    </td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr> 
                <td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
            </tr>
        </cfif>
    </table>
</div>

