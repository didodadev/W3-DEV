<cfparam name="attributes.salary" default="">
<cfparam name="attributes.salary_money" default="">
<cfinclude template="../query/get_moneys.cfm">
<cfquery name="get_list_row" datasource="#dsn#">
	SELECT SALARY FROM EMPLOYEES_APP_SEL_LIST_ROWS WHERE LIST_ID = #attributes.list_id# AND LIST_ROW_ID = #attributes.list_row_id#
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="55580.Kabul Edildiği Ücret"></cfsavecontent>
<cf_popup_box title="#message#">
    <cfform name="add_salary" method="post" action="#request.self#?fuseaction=hr.emptypopup_add_salary">
    <table border="0">
        <input type="hidden" name="list_id" id="list_id" value="<cfoutput>#attributes.list_id#</cfoutput>">
        <input type="hidden" name="list_row_id" id="list_row_id" value="<cfoutput>#attributes.list_row_id#</cfoutput>">
        <tr>
            <td><cf_get_lang dictionary_id="55123.Ücret"></td>
            <td><cfinput type="text" name="salary" style="width:300px;" value="#get_list_row.salary#" maxlength="100"></td>
        </tr>
    </table>
    <cf_popup_box_footer><cf_workcube_buttons is_upd='1' is_delete='0'></cf_popup_box_footer>
    </cfform>
</cf_popup_box>

