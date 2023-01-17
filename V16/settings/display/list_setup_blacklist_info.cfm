<cfquery name="GET_SETUP_BLACKLIST_INFO_" datasource="#dsn#">
	SELECT 
    	BLACKLIST_INFO_ID, 
        BLACKLIST_INFO_NAME, 
        BLACKLIST_INFO_DETAIL, 
        RECORD_DATE, 
        RECORD_EMP,
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
	    SETUP_BLACKLIST_INFO 
    ORDER BY 
    	BLACKLIST_INFO_ID
</cfquery>
<table width="135" cellpadding="0" cellspacing="0" border="0">
    <tr> 
        <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='1791.isimler'></td>
    </tr>
    <cfif GET_SETUP_BLACKLIST_INFO_.recordcount>
		<cfoutput query="GET_SETUP_BLACKLIST_INFO_">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                <td width="115"><a href="#request.self#?fuseaction=settings.form_upd_setup_blacklist_info&id=#blacklist_info_id#" class="tableyazi">#blacklist_info_name#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="115"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>

