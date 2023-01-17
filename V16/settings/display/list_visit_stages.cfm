<cfquery name="GET_VISIT_TYPES" datasource="#dsn#">
	SELECT 
    	VISIT_STAGE_ID, 
        VISIT_STAGE, 
        DETAIL, 
        RECORD_EMP, 
        RECORD_DATE, 
        RECORD_IP,
        UPDATE_EMP, 
        UPDATE_DATE, 
        UPDATE_IP 
    FROM 
	    SETUP_VISIT_STAGES
</cfquery>
<table width="200" cellpadding="0" cellspacing="0" border="0">
    <tr> 
        <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='933.Ziyaret Aşamaları'></td>
    </tr>
    <cfif get_visit_types.recordcount>
		<cfoutput query="get_visit_types">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                <td width="180"><a href="#request.self#?fuseaction=settings.form_upd_visit_stage&visit_stage_id=#visit_stage_id#" class="tableyazi">#visit_stage#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="180" align="left"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>
