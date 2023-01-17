<cfquery name="BACKGROUNDS" datasource="#dsn#">
    SELECT 
    	BACKGROUND_ID, 
        BACKGROUND_NAME, 
        BACKGROUND_FILE, 
        BACKGROUND_FILE_SERVER_ID, 
        PORTAL, 
        PAGE 
    FROM 
	    SETUP_BACKGROUND 
    ORDER BY 
    	BACKGROUND_NAME
</cfquery>
<table width="135" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td class="txtbold" height="20" colspan="2" width="135">&nbsp;&nbsp;<cf_get_lang no='3087.Backgrounds'></td>
    </tr>
    <cfif BACKGROUNDS.RecordCount>
		<cfoutput query="BACKGROUNDS">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif"></td>
                <td width="115"><a href="#request.self#?fuseaction=settings.form_upd_background&BACKGROUND_ID=#BACKGROUND_ID#" class="tableyazi">#BACKGROUND_NAME#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>
