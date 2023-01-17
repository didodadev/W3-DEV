<cfquery name="GET_MAX_GDPR" datasource="#dsn#" maxrows="1">
    SELECT * FROM GDPR_DECLERATION   
    ORDER BY 
    GDPR_DECLERATION_ID DESC
</cfquery>
<cfquery name="GET_POSITION_DETAIL" datasource="#DSN#">
    SELECT
        *
    FROM
        EMPLOYEE_POSITIONS,
        DEPARTMENT,
        BRANCH,
        OUR_COMPANY,
        ZONE
    WHERE
        EMPLOYEE_POSITIONS.DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID AND
        DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID AND
        OUR_COMPANY.COMP_ID=BRANCH.COMPANY_ID AND
        BRANCH.ZONE_ID=ZONE.ZONE_ID AND 
        EMPLOYEE_POSITIONS.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
</cfquery>
<cfif not GET_MAX_GDPR.recordcount>
    <cfset hata  = 10>
    <cfsavecontent variable="message"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'>!</cfsavecontent>
    <cfset hata_mesaj  = message>
    <cfinclude template="../../dsp_hata.cfm">
<cfelse>
    <cf_woc_header title="#GET_POSITION_DETAIL.nick_name# #GET_POSITION_DETAIL.branch_name# #getLang('','',65093)#">
	<cfoutput>
        <cf_woc_elements>
            <cf_wuxi id="ship_internal_number" data="#GET_MAX_GDPR.GDPR_DECLERATION_TEXT#" label="" type="cell">
        </cf_woc_elements>
		<cf_woc_footer>
            <table >
                <tr>
                    <td class="bold"><cf_get_lang dictionary_id='33675.Versiyon No'></td>
                    <td>#GET_MAX_GDPR.GDPR_DECLERATION_ID#</td>
                </tr>
                <tr>
                    <td class="bold"  style="width:30mm">#getLang('','',57576)# #getLang('','',57570)#</td>
                    <td>#get_emp_info(attributes.employee_id,0,0)#</td>
                </tr>
                <tr>
                    <td class="bold"><cf_get_lang dictionary_id='58957.İmza'></td>
                    <td></td>
                </tr>
            </table>
	</cfoutput>
</cfif>