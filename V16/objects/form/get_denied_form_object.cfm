<cfquery name="GET_POS_CODE" datasource="#DSN#">
    SELECT 
        POSITION_CODE,
        EMPLOYEE_NAME,
        EMPLOYEE_SURNAME,
        EMPLOYEE_ID 
    FROM 
        EMPLOYEE_POSITIONS
    WHERE 
        POSITION_CAT_ID = #attributes.id#
        AND EMPLOYEE_ID IS NOT NULL
	ORDER BY 
		EMPLOYEE_NAME
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='32403.Bireysel'></cfsavecontent>
<cf_popup_box title="#message#">
	<cf_ajax_list>
    	<tbody>
        	 <cfoutput query="get_pos_code">
                <tr>
					<td nowrap><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#EMPLOYEE_ID#','medium');" class="tableyazi">#employee_name# #employee_surname#</a></td>
                </tr>
            </cfoutput>
        </tbody>
	</cf_ajax_list>
</cf_popup_box>

