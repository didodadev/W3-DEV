<cfquery name="BADWORDS" datasource="#dsn#">
	SELECT 
	    WORD_ID, 
        WORD
    FROM 
    	SETUP_FORUM_FILTER
</cfquery>
<table>
    <tr> 
        <td colspan="2" class="txtbold">&nbsp;&nbsp;<cf_get_lang no='67.Yasak Kelimeler'></td>
    </tr>
    <cfif badwords.recordcount>
		<cfoutput query="badwords">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                <td width="115"><a href="#request.self#?fuseaction=settings.form_upd_badword&word_ID=#word_ID#" class="tableyazi">#word#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="115"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>
