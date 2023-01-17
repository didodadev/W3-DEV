<cfquery name="GET_STUFF" datasource="#dsn#">
	SELECT 
    	STUFF_ID, 
        STUFF_NAME,
        STUFF_DETAIL, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
	    SETUP_OFFICE_STUFF 
    ORDER BY 
    	STUFF_NAME
</cfquery>
<table cellpadding="0" cellspacing="0" border="0">
    <tr>
        <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='917.Büro Yazılımları'></td>
    </tr>
    <cfif get_stuff.recordcount>
		<cfoutput query="get_stuff">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif"></td>
                <td><a href="#request.self#?fuseaction=settings.form_upd_office_stuff&stuff_id=#stuff_id#" class="tableyazi">#stuff_name#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif"></td>
            <td><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>

