<cfquery name="get_bill_payment_types" datasource="#dsn#">
	SELECT 
	    BILL_PAYMENT_TYPE_ID, 
        BILL_PAYMENT_TYPE, 
        DETAIL
    FROM 
    	BILL_PAYMENT_TYPES
	ORDER BY
		BILL_PAYMENT_TYPE
</cfquery>
<table cellpadding="0" cellspacing="0" border="0">
    <tr> 
        <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;Fiş Ödeme Şekilleri</td>
    </tr>
    <cfif get_bill_payment_types.recordcount>
		<cfoutput query="get_bill_payment_types">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                <td><a href="#request.self#?fuseaction=account.form_upd_bill_payment_type&bill_payment_type_id=#bill_payment_type_id#" class="tableyazi">#bill_payment_type#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>
