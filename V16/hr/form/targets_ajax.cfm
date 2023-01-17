<cfinclude template="../query/get_position.cfm">
<cf_ajax_list>
    <tbody>
        <tr>
            <td>
                <cfif get_position.recordcount>
                    <cfset attributes.position_code = get_position.position_code>
                    <cfinclude template="../query/get_pos_targets.cfm">
                    <cfif GET_TARGET.recordcount>
                        <cfoutput query="GET_TARGET">
                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.targets&event=upd&target_id=#target_id#&position_code=#get_position.position_code#','list','form_upd_target_popup');" class="tableyazi">#target_head#</a><br/></cfoutput>
                    <cfelse>
                        <cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!
                    </cfif>
                <cfelse>
                    <cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!
                </cfif>
            </td>
        </tr>
    </tbody>
</cf_ajax_list>
