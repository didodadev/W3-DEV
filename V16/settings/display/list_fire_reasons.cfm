<cfquery name="FIRE_REASONS" datasource="#dsn#">
    SELECT 
    	REASON_ID, 
        REASON, 
        REASON_DETAIL, 
        RECORD_EMP, 
        RECORD_IP, 
        RECORD_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        UPDATE_DATE 
    FROM 
	    SETUP_EMPLOYEE_FIRE_REASONS 
    ORDER BY 
    	REASON
</cfquery>
<table width="200" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='1353.Nedenler'></td>
    </tr>
    <cfif FIRE_REASONS.recordcount>
		<cfoutput query="FIRE_REASONS">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif"></td>
                <td width="180"><a href="#request.self#?fuseaction=settings.form_upd_fire_reason&reason_id=#reason_id#" class="tableyazi">#reason#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="180" class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
        </tr>
    </cfif>
</table>

