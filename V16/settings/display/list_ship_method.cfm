<cfquery name="SHIP_METHODS" datasource="#DSN#">
	SELECT 
	    SHIP_METHOD_ID,
        SHIP_METHOD,
        CALCULATE, 
        SHIP_DAY, 
        SHIP_HOUR, 
        IS_OPPOSITE, 
        IS_INTERNET, 
        RECORD_IP, 
        RECORD_DATE, 
        RECORD_EMP, 
        UPDATE_IP, 
        UPDATE_EMP, 
        UPDATE_DATE 
    FROM 
    	SHIP_METHOD
</cfquery>
<table width="99%" cellpadding="0" cellspacing="0" border="0">
    <tr> 
        <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='192.Sevk Yöntemleri'></td>
    </tr>
    <cfif ship_methods.recordcount>
		<cfoutput query="ship_methods">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                <td><a href="#request.self#?fuseaction=settings.form_upd_ship_method&ship_method_ID=#ship_method_ID#" class="tableyazi">#ship_method#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>
