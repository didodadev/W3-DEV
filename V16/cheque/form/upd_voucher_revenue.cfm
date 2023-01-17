<cf_popup_box title="#getLang('cheque',240)#">
    <cfform name="delete_payroll" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_payroll_cancel">
        <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
        <table>
            <tr>
                <td width="70"><cf_get_lang_main no='336.İptal Tarihi'></td>
                <td>
                    <cfsavecontent variable="alert"><cf_get_lang_main no ='326.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
                    <input type="text" name="payroll_date" id="payroll_date" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>" required="yes" message=" !" style="width:70px;" validate="#validate_style#">
                     <cf_wrk_date_image date_field="payroll_date">
                    <input type="hidden" name="payroll_id" id="payroll_id" value="<cfoutput>#attributes.payroll_id#</cfoutput>">
                    <input type="hidden" name="head" id="head" value="<cfoutput>#attributes.head#</cfoutput>">
                    <input type="hidden" name="payroll_type" id="payroll_type" value="<cfoutput>#attributes.payroll_type#</cfoutput>">
                    <input type="hidden" name="is_delete" id="is_delete" value="">
                </td>
            </tr>
        </table>
        <cf_popup_box_footer>
            <cfquery name="get_payroll_actions" datasource="#dsn2#">
                SELECT * FROM VOUCHER_PAYROLL_ACTIONS WHERE PAYROLL_ID = #attributes.payroll_id#
            </cfquery>
            <cfquery name="get_voucher_actions" datasource="#dsn2#">
                SELECT COUNT(STATUS) AS IADE_COUNT FROM VOUCHER_HISTORY WHERE PAYROLL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.payroll_id#"> AND STATUS = 9
            </cfquery> 
            <cfif get_voucher_actions.IADE_COUNT gt 0 >
                <cf_get_lang dictionary_id='62892.Senete ait iade işlemi olduğundan tahsilat işlemi silinemez ya da iptal edilemez'>
            <cfelse>
                <cfif get_payroll_actions.action_type_id eq 241>
                    <cfquery name="CONTROL" datasource="#dsn3#" maxrows="1">
                        SELECT BANK_ACTION_ID FROM CREDIT_CARD_BANK_PAYMENTS_ROWS WHERE CREDITCARD_PAYMENT_ID = #get_payroll_actions.action_id# AND BANK_ACTION_ID IS NOT NULL
                    </cfquery>
                <cfelse>
                    <cfset control.recordcount = 0>
                </cfif>
                <cfif control.recordcount eq 0>
                    <cfsavecontent variable="message2"><cf_get_lang dictionary_id="56610.Tahsilat İşlemi Silinecek Emin misiniz"></cfsavecontent>
                    <cf_workcube_buttons is_upd='0' is_cancel='0' insert_info='Sil' add_function='kontrol(2)' insert_alert='#message2#'>
                </cfif>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='50438.Tahsilat İşlemi İptal Edilecek Emin misiniz?'></cfsavecontent>
                <cf_workcube_buttons is_upd='0' is_cancel='0' insert_info='İptal Et' add_function='kontrol(1)' insert_alert='#message#'>
            </cfif>
       </cf_popup_box_footer>
    </cfform>
</cf_popup_box>
<script type="text/javascript">
	function kontrol(type)
	{
		if(type == 2)
			delete_payroll.is_delete.value = 1;
		else
			delete_payroll.is_delete.value = 0;
		return true;
	}
</script>

