<cfinclude template="../query/get_employee_cautions.cfm">
<cf_flat_list>
    <tbody>
		<cfif get_employee_cautions.recordcount>
			<cfoutput query="get_employee_cautions">		
                <tr>
                    <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_view_caution&caution_id=#caution_id#','small','popup_view_caution')" class="tableyazi">#caution_head#</a></td>
                    <td style="text-align:right;">#dateformat(caution_date,dateformat_style)#</td>
                    <td></td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr>
            	<td><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
            </tr>
        </cfif>
    </tbody>
</cf_flat_list>