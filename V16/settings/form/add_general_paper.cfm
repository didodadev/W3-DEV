<cfif fusebox.use_period eq 1>
    <cfquery name="get_all" datasource="#DSN3#">
        SELECT * FROM GENERAL_PAPERS
    </cfquery>
    <!--- Finans ve Genel Sayfa Numaralari --->
    <cfquery name="get_all_control" dbtype="query">
        SELECT * FROM get_all WHERE PAPER_TYPE IS NULL
    </cfquery>
    <!--- Employee Alinan Teklif - Alinan Siparis No --->
    <cfquery name="get_general_papers" dbtype="query">
        SELECT * FROM get_all WHERE PAPER_TYPE = 0 AND ZONE_TYPE = 0
    </cfquery>
    <!--- Employee Verilen Teklif - Verilen Siparis No --->
    <cfquery name="get_general_papers_give" dbtype="query">
        SELECT * FROM get_all WHERE PAPER_TYPE = 1 AND ZONE_TYPE = 0
    </cfquery>
    <!--- Partner Alinan Teklif - Alinan Siparis No --->
    <cfquery name="get_general_papers_part" dbtype="query">
        SELECT * FROM get_all WHERE PAPER_TYPE = 0 AND ZONE_TYPE = 1
    </cfquery>
    <!--- Partner Verilen Teklif - Verilen Siparis No --->
    <cfquery name="get_general_papers_give_part" dbtype="query">
        SELECT * FROM get_all WHERE PAPER_TYPE = 1 AND ZONE_TYPE = 1
    </cfquery>
</cfif>
<!--- Genel Sayfa Numaralari Main --->
<cfquery name="get_general_papers_main" datasource="#dsn#">
	SELECT 
    	GENERAL_PAPER_ID, 
        EMPLOYEE_NO, 
        EMPLOYEE_NUMBER, 
        EMP_APP_NO,
        EMP_APP_NUMBER, 
        G_SERVICE_APP_NO, 
        G_SERVICE_APP_NUMBER, 
        ASSET_NO, 
        ASSET_NUMBER, 
        FIXTURES_NO,
        FIXTURES_NUMBER, 
        EMPLOYEE_HEALTY_NO, 
        EMPLOYEE_HEALTY_NUMBER, 
        EMP_NOTICE_NO, 
        EMP_NOTICE_NUMBER,
        ASSET_FAILURE_NO,
        ASSET_FAILURE_NUMBER,
		ALLOWENCE_EXPENSE_NO,
		ALLOWENCE_EXPENSE_NUMBER,
		HEALTH_ALLOWENCE_EXPENSE_NO,
		HEALTH_ALLOWENCE_EXPENSE_NUMBER,
		ADDITIONAL_ALLOWANCE_NO,
		ADDITIONAL_ALLOWANCE_NUMBER,
		WORK_NO,
		WORK_NUMBER,
		PACKAGE_NO,
		PACKAGE_NUMBER
    FROM 
	    GENERAL_PAPERS_MAIN
</cfquery>
<br />
<cfsavecontent variable="img_">
	<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_paperno"><img src="/images/properties.gif" border="0" alt="<cf_get_lang no='522.Genel Nolar'>"></a>
</cfsavecontent>
<cfif fusebox.use_period eq 1>
	<cf_box id="general_paper_emp" title="#getLang('settings',417)# (#getLang('settings',734)#)"> <!--- Genel Sayfa Numaraları(Employee) --->
<table id="general_paper_emp" width="100%" cellpadding="2" cellspacing="2">
		<cfoutput>
			<form method="post" action="#request.self#?fuseaction=settings.add_emp_port_paper_no">
				<cf_box_elements>
					<div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-text">
							<label class="col col-4 col-md-6 col-xs-12"></label>
								<div class="col col-8 col-md-6 col-xs-12">
									<cf_get_lang_main no='1076.Alınan'>
								</div>
							</div>
						<div class="form-group" id="item-offer">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='800.Teklif No'></label>
							<div class="col col-8 col-md-6 col-xs-12">
								<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="offer_no" id="offer_no" value="#get_general_papers.offer_no#"></div>
								<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="offer_number" id="offer_number" value="#get_general_papers.offer_number#"></div>
							</div>
						</div>
						<div class="form-group" id="item-order">
							<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='799.Siparis No'></label>
								<div class="col col-8 col-md-6 col-xs-12">
									<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="order_no" id="order_no" value="#get_general_papers.order_no#"></div>
									<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="order_number" id="order_number" value="#get_general_papers.order_number#"></div>
								</div>
						</div>
					</div>
					<div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-text">
							<label class="col col-4 col-md-6 col-xs-12"></label>
								<div class="col col-8 col-md-6 col-xs-12">
									<cf_get_lang_main no='1078.Verilen'>
								</div>
							</div>
						<div class="form-group" id="item-g_offer">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='800.Teklif No'></label>
							<div class="col col-8 col-md-6 col-xs-12">
								<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="g_offer_no" id="g_offer_no" value="#get_general_papers_give.offer_no#"></div>
								<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="g_offer_number" id="g_offer_number" value="#get_general_papers_give.offer_number#"></div>
							</div>
						</div>
						<div class="form-group" id="item-g_order">
							<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='799.Siparis No'></label>
								<div class="col col-8 col-md-6 col-xs-12">
									<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="g_order_no" id="g_order_no" value="#get_general_papers_give.order_no#"></div>
									<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="g_order_number" id="g_order_number" value="#get_general_papers_give.order_number#"></div>
								</div>
						</div>
					</div>
					<div class="row">
				<cf_box_footer>	
					<cf_workcube_buttons is_upd='0'>
					<cf_box_footer>	
					</div>
			</cf_box_elements>
			</form>
		</cfoutput>
	</table>
</cf_box>
	<cf_box id="general_paper_partner" title="#getLang('settings',417)# (#getLang('main',1473)#)"> <!--- Genel Sayfa Numaraları(Partner) --->
	<table id="general_paper_partner" width="100%" cellpadding="2" cellspacing="2">
		<cfoutput>
			<form method="post" action="#request.self#?fuseaction=settings.add_par_port_paper_no">
				<cf_box_elements>
					<input type="hidden" name="zone_type" id="zone_type" value="1">
					<div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-text">
							<label class="col col-4 col-md-6 col-xs-12"></label>
								<div class="col col-8 col-md-6 col-xs-12">
									<cf_get_lang_main no='1076.Alınan'>
								</div>
							</div>
						<div class="form-group" id="item-offer">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='800.Teklif No'></label>
							<div class="col col-8 col-md-6 col-xs-12">
								<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="offer_no" id="offer_no" value="#get_general_papers_part.offer_no#"></div>
								<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="offer_number" id="offer_number" value="#get_general_papers_part.offer_number#"></div>
							</div>
						</div>
						<div class="form-group" id="item-order">
							<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='799.Siparis No'></label>
								<div class="col col-8 col-md-6 col-xs-12">
									<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="order_no" id="order_no" value="#get_general_papers_part.order_no#"></div>
									<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="order_number" id="order_number" value="#get_general_papers_part.order_number#"></div>
								</div>
						</div>
					</div>
					<div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-text">
							<label class="col col-4 col-md-6 col-xs-12"></label>
								<div class="col col-8 col-md-6 col-xs-12">
									<cf_get_lang_main no='1078.Verilen'>
								</div>
							</div>
						<div class="form-group" id="item-g_offer">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='800.Teklif No'></label>
							<div class="col col-8 col-md-6 col-xs-12">
								<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="g_offer_no" id="g_offer_no" value="#get_general_papers_give_part.offer_no#"></div>
								<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="g_offer_number" id="g_offer_number" value="#get_general_papers_give_part.offer_number#"></div>
							</div>
						</div>
						<div class="form-group" id="item-g_order">
							<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='799.Siparis No'></label>
								<div class="col col-8 col-md-6 col-xs-12">
									<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="g_order_no" id="g_order_no" value="#get_general_papers_give_part.order_no#"></div>
									<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="g_order_number" id="g_order_number" value="#get_general_papers_give_part.order_number#"></div>
								</div>
						</div>
					</div>
					<div class="row">
						<cf_box_footer>	
					<cf_workcube_buttons is_upd='0'>
					<cf_box_footer>	
					</div>
			</cf_box_elements>
			</form>
		</cfoutput>
	</table>
</cf_box>
	<cf_box id="financial_paper_no" title="#getLang('settings',1607)#"> <!--- Finans Sayfa Numaraları --->
	<table id="financial_paper_no" width="100%" cellpadding="2" cellspacing="2">
		<cfoutput>
			<form name="add_other_no" method="post" action="#request.self#?fuseaction=settings.add_general_paper&type=2">
				<cf_box_elements>
				<cfif get_all_control.recordcount>
					<input type="hidden" name="is_upd" id="is_upd" value="1">
					<input type="hidden" name="general_papers_id" id="general_papers_id" value="#get_all_control.general_papers_id#">
				</cfif>
				<div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-virman">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='109.Banka'> - <cf_get_lang_main no='648.Virman'> <cf_get_lang_main no='75.No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="virman_no" id="virman_no" value="#get_all_control.virman_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="virman_number" id="virman_number" value="#get_all_control.virman_number#" onkeyup="isNumber(this);" onblur='isNumber(this);'></div>
						</div>
					</div>
					<div class="form-group" id="item-incoming">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='109.Banka'> - <cf_get_lang_main no='422.Gelen Havale'> <cf_get_lang_main no='75.No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="incoming_transfer_no" id="incoming_transfer_no" value="#get_all_control.incoming_transfer_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="incoming_transfer_number" id="incoming_transfer_number" value="#get_all_control.incoming_transfer_number#" onkeyup="isNumber(this);" onblur='isNumber(this);'></div>
						</div>
					</div>
					<div class="form-group" id="item-outgoing">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='109.Banka'> - <cf_get_lang_main no='423.Giden Havale'> <cf_get_lang_main no='75.No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="outgoing_transfer_no" id="outgoing_transfer_no" value="#get_all_control.outgoing_transfer_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="outgoing_transfer_number" id="outgoing_transfer_number" value="#get_all_control.outgoing_transfer_number#" onkeyup="isNumber(this);" onblur='isNumber(this);'></div>
						</div>
					</div>
					<div class="form-group" id="item-purchase_doviz">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='109.Banka'> - <cf_get_lang_main no='420.Doviz Alıs'> <cf_get_lang_main no='75.No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="purchase_doviz_no" id="purchase_doviz_no" value="#get_all_control.purchase_doviz_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="purchase_doviz_number" id="purchase_doviz_number" value="#get_all_control.purchase_doviz_number#" onkeyup="isNumber(this);" onblur='isNumber(this);'></div>
						</div>
					</div>
					<div class="form-group" id="item-sale_doviz_no">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='109.Banka'> - <cf_get_lang_main no='421.Doviz Satis'> <cf_get_lang_main no='75.No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="sale_doviz_no" id="sale_doviz_no" value="#get_all_control.sale_doviz_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="sale_doviz_number" id="sale_doviz_number" value="#get_all_control.sale_doviz_number#" onkeyup="isNumber(this);" onblur='isNumber(this);'></div>
						</div>
					</div>
					<div class="form-group" id="item-creditcard_revenue_no">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='109.Banka'> - <cf_get_lang_main no='424.Kredi Kartı Tahsilat'> <cf_get_lang_main no='75.No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="creditcard_revenue_no" id="creditcard_revenue_no" value="#get_all_control.creditcard_revenue_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="creditcard_revenue_number" id="creditcard_revenue_number" value="#get_all_control.creditcard_revenue_number#" onkeyup="isNumber(this);" onblur='isNumber(this);' ></div>
						</div>
					</div>
					<div class="form-group" id="item-creditcard_payment_no">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='109.Banka'> - <cf_get_lang_main no='425.Kredi Kartı Odeme'> <cf_get_lang_main no='75.No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="creditcard_payment_no" id="creditcard_payment_no" value="#get_all_control.creditcard_payment_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="creditcard_payment_number" id="creditcard_payment_number" value="#get_all_control.creditcard_payment_number#" onkeyup="isNumber(this);" onblur='isNumber(this);' ></div>
						</div>
					</div>
					<div class="form-group" id="item-creditcard_debit_payment_no">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='109.Banka'> - <cf_get_lang_main no='1753.Kredi Kartı Borcu Odeme'> <cf_get_lang_main no='75.No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="creditcard_debit_payment_no" id="creditcard_debit_payment_no" value="#get_all_control.creditcard_debit_payment_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="creditcard_debit_payment_number" id="creditcard_debit_payment_number" value="#get_all_control.creditcard_debit_payment_number#" onkeyup="isNumber(this);" onblur='isNumber(this);' ></div>
						</div>
					</div>
					<div class="form-group" id="item-creditcard_cc_bank_action_no">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='109.Banka'> - <cf_get_lang_main no='1751.Kredi Kartı Hesaba Geçiş'> <cf_get_lang_main no='75.No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="creditcard_cc_bank_action_no" id="creditcard_cc_bank_action_no" value="#get_all_control.creditcard_cc_bank_action_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="creditcard_cc_bank_action_number" id="creditcard_cc_bank_action_number" value="#get_all_control.creditcard_cc_bank_action_number#" onkeyup="isNumber(this);" onblur='isNumber(this);' ></div>
						</div>
					</div>
					<div class="form-group" id="item-buying_securities_no">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main dictionary_id='57840.Menkul kıymetler satış'> <cf_get_lang_main no='75.No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="buying_securities_no" id="buying_securities_no" value="#get_all_control.buying_securities_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"> <input type="text" name="buying_securities_number" id="buying_securities_number" value="#get_all_control.buying_securities_number#" onkeyup="isNumber(this);" onblur='isNumber(this);' ></div>
						</div>
					</div>
					<div class="form-group" id="item-receipt_no">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main dictionary_id='58062.Dekont'> <cf_get_lang_main no='75.No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="receipt_no" id="receipt_no" value="#get_all_control.receipt_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="receipt_number" id="receipt_number" value="#get_all_control.receipt_number#" onkeyup="isNumber(this);" onblur='isNumber(this);' ></div>
						</div>
					</div>
					<div class="form-group" id="item-budgettransfer_no">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id="61325.Bütçe Aktarım Talebi"> <cf_get_lang_main no='75.No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="budgettransfer_no" id="budgettransfer_no" value="#get_all_control.BUDGET_TRANSFER_DEMAND_NO#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="budgettransfer_number" id="budgettransfer_number" value="#get_all_control.BUDGET_TRANSFER_DEMAND_NUMBER#" onkeyup="isNumber(this);" onblur='isNumber(this);' ></div>
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-cari_to_cari_number">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='649.Cari'> - <cf_get_lang_main no='649.Cari'> <cf_get_lang_main no='648.Virman'> <cf_get_lang_main no='75.No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="cari_to_cari_no" id="cari_to_cari_no" value="#get_all_control.cari_to_cari_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="cari_to_cari_number" id="cari_to_cari_number" value="#get_all_control.cari_to_cari_number#" onkeyup="isNumber(this);" onblur='isNumber(this);'></div>
						</div>
					</div>
					<div class="form-group" id="item-debit_claim_no">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='649.Cari'> - <cf_get_lang_main no='650.Dekont'> <cf_get_lang_main no='75.No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="debit_claim_no" id="debit_claim_no" value="#get_all_control.debit_claim_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="debit_claim_number" id="debit_claim_number" value="#get_all_control.debit_claim_number#" onkeyup="isNumber(this);" onblur='isNumber(this);'></div>
						</div>
					</div>
					<div class="form-group" id="item-cash_to_cash_no">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='108.Kasa'> - <cf_get_lang_main no='648.Virman'> <cf_get_lang_main no='75.No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="cash_to_cash_no" id="cash_to_cash_no" value="#get_all_control.cash_to_cash_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="cash_to_cash_number" id="cash_to_cash_number" value="#get_all_control.cash_to_cash_number#" onkeyup="isNumber(this);" onblur='isNumber(this);'></div>
						</div>
					</div>
					<div class="form-group" id="item-cash_payment_number">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='108.Kasa'> - <cf_get_lang_main no='435.Odeme'> <cf_get_lang_main no='75.No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="cash_payment_no" id="cash_payment_no" value="#get_all_control.cash_payment_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="cash_payment_number" id="cash_payment_number" value="#get_all_control.cash_payment_number#" onkeyup="isNumber(this);" onblur='isNumber(this);'></div>
						</div>
					</div>
					<div class="form-group" id="item-expense_cost_no">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='652.Masraf Fişi'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="expense_cost_no" id="expense_cost_no" value="#get_all_control.expense_cost_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="expense_cost_number" id="expense_cost_number" value="#get_all_control.expense_cost_number#" onkeyup="isNumber(this);" onblur='isNumber(this);'></div>
						</div>
					</div>
					<div class="form-group" id="item-income_cost_no">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='653.Gelir Fişi'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="income_cost_no" id="income_cost_no" value="#get_all_control.income_cost_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="income_cost_number" id="income_cost_number" value="#get_all_control.income_cost_number#" onkeyup="isNumber(this);" onblur='isNumber(this);'></div>
						</div>
					</div>
					<div class="form-group" id="item-budget_plan_no">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='147.Bütçe'> - <cf_get_lang_main no='788.Gelir/Gider Planı'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="budget_plan_no" id="budget_plan_no" value="#get_all_control.budget_plan_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="budget_plan_number" id="budget_plan_number" value="#get_all_control.budget_plan_number#" onkeyup="isNumber(this);" onblur='isNumber(this);'></div>
						</div>
					</div>
					<div class="form-group" id="item-expenditure_request_no">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='1575.Harcama Talebi'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="expenditure_request_no" id="expenditure_request_no" value="#get_all_control.expenditure_request_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="expenditure_request_number" id="expenditure_request_number" value="#get_all_control.expenditure_request_number#" onkeyup="isNumber(this);" onblur='isNumber(this);'></div>
						</div>
					</div>
					<div class="form-group" id="item-securefund_no">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='1277.Teminat'><cf_get_lang_main no='75.No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="securefund_no" id="securefund_no" value="#get_all_control.securefund_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="securefund_number" id="securefund_number" value="#get_all_control.securefund_number#" onkeyup="isNumber(this);" onblur='isNumber(this);'></div>
						</div>
					</div>
					<div class="form-group" id="item-securities_sale_no">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main dictionary_id='57841.Menkul kıymetler satış'> <cf_get_lang_main no='75.No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="securities_sale_no" id="securities_sale_no" value="#get_all_control.securities_sale_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="securities_sale_number" id="securities_sale_number" value="#get_all_control.securities_sale_number#" onkeyup="isNumber(this);" onblur='isNumber(this);'></div>
						</div>
					</div>
					<div class="form-group" id="item-mkdad_no">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='59920.Menkul Kıymet Değer Artışı Ve Düşüşü'> <cf_get_lang_main no='75.No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="mkdad_no" id="dad_no" value="#get_all_control.mkdad_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="mkdad_number" id="dad_number" value="#get_all_control.mkdad_number#" onkeyup="isNumber(this);" onblur='isNumber(this);'></div>
						</div>
					</div>
					<div class="form-group" id="item-cashregister_no">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='39344.Yazar Kasa'> <cf_get_lang_main no='75.No'></label>
							<div class="col col-8 col-md-6 col-xs-12">
								<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="cashregister_no" id="cashregister_no" value="#get_all_control.cashregister_no#"></div>
								<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="cashregister_number" id="cashregister_number" value="#get_all_control.cashregister_number#" onkeyup="isNumber(this);" onblur='isNumber(this);'></div>
							</div>
						</div>
				</div>
			<div class="row">
				<cf_box_footer>	
					<cf_workcube_buttons is_upd='0'>
					</cf_box_footer>	
				</div>	
			</cf_box_elements>				
			</form>
		</cfoutput>
	</table>
</cf_box>
</cfif>
	<cf_box id="general_paper_no" title="#getLang('settings',417)#"> <!--- Genel Sayfa Numaraları --->
	<table id="general_paper_no" width="100%" cellpadding="2" cellspacing="2">
		<cfoutput>
			<form name="add_other_no" method="post" action="#request.self#?fuseaction=settings.add_general_paper&type=1">
				<cf_box_elements>
            <cfif fusebox.use_period eq 1>
				<cfif get_all_control.recordcount or get_general_papers_main.recordcount>
					<input type="hidden" name="is_upd" id="is_upd" value="1">
					<input type="hidden" name="general_papers_id" id="general_papers_id" value="#get_all_control.general_papers_id#">
				</cfif>
				<div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-system_paper_number">
					<label class="col col-4 col-md-6 col-xs-12">  <cf_get_lang dictionary_id='58147.Sistem'><cf_get_lang dictionary_id='57880.Belge No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="system_paper_no" id="system_paper_no" value="#get_all_control.system_paper_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="system_paper_number" id="system_paper_number" value="#get_all_control.system_paper_number#"></div>
						</div>
					</div>
					<div class="form-group" id="item-campaign_number">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang no='423.Kampanya No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="campaign_no" id="campaign_no" value="#get_all_control.campaign_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="campaign_number" id="campaign_number" value="#get_all_control.campaign_number#"></div>
						</div>
					</div>
					<div class="form-group" id="item-target_market_number">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang no='427.Hedef Kitle No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="target_market_no" id="target_market_no" value="#get_all_control.target_market_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="target_market_number" id="target_market_number" value="#get_all_control.target_market_number#"></div>
						</div>
					</div>
					<div class="form-group" id="item-cat_prom_number">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang no='429.Aksiyon No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="cat_prom_no" id="cat_prom_no" value="#get_all_control.cat_prom_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="cat_prom_number" id="cat_prom_number" value="#get_all_control.cat_prom_number#"></div>
						</div>
					</div>
					<div class="form-group" id="item-support_number">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang no='431.Destek No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="support_no" id="support_no" value="#get_all_control.support_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="support_number" id="support_number" value="#get_all_control.support_number#"></div>
						</div>
					</div>
					<div class="form-group" id="item-correspondence_number">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang no ='2918.Yazışma No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="correspondence_no" id="correspondence_no" value="#get_all_control.correspondence_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="correspondence_number" id="correspondence_number" value="#get_all_control.correspondence_number#"></div>
						</div>
					</div>
					<div class="form-group" id="item-internal_number">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang no='1600.İç Talep No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="internal_no" id="internal_no" value="#get_all_control.internal_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="internal_number" id="internal_number" value="#get_all_control.internal_number#"></div>
						</div>
					</div>
					<div class="form-group" id="item-credit_number">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang no='1297.Kredi No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="credit_no" id="credit_no" value="#get_all_control.credit_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="credit_number" id="credit_number" value="#get_all_control.credit_number#"></div>
						</div>
					</div>
					<div class="form-group" id="item-credit_payment_number">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='57838.Kredi Ödemesi'> <cf_get_lang dictionary_id='57487.No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="credit_payment_no" id="credit_payment_no" value="#get_all_control.credit_payment_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="credit_payment_number" id="credit_payment_number" value="#get_all_control.credit_payment_number#"></div>
						</div>
					</div>
					<div class="form-group" id="item-service_app_number">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang no='433.Servis Başvuru No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="service_app_no" id="service_app_no" value="#get_all_control.service_app_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="service_app_number" id="service_app_number" value="#get_all_control.service_app_number#"></div>
						</div>
					</div>
					<div class="form-group" id="item-ship_fis_number">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang no='985.Sevkiyat No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="ship_fis_no" id="ship_fis_no" value="#get_all_control.ship_fis_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="ship_fis_number" id="ship_fis_number" value="#get_all_control.ship_fis_number#"></div>
						</div>
					</div>
					<div class="form-group" id="item-prod_order_number">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang no='430.Üretim Emir No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="prod_order_no" id="prod_order_no" value="#get_all_control.prod_order_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="prod_order_number" id="prod_order_number" value="#get_all_control.prod_order_number#"></div>
						</div>
					</div>
					<div class="form-group" id="item-production_lot_number">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang no ='1906.Üretim Lot No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="production_lot_no" id="production_lot_no" value="#get_all_control.production_lot_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="production_lot_number" id="production_lot_number" value="#get_all_control.production_lot_number#"></div>
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-catalog_number">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang no='425.Katalog No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="catalog_no" id="catalog_no" value="#get_all_control.catalog_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="catalog_number" id="catalog_number" value="#get_all_control.catalog_number#"></div>
						</div>
					</div>
					<div class="form-group" id="item-subscription_number">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='1705.Abone No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="subscription_no" id="subscription_no" value="#get_all_control.subscription_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="subscription_number" id="subscription_number" value="#get_all_control.subscription_number#"></div>
						</div>
					</div>
					<div class="form-group" id="item-promotion_number">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang no='424.Promosyon No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="promotion_no" id="promotion_no" value="#get_all_control.promotion_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="promotion_number" id="promotion_number" value="#get_all_control.promotion_number#"></div>
						</div>
					</div>
						<div class="form-group" id="item-opp_number">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang no='432.Fırsat No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="opp_no" id="opp_no" value="#get_all_control.opportunity_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="opp_number" id="opp_number" value="#get_all_control.opportunity_number#"></div>
						</div>
					</div>
					<div class="form-group" id="item-pro_material_number">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang no ='1907.Proje Malz Plan No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="pro_material_no" id="pro_material_no" value="#get_all_control.pro_material_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="pro_material_number" id="pro_material_number" value="#get_all_control.pro_material_number#"></div>
						</div>
					</div>
					<div class="form-group" id="item-purchasedemand_number">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='1743.Satınalma talebi no'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="purchasedemand_no" id="purchasedemand_no" value="#get_all_control.purchasedemand_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="purchasedemand_number" id="purchasedemand_number" value="#get_all_control.purchasedemand_number#"></div>
						</div>
					</div>
						<div class="form-group" id="item-credit_revenue_number">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='57839.Kredi Tahsilatı'> <cf_get_lang dictionary_id='57487.No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="credit_revenue_no" id="credit_revenue_no" value="#get_all_control.credit_revenue_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="credit_revenue_number" id="credit_revenue_number" value="#get_all_control.credit_revenue_number#"></div>
						</div>
					</div>
					<div class="form-group" id="item-stock_fis_number">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang no='434.Stok Fiş No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="stock_fis_no" id="stock_fis_no" value="#get_all_control.stock_fis_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="stock_fis_number" id="stock_fis_number" value="#get_all_control.stock_fis_number#"></div>
						</div>
					</div>
					<div class="form-group" id="item-production_result">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang no='1296.Üretim Sonuç No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="production_result_no" id="production_result_no" value="#get_all_control.production_result_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="production_result" id="production_result" value="#get_all_control.production_result_number#"></div>
						</div>
					</div>
						<div class="form-group" id="item-quality_control_number">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='45359.Kalite Kontrol'> <cf_get_lang dictionary_id='57487.No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="quality_control_no" id="quality_control_no" value="#get_all_control.quality_control_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="quality_control_number" id="quality_control_number" value="#get_all_control.quality_control_number#"></div>
						</div>
					</div>
					<div class="form-group" id="item-production_quality_control_no">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='61295.Üretim Kalite Kontrol'> <cf_get_lang dictionary_id='57487.No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="production_quality_control_no" id="production_quality_control_no" value="#get_all_control.production_quality_control_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="production_quality_control_number" id="production_quality_control_number" value="#get_all_control.production_quality_control_number#"></div>
						</div>
					</div>
					<div class="form-group" id="item-travel_demand_no">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main dictionary_id='59930.Seyahat Talebi'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="travel_demand_no" id="travel_demand_no" value="#get_all_control.travel_demand_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="travel_demand_number" id="travel_demand_number" value="#get_all_control.travel_demand_number#"></div>
						</div>
					</div>
					<div class="form-group" id="item-lab_report_no">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='62139.Lab Rapor No'></label>
							<div class="col col-8 col-md-6 col-xs-12">
								<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="lab_report_no" id="lab_report_no" value="#get_all_control.SAMPLE_ANALYSIS_NO#"></div>
								<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="lab_report_number" id="lab_report_number" value="#get_all_control.SAMPLE_ANALYSIS_NUMBER#"></div>
							</div>
						</div>
				</div>
           	</cfif>
				<!--- Bu Blok Mainden Cekiliyor --->
				
				<div class="row"><br/>
				<div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-emp_notice_no">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang no ='3132.İlan No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="emp_notice_no" id="emp_notice_no" value="#get_general_papers_main.emp_notice_no#" ></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="emp_notice_number" id="emp_notice_number" value="#get_general_papers_main.emp_notice_number#"></div>
						</div>
					</div>
					<div class="form-group" id="item-employee_no">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='1075.Çalışan No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="employee_no" id="employee_no" value="#get_general_papers_main.employee_no#" ></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="employee_number" id="employee_number" value="#get_general_papers_main.employee_number#"></div>
						</div>
					</div>
					<div class="form-group" id="item-fixtures_no">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='1466.Demirbaş No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="fixtures_no" id="fixtures_no" value="#get_general_papers_main.fixtures_no#"></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="fixtures_number" id="fixtures_number" value="#get_general_papers_main.fixtures_number#"></div>
						</div>
					</div>
					<div class="form-group" id="item-g_service_app_number">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang no='984.Şikayet Başvuru No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="g_service_app_no" id="g_service_app_no" value="#get_general_papers_main.g_service_app_no#" ></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="g_service_app_number" id="g_service_app_number" value="#get_general_papers_main.g_service_app_number#"></div>
						</div>
					</div>
					<div class="form-group" id="item-allowence_expense_number">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='47809.harcırah talebi'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="allowence_expense_no" id="allowence_expense_no" value="#get_general_papers_main.allowence_expense_no#" ></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="allowence_expense_number" id="allowence_expense_number" value="#get_general_papers_main.allowence_expense_number#"></div>
						</div>
					</div>
					<div class="form-group" id="item-additional_allowance_number">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main dictionary_id='32189.Ek Ödenek'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="additional_allowance_no" id="additional_allowance_no" value="#get_general_papers_main.additional_allowance_no#" ></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="additional_allowance_number" id="additional_allowance_number" value="#get_general_papers_main.additional_allowance_number#"></div>
						</div>
					</div>
					<div class="form-group" id="item-ship_internal_number">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='45959.Sevk Talebi'><cf_get_lang dictionary_id='57880.Belge No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="ship_internal_no" id="ship_internal_no" value="#get_all_control.ship_internal_no#" ></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="ship_internal_number" id="ship_internal_number" value="#get_all_control.ship_internal_number#"></div>
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-emp_app_number">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang no='428.İş Başvuru No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="emp_app_no" id="emp_app_no" value="#get_general_papers_main.emp_app_no#" ></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="emp_app_number" id="emp_app_number" value="#get_general_papers_main.emp_app_number#"></div>
						</div>
					</div>
					<div class="form-group" id="item-employee_healty_number">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='53108.İşçi Sağlığı Belgesi'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="employee_healty_no" id="employee_healty_no" value="#get_general_papers_main.employee_healty_no#" ></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="employee_healty_number" id="employee_healty_number" value="#get_general_papers_main.employee_healty_number#"></div>
						</div>
					</div>
					<div class="form-group" id="item-asset_number">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no ='150.Dijital Varlık'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="asset_no" id="asset_no" value="#get_general_papers_main.asset_no#" ></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="asset_number" id="asset_number" value="#get_general_papers_main.asset_number#"></div>
						</div>
					</div>
					<div class="form-group" id="item-asset_failure_number">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='48658.Arıza Bildirimi'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="asset_failure_no" id="asset_failure_no" value="#get_general_papers_main.asset_failure_no#" ></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="asset_failure_number" id="asset_failure_number" value="#get_general_papers_main.asset_failure_number#"></div>
						</div>
					</div>
					<div class="form-group" id="item-health_allowence_expense_number">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='37614.sağlık harcama talebi'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="health_allowence_expense_no" id="health_allowence_expense_no" value="#get_general_papers_main.health_allowence_expense_no#" ></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="health_allowence_expense_number" id="health_allowence_expense_number" value="#get_general_papers_main.health_allowence_expense_number#"></div>
						</div>
					</div>
					<div class="form-group" id="item-work_number">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id ='38472.İş No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="work_no" id="work_no" value="#get_general_papers_main.work_no#" ></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="work_number" id="work_number" value="#get_general_papers_main.work_number#"></div>
						</div>
					</div>
					<div class="form-group" id="item-package_number">
					<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id ='400.Paket No'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<div class="col col-3 col-md-6 col-xs-12"><input type="text" name="package_no" id="package_no" value="#get_general_papers_main.package_no#" ></div>
							<div class="col col-9 col-md-6 col-xs-12"><input type="text" name="package_number" id="package_number" value="#get_general_papers_main.package_number#"></div>
						</div>
					</div>
				</div>
			</div>
				<!--- //Bu Blok Mainden Cekiliyor --->
				<div class="row">
					<cf_box_footer>	
					<cf_workcube_buttons is_upd='0'>
					</cf_box_footer>
				</div>	
			</cf_box_elements>
			</form>
		</cfoutput>
	</table>
</cf_box>
<cf_box title="#getlang('','Ürün Numaraları','64048')#">
    	<form name="add_product_no" method="post" action="<cfoutput>#request.self#?fuseaction=settings.add_general_paper&type=3</cfoutput>">
				<cf_box_elements>
						<div class="col col-8 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
							<div class="form-group" id="item-product">
							<label class="col col-2 col-md-6 col-xs-12"></label>
								<div class="col col-6 col-md-6 col-xs-12">
									<div class="col col-2 col-md-6 col-xs-12"><cf_get_lang dictionary_id='62608.Ürün No'></div>
									<div class="col col-2 col-md-6 col-xs-12"><cf_get_lang dictionary_id='64049.Stok No'></div>
									<div class="col col-6 col-md-6 col-xs-12"><cf_get_lang dictionary_id='47699.Barkod No'></div>
								</div>
								</div>
							</div>
						<div class="col col-8 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-product_">
						<label class="col col-2 col-md-6 col-xs-12"><cf_get_lang dictionary_id='58800.Ürün Kodu'></label>
							<div class="col col-6 col-md-6 col-xs-12">
								<div class="col col-2 col-md-6 col-xs-12"><input type="text" name="product_no" id="product_no"></div>
								<div class="col col-2 col-md-6 col-xs-12"><input type="text" name="stock_no" id="stock_no"></div>
								<div class="col col-6 col-md-6 col-xs-12"><input type="text" name="barcode_no" id="barcode_no"></div>
							</div>
							</div>
						</div>
				</cf_box_elements>
			<cf_box_footer>	
		    	<cf_workcube_buttons is_upd='0'>
			<cf_box_footer>	
		</form>
</cf_box>