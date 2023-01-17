<cfquery name="GET_PARTNER_TITLE_NAME" datasource="#dsn#">
    SELECT 
    	PARTNER_DEPARTMENT_ID, 
        PARTNER_DEPARTMENT, 
        DETAIL, 
        RECORD_EMP, 
        RECORD_IP, 
        RECORD_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        UPDATE_DATE 
    FROM 
	    SETUP_PARTNER_DEPARTMENT
</cfquery>
<table width="135" cellpadding="0" cellspacing="0" border="0">
    <tr> 
        <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang_main no='725.Kategoriler'></td>
    </tr>
    <cfif get_partner_title_name.recordcount>
		<cfoutput query="get_partner_title_name">
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="115"><a href="#request.self#?fuseaction=settings.form_upd_setup_partner_department&id=#partner_department_id#" class="tableyazi">#partner_department#</a></td>
        </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="115"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>

