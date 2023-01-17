<!--- bu sayfa muhasebe mevz değişikliklerine göre düzenlenecektir,şimdilik sadece money tablolari bilgisi vardir
işlem tiplerine göre entegre gelen işlem tablosundan bilgi alır... 
İşlem kategorilerindeki yapacağınız değişiklikleri burda da güncellemelisiniz...
Ayşenur20060801--->

<!--- Sayfaya muhasebe fişi oluşturan işlemlerin linkleri eklendi. Bu linklere göre fiş update ve display ekranlarından ilgili işlemlere ulaşılabiliyor.
Muhasebe işlemi yapan işlemlerin fuseactionlarında yapılacak değişiklikler bu sayfaya da aktarılmalı. OZDEN20060828
--->
<cfif not isdefined("acc_process_type")>
	<cfset acc_process_type = ""> <!--- muhasebe fisi olusturulan islemin process type 'ı   --->
</cfif>
<cfset from_money_table = "">
<cfset link_str = "">
<cfset muhasebe_db = "#dsn2#">
<!--- kasa ya da banka masraf fisi --->
<cfif isdefined("expense_type_id_") and ListFind("120,121,122",expense_type_id_)>
	<cfset from_money_table = "EXPENSE_ITEM_PLANS_MONEY">
	<cfset muhasebe_db = "#dsn2#">
	<cfif expense_type_id_ eq 120>
		<cfset refurl="#CGI.HTTP_REFERER#">
        <cfif isdefined("refurl") and len(refurl)>
            <cfset refurl_len=find('fuseaction',refurl)+11>
            <cfset refmodule="#mid(refurl,refurl_len,find('.',refurl,refurl_len)-refurl_len )#">
        <cfelse>
            <cfset refmodule="">
        </cfif>
		<cfset link_str="#request.self#?fuseaction=cost.form_add_expense_cost&event=upd&expense_id="> <!--- masraf fisi --->
	<cfelseif expense_type_id_ eq 122>
		<cfset link_str="#request.self#?fuseaction=assetcare.form_add_expense_cost&event=upd&expense_id="> <!--- bakım fisi --->
	<cfelse>
		<cfset refurl="#CGI.HTTP_REFERER#">
        <cfif isdefined("refurl") and len(refurl)>
            <cfset refurl_len=find('fuseaction',refurl)+11>
            <cfset refmodule="#mid(refurl,refurl_len,find('.',refurl,refurl_len)-refurl_len )#">
        <cfelse>
            <cfset refmodule="">
        </cfif>
		<cfset link_str="#request.self#?fuseaction=cost.add_income_cost&event=upd&expense_id=">  <!--- gelir fisi --->
	</cfif>
<cfelseif ListFind("20,21,22,23,24,25,26,27,29,243,244,2311,240,250",acc_process_type)>
	<cfset from_money_table = "BANK_ACTION_MONEY">
	<cfset muhasebe_db = "#dsn2#">
	<cfif acc_process_type eq 20>
		<cfset link_str="#request.self#?fuseaction=bank.form_add_bank_account_open&event=upd&id="><!--- açılış fişi(banka) --->
	<cfelseif acc_process_type eq 21>
		<cfset link_str="#request.self#?fuseaction=bank.form_add_invest_money&event=upd&ID="><!--- para yatırma --->
	<cfelseif acc_process_type eq 22>
		<cfset link_str="#request.self#?fuseaction=bank.form_add_get_money&event=upd&ID="><!--- para çekme --->
	<cfelseif acc_process_type eq 23>
		<cfset link_str="#request.self#?fuseaction=bank.form_add_virman&event=upd&ID="><!--- virman --->
	<cfelseif acc_process_type eq 24>
		<cfset link_str="#request.self#?fuseaction=bank.form_add_gelenh&event=upd&ID="><!--- gelen havale--->
	<cfelseif acc_process_type eq 240>
		<cfset link_str="#request.self#?fuseaction=bank.form_add_gelenh&event=updMulti&multi_id="><!---toplu gelen havale--->
	<cfelseif acc_process_type eq 25>
		<cfset link_str="#request.self#?fuseaction=bank.form_add_gidenh&event=upd&ID="><!--- giden havale--->
	<cfelseif acc_process_type eq 250>
		<cfset link_str="#request.self#?fuseaction=bank.form_add_gidenh&event=updMulti&multi_id="><!--- toplu giden havale--->
	<cfelseif acc_process_type eq 29>
		<cfset link_str="#request.self#?fuseaction=objects.form_add_expense_cost&event=upd&expense_id="><!--- banka masraf fişi--->
	<cfelseif acc_process_type eq 243>
		<cfset link_str="#request.self#?fuseaction=bank.popup_upd_bank_cc_payment&ID="><!--- kredi kartı hesaba geçiş (display sayfası)--->
	<cfelseif acc_process_type eq 244>
		<cfset link_str="#request.self#?fuseaction=bank.list_credit_card_expense&event=updDebit&ID="><!--- kredi kartı borcu odeme (display sayfası) --->
	<cfelseif acc_process_type eq 2311>
		<cfset link_str="#request.self#?fuseaction=bank.form_add_term_deposit&event=upd&ID="><!--- vadeli mevduat hesaba yatırma --->
	</cfif>
<cfelseif ListFind("160,161",acc_process_type) and isdefined("get_card_rows.action_table") and get_card_rows.action_table is 'BUDGET_PLAN'> 
	<cfset from_money_table = "BUDGET_PLAN_MONEY">
	<cfset link_str="#request.self#?fuseaction=budget.list_plan_rows&event=upd&&budget_plan_id="><!--- bütçe planlama fişi --->
	<cfset muhasebe_db = "#dsn#">
<cfelseif ListFind("260,251",acc_process_type)>
	<cfset from_money_table = "BANK_ORDER_MONEY">
	<cfset muhasebe_db = "#dsn2#">	
	<cfif acc_process_type eq 260>
		<cfset link_str="#request.self#?fuseaction=bank.list_assign_order&event=upd_assign&bank_order_id="><!--- giden banka talimatı --->
	<cfelse>
		<cfset link_str="#request.self#?fuseaction=bank.list_assign_order&event=upd_incoming&bank_order_id="><!--- gelen banka talimatı --->
	</cfif>
<cfelseif ListFind("241",acc_process_type)>
	<cfset from_money_table = "CREDIT_CARD_BANK_PAYMENT_MONEY">
	<cfset link_str="#request.self#?fuseaction=bank.list_creditcard_revenue&event=upd&id="><!--- kredi kartı tahsilatı --->
	<cfset muhasebe_db = "#dsn3#">	
<cfelseif ListFind("242",acc_process_type)>
	<cfset from_money_table = "CREDIT_CARD_BANK_EXPENSE_MONEY">
	<cfset link_str="#request.self#?fuseaction=bank.list_credit_card_expense&event=upd&id="><!--- kredi kartıyla odemeler --->
	<cfset muhasebe_db = "#dsn3#">
<cfelseif ListFind("291",acc_process_type)>
	<cfset from_money_table = "CREDIT_CONTRACT_PAYMENT_INCOME_MONEY">
	<cfset link_str="#request.self#?fuseaction=credit.list_credit_contract&event=updPayment&credit_contract_row_id="><!--- kredi ödeme--->
	<cfset muhasebe_db = "#dsn2#">
<cfelseif ListFind("292",acc_process_type)>
	<cfset from_money_table = "CREDIT_CONTRACT_PAYMENT_INCOME_MONEY">
	<cfset link_str="#request.self#?fuseaction=credit.list_credit_contract&event=updRevenue&credit_contract_row_id="><!--- kredi tahsilat--->
	<cfset muhasebe_db = "#dsn2#">
<cfelseif ListFind("300,301",acc_process_type)>
	<cfset from_money_table = "COMPANY_SECUREFUND_MONEY">
	<cfset link_str="#request.self#?fuseaction=finance.list_securefund&event=upd&securefund_id="><!---teminatlar--->
	<cfset muhasebe_db = "#dsn#">
<cfelseif ListFind("120,121,122",acc_process_type)>
	<cfset from_money_table = "EXPENSE_ITEM_PLANS_MONEY">
	<cfset muhasebe_db = "#dsn2#">
	<cfif acc_process_type eq 120>
		<cfset refurl="#CGI.HTTP_REFERER#">
        <cfif isdefined("refurl") and len(refurl)>
            <cfset refurl_len=find('fuseaction',refurl)+11>
            <cfset refmodule="#mid(refurl,refurl_len,find('.',refurl,refurl_len)-refurl_len )#">
        <cfelse>
            <cfset refmodule="">
        </cfif>
		<cfset link_str="#request.self#?fuseaction=cost.form_add_expense_cost&event=upd&expense_id="> <!--- masraf fisi --->
	<cfelseif acc_process_type eq 122>
		<cfset link_str="#request.self#?fuseaction=assetcare.form_add_expense_cost&event=upd&expense_id="> <!--- bakım fisi --->
	<cfelse>
		<cfset refurl="#CGI.HTTP_REFERER#">
        <cfif isdefined("refurl") and len(refurl)>
            <cfset refurl_len=find('fuseaction',refurl)+11>
            <cfset refmodule="#mid(refurl,refurl_len,find('.',refurl,refurl_len)-refurl_len )#">
        <cfelse>
            <cfset refmodule="">
        </cfif>
		<cfset link_str="#request.self#?fuseaction=cost.add_income_cost&event=upd&expense_id=">  <!--- gelir fisi --->
	</cfif>
<cfelseif ListFind("30,32,33,34,35,37,38,39,31,310",acc_process_type)>
	<cfset from_money_table = "CASH_ACTION_MONEY">
	<cfset muhasebe_db = "#dsn2#">	
	<cfif acc_process_type eq 30> 
		<cfset link_str="#request.self#?fuseaction=cash.form_add_cash_open&event=upd&ID="> <!--- kasa acılısı --->
	<cfelseif acc_process_type eq 31> 
		<cfset link_str="#request.self#?fuseaction=cash.form_add_cash_revenue&event=upd&ID="> <!---nakit tahsilat --->
	<cfelseif acc_process_type eq 32> 
		<cfset link_str="#request.self#?fuseaction=cash.form_add_cash_payment&event=upd&ID="> <!--- cari odeme --->
	<cfelseif acc_process_type eq 33> 
		<cfset link_str="#request.self#?fuseaction=cash.form_add_cash_to_cash&event=upd&ID="> <!--- virman --->
		<cfelseif acc_process_type eq 34> 
		<cfset link_str="#request.self#?fuseaction=invoice.form_add_bill_purchas&event=upd&iid="> <!--- virman --->
	<cfelseif listfind('34,35',acc_process_type)>  <!--- alış- satış fatura kapama--->
		<cfset link_str="">
	<cfelseif acc_process_type eq 37> 
		<cfset link_str="#request.self#?fuseaction=cash.popup_upd_gider_pusula&ID="> <!--- kasa masraf --->
	</cfif>
<cfelseif ListFind("40,41,42,43",acc_process_type)>
	<cfset from_money_table = "CARI_ACTION_MONEY">
	<cfset muhasebe_db = "#dsn2#">
	<cfif acc_process_type eq 40>
		<cfset link_str="">
	<cfelseif acc_process_type eq 41>
		<cfset link_str="#request.self#?fuseaction=ch.form_add_debit_claim_note&event=upd&ID="> <!--- borc dekontu --->
	<cfelseif acc_process_type eq 42>
		<cfset link_str="#request.self#?fuseaction=ch.form_add_debit_claim_note&event=upd&ID="> <!--- alacak dekontu --->
	<cfelseif acc_process_type eq 43>
		<cfset link_str="#request.self#?fuseaction=ch.form_add_cari_to_cari&event=upd&ID="> <!--- cari virman --->
	</cfif>
<cfelseif ListFind("410,420,45,46",acc_process_type)>
	<cfset from_money_table = "CARI_ACTION_MULTI_MONEY">
	<cfset muhasebe_db = "#dsn2#">
	<cfset link_str="#request.self#?fuseaction=ch.form_add_debit_claim_note&event=updMulti&multi_id="> <!--- toplu dekont --->
<cfelseif ListFind("50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,690,691,591,592,531,561,601",acc_process_type)>
	<cfset from_money_table = "INVOICE_MONEY">
	<cfset muhasebe_db = "#dsn2#">
	<cfif acc_process_type eq 65>
		<cfset link_str="#request.self#?fuseaction=invent.add_invent_purchase&event=upd&invoice_id="><!--- demirbaş alım faturası --->
	<cfelseif acc_process_type eq 66>
		<cfset link_str="#request.self#?fuseaction=invent.add_invent_sale&event=upd&invoice_id="><!--- demirbaş satış faturası --->
		<cfelseif acc_process_type eq 69>
		<cfset link_str="#request.self#?fuseaction=finance.upd_daily_zreport&iid="><!--- Z raporu --->
	<cfelseif acc_process_type eq 52>
		<cfset link_str="#request.self#?fuseaction=invoice.add_bill_retail&event=upd&iid="> <!--- perakende satıs fat. --->
	<cfelseif acc_process_type eq 592>
		<cfset link_str="#request.self#?fuseaction=invoice.form_upd_marketplace_bill&iid="> <!--- hal faturası --->
	<cfelseif listfind("50,52,53,56,58,62,66,67,531,561",acc_process_type,",")>
		<cfset link_str="#request.self#?fuseaction=invoice.form_add_bill&event=upd&iid="> <!--- satış faturası --->
	<cfelseif listfind("51,54,55,59,60,63,64,65,591,601",acc_process_type,",")>
		<cfset link_str="#request.self#?fuseaction=invoice.form_add_bill_purchase&event=upd&iid="> <!---alış faturası  --->
	<cfelseif listfind("64,68,690,691",acc_process_type,",")>
		<cfset link_str="#request.self#?fuseaction=invoice.form_add_bill_other&event=upd&iid="> <!--- diger alış fat. --->
	</cfif>
<cfelseif ListFind("81,811",acc_process_type)>
	<cfset from_money_table = "SHIP_MONEY">
	<cfset muhasebe_db = "#dsn2#">
	<cfif acc_process_type eq 81>
		<cfset link_str="#request.self#?fuseaction=stock.add_ship_dispatch&event=upd&ship_id="> <!--- depolararası sevk irsaliyesi --->
	<cfelseif acc_process_type eq 811>
		<cfset link_str="#request.self#?fuseaction=stock.add_stock_in_from_customs&event=upd&ship_id="> <!---ithal mal girisi --->
	</cfif>
<cfelseif ListFind("90,91,92,93,94,95,96,106,105,133",acc_process_type)>
	<cfset refurl="#CGI.HTTP_REFERER#">
    <cfif isdefined("refurl") and len(refurl)>
        <cfset refurl_len=find('fuseaction',refurl)+11>
        <cfset refmodule="#mid(refurl,refurl_len,find('.',refurl,refurl_len)-refurl_len )#">
    <cfelse>
        <cfset refmodule="">
    </cfif>
	<cfset from_money_table = "PAYROLL_MONEY">
	<cfset muhasebe_db = "#dsn2#">
	<cfif acc_process_type eq 90>
		<cfset link_str="#request.self#?fuseaction=cheque.form_add_payroll_entry&event=upd&ID=">
	<cfelseif acc_process_type eq 91>
		<cfset link_str="#request.self#?fuseaction=cheque.form_add_payroll_endorsement&event=upd&ID=">
	<cfelseif acc_process_type eq 92>
		<cfset link_str="#request.self#?fuseaction=cheque.form_add_payroll_bank_revenue&event=upd&ID=">
	<cfelseif acc_process_type eq 93>
		<cfset link_str="#request.self#?fuseaction=cheque.form_add_payroll_bank_guaranty&event=upd&ID=">
	<cfelseif acc_process_type eq 133>
		<cfset link_str="#request.self#?fuseaction=cheque.form_add_payroll_bank_guaranty_tem&event=upd&ID=">
	<cfelseif acc_process_type eq 94>
		<cfset link_str="#request.self#?fuseaction=cheque.form_add_payroll_endor_return&event=upd&ID=">
	<cfelseif acc_process_type eq 95>
		<cfset link_str="#request.self#?fuseaction=cheque.form_add_payroll_entry_return&event=upd&ID=">
	<cfelseif acc_process_type eq 96>
		<cfset link_str="">
	<cfelseif acc_process_type eq 105>
		<cfset link_str="#request.self#?fuseaction=cheque.form_add_payroll_bank_guaranty_return&event=upd&ID=">
	<cfelseif acc_process_type eq 106>
		<cfset link_str="">
	</cfif>
<cfelseif ListFind("98,99,100,101,102,103,107,104,108,136,137",acc_process_type)>
	<cfset refurl="#CGI.HTTP_REFERER#">
    <cfif isdefined("refurl") and len(refurl)>
        <cfset refurl_len=find('fuseaction',refurl)+11>
        <cfset refmodule="#mid(refurl,refurl_len,find('.',refurl,refurl_len)-refurl_len )#">
    <cfelse>
        <cfset refmodule="">
    </cfif>
	<cfset from_money_table = "VOUCHER_PAYROLL_MONEY">
	<cfset muhasebe_db = "#dsn2#">
	<cfif acc_process_type eq 97>
		<cfset link_str="#request.self#?fuseaction=cheque.form_add_voucher_payroll_entry&event=upd&ID=">
	<cfelseif acc_process_type eq 98>
		<cfset link_str="#request.self#?fuseaction=cheque.form_add_voucher_payroll_endorsement&event=upd&ID=">
	<cfelseif acc_process_type eq 99>
		<cfset link_str="#request.self#?fuseaction=cheque.form_add_voucher_payroll_bank_tah&event=upd&ID=">
	<cfelseif acc_process_type eq 100>
		<cfset link_str="#request.self#?fuseaction=cheque.form_add_voucher_payroll_bank_tem&event=upd&ID=">
	<cfelseif acc_process_type eq 101>
		<cfset link_str="#request.self#?fuseaction=cheque.add_voucher_payroll_endor_return&event=upd&ID=">
	<cfelseif acc_process_type eq 136>
		<cfset link_str="#request.self#?fuseaction=cheque.form_add_voucher_transfer&event=upd&ID=">
	<cfelseif acc_process_type eq 137>
		<cfset link_str="#request.self#?fuseaction=cheque.form_add_voucher_transfer&event=upd&ID=">
	<cfelseif acc_process_type eq 102>
		<cfset link_str="">
	<cfelseif acc_process_type eq 103>
		<cfset link_str="">
	<cfelseif acc_process_type eq 104>
		<cfset link_str="#request.self#?fuseaction=cheque.form_add_payroll_voucher_revenue&event=upd&ID=">
	<cfelseif acc_process_type eq 107>
		<cfset link_str="">
	<cfelseif acc_process_type eq 108>
		<cfset link_str="#request.self#?fuseaction=cheque.add_voucher_payroll_entry_return&event=upd&ID=">
	</cfif>
<cfelseif ListFind("110,111,112,113,114,115,117,118",acc_process_type)>
	<cfset from_money_table = "STOCK_FIS_MONEY">
	<cfset muhasebe_db = "#dsn2#">
	<cfif acc_process_type eq 114>
		<cfset link_str="#request.self#?fuseaction=stock.form_add_open_fis&event=upd&upd_id=">
	<cfelseif acc_process_type eq 118>
		<cfset link_str="#request.self#?fuseaction=invent.add_invent_stock_fis&event=upd&fis_id=">
	<cfelse>
		<cfset link_str="#request.self#?fuseaction=stock.form_add_fis&event=upd&upd_id=">
	</cfif>
<cfelseif ListFind("293,294",acc_process_type)>
	<cfset from_money_table = "STOCKBONDS_SALEPURCHASE_MONEY">
	<cfset muhasebe_db = "#dsn3#">
	<cfif acc_process_type eq 293>
		<cfset link_str="#request.self#?fuseaction=credit.add_stockbond_purchase&event=upd&action_id="><!--- menkul kıymet alış işlemi --->
	<cfelseif acc_process_type eq 294>
		<cfset link_str="#request.self#?fuseaction=credit.add_stockbond_sale&event=upd&action_id="><!--- menkul kıymet satış işlemi --->
	</cfif>
</cfif>

