<cfset attributes.class_id = #attributes.id#>
<cfquery name="get_result" datasource="#DSN#">
    SELECT 
        CLASS_ID, 
        RESULT_HEAD, 
        RESULT_DETAIL
    FROM 
        TRAINING_CLASS_RESULT_REPORT 
    WHERE 
    	CLASS_ID = #attributes.CLASS_ID#
</cfquery>
<cfinclude template="view_class.cfm">
<table width="650" align="center">
    <tr>
        <td class="headbold" height="35"><cf_get_lang no='37.Eğitim Sonuç Raporu'>:<cfoutput>#get_result.result_head#</cfoutput></td>
    </tr>
</table>
<table width="650" align="center">
    <tr>
        <td>
			<cfoutput>#get_result.RESULT_DETAIL#</cfoutput> 
        </td>
    </tr>
</table>
