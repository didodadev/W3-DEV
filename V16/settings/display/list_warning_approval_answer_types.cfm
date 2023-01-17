<cfquery name="GET_SETUP_WARNING_RESULT" datasource="#dsn#">
	SELECT 
    	SETUP_WARNING_RESULT_ID, 
        SETUP_WARNING_RESULT, 
        DETAIL, 
        RECORD_EMP, 
        RECORD_DATE, 
        RECORD_IP, 
        UPDATE_EMP, 
        UPDATE_DATE, 
        UPDATE_IP 
    FROM 
	    SETUP_WARNING_RESULT 
    ORDER BY 
    	SETUP_WARNING_RESULT
</cfquery>
<table width="200" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='792.Uyarı Onay Cevap Kategorileri'></td>
    </tr>
    <cfif get_setup_warning_result.RecordCount>
		<cfoutput query="get_setup_warning_result">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                <td width="180"><a href="#request.self#?fuseaction=settings.form_upd_approval_warnings_answer_types&setup_warning_result_id=#setup_warning_result_id#" class="tableyazi">#setup_warning_result#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="180"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>
