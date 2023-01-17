<cfinclude template="../query/get_hr_offtimes.cfm">
<cfsetting showdebugoutput="no">
<cf_ajax_list>
    <tbody>
		<cfif get_hr_offtimes.recordcount>
            <cfoutput query="get_hr_offtimes">
                <tr>
                    <td colspan="2"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=ehesap.offtimes&event=upd&offtime_id=#offtime_id#','medium');" class="tableyazi">#NEW_CAT_NAME#</a> (
                        <cfif valid eq 1>
                            <cf_get_lang dictionary_id='57616.onaylı'>
                        <cfelse>
                            <cfif validdate eq "">
                                <cf_get_lang dictionary_id='57615.onay bekliyor'>
                            <cfelse>
                                <cf_get_lang dictionary_id='57617.reddedildi'>
                            </cfif>
                        </cfif>) / #dateformat(date_add("h",session.ep.time_zone,startdate),dateformat_style)#-#dateformat(date_add("h",session.ep.time_zone,finishdate),dateformat_style)#
                    </td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
            </tr>
        </cfif>
    </tbody>
</cf_ajax_list>
