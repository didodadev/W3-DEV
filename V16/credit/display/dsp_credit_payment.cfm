<!--- Burada banka işlemleri için url.action_id cari işlemler icin url.id kontrolü yapılmıstır FB--->
<cf_get_lang_set module_name="credit">
<cfif isdefined('url.id') and not len(url.id) or isdefined('url.action_id') and not len(url.action_id) or (not isdefined('url.action_id') and not isdefined('url.id'))>
	<br/><font class="txtbold"><cf_get_lang dictionary_id='58943.Böyle Bir Kayıt Bulunmamaktadır'>!</font>
	<cfexit method="exittemplate">
</cfif>
<cfif not isdefined("attributes.period_id")><cfset attributes.period_id = session.ep.period_id></cfif>
<cfif not isdefined("attributes.our_company_id")><cfset attributes.our_company_id = session.ep.company_id></cfif>
<cfquery name="GET_PERIOD" datasource="#DSN#">
	SELECT
		*
	FROM
		SETUP_PERIOD
	WHERE
		PERIOD_ID = #attributes.period_id# AND
		OUR_COMPANY_ID = #attributes.our_company_id#
</cfquery> 
<cfset temp_dsn = '#dsn#_#get_period.period_year#_#get_period.our_company_id#'>
<cfquery name="GET_CREDIT_CONTRACT_PAYMENT" datasource="#temp_dsn#">
	SELECT
		*
	FROM
		CREDIT_CONTRACT_PAYMENT_INCOME
	WHERE
		<cfif isdefined('url.id')>
			CREDIT_CONTRACT_PAYMENT_ID = #url.id#
		<cfelse>
			BANK_ACTION_ID = #url.action_id#
		</cfif>
</cfquery>
<cfquery name="get_project_from_bank_actions" datasource="#dsn2#">
	SELECT PR.PROJECT_ID, PR.PROJECT_HEAD FROM BANK_ACTIONS LEFT JOIN #dsn_alias#.PRO_PROJECTS PR ON BANK_ACTIONS.PROJECT_ID=PR.PROJECT_ID WHERE BANK_ACTIONS.ACTION_ID = #GET_CREDIT_CONTRACT_PAYMENT.BANK_ACTION_ID#
</cfquery>
<cfif not get_credit_contract_payment.recordcount>
	<br/><font class="txtbold"><cf_get_lang dictionary_id='58943.Böyle Bir Kayıt Bulunmamaktadır'>!</font>
	<cfexit method="exittemplate">
</cfif>
<cfinclude template="../query/get_accounts.cfm">
<cfinclude template="../query/get_expense_center.cfm">

<cfif get_credit_contract_payment.process_type eq 291>
	<cfsavecontent variable="baslik"><cf_get_lang dictionary_id='57838.Kredi Ödemesi'></cfsavecontent>
<cfelseif get_credit_contract_payment.process_type eq 292>
	<cfsavecontent variable="baslik"><cf_get_lang dictionary_id='57839.Kredi Tahsilatı'></cfsavecontent>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title='#baslik#' popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="upd_credit_payment_2" method="post" action="#request.self#?fuseaction=credit.popup_dsp_credit_payment">
			<cf_box_elements>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<div class="form-group" id="item-process_cat">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57124.İşlem Kategorisi'></label>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
							<cfquery name="get_setup_process_cat" datasource="#DSN3#">
								SELECT 
									PROCESS_CAT 
								FROM 
									SETUP_PROCESS_CAT 
								WHERE 
									PROCESS_CAT_ID = #get_credit_contract_payment.process_cat#
							</cfquery>
							<cfoutput>#get_setup_process_cat.process_cat#</cfoutput>
						</div>
					</div>
					<div class="form-group" id="item-document_no">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57880.Belge No'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cfoutput>#get_credit_contract_payment.document_no#</cfoutput></div>
					</div>
					<div class="form-group" id="item-contract_payment">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='59171.Kredi Kurumu'></label>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
							<cfoutput>#get_par_info(get_credit_contract_payment.company_id,1,1,0)#</cfoutput> 
							<cfset str_linke_ait="&field_comp_id=upd_credit_payment_2.company_id&field_partner=upd_credit_payment_2.partner_id&field_comp_name=upd_credit_payment_2.company&field_name=upd_credit_payment_2.partner&select_list=2">
						</div>
					</div>
					<div class="form-group" id="item-yetkili">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57578.Yetkili'></label>
						<cfif len(get_credit_contract_payment.company_id)>
							<cfif len(get_credit_contract_payment.partner_id)>
								<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
									<cfoutput>#get_par_info(get_credit_contract_payment.partner_id ,0,-1,0)#</cfoutput>
								</div>
							</cfif>
						</cfif>	
					</div>
					<div class="form-group" id="item-account_name">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51375.Banka Hesabından'></label>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
							<cfoutput query="get_accounts">
								<cfif account_id eq get_credit_contract_payment.bank_account_id>#account_name#&nbsp;#account_currency_id#</cfif>
							</cfoutput>
						</div>
					</div>
					<div class="form-group" id="item-expense">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></label>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
							<cfoutput query="get_expense_center">
								<cfif expense_id eq get_credit_contract_payment.expense_center_id>#expense#</cfif>
							</cfoutput>
						</div>			  		
					</div>
					<div class="form-group" id="item-project_head">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cfoutput>#get_project_from_bank_actions.project_head#</cfoutput></div>
					</div>		  
					<div class="form-group" id="item-process_date">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
							<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
							<cfoutput>#dateformat(get_credit_contract_payment.process_date,dateformat_style)#</cfoutput>
						</div>
					</div>
					<div class="form-group" id="item-process_type">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12">
							<cfif get_credit_contract_payment.process_type eq 291><cf_get_lang dictionary_id='57847.Ödeme'></cfif>
							<cfif get_credit_contract_payment.process_type eq 292><cf_get_lang dictionary_id='57845.Tahsilat'></cfif>
						</label>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
							<cfif get_credit_contract_payment.process_type eq 291><cf_get_lang dictionary_id='58551.Gider Kalemi'></cfif>
							<cfif get_credit_contract_payment.process_type eq 292><cf_get_lang dictionary_id='58173.Gelir Kalemi'></cfif>
						</div>
					</div>
					<div class="form-group" id="item-capital_expense_item_id">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='59179.Ana Para'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cfoutput>#TlFormat(get_credit_contract_payment.capital_price,session.ep.our_company_info.rate_round_num)#</cfoutput>
							<cfif len(get_credit_contract_payment.capital_expense_item_id)>
								<cfquery name="GET_EXPENSE_CAPITAL" datasource="#dsn2#">
									SELECT 
										EXPENSE_ITEM_NAME 
									FROM 
										EXPENSE_ITEMS 
									WHERE 
										EXPENSE_ITEM_ID = #get_credit_contract_payment.capital_expense_item_id#
								</cfquery>
								<cfoutput>(#get_expense_capital.expense_item_name#)</cfoutput>
							</cfif>			
						</div>
					</div>
					<div class="form-group" id="item-interest_expense_item_id">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='59180.Faiz'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cfoutput>#TlFormat(get_credit_contract_payment.interest_price,session.ep.our_company_info.rate_round_num)#</cfoutput>
							<cfif len(get_credit_contract_payment.interest_expense_item_id)>
								<cfquery name="GET_EXPENSE_INTEREST" datasource="#dsn2#">
									SELECT 
										EXPENSE_ITEM_NAME 
									FROM 
										EXPENSE_ITEMS 
									WHERE 
										EXPENSE_ITEM_ID = (#get_credit_contract_payment.interest_expense_item_id#)
								</cfquery>
								<cfoutput>#get_expense_interest.expense_item_name#</cfoutput>
							</cfif>			
						</div>
					</div>
					<cfquery name="GET_EXPENSE_TAX" datasource="#dsn2#">
						SELECT
							EX.EXPENSE_ITEM_NAME,
							CC.TAX_PRICE
						FROM
							CREDIT_CONTRACT_PAYMENT_INCOME_TAX CC,
							EXPENSE_ITEMS EX
						WHERE
							EX.EXPENSE_ITEM_ID = CC.TAX_EXPENSE_ITEM_ID
							AND CC.CREDIT_CONTRACT_PAYMENT_ID = #get_credit_contract_payment.credit_contract_payment_id#
					</cfquery>
					<cfif get_expense_tax.recordcount>
						<cfoutput query="get_expense_tax">
							<div class="form-group" id="item-rate_round_num">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62390.Vergi/Masraf'></label>
								<div class="col col-6 col-md-6 col-sm-6 col-xs-12">#TlFormat(tax_price,session.ep.our_company_info.rate_round_num)#(#get_expense_tax.expense_item_name#)</div>
							</div>
						</cfoutput>
					</cfif>
					<div class="form-group" id="item-expense_item_name">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51368.Gecikme'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cfoutput>#TlFormat(get_credit_contract_payment.delay_price,session.ep.our_company_info.rate_round_num)#</cfoutput>
							<cfif len(get_credit_contract_payment.delay_expense_item_id)>
								<cfquery name="GET_EXPENSE_DELAY" datasource="#dsn2#">
									SELECT 
										EXPENSE_ITEM_NAME 
									FROM 
										EXPENSE_ITEMS 
									WHERE 
										EXPENSE_ITEM_ID = (#get_credit_contract_payment.delay_expense_item_id#)
								</cfquery>
								<cfoutput>#get_expense_delay.expense_item_name#</cfoutput>
							</cfif>			
						</div>
					</div>
					<div class="form-group" id="item-total_price">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29534.Toplam Tutar'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cfoutput>#TlFormat(get_credit_contract_payment.total_price,session.ep.our_company_info.rate_round_num)#&nbsp;#get_credit_contract_payment.other_money#</cfoutput><!--- readonly ---></div>
					</div>
					<div class="form-group" id="item-other_total_price">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58056.Dövizli Tutar'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cfoutput>#TlFormat(get_credit_contract_payment.other_total_price,session.ep.our_company_info.rate_round_num)#&nbsp;#get_credit_contract_payment.ACTION_CURRENCY_ID#</cfoutput></div>
					</div>	
					<div class="form-group" id="item-detail">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cfoutput>#get_credit_contract_payment.detail#</cfoutput></div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_record_info query_name="get_credit_contract_payment">
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
