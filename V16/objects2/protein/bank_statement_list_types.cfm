<cfswitch expression = "#attributes.action_type_id#">
    <cfcase value="40"><!--- cari acilis fisi --->
        <cfinclude template="../finance/display/dsp_acc_opening.cfm">
    </cfcase>
    <cfcase value="24"><!--- gelen havale --->
        <cfinclude template="../finance/display/upd_gelenh_.cfm">
    </cfcase>
    <cfcase value="25"><!--- giden havale --->
        <cfinclude template="../finance/display/upd_gidenh_.cfm">
    </cfcase>
    <cfcase value="34"><!---alış f. kapama--->
        <cfinclude template="../finance/display/upd_alisf_kapa_.cfm">
    </cfcase>
    <cfcase value="35"><!---satış f. kapama--->
        <cfinclude template="../finance/display/upd_satisf_kapa_.cfm">
    </cfcase>
    <cfcase value="241"><!--- kredi kartı tahsilat --->
        <cfinclude template="../finance/display/dsp_credit_card_payment_type.cfm">
    </cfcase>
    <cfcase value="242"><!--- kredi karti odeme --->
        <cfinclude template="../finance/display/cash/form/dsp_credit_card_pay.cfm">
    </cfcase>
    <cfcase value="245"><!--- kredi kartı tahsilat --->
        <cfinclude template="../finance/display/dsp_credit_card_payment_type.cfm">
    </cfcase>
    <cfcase value="31"><!---tahsilat--->
        <cfinclude template="../finance/display/upd_cash_revenue_.cfm">
    </cfcase>
    <cfcase value="32"><!---ödeme--->
        <cfinclude template="../finance/display/upd_cash_payment_.cfm">
    </cfcase>
    <!--- BK kaldirdi 20130912 6 aya kaldirilsin <cfcase value="36">
        <cfset type="objects2.popup_list_cash_expense&period_id=#encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex")#">
    </cfcase> --->	
    <cfcase value="41,42"><!--- borc/alacak dekontu --->
        <cfinclude template="../finance/display/dsp_debt_claim_note.cfm">
    </cfcase>
    <cfcase value="43"><!--- cari virman --->
        <cfinclude template="../finance/display/dsp_cari_to_cari.cfm">
    </cfcase>
    <cfcase value="90"><!--- çek giriş bordrosu --->
        <cfinclude template="../finance/display/upd_payroll_entry_.cfm">
    </cfcase>
    <cfcase value="91"><!--- çek çıkış bordrosu(ciro) --->
        <cfinclude template="../finance/display/upd_payroll_endorsement_.cfm">
    </cfcase>
    <cfcase value="94"><!--- Çek İade çıkış bordrosu --->
        <cfinclude template="../finance/display/upd_payroll_endor_return_.cfm">
    </cfcase>
    <cfcase value="95"><!--- Çek iade giriş bordrosu --->
        <cfinclude template="../finance/display/upd_payroll_entry_return_.cfm">
    </cfcase>
    <cfcase value="98,101,97,108"><!--- Senet Çıkış bordrosu --->
        <cfinclude template="../finance/display/upd_voucher_endorsement_.cfm">
    </cfcase>
    <cfcase value="120"><!--- masraf fisi --->
        <cfinclude template="../finance/display/list_cost_expense.cfm">
    </cfcase>
    <cfcase value="121"><!--- gelir fisi --->
        <cfinclude template="../finance/display/list_cost_expense.cfm">
    </cfcase>
    <cfcase value="50,51,52,53,531,54,55,56,57,58,59,591,60,61,62,63,64,65,66,690,601,561,48,49">
        <cfinclude template="../finance/display/detail_invoice.cfm">
    </cfcase>
    <!--- Gelen ve Giden Banka Talimatı --->
    <cfcase value="260,251">
        <cfinclude template="../finance/display/dsp_assign_order.cfm">
    </cfcase>
    <cfcase value="102">
        <cfinclude template="../finance/display/detail_cheque.cfm">
    </cfcase>
</cfswitch>		