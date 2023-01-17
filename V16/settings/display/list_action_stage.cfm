<cfquery name="get_action_stages" datasource="#dsn#">
    SELECT 
    	STAGE_ID, 
        STAGE_NAME, 
        DETAIL, 
        RECORD_DATE, 
        RECORD_IP, 
        RECORD_EMP, 
        UPDATE_DATE, 
        UPDATE_IP, 
        UPDATE_EMP 
    FROM 
	    SETUP_ACTION_STAGES 
    ORDER BY 
    	STAGE_NAME
</cfquery>
<table width="200" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='62.Aksiyon Aşamaları'></td>
    </tr>
    <cfif get_action_stages.RecordCount>
		<cfoutput query="get_action_stages">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                <td width="180"><a href="#request.self#?fuseaction=settings.form_upd_action_stage&stage_id=#stage_id#" class="tableyazi">#stage_name#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="180"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>
