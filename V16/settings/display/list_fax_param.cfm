<cfquery name="FAX" datasource="#dsn#">
    SELECT 
    	* 
    FROM 
        SETUP_FAX
</cfquery>
<table width="135" cellpadding="0" cellspacing="0" border="0">
    <tr> 
        <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='126.Fax Parametreleri'></td>
    </tr>
    <cfif FAX.recordcount>
		<cfoutput query="FAX">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                <td width="115"><a href="#request.self#?fuseaction=settings.form_upd_del_fax_param&ID=#FAX_ID#" class="tableyazi"> Port : #PORT_NAME#</a></td>
            </tr>
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;">&nbsp;</td>
                <td width="115"><a href="#request.self#?fuseaction=settings.form_upd_del_fax_param&ID=#FAX_ID#" class="tableyazi"><cf_get_lang no='682.Uzak Bağlantı'> : #REMOTE_NUMBER#</a></td>
            </tr>  
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="115"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>
