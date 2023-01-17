<cfquery name="PRO_STAGES" datasource="#dsn#">
	SELECT 
	    PERFORM_CAT_ID, 
        PERFORM_CAT, 
        PERFORM_CAT_DETAIL, 
        RECORD_EMP,
        RECORD_IP, 
        RECORD_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        UPDATE_DATE 
    FROM 
    	SETUP_PERFORM_CATS
</cfquery>
<table width="200" cellpadding="0" cellspacing="0" border="0">
    <tr> 
        <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='942.Performans Kategorileri'></td>
    </tr>
    <cfif PRO_STAGES.RecordCount>
		<cfoutput query="PRO_STAGES">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                <td width="180"><a href="#request.self#?fuseaction=settings.form_upd_perform_cat&perform_cat_id=#perform_cat_id#" class="tableyazi">#perform_cat#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="180" align="left"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>
