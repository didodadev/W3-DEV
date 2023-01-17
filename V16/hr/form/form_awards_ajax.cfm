<cfinclude template="../query/get_employee_prizes.cfm">
<cf_flat_list>
    <tbody>
        <cfif get_employee_prizes.recordcount>
            <cfoutput query="get_employee_prizes">
                <tr>
                    <td>
                        <cfif get_module_user(48)>
                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_view_prize&prize_id=#prize_id#','small','popup_view_prize')" class="tableyazi">#prize_head#</a>
                        <cfelse>
                            #prize_head#
                        </cfif>
                    </td>
                </tr>
            </cfoutput>		 
        <cfelse>
            <cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!
        </cfif>				  
    </tbody>
</cf_flat_list>