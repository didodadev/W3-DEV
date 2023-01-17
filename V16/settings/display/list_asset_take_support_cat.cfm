<cfquery name="ASSET_SUPPORT_CAT_JTAKE" datasource="#dsn#">
	SELECT 
    	TAKE_SUP_CATID, 
        TAKE_SUP_CAT, 
        DETAIL, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
	    ASSET_TAKE_SUPPORT_CAT 
    ORDER BY 
    	TAKE_SUP_CAT
</cfquery>	
<table cellpadding="0" cellspacing="0" border="0">
    <tr> 
        <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='864.Alınan Destek Kategorileri'></td>
    </tr>
    <cfif ASSET_SUPPORT_CAT_JTAKE.recordcount>
		<cfoutput query="ASSET_SUPPORT_CAT_JTAKE">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                <td width="115"><a href="#request.self#?fuseaction=settings.form_upd_asset_take_support_cat&TAKE_SUP_CATID=#TAKE_SUP_CATID#" class="tableyazi">#TAKE_SUP_CAT#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="115"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>
