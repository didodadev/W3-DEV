<cfquery name="GET_RISK_CATS" datasource="#DSN#">
	SELECT 
    	RISK_CAT_ID, 
        RISK_CAT, 
        DETAIL, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
	    SETUP_RISK_CAT 
    ORDER BY 
    	RISK_CAT
</cfquery>
<table cellpadding="0" cellspacing="0" border="0">
	<tr> 
    	<td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang dictionary_id='58137.Kategoriler'></td>
	</tr>
	<cfif get_risk_cats.recordcount>
        <cfoutput query="get_risk_cats">
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="200"><a href="#request.self#?fuseaction=settings.upd_risk_cat&id=#risk_cat_id#" class="tableyazi">#risk_cat#</a></td>
        </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="115"><font class="tableyazi"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>
