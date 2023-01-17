<cfquery name="GET_SETUP_WARNING" datasource="#dsn#">
	SELECT 
    	SETUP_WARNING_ID, 
        SETUP_WARNING, 
        DETAIL, 
        RECORD_EMP, 
        RECORD_IP, 
        RECORD_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        UPDATE_DATE 
    FROM
	    SETUP_WARNINGS 
    ORDER BY 
    	SETUP_WARNING
</cfquery>
<table width="200" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='807.Uyarı Onay Kategorileri'></td>
    </tr>
    <cfif get_setup_warning.RecordCount>
		<cfoutput query="get_setup_warning">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                <td width="180"><a href="#request.self#?fuseaction=settings.form_upd_warnings_approval_types&setup_warning_id=#setup_warning_id#" class="tableyazi">#setup_warning#</a></td>
            </tr>
		</cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="180"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>
