<cfquery name="COMMETHODS" datasource="#dsn#">
	SELECT 
	    COMMETHOD_ID, 
        COMMETHOD, 
        IS_DEFAULT, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	SETUP_COMMETHOD
</cfquery>
<table width="135" cellpadding="0" cellspacing="0" border="0">
    <tr> 
        <td class="txtbold" height="30" colspan="2">&nbsp;&nbsp;<cf_get_lang no='61.İletişim Yöntemleri'></td>
    </tr>
    <cfif comMethods.recordcount>
		<cfoutput query="comMethods">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                <td width="115"><a href="#request.self#?fuseaction=settings.form_upd_com_method&ID=#comMethod_ID#" class="tableyazi">#comMethod#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="115"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>
