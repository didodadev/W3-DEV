<cfquery name="CARDS" datasource="#dsn#">
	SELECT 
        CARDCAT_ID,
        CARDCAT, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP,
        UPDATE_DATE,
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	SETUP_CREDITCARD
</cfquery>	
<table width="135" cellpadding="0" cellspacing="0" border="0">
    <tr> 
        <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='59.Ödeme Kartı Tipleri'></td>
    </tr>
    <cfif cards.recordcount>
		<cfoutput query="cards">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                <td width="115"><a href="#request.self#?fuseaction=settings.form_upd_card&ID=#cardCat_ID#" class="tableyazi">#cardCat#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="115"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>
