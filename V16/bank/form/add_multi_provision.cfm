<cf_xml_page_edit fuseact="bank.popup_add_multi_provision">
<cfparam name="attributes.start_date" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.finish_date" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.contract_start" default="">
<cfparam name="attributes.contract_finish" default="">
<cfparam name="attributes.bank_name" default="">
<cfparam name="attributes.setup_bank_type" default="">
<cfparam name="attributes.open_form" default="0">
<cfparam name="attributes.pay_method" default="">
<cfparam name="attributes.month_info" default="">
<cfparam name="attributes.year_info" default="">
<cfparam name="attributes.prov_period" default="">
<cfparam name="attributes.comp_code_info" default="">
<cfif not isDefined("attributes.from_subs_detail")>
	<cfparam name="attributes.company_id" default="">
	<cfparam name="attributes.consumer_id" default="">
</cfif>
<cfquery name="GET_PAY_METHOD" datasource="#dsn3#">
	SELECT PAYMENT_TYPE_ID,CARD_NO FROM CREDITCARD_PAYMENT_TYPE ORDER BY CARD_NO
</cfquery>
<cfquery name="get_bank_type" datasource="#dsn#">
	SELECT BANK_NAME,BANK_ID FROM SETUP_BANK_TYPES ORDER BY BANK_NAME
</cfquery>
<cf_get_lang_set module_name="bank">

<cfsavecontent variable="title_">
	<cfif attributes.fuseaction eq "sales.popup_add_multi_provision"><cf_get_lang dictionary_id ='48957.Sistem Sanal POS İşlemleri'><cfelse><cf_get_lang dictionary_id ='48958.Sistem Toplu Provizyon Belgesi Oluşturma'></cfif>
</cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#title_#">
		<cfform name="add_multi_provision" method="post" action="">
			<input type="hidden" name="open_form" id="open_form" value="<cfoutput>#attributes.open_form#</cfoutput>">
			<cf_box_elements id="add_due">
				<div class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-is_detailed">
						<label class="col col-4 col-xs-12"><!--- işbankası dışındaki tüm bankalarda detaylı olmak zorundadır, işbankasnda detaysız seçilirse oradaki desen anlşamasına göre tüm ödeme planı satrlarının yarısı dosyada gönderilir, sonrası ayrıca işleme alınır, pronete özeldir ---></label>
						<div class="col col-8 col-xs-12">
							<input type="checkbox" name="is_detailed" id="is_detailed" <cfif isDefined("attributes.is_detailed") or not isDefined("open_form")>checked</cfif>><cf_get_lang dictionary_id='58785.Detaylı'>
						</div>
					</div>
					<div class="form-group" id="item-pay_method">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'> *</label>
						<div class="col col-8 col-xs-12">
							<select name="pay_method" id="pay_method">
								<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
								<cfoutput query="GET_PAY_METHOD">
									<option value="#PAYMENT_TYPE_ID#" <cfif attributes.pay_method eq GET_PAY_METHOD.PAYMENT_TYPE_ID>selected</cfif>>#CARD_NO#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-start_date">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57742.Başlangıç Tarihi'></label>
						<div class="col col-4 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57738.Başlangıç Tarihi Girmelisiniz'> !</cfsavecontent>
								<cfinput type="text" name="start_date" required="Yes" message="#message#" value="#attributes.start_date#" validate="#validate_style#" maxlength="10">
								<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
							</div>
						</div>
						<div class="col col-4 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57739.Bitiş Tarihi Girmelisiniz'> !</cfsavecontent>
								<cfinput type="text" name="finish_date" required="Yes" message="#message#" value="#attributes.finish_date#" validate="#validate_style#" maxlength="10">
								<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-contract_start">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32499.Ödeme Planı Başlangıç Tarihi'></label>
						<div class="col col-4 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message2"><cf_get_lang dictionary_id='32499.Ödeme Planı Başlangıç Tarihi'> !</cfsavecontent>
								<cfinput type="text" name="contract_start" message="#message2#" value="#attributes.contract_start#" validate="#validate_style#" maxlength="10">
								<span class="input-group-addon"><cf_wrk_date_image date_field="contract_start"></span>
							</div>
						</div>
						<div class="col col-4 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message3"><cf_get_lang dictionary_id='32499.Ödeme Planı Başlangıç Tarihi'> !</cfsavecontent>
								<cfinput type="text" name="contract_finish" message="#message3#" value="#attributes.contract_finish#" validate="#validate_style#" maxlength="10">
								<span class="input-group-addon"><cf_wrk_date_image date_field="contract_finish"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-prov_period">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='48956.İlişkili Fatura Dönemi'></label>
						<div class="col col-8 col-xs-12">
							<cfquery name="GET_PERIODS" datasource="#dsn#">
								SELECT PERIOD_YEAR,OUR_COMPANY_ID,PERIOD_ID,PERIOD FROM SETUP_PERIOD ORDER BY OUR_COMPANY_ID,PERIOD_YEAR
							</cfquery>
							<select name="prov_period" id="prov_period">
								<cfoutput query="GET_PERIODS">
									<option value="#PERIOD_YEAR#;#OUR_COMPANY_ID#;#PERIOD_ID#" <cfif attributes.prov_period eq "#PERIOD_YEAR#;#OUR_COMPANY_ID#;#PERIOD_ID#">selected<cfelseif PERIOD_ID eq session.ep.period_id>selected</cfif>>#PERIOD# - (#PERIOD_YEAR#)</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-subscription_no">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29502.Sistem No'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="subscription_id" id="subscription_id" value="<cfif isdefined("attributes.subscription_id")><cfoutput>#attributes.subscription_id#</cfoutput></cfif>">
								<input type="text" name="subscription_no" id="subscription_no" value="<cfif isdefined("attributes.subscription_no")><cfoutput>#attributes.subscription_no#</cfoutput></cfif>" <cfif isDefined("attributes.from_subs_detail")>readonly="yes"</cfif>>
								<span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='29502.Sistem No'>" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_subscription&field_id=add_multi_provision.subscription_id&field_no=add_multi_provision.subscription_no'</cfoutput>,'list','popup_list_subscription');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-bank_name">
						<label class="col col-4 col-xs-12"><cfif not attributes.fuseaction eq "sales.popup_add_multi_provision"><cf_get_lang dictionary_id ='48952.Pos Tipi'> *</cfif></label>
						<div class="col col-8 col-xs-12">
							<cfif not attributes.fuseaction eq "sales.popup_add_multi_provision">
								<select name="bank_name" id="bank_name" onChange="open_code_input(this.value);">
									<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
									<option value="7" <cfif attributes.bank_name eq 7>selected</cfif>><cf_get_lang dictionary_id="48737.Akbank"></option>
									<option value="10" <cfif attributes.bank_name eq 10>selected</cfif>><cf_get_lang dictionary_id="48751.Banksoft"></option>
									<option value="8" <cfif attributes.bank_name eq 8>selected</cfif>><cf_get_lang dictionary_id="48739.Denizbank"></option>
									<option value="3" <cfif attributes.bank_name eq 3>selected</cfif>><cf_get_lang dictionary_id="48725.Garanti TPOS"></option>
									<option value="1" <cfif attributes.bank_name eq 1>selected</cfif>><cf_get_lang dictionary_id="56330.Garanti Bankası"></option>
									<option value="2" <cfif attributes.bank_name eq 2>selected</cfif>><cf_get_lang dictionary_id="48720.HSBC"></option>
									<option value="5" <cfif attributes.bank_name eq 5>selected</cfif>><cf_get_lang dictionary_id="48730.İşBankası"></option>
									<option value="4" <cfif attributes.bank_name eq 4>selected</cfif>><cf_get_lang dictionary_id="48729.TEB"></option>
									<option value="6" <cfif attributes.bank_name eq 6>selected</cfif>><cf_get_lang dictionary_id="48784.YKB"></option>
									<option value="9" <cfif attributes.bank_name eq 9>selected</cfif>><cf_get_lang dictionary_id="48747.ING"></option>
								</select>
							</cfif>
						</div>
					</div>
					<div class="form-group" id="item-company">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57457.Müşteri'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfif len(attributes.company_id)>
									<cfset company_ = get_par_info(attributes.company_id,1,0,0)>
								<cfelse>
									<cfset company_ = get_cons_info(attributes.consumer_id,0,0)>
								</cfif>					
								<input type="hidden" name="consumer_id" id="consumer_id" <cfif isDefined("attributes.consumer_id")> value="<cfoutput>#attributes.consumer_id#</cfoutput>"</cfif>>			
								<input type="hidden" name="company_id" id="company_id" <cfif isDefined("attributes.company_id")> value="<cfoutput>#attributes.company_id#</cfoutput>"</cfif>>
								<input name="company" type="text" id="company" onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',0,0,0','CONSUMER_ID,COMPANY_ID','consumer_id,company_id','','3','250');" value="<cfoutput>#company_#</cfoutput>" <cfif isDefined("attributes.from_subs_detail")>readonly="yes"</cfif> autocomplete="off">
								<span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='57734.Seciniz'>" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_comp_name=add_multi_provision.company&field_comp_id=add_multi_provision.company_id&field_consumer=add_multi_provision.consumer_id&field_member_name=add_multi_provision.company</cfoutput>&keyword='+encodeURIComponent(document.add_multi_provision.company.value),'list')"></span>
							</div>
						</div>
					</div>
					<cfif isDefined("xml_company_code") and not listfind(xml_company_code,attributes.bank_name,',')>
						<div class="form-group" id="comp_code" style="display:none">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48997.İşyeri Kodu'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="comp_code_info" id="comp_code_info" value="<cfoutput>#attributes.comp_code_info#</cfoutput>">
							</div>
						</div>
					</cfif>
					<div class="form-group" id="item-is_cvv">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='48949.CVV Bilgisi'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<span class="input-group-addon no-bg">
								<label><input type="checkbox" name="is_cvv" id="is_cvv" <cfif isDefined("attributes.is_cvv")>checked</cfif>></label>
								</span>
								<select name="month_info" id="month_info">
									<option value=""><cf_get_lang dictionary_id='58724.Ay'></option>
									<cfloop from="1" to="12" index="k">
										<cfoutput>
											<option value="#k#"<cfif attributes.month_info eq k>selected</cfif>>#k#</option>
										</cfoutput> 
									</cfloop>
								</select>
								<span class="input-group-addon no-bg"></span>
								<select name="year_info" id="year_info">
									<option value=""><cf_get_lang dictionary_id='58455.Yıl'></option>
									<cfloop from="2002" to="2050" index="i">
										<cfoutput>
											<option value="#i#" <cfif attributes.year_info eq i>selected</cfif>>#i#</option>
										</cfoutput>
									</cfloop>
								</select>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-setup_bank_type">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='48948.Kart Bankası'></label>
						<div class="col col-8 col-xs-12">
							<select name="setup_bank_type" id="setup_bank_type" multiple>
								<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
								<cfoutput query="get_bank_type">
									<option value="#BANK_ID#" <cfif listfind(attributes.setup_bank_type,BANK_ID)>selected</cfif>>#BANK_NAME#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_wrk_search_button button_type="2" button_name="#getLang('','Listele',58715)#" search_function="kontrol()">
			<cf_box_footer>
		</cfform>
		<cfif attributes.open_form eq 1>
			<cf_date tarih='attributes.start_date'>
			<cf_date tarih='attributes.finish_date'>
			<cfif len(attributes.contract_start)><cf_date tarih='attributes.contract_start'></cfif>
			<cfif len(attributes.contract_finish)><cf_date tarih='attributes.contract_finish'></cfif>
			<cfif isDefined("attributes.is_detailed")>
				<cfif isDefined("attributes.prov_period") and len(attributes.prov_period)>
					<cfset new_dsn2 = '#dsn#_#ListGetAt(attributes.prov_period,1,";")#_#ListGetAt(attributes.prov_period,2,";")#'>
					<cfset period_id = ListGetAt(attributes.prov_period,3,";")>
				<cfelse>
					<cfset new_dsn2 = '#dsn2#'>
					<cfset period_id = session.ep.period_id>
				</cfif>
				<cfquery name="GET_PAYMENT_PLAN" datasource="#dsn3#"><!--- query de yapılan değişiklikler, action sayfasındaki desen querylerinde de yapılmalıdır.. mutlaka.. aysenur --->
					SELECT
						SPR.SUBSCRIPTION_PAYMENT_ROW_ID,
						SPR.SUBSCRIPTION_ID,
						SPR.INVOICE_ID,
						SPR.PERIOD_ID,
						SPR.PAYMENT_DATE,
						SPR.DETAIL,
						SPR.UNIT,
						SPR.AMOUNT,
						SPR.MONEY_TYPE,
						SPR.ROW_TOTAL,
						SPR.DISCOUNT,
						SPR.ROW_NET_TOTAL,
						SPR.PAYMETHOD_ID,
						SPR.CARD_PAYMETHOD_ID,
						SPR.QUANTITY,
						SC.SUBSCRIPTION_NO,
						SC.SUBSCRIPTION_ID,
						SC.MEMBER_CC_ID,
						COMP_CC.COMPANY_CC_NUMBER CC_NUMBER,
						COMP_CC.COMP_CVS CVS,
						COMP_CC.COMPANY_EX_MONTH EX_MONTH,
						COMP_CC.COMPANY_EX_YEAR EX_YEAR,
						COMP_CC.COMPANY_ID MEMBER_ID,
						COMPANY.NICKNAME MEMBER_NAME,
						0 MEMBER_TYPE,
						I.NETTOTAL,
						I.INVOICE_ID INVOICE_ID,
						I.INVOICE_NUMBER,
						CARD_PAYM.CARD_NO,
						ISNULL(I.CREDITCARD_PAYMENT_ID,0) CREDITCARD_PAYMENT_ID
					FROM
						SUBSCRIPTION_PAYMENT_PLAN_ROW SPR,
						SUBSCRIPTION_CONTRACT SC,
						#dsn_alias#.COMPANY_CC COMP_CC,
						#dsn_alias#.COMPANY COMPANY,
						#new_dsn2#.INVOICE I,
						CREDITCARD_PAYMENT_TYPE CARD_PAYM
					WHERE
						SPR.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID AND
						SC.INVOICE_COMPANY_ID = COMP_CC.COMPANY_ID AND
						SC.INVOICE_COMPANY_ID = COMPANY.COMPANY_ID AND
						COMPANY.COMPANY_ID = COMP_CC.COMPANY_ID AND
						SC.MEMBER_CC_ID = COMP_CC.COMPANY_CC_ID AND
						I.INVOICE_ID = SPR.INVOICE_ID AND
						CARD_PAYM.PAYMENT_TYPE_ID = SPR.CARD_PAYMETHOD_ID AND
						SPR.PAYMENT_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"> AND
						<cfif len(attributes.pay_method)>
							SPR.CARD_PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pay_method#"> AND<!---ödeme yöntemi--->
						</cfif>
						SPR.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#period_id#"> AND
						SPR.IS_BILLED = 1 AND<!--- faturalandı --->
						SPR.IS_PAID = 0 AND<!--- ödenmedi --->
						SPR.IS_COLLECTED_PROVISION = 0 AND<!--- toplu provizyon oluşturulmadı --->
						SPR.IS_ACTIVE = 1 AND<!--- aktif satırlar --->
						I.NETTOTAL > 0 AND
						I.IS_IPTAL = 0 AND
						I.INVOICE_CAT <> 57 AND <!--- verilen proforma faturası (id:57) odeme plani satirlarina dahil edilmez --->
						COMP_CC.IS_DEFAULT = 1
						<cfif len(attributes.company_id)>
							AND SC.INVOICE_COMPANY_ID =	<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
						</cfif>
						<cfif len(attributes.consumer_id)>
							AND SC.INVOICE_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
						</cfif>
						<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>
							AND SC.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
						</cfif>
						<cfif isDefined("attributes.setup_bank_type") and len(attributes.setup_bank_type)>
							AND COMP_CC.COMPANY_BANK_TYPE IN (#attributes.setup_bank_type#)
						</cfif>
						<cfif isDefined("attributes.is_cvv")>
							AND COMP_CC.COMP_CVS IS NOT NULL
						</cfif>
						<cfif len(attributes.year_info) and len(attributes.month_info)>
							AND (
									(COMP_CC.COMPANY_EX_MONTH >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.month_info#"> AND COMP_CC.COMPANY_EX_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.year_info#">)
									OR 
									(COMP_CC.COMPANY_EX_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.year_info#"> AND COMP_CC.COMPANY_EX_MONTH >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.month_info#">)
									OR
									(COMP_CC.COMPANY_EX_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.year_info#">)			    
								)
						</cfif>
						<cfif len(attributes.contract_start) and len(attributes.contract_finish)>
							AND SPR.SUBSCRIPTION_ID IN (SELECT SUBSCRIPTION_ID FROM SUBSCRIPTION_PAYMENT_PLAN_ROW <cfif isDefined("xml_product_list") and len(xml_product_list)>WHERE PRODUCT_ID IN (#xml_product_list#)</cfif> GROUP BY SUBSCRIPTION_ID HAVING MIN(PAYMENT_DATE) BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.contract_start#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.contract_finish#">)
						<cfelseif len(attributes.contract_start)>
							AND SPR.SUBSCRIPTION_ID IN (SELECT SUBSCRIPTION_ID FROM SUBSCRIPTION_PAYMENT_PLAN_ROW <cfif isDefined("xml_product_list") and len(xml_product_list)>WHERE PRODUCT_ID IN (#xml_product_list#)</cfif> GROUP BY SUBSCRIPTION_ID HAVING MIN(PAYMENT_DATE) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.contract_start#">)
						<cfelseif len(attributes.contract_finish)>
							AND SPR.SUBSCRIPTION_ID IN (SELECT SUBSCRIPTION_ID FROM SUBSCRIPTION_PAYMENT_PLAN_ROW <cfif isDefined("xml_product_list") and len(xml_product_list)>WHERE PRODUCT_ID IN (#xml_product_list#)</cfif> GROUP BY SUBSCRIPTION_ID HAVING MIN(PAYMENT_DATE) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.contract_finish#">)
						</cfif>
				UNION ALL
					SELECT
						SPR.SUBSCRIPTION_PAYMENT_ROW_ID,
						SPR.SUBSCRIPTION_ID,
						SPR.INVOICE_ID,
						SPR.PERIOD_ID,
						SPR.PAYMENT_DATE,
						SPR.DETAIL,
						SPR.UNIT,
						SPR.AMOUNT,
						SPR.MONEY_TYPE,
						SPR.ROW_TOTAL,
						SPR.DISCOUNT,
						SPR.ROW_NET_TOTAL,
						SPR.PAYMETHOD_ID,
						SPR.CARD_PAYMETHOD_ID,
						SPR.QUANTITY,
						SC.SUBSCRIPTION_NO,
						SC.SUBSCRIPTION_ID,
						SC.MEMBER_CC_ID,
						CONS_CC.CONSUMER_CC_NUMBER CC_NUMBER,
						CONS_CC.CONS_CVS CVS,
						CONS_CC.CONSUMER_EX_MONTH EX_MONTH,
						CONS_CC.CONSUMER_EX_YEAR EX_YEAR,
						CONS_CC.CONSUMER_ID MEMBER_ID,
						CONSUMER.CONSUMER_NAME + ' ' + CONSUMER.CONSUMER_SURNAME MEMBER_NAME,
						1 MEMBER_TYPE,
						I.NETTOTAL,
						I.INVOICE_ID INVOICE_ID,
						I.INVOICE_NUMBER,
						CARD_PAYM.CARD_NO,
						ISNULL(I.CREDITCARD_PAYMENT_ID,0) CREDITCARD_PAYMENT_ID
					FROM
						SUBSCRIPTION_PAYMENT_PLAN_ROW SPR,
						SUBSCRIPTION_CONTRACT SC,
						#dsn_alias#.CONSUMER_CC CONS_CC,
						#dsn_alias#.CONSUMER CONSUMER,
						#new_dsn2#.INVOICE I,
						CREDITCARD_PAYMENT_TYPE CARD_PAYM
					WHERE
						SPR.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID AND
						SC.INVOICE_CONSUMER_ID = CONS_CC.CONSUMER_ID AND
						SC.INVOICE_CONSUMER_ID = CONSUMER.CONSUMER_ID AND
						CONSUMER.CONSUMER_ID = CONS_CC.CONSUMER_ID AND
						SC.MEMBER_CC_ID = CONS_CC.CONSUMER_CC_ID AND
						I.INVOICE_ID = SPR.INVOICE_ID AND
						CARD_PAYM.PAYMENT_TYPE_ID = SPR.CARD_PAYMETHOD_ID AND
						SPR.PAYMENT_DATE BETWEEN  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"> AND
						<cfif len(attributes.pay_method)>
							SPR.CARD_PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pay_method#"> AND<!---ödeme yöntemi--->
						</cfif>
						SPR.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#period_id#"> AND
						SPR.IS_BILLED = 1 AND<!--- faturalandı --->
						SPR.IS_PAID = 0 AND<!--- ödenmedi --->
						SPR.IS_COLLECTED_PROVISION = 0 AND<!--- toplu provizyon oluşturulmadı --->
						SPR.IS_ACTIVE = 1 AND<!--- aktif satırlar --->
						I.NETTOTAL > 0 AND
						I.IS_IPTAL = 0 AND
						I.INVOICE_CAT <> 57 AND <!--- verilen proforma faturası (id:57) odeme plani satirlarina dahil edilmez --->
						CONS_CC.IS_DEFAULT = 1
						<cfif len(attributes.company_id)>
							AND SC.INVOICE_COMPANY_ID =	<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
						</cfif>
						<cfif len(attributes.consumer_id)>
							AND SC.INVOICE_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
						</cfif>
						<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>
							AND SC.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
						</cfif>
						<cfif isDefined("attributes.setup_bank_type") and len(attributes.setup_bank_type)>
							AND CONS_CC.CONSUMER_BANK_TYPE IN (#attributes.setup_bank_type#)
						</cfif>
						<cfif isDefined("attributes.is_cvv")>
							AND CONS_CC.CONS_CVS IS NOT NULL
						</cfif>
						<cfif len(attributes.year_info) and len(attributes.month_info)>
							AND (
									(CONS_CC.CONSUMER_EX_MONTH >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.month_info#"> AND CONS_CC.CONSUMER_EX_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.year_info#">)
									OR 
									(CONS_CC.CONSUMER_EX_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.year_info#"> AND CONS_CC.CONSUMER_EX_MONTH >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.month_info#">)
									OR
									(CONS_CC.CONSUMER_EX_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.year_info#">)			    
								)
						</cfif>
						<cfif len(attributes.contract_start) and len(attributes.contract_finish)>
							AND SPR.SUBSCRIPTION_ID IN (SELECT SUBSCRIPTION_ID FROM SUBSCRIPTION_PAYMENT_PLAN_ROW <cfif isDefined("xml_product_list") and len(xml_product_list)>WHERE PRODUCT_ID IN (#xml_product_list#)</cfif> GROUP BY SUBSCRIPTION_ID HAVING MIN(PAYMENT_DATE) BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.contract_start#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.contract_finish#">)
						<cfelseif len(attributes.contract_start)>
							AND SPR.SUBSCRIPTION_ID IN (SELECT SUBSCRIPTION_ID FROM SUBSCRIPTION_PAYMENT_PLAN_ROW <cfif isDefined("xml_product_list") and len(xml_product_list)>WHERE PRODUCT_ID IN (#xml_product_list#)</cfif> GROUP BY SUBSCRIPTION_ID HAVING MIN(PAYMENT_DATE) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.contract_start#">)
						<cfelseif len(attributes.contract_finish)>
							AND SPR.SUBSCRIPTION_ID IN (SELECT SUBSCRIPTION_ID FROM SUBSCRIPTION_PAYMENT_PLAN_ROW <cfif isDefined("xml_product_list") and len(xml_product_list)>WHERE PRODUCT_ID IN (#xml_product_list#)</cfif> GROUP BY SUBSCRIPTION_ID HAVING MIN(PAYMENT_DATE) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.contract_finish#">)
						</cfif>
					ORDER BY
						I.INVOICE_ID<!--- provizyon sırası değiştirilmemeli!! AE--->
				</cfquery>
			</cfif>
			<cfform name="provision_rows" method="post" action="#request.self#?fuseaction=bank.emptypopupflush_multi_provision_file">
				<cf_basket id="add_due_bask">
					<table class="detail_basket_list">
					<cfoutput>
						<input name="all_records" id="all_records" type="hidden" value="<cfif isDefined("attributes.is_detailed")>#GET_PAYMENT_PLAN.recordcount#</cfif>">
						<input name="bank_name" id="bank_name" type="hidden" value="#attributes.bank_name#">
						<input name="pay_method" id="pay_method" type="hidden" value="#attributes.pay_method#">
						<input name="prov_period" id="prov_period" type="hidden" value="#attributes.prov_period#">
						<input name="consumer_id" id="consumer_id" type="hidden" value="#attributes.consumer_id#">
						<input name="company_id" id="company_id" type="hidden" value="#attributes.company_id#">
						<input name="company" id="company" type="hidden" value="#company_#">
						<input name="subscription_id" id="subscription_id" type="hidden" value="#attributes.subscription_id#">
						<input name="subscription_no" id="subscription_no" type="hidden" value="#attributes.subscription_no#">
						<input name="start_date" id="start_date" type="hidden" value="#attributes.start_date#">
						<input name="finish_date" id="finish_date" type="hidden" value="#attributes.finish_date#">
						<input name="setup_bank_type" id="setup_bank_type" type="hidden" value="#attributes.setup_bank_type#">
						<cfif isDefined("attributes.is_cvv")><input name="is_cvv" id="is_cvv" type="hidden" value="#attributes.is_cvv#"></cfif>
						<input name="month_info" id="month_info" type="hidden" value="#attributes.month_info#">
						<input name="year_info" id="year_info" type="hidden" value="#attributes.year_info#">
						<input name="contract_start" id="contract_start" type="hidden" value="#attributes.contract_start#">
						<input name="contract_finish" id="contract_finish" type="hidden" value="#attributes.contract_finish#">
						<cfif isDefined("attributes.is_detailed")><input name="is_detailed" id="is_detailed" type="hidden" value="#attributes.is_detailed#"></cfif>
						<cfif isDefined("xml_product_list") and len(xml_product_list)><input name="xml_product_list" id="xml_product_list" type="hidden" value="#xml_product_list#"></cfif><!--- XML den gelen bilgi --->
						<cfif isDefined("xml_company_code") and len(xml_company_code)><input name="xml_company_code" id="xml_company_code" type="hidden" value="#xml_company_code#"></cfif><!--- XML den gelen bilgi --->
						<input name="comp_code_info" id="comp_code_info" type="hidden" value="#attributes.comp_code_info#">
					</cfoutput>
					<cfif not isDefined("GET_PAYMENT_PLAN") or GET_PAYMENT_PLAN.recordcount>
						<cfif isDefined("attributes.is_detailed")>
							<thead>
								<tr>
									<th><input type="checkbox" name="hepsi" id="hepsi" value="1" onClick="check_all(this.checked);" checked></th>
									<th><cf_get_lang dictionary_id='57487.No'></th>
									<th><cf_get_lang dictionary_id='57742.Tarih'></th>
									<th><cf_get_lang dictionary_id ='58516.Ödeme Yöntemi'></th>
									<th><cf_get_lang dictionary_id='29502.Sistem No'></th>
									<th><cf_get_lang dictionary_id='58133.Fatura No'></th>
									<th><cf_get_lang dictionary_id ='57629.Açıklama'></th>
									<th><cf_get_lang dictionary_id ='57636.Birim'></th>
									<th><cf_get_lang dictionary_id ='57635.Miktar'></th>
									<th><cf_get_lang dictionary_id ='57673.Tutar'></th>
									<th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
									<th><cf_get_lang dictionary_id='58170.Satır Toplam'></th>
									<th><cf_get_lang dictionary_id='57641.İskonto'> %</th>
									<th><cf_get_lang dictionary_id ='57642.Net Toplam'></th>
									<th><cf_get_lang dictionary_id ='48962.Fatura Toplamı'></th>
									<cfif attributes.fuseaction eq "sales.popup_add_multi_provision"><th></th></cfif>
								</tr>
								</thead>
							<tbody>
							<cfset general_alert = 0>
							<cfoutput query="GET_PAYMENT_PLAN" maxrows="8000">
								<cfset kontrol_invoice = 0>
								<!--- Tahsil Edilmiş Faturalar Kontrolu --->
								<cfif GET_PAYMENT_PLAN.CREDITCARD_PAYMENT_ID neq 0>
									<cfif general_alert neq 1>
										<script>
											$('.sepetim_total_form_button').append('<tr style="float:left;"><td><b><font color="red">Tahsil Edilmiş Faturalar Bulunmaktadır. Lütfen Kontrol Ediniz!</font><b></td></tr>');
										</script>
										<cfset general_alert = 1>
									</cfif>
									<cfset kontrol_invoice = 1>
								</cfif>
								<cfif GET_PAYMENT_PLAN.INVOICE_ID eq GET_PAYMENT_PLAN.INVOICE_ID[currentrow-1]>
									<tr>
									<td width="15"><input type="checkbox" name="payment_row#currentrow#" id="payment_row#currentrow#" value="#SUBSCRIPTION_PAYMENT_ROW_ID#" checked disabled></td>
								<cfelse>
									<tr>
									<td width="15"><input type="checkbox" name="payment_row#currentrow#" id="payment_row#currentrow#" value="#SUBSCRIPTION_PAYMENT_ROW_ID#" checked></td>
								</cfif>
								<!--- 
									FA-09102013
									kredi kartı Gelişmiş şifreleme standartları ile şifrelenmesi. 
									Bu sistemin çalışması için sistem/güvenlik altında kredi kartı şifreleme anahtarlırının tanımlanması gerekmektedir 
								--->
								<cfscript>
									getCCNOKey = createObject("component", "V16.settings.cfc.setupCcnoKey");
									getCCNOKey.dsn = dsn;
									getCCNOKey1 = getCCNOKey.getCCNOKey1();
									getCCNOKey2 = getCCNOKey.getCCNOKey2();
								</cfscript>
								<!--- key 1 ve key 2 DB ye kaydedilmiş ise buna göre encryptleme sistemi çalışıyor --->
								<cfif getCCNOKey1.recordcount and getCCNOKey2.recordcount>
									<!--- anahtarlar decode ediliyor --->
									<cfset ccno_key1 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey1.record_emp,content:getCCNOKey1.ccnokey) />
									<cfset ccno_key2 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey2.record_emp,content:getCCNOKey2.ccnokey) />
									<!--- kart no encode ediliyor --->
									<cfset card_number = contentEncryptingandDecodingAES(isEncode:0,content:CC_NUMBER,accountKey:MEMBER_ID,key1:ccno_key1,key2:ccno_key2) />
								<cfelse>
									<cfset card_number = Decrypt(CC_NUMBER,MEMBER_ID,"CFMX_COMPAT","Hex")>
								</cfif>
								<input type="hidden" name="invoice_id#currentrow#" id="invoice_id#currentrow#" value="#INVOICE_ID#">
								<input type="hidden" name="member_name#currentrow#" id="member_name#currentrow#" value="#MEMBER_NAME#">
								<input type="hidden" name="cvs#currentrow#" id="cvs#currentrow#" value="#CVS#">
								<input type="hidden" name="card_number#currentrow#" id="card_number#currentrow#" value="#card_number#">
								<input type="hidden" name="ex_month#currentrow#" id="ex_month#currentrow#" value="#EX_MONTH#">
								<input type="hidden" name="ex_year#currentrow#" id="ex_year#currentrow#" value="#EX_YEAR#">
								<input type="hidden" name="payment_date#currentrow#" id="payment_date#currentrow#" value="#dateformat(PAYMENT_DATE,dateformat_style)#">
								<input type="hidden" name="nettotal#currentrow#" id="nettotal#currentrow#" value="#wrk_round(NETTOTAL)#">
								<td><cfif kontrol_invoice eq 1><font color="red"></cfif>#currentrow#<cfif kontrol_invoice eq 1></font></cfif></td>
								<td><cfif kontrol_invoice eq 1><font color="red"></cfif>#dateformat(PAYMENT_DATE,dateformat_style)#<cfif kontrol_invoice eq 1></font></cfif></td>
								<td><cfif kontrol_invoice eq 1><font color="red"></cfif>#CARD_NO#<cfif kontrol_invoice eq 1></font></cfif></td>
								<td><cfif kontrol_invoice eq 1><font color="red"></cfif>#SUBSCRIPTION_NO#<cfif kontrol_invoice eq 1></font></cfif></td>
								<td><cfif kontrol_invoice eq 1><font color="red"></cfif>#INVOICE_NUMBER#<cfif kontrol_invoice eq 1></font></cfif></td>
								<td><cfif kontrol_invoice eq 1><font color="red"></cfif>#DETAIL#<cfif kontrol_invoice eq 1></font></cfif></td>
								<td><cfif kontrol_invoice eq 1><font color="red"></cfif>#UNIT#<cfif kontrol_invoice eq 1></font></cfif></td>
								<td><cfif kontrol_invoice eq 1><font color="red"></cfif>#QUANTITY#<cfif kontrol_invoice eq 1></font></cfif></td>
								<td><cfif kontrol_invoice eq 1><font color="red"></cfif>#TLFormat(AMOUNT)#<cfif kontrol_invoice eq 1></font></cfif></td>
								<td><cfif kontrol_invoice eq 1><font color="red"></cfif>#MONEY_TYPE#<cfif kontrol_invoice eq 1></font></cfif></td>
								<td style="text-align:right;"><cfif kontrol_invoice eq 1><font color="red"></cfif>#TLFormat(ROW_TOTAL)#<cfif kontrol_invoice eq 1></font></cfif></td>
								<td style="text-align:right;"><cfif kontrol_invoice eq 1><font color="red"></cfif>#TLFormat(DISCOUNT)#<cfif kontrol_invoice eq 1></font></cfif></td>
								<td style="text-align:right;"><cfif kontrol_invoice eq 1><font color="red"></cfif>#TLFormat(ROW_NET_TOTAL)#<cfif kontrol_invoice eq 1></font></cfif></td>
								<td style="text-align:right;"><cfif kontrol_invoice eq 1><font color="red"></cfif>#TLFormat(NETTOTAL)# #SESSION.EP.MONEY#<cfif kontrol_invoice eq 1></font></cfif></td>
								<cfif attributes.fuseaction eq "sales.popup_add_multi_provision"><!--- sanal pos işlemleri için ek düzenlemeler --->
									<input type="hidden" name="invoice_id#currentrow#" id="invoice_id#currentrow#" value="#INVOICE_ID#">
									<cfif GET_PAYMENT_PLAN.INVOICE_ID neq GET_PAYMENT_PLAN.INVOICE_ID[currentrow-1]>
										<td>
											<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=bank.popup_add_online_pos&member_type=#MEMBER_TYPE#&member_id=#MEMBER_ID#&card_id_info=#MEMBER_CC_ID#&action_value=#NETTOTAL#&invoice_id=#INVOICE_ID#&period_id=#PERIOD_ID#&paym_id=#CARD_PAYMETHOD_ID#','medium');"><img src="/images/plus_list.gif" alt="Sanal POS" title="Sanal POS" border="0"></a>
										</td>
									<cfelse>
										<td></td>
									</cfif>
								</cfif>
							</tr>
						</cfoutput>
						</tbody>
						</cfif>
					<cfelse>
						<tbody>
							<tr>
								<td colspan="10"><cf_get_lang dictionary_id ='57484.Kayıt yok'>!</td>
							</tr>
						</tbody>
					</cfif>
					<cfif not attributes.fuseaction eq "sales.popup_add_multi_provision"><!--- sanal pos işlemleri için ek düzenlemeler --->
						<cf_basket_footer height="30">
							<cf_get_lang dictionary_id ='48918.Anahtar'> : <input name="key_type" id="key_type" type="password" autocomplete="off">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='29477.Belge Oluştur'></cfsavecontent>
							<cf_workcube_buttons is_upd='0' is_cancel='0' insert_info = '#message#' add_function='input_control()'>
						</cf_basket_footer>
					</cfif>
					</table>
				</cf_basket>
			</cfform>
			<cfif isDefined("attributes.is_detailed")>
				<script type="text/javascript">
					function check_all(deger)
					{
						<cfif GET_PAYMENT_PLAN.recordcount >
							if(provision_rows.hepsi.checked)
							{
								for (var i=1; i <= <cfoutput>#GET_PAYMENT_PLAN.recordcount#</cfoutput>; i++)
								{
									if(eval("document.provision_rows.payment_row" + i).disabled == false)
									{
										var form_field = eval("document.provision_rows.payment_row" + i);
										form_field.checked = true;
										eval('provision_rows.payment_row'+i).focus();
									}
								}
							}
							else
							{
								for (var i=1; i <= <cfoutput>#GET_PAYMENT_PLAN.recordcount#</cfoutput>; i++)
								{
									if(eval("document.provision_rows.payment_row" + i).disabled == false)
									{
										form_field = eval("document.provision_rows.payment_row" + i);
										form_field.checked = false;
										eval('provision_rows.payment_row'+i).focus();
									}
								}				
							}
						</cfif>
					}
				</script>
			</cfif>
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	function kontrol()
	{
		<cfif not listfirst(attributes.fuseaction,'.') eq "sales">
			if(add_multi_provision.bank_name.value=="")
			{
				alert("<cf_get_lang dictionary_id ='48963.Pos Tipi Seçiniz'>");
				return false;
			}
			if(add_multi_provision.pay_method.value=="")
			{
				alert("<cf_get_lang dictionary_id='58027.Lutfen Odeme Yontemi Seciniz'>");
				return false;
			}
		</cfif>
		document.add_multi_provision.open_form.value = 1
		return true;
	}
	function input_control()
	{
		if(provision_rows.key_type.value == "")
		{
			alert("<cf_get_lang dictionary_id ='48964.Anahtar Giriniz'>");
			return false;
		}
		<cfif isDefined("attributes.is_detailed")>
			var checked_info = false;
			var toplam = document.provision_rows.all_records.value;
			for(var i=1; i<=toplam; i++)
			{
				if(eval('provision_rows.payment_row'+i).checked){
					checked_info = true;
					i = toplam+1;
				}
			}
			if(!checked_info)
			{
				alert("<cf_get_lang dictionary_id ='48965.Seçim Yapmadınız'>!");
				return false;
			}
			return true;
		</cfif>
	}
	function open_code_input(pos_type_info)
	{
		<cfif isDefined("xml_company_code") and len(xml_company_code)>//xml den pos tipi verilerek üye işyeri numarası girilmesi sağlanması için
			if(list_find('<cfoutput>#xml_company_code#</cfoutput>',pos_type_info,','))
				document.getElementById('comp_code').style.display = '';
			else
				document.getElementById('comp_code').style.display = 'none';
		</cfif>
	}
	
	$(document).ready(function(){
		$("#page-subtitle").html("Document-ready was called!");
	  });
	
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
