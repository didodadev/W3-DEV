<cfquery name="SUPPORTS" datasource="#dsn#">
	SELECT 
        SUPPORT_CAT_ID, 
        SUPPORT_CAT, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	SETUP_SUPPORT
</cfquery>
<table width="200" cellpadding="0" cellspacing="0" border="0">
    <tr> 
    	<td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='175.Servis Destek Kategorileri'></td>
    </tr>
    <cfif supports.recordcount>
		<cfoutput query="supports">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                <td width="180"><a href="#request.self#?fuseaction=settings.form_upd_service_support_cat&ID=#SUPPORT_CAT_ID#" class="tableyazi">#SUPPORT_CAT#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="180"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>
