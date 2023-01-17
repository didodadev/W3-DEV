<cfquery name="ORDERS" datasource="#dsn3#">
	SELECT 
    	ORDER_CURRENCY_ID,
        ORDER_CURRENCY, 
        RECORD_EMP, 
        RECORD_DATE, 
        RECORD_IP, 
        UPDATE_EMP, 
        UPDATE_DATE, 
        UPDATE_IP 
    FROM 
	    ORDER_CURRENCY 
    ORDER BY 
    	ORDER_CURRENCY
</cfquery>
<table width="135" cellpadding="0" cellspacing="0" border="0">
    <tr> 
        <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='44.Sipariş Durumları'></td>
    </tr>
    <cfif orders.recordcount>
		<cfoutput query="orders">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                <td width="115"><a href="#request.self#?fuseaction=settings.form_upd_order_currency&ID=#order_currency_ID#" class="tableyazi">#order_currency#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="115"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>
