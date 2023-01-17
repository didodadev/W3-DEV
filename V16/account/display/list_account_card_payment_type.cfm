<cfscript>
	netbook = createObject("component","V16.e_government.cfc.netbook");
	netbook.dsn = dsn;
	getAccountCardPaymentTypes = netbook.getAccountCardPaymentTypes();
</cfscript>
<table>
    <cfif getAccountCardPaymentTypes.recordcount>
		<cfoutput query="getAccountCardPaymentTypes">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
                <td  width="380"><a href="#request.self#?fuseaction=account.form_upd_account_card_payment_type&payment_type_id=#payment_type_id#" class="tableyazi">#payment_type#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
            <td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
        </tr>
    </cfif>
</table>