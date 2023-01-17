<cfsetting showdebugoutput="no">
<cf_ajax_list>
	<tbody>
	<cfquery name="get_test_type" datasource="#DSN#">
		SELECT 
        	ER.ID,
			ST.TEST_TYPE,
            ER.TEST_FINAL_POINT,
            ER.POINT_BASE_TYPE 
        FROM 
        	EMPLOYEES_APP_TEST_RESULTS ER LEFT JOIN SETUP_TEST_TYPE ST
			ON ER.TEST_ID = ST.ID 
       	WHERE 
        	ER.EMPAPP_ID = #attributes.EMPAPP_ID# 
       ORDER BY 
       		ER.RECORD_DATE DESC
	</cfquery> 
	<cfif isDefined("get_test_type") and get_test_type.recordcount>
		<cfoutput query="get_test_type">
		<tr>
			<td>#test_type#</td>
            <td>#test_final_point#/#point_base_type#</td>
			<td width="15" style="text-align:right;"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=hr.popup_upd_test_result&empapp_id=#attributes.empapp_id#&test_result_id=#id#');"><i class="fa fa-pencil"></a></td>
		</tr>
		</cfoutput>
	</cfif>
	<cfif isDefined("get_test_type") and (get_test_type.recordcount eq 0)>
		<tr>
			<td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
		</tr>
	</cfif>
    </tbody>
</cf_ajax_list>
