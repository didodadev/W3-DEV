<cfquery name="get_dep" datasource="#dsn#">
	SELECT 
    	DEPARTMENT_NAME_ID, 
        DEPARTMENT_NAME, 
        DETAIL, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        IS_ACTIVE 
    FROM 
	    SETUP_DEPARTMENT_NAME 
    ORDER BY 
    	DEPARTMENT_NAME
</cfquery>
    <table width="200" cellpadding="0" cellspacing="0" border="0">
    <tr>
        <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='960.Departman Adları'></td>
    </tr>
    <cfif get_dep.recordcount>
		<cfoutput query="get_dep">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                <td width="180"><a href="#request.self#?fuseaction=settings.form_upd_department_name&dep_name_id=#get_dep.department_name_id#" class="tableyazi">#department_name#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="180"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>
