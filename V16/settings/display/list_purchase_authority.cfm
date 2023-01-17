<cfquery name="GET_PURCHASE_AUTHORITY" datasource="#dsn#">
	SELECT 
	    AUTHORITY_ID, 
        AUTHORITY_NAME, 
        DETAIL, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	SETUP_PURCHASE_AUTHORITY
</cfquery>
<table width="135" cellpadding="0" cellspacing="0" border="0">
    <tr> 
        <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang dictionary_id='43347.Durumlar'></td>
    </tr>
    <cfif get_purchase_authority.recordcount>
		<cfoutput query="get_purchase_authority">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                <td width="115"><a href="#request.self#?fuseaction=settings.form_upd_purchase_authority&id=#authority_id#" class="tableyazi">#authorıty_name#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="115"><font class="tableyazi"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>

