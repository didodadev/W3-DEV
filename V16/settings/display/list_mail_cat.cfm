<cfquery name="GET_MAIL_CATS" datasource="#dsn#">
	SELECT 
	    MAIL_CAT_ID, 
        MAIL_CAT, 
        DETAIL, 
        RECORD_DATE, 
        RECORD_IP, 
        RECORD_EMP, 
        UPDATE_DATE, 
        UPDATE_IP, 
        UPDATE_EMP 
    FROM 
    	SETUP_MAIL_WARNING
</cfquery>
<table width="135" cellpadding="0" cellspacing="0" border="0">
    <tr> 
        <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang_main no='345.Uyarılar'></td>
    </tr>
    <cfif GET_MAIL_CATS.recordcount>
        <cfoutput query="GET_MAIL_CATS">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                <td width="115"><a href="#request.self#?fuseaction=settings.form_upd_mail_cat&id=#mail_cat_id#" class="tableyazi">#mail_cat#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="115"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>

