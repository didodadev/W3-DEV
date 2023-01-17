<cfquery name="GET_SPECIAL_STATE_CATS" datasource="#DSN#">
	SELECT 
    	SPECIAL_STATE_CAT_ID, 
        SPECIAL_STATE_CAT, 
        DETAIL, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
	    SETUP_SPECIAL_STATE_CAT 
    ORDER BY 
    	SPECIAL_STATE_CAT
</cfquery>
<table cellpadding="0" cellspacing="0" border="0">
	<tr> 
    	<td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang_main no='725.Kategoriler'></td>
	</tr>
	<cfif get_special_state_cats.recordcount>
        <cfoutput query="get_special_state_cats">
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="200"><a href="#request.self#?fuseaction=settings.upd_special_state_cat&id=#special_state_cat_id#" class="tableyazi">#special_state_cat#</a></td>
        </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="115"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>
