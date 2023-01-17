<cfquery name="SUBSCRIPTION_ADD_OPTIONS" datasource="#dsn3#">
	SELECT 
    	SUBSCRIPTION_ADD_OPTION_ID, 
        SUBSCRIPTION_ADD_OPTION_NAME, 
        DETAIL, 
        RECORD_IP, 
        RECORD_DATE,
        RECORD_EMP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
	    SETUP_SUBSCRIPTION_ADD_OPTIONS
</cfquery>
<table width="135" cellpadding="0" cellspacing="0" border="0">
    <tr> 
        <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='1703.Sistem Özel Tanım'></td>
    </tr>
    <cfif SUBSCRIPTION_ADD_OPTIONS.recordcount>
		<cfoutput query="SUBSCRIPTION_ADD_OPTIONS">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                <td width="115"><a href="#request.self#?fuseaction=settings.upd_subscription_add_option&subs_option_id=#SUBSCRIPTION_ADD_OPTION_ID#" class="tableyazi">#SUBSCRIPTION_ADD_OPTION_NAME#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="115"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>
