<cfquery name="PRO_ROLLES" datasource="#dsn#">
	SELECT 
	    PROJECT_ROLES_ID, 
        PROJECT_ROLES, 
        DETAIL, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	SETUP_PROJECT_ROLES
</cfquery>
<table width="200" cellpadding="0" cellspacing="0" border="0">
    <tr> 
        <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='182.Roller'></td>
    </tr>
    <cfif PRO_ROLLES.RecordCount>
		<cfoutput query="PRO_ROLLES">
            <tr>
                <td width="20" align="right" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                <td width="180"><a href="#request.self#?fuseaction=settings.form_upd_pro_rol&type=upd&ID=#PROJECT_ROLES_ID#" class="tableyazi">#PROJECT_ROLES#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="180" align="left"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>
