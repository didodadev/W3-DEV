<!--- Detayli Kredi Raporu 20121011 --->
<cfparam name="attributes.credit_type_id" default="">
<cfparam name="attributes.credit_limit_id" default="">
<cfparam name="attributes.process_type" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_name" default="">
<cfparam name="attributes.pos_code" default="">
<cfparam name="attributes.pos_manager" default="">
<cfparam name="attributes.is_all_credits" default="">
<cfparam name="attributes.credit_contract_type" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.listing_type" default="">
<cfparam name="attributes.is_tahsil_edildi" default="">
<cfparam name="attributes.is_odendi" default="">
<cfparam name="attributes.is_planlanan_row" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<!--- Kredi Limitleri --->
<cfquery name="get_credit_limit" datasource="#dsn3#">
	SELECT CREDIT_LIMIT_ID, LIMIT_HEAD FROM CREDIT_LIMIT ORDER BY LIMIT_HEAD
</cfquery>
<!--- Islem Tipleri --->
<cfquery name="get_setup_process" datasource="#dsn3#">
	SELECT DISTINCT
		SPC.PROCESS_TYPE,
		SPC.PROCESS_CAT
	FROM
		SETUP_PROCESS_CAT_FUSENAME AS SPCF,
		SETUP_PROCESS_CAT SPC
	WHERE
		SPC.PROCESS_CAT_ID = SPCF.PROCESS_CAT_ID AND			
		SPCF.FUSE_NAME = 'credit.upd_credit_contract'
	ORDER BY
		SPC.PROCESS_CAT
</cfquery>
<!--- Para Birimleri --->
<cfquery name="get_money_rate" datasource="#dsn#">
	SELECT
		MONEY
	FROM
		SETUP_MONEY
	WHERE
		PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
		MONEY_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
</cfquery>
<cfif isdefined("attributes.is_form")>
	<cfparam name="attributes.page" default=1>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cfif isdate(attributes.start_date)>
		<cf_date tarih = "attributes.start_date">
	</cfif>
	<cfif isdate(attributes.finish_date)>
		<cf_date tarih = "attributes.finish_date">
	</cfif>
	<cfquery name="get_credit_contract_payments" datasource="#dsn3#">
		SELECT 
			C.CREDIT_CONTRACT_ID,
			C.CREDIT_DATE,
			C.CREDIT_NO,
			COMPANY.FULLNAME COMP_NAME,
			SCT.CREDIT_TYPE,
			C.DETAIL DOC_DETAIL,
			C.MONEY_TYPE
			<cfif attributes.listing_type eq 2>
				,C.BANK_NAME,
				CR.CREDIT_CONTRACT_ROW_ID,
				ISNULL(CR.DETAIL,'') DETAIL,
				CR.CREDIT_CONTRACT_TYPE,
				CR.TOTAL_PRICE PLAN_TOTAL_PRICE, 
				CR.INTEREST_PRICE PLAN_INTEREST_PRICE, 
				CR.TAX_PRICE PLAN_TAX_PRICE,
				ISNULL(CR.DELAY_PRICE,0) PLAN_DELAY_PRICE,
				CR.CAPITAL_PRICE PLAN_CAPITAL_PRICE, 
				0 PAID_TOTAL_PRICE, 
				0 PAID_INTEREST_PRICE, 
				0 PAID_TAX_PRICE,
				0 PAID_DELAY_PRICE,
				0 PAID_CAPITAL_PRICE, 
				ISNULL(CR.PROCESS_DATE,C.CREDIT_DATE) PLAN_PROCESS_DATE,
				ISNULL(ISNULL(CCP.PROCESS_DATE,CCP2.EXPENSE_DATE),0) PAID_PROCESS_DATE,
				CR.IS_PAID,
				CR.OTHER_MONEY,
				CR.PERIOD_ID,
				CR.OUR_COMPANY_ID
			</cfif>
		FROM
			<cfif attributes.listing_type eq 2>
				CREDIT_CONTRACT_ROW CR
					LEFT JOIN #dsn2_alias#.CREDIT_CONTRACT_PAYMENT_INCOME CCP ON CR.CREDIT_CONTRACT_ROW_ID = CCP.CREDIT_CONTRACT_ROW_ID
					LEFT JOIN #dsn2_alias#.EXPENSE_ITEM_PLANS CCP2 ON CR.CREDIT_CONTRACT_ROW_ID = CCP2.CREDIT_CONTRACT_ROW_ID,
			</cfif>
			CREDIT_CONTRACT C
				LEFT JOIN #dsn_alias#.COMPANY COMPANY ON C.COMPANY_ID = COMPANY.COMPANY_ID
				LEFT JOIN #dsn_alias#.SETUP_CREDIT_TYPE SCT ON C.CREDIT_TYPE = SCT.CREDIT_TYPE_ID
		WHERE 
			1=1
			<cfif len(attributes.credit_type_id)>
				AND C.CREDIT_TYPE = #attributes.credit_type_id#
			</cfif>
			<cfif len(attributes.credit_limit_id)>
				AND C.CREDIT_LIMIT_ID = #attributes.credit_limit_id# 
			</cfif>
			<cfif len(attributes.company_id) and len(attributes.company)>
				AND C.COMPANY_ID = #attributes.company_id#
			</cfif>
			<cfif len(attributes.project_id) and len(attributes.project_name)>
				AND C.PROJECT_ID = #attributes.project_id#
			</cfif>
			<cfif len(attributes.pos_code) and len(attributes.pos_manager)>
				AND C.CREDIT_EMP_ID = #attributes.pos_code#
			</cfif>
			<cfif len(attributes.process_type)>
				AND C.PROCESS_TYPE = #attributes.process_type#
			</cfif>
			<cfif attributes.listing_type eq 2>
				AND CR.CREDIT_CONTRACT_ID = C.CREDIT_CONTRACT_ID
				AND CR.IS_PAID = 0
				<!--- eger odeme satirlari odendi/odenmedi ise (kredi sozlesmesi)--->
				<cfif len(attributes.is_odendi) and attributes.is_odendi eq 1 and attributes.process_type neq 296>
					AND CCP.CREDIT_CONTRACT_ROW_ID = CR.CREDIT_CONTRACT_ROW_ID
					AND CR.CREDIT_CONTRACT_TYPE = 1
				<cfelseif len(attributes.is_odendi) and attributes.is_odendi eq 0 and attributes.process_type neq 296>	
					AND CCP.CREDIT_CONTRACT_ROW_ID IS NULL
					AND CR.CREDIT_CONTRACT_TYPE = 1
				</cfif>
				<!--- eger odeme satirlari odendi/odenmedi ise (finansal kiralama sozlesmesi)--->
				<cfif len(attributes.is_odendi) and attributes.is_odendi eq 1 and attributes.process_type eq 296>
					AND CCP2.CREDIT_CONTRACT_ROW_ID = CR.CREDIT_CONTRACT_ROW_ID
					AND CR.CREDIT_CONTRACT_TYPE = 1
				<cfelseif len(attributes.is_odendi) and attributes.is_odendi eq 0 and attributes.process_type eq 296>	
					AND CCP2.CREDIT_CONTRACT_ROW_ID IS NULL
					AND CR.CREDIT_CONTRACT_TYPE = 1
				</cfif>
				<!--- eger tahsilat satirlari tahsil edildi/edilmedi ise --->
				<cfif len(attributes.is_tahsil_edildi) and attributes.is_tahsil_edildi eq 1>
					AND CCP.CREDIT_CONTRACT_ROW_ID = CR.CREDIT_CONTRACT_ROW_ID
					AND CR.CREDIT_CONTRACT_TYPE = 2
				<cfelseif len(attributes.is_tahsil_edildi) and attributes.is_tahsil_edildi eq 0>	
					AND CCP.CREDIT_CONTRACT_ROW_ID IS NULL
					AND CR.CREDIT_CONTRACT_TYPE = 2
				</cfif>
				<!--- plan satırı olanlar/olmayanlar (kredi sozlesmesi) --->
				<cfif len(attributes.is_planlanan_row) and attributes.is_planlanan_row eq 0 and attributes.process_type neq 296>
					AND CCP.CREDIT_CONTRACT_ROW_ID IS NOT NULL
					AND IS_PAID = 1
				</cfif>
				<!--- plan satırı olanlar/olmayanlar (finansal kiralama sozlesmesi)--->
				<cfif len(attributes.is_planlanan_row) and attributes.is_planlanan_row eq 0 and attributes.process_type eq 296>
					AND CCP2.CREDIT_CONTRACT_ROW_ID IS NOT NULL
					AND IS_PAID = 1
				</cfif>
				<cfif len(attributes.is_all_credits)>
					AND CR.IS_PAID = #attributes.is_all_credits#
				</cfif>
				<cfif len(attributes.credit_contract_type)>
					AND CR.CREDIT_CONTRACT_TYPE = #attributes.credit_contract_type#
				</cfif>
				<cfif len(attributes.start_date)>
					AND CR.PROCESS_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
				</cfif>
				<cfif len(attributes.finish_date)>
					AND CR.PROCESS_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
				</cfif>
			<cfelse>
				<cfif len(attributes.start_date)>
					AND C.CREDIT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
				</cfif>
				<cfif len(attributes.finish_date)>
					AND C.CREDIT_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
				</cfif>
			</cfif>
		<cfif attributes.listing_type eq 2>
			UNION ALL
			SELECT 
				C.CREDIT_CONTRACT_ID,
				C.CREDIT_DATE,
				C.CREDIT_NO,
				COMPANY.FULLNAME COMP_NAME,
				SCT.CREDIT_TYPE,
				C.DETAIL DOC_DETAIL,
				C.MONEY_TYPE,
				C.BANK_NAME,
				ISNULL(CCP.CREDIT_CONTRACT_ROW_ID,CR.CREDIT_CONTRACT_ROW_ID) CREDIT_CONTRACT_ROW_ID,
				ISNULL(CR.DETAIL,'') DETAIL,
				CR.CREDIT_CONTRACT_TYPE,
				0 PLAN_TOTAL_PRICE, 
				0 PLAN_INTEREST_PRICE, 
				0 PLAN_TAX_PRICE,
				0 PLAN_DELAY_PRICE,
				0 PLAN_CAPITAL_PRICE, 
				CR.TOTAL_PRICE PAID_TOTAL_PRICE, 
				CR.INTEREST_PRICE PAID_INTEREST_PRICE, 
				CR.TAX_PRICE PAID_TAX_PRICE,
				ISNULL(CR.DELAY_PRICE,0) PAID_DELAY_PRICE,
				CR.CAPITAL_PRICE PAID_CAPITAL_PRICE, 
				ISNULL(ISNULL((SELECT CR2.PROCESS_DATE FROM CREDIT_CONTRACT_ROW CR2 WHERE CR2.CREDIT_CONTRACT_ROW_ID = CCP.CREDIT_CONTRACT_ROW_ID),CR.PROCESS_DATE),C.CREDIT_DATE) PLAN_PROCESS_DATE,				CR.PROCESS_DATE PAID_PROCESS_DATE,
				CR.IS_PAID,
				CR.OTHER_MONEY,
				CR.PERIOD_ID,
				CR.OUR_COMPANY_ID
			FROM
				CREDIT_CONTRACT_ROW CR
					LEFT JOIN #dsn2_alias#.CREDIT_CONTRACT_PAYMENT_INCOME CCP ON CR.ACTION_ID = CCP.CREDIT_CONTRACT_PAYMENT_ID,
				CREDIT_CONTRACT C
					LEFT JOIN #dsn_alias#.COMPANY COMPANY ON C.COMPANY_ID = COMPANY.COMPANY_ID
					LEFT JOIN #dsn_alias#.SETUP_CREDIT_TYPE SCT ON C.CREDIT_TYPE = SCT.CREDIT_TYPE_ID
			WHERE 
				CR.PROCESS_TYPE <> 120<!--- finansal kiralama sözleşmesi olmayanlar --->
				AND CR.CREDIT_CONTRACT_ID = C.CREDIT_CONTRACT_ID
				AND CR.IS_PAID = 1
				<cfif len(attributes.credit_type_id)>
					AND C.CREDIT_TYPE = #attributes.credit_type_id#
				</cfif>
				<cfif len(attributes.credit_limit_id)>
					AND C.CREDIT_LIMIT_ID = #attributes.credit_limit_id# 
				</cfif>
				<cfif len(attributes.company_id) and len(attributes.company)>
					AND C.COMPANY_ID = #attributes.company_id#
				</cfif>
				<cfif len(attributes.project_id) and len(attributes.project_name)>
					AND C.PROJECT_ID = #attributes.project_id#
				</cfif>
				<cfif len(attributes.pos_code) and len(attributes.pos_manager)>
					AND C.CREDIT_EMP_ID = #attributes.pos_code#
				</cfif>
				<cfif len(attributes.process_type)>
					AND C.PROCESS_TYPE = #attributes.process_type#
				</cfif>
				<!--- eger odeme satirlari odendi/odenmedi ise --->
				<cfif len(attributes.is_odendi) and attributes.is_odendi eq 1>
					AND CCP.CREDIT_CONTRACT_PAYMENT_ID = CR.ACTION_ID
					AND CR.CREDIT_CONTRACT_TYPE = 1
				<cfelseif len(attributes.is_odendi) and attributes.is_odendi eq 0>	
					AND CCP.CREDIT_CONTRACT_PAYMENT_ID <> CR.ACTION_ID
					AND CR.CREDIT_CONTRACT_TYPE = 1
				</cfif>
				<!--- eger tahsilat satirlari tahsil edildi/edilmedi ise --->
				<cfif len(attributes.is_tahsil_edildi) and attributes.is_tahsil_edildi eq 1>
					AND CCP.CREDIT_CONTRACT_PAYMENT_ID = CR.ACTION_ID
					AND CR.CREDIT_CONTRACT_TYPE = 2
				<cfelseif len(attributes.is_tahsil_edildi) and attributes.is_tahsil_edildi eq 0>	
					AND CCP.CREDIT_CONTRACT_PAYMENT_ID <> CR.ACTION_ID
					AND CR.CREDIT_CONTRACT_TYPE = 2
				</cfif>
				<!--- plan satırı olan/olmayan --->
				<cfif len(attributes.is_planlanan_row) and attributes.is_planlanan_row eq 1>
					AND CCP.CREDIT_CONTRACT_ROW_ID IS NOT NULL
				<cfelseif len(attributes.is_planlanan_row) and attributes.is_planlanan_row eq 0>	
					AND CCP.CREDIT_CONTRACT_ROW_ID IS NULL
				</cfif>
				<cfif len(attributes.is_all_credits)>
					AND CR.IS_PAID = #attributes.is_all_credits#
				</cfif>
				<cfif len(attributes.credit_contract_type)>
					AND CR.CREDIT_CONTRACT_TYPE = #attributes.credit_contract_type#
				</cfif>
				<cfif len(attributes.start_date)>
					AND CR.PROCESS_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
				</cfif>
				<cfif len(attributes.finish_date)>
					AND CR.PROCESS_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
				</cfif>
				
			UNION ALL
			SELECT 
				C.CREDIT_CONTRACT_ID,
				C.CREDIT_DATE,
				C.CREDIT_NO,
				COMPANY.FULLNAME COMP_NAME,
				SCT.CREDIT_TYPE,
				C.DETAIL DOC_DETAIL,
				C.MONEY_TYPE,
				C.BANK_NAME,
				ISNULL(CCP.CREDIT_CONTRACT_ROW_ID,CR.CREDIT_CONTRACT_ROW_ID) CREDIT_CONTRACT_ROW_ID,
				ISNULL(CR.DETAIL,'') DETAIL,
				CR.CREDIT_CONTRACT_TYPE,
				0 PLAN_TOTAL_PRICE, 
				0 PLAN_INTEREST_PRICE, 
				0 PLAN_TAX_PRICE,
				0 PLAN_DELAY_PRICE,
				0 PLAN_CAPITAL_PRICE, 
				(CR.INTEREST_PRICE+CR.TAX_PRICE+ISNULL(CR.DELAY_PRICE,0)+CR.CAPITAL_PRICE) PAID_TOTAL_PRICE, 
				CR.INTEREST_PRICE PAID_INTEREST_PRICE, 
				CR.TAX_PRICE PAID_TAX_PRICE,
				ISNULL(CR.DELAY_PRICE,0) PAID_DELAY_PRICE,
				CR.CAPITAL_PRICE PAID_CAPITAL_PRICE, 
				ISNULL(ISNULL((SELECT CR2.PROCESS_DATE FROM CREDIT_CONTRACT_ROW CR2 WHERE CR2.CREDIT_CONTRACT_ROW_ID = CCP.CREDIT_CONTRACT_ROW_ID),CR.PROCESS_DATE),C.CREDIT_DATE) PLAN_PROCESS_DATE,
				CR.PROCESS_DATE PAID_PROCESS_DATE,
				CR.IS_PAID,
				CR.OTHER_MONEY,
				CR.PERIOD_ID,
				CR.OUR_COMPANY_ID
			FROM
				CREDIT_CONTRACT_ROW CR
					LEFT JOIN #dsn2_alias#.EXPENSE_ITEM_PLANS CCP ON CR.ACTION_ID = CCP.EXPENSE_ID,
				CREDIT_CONTRACT C
					LEFT JOIN #dsn_alias#.COMPANY COMPANY ON C.COMPANY_ID = COMPANY.COMPANY_ID
					LEFT JOIN #dsn_alias#.SETUP_CREDIT_TYPE SCT ON C.CREDIT_TYPE = SCT.CREDIT_TYPE_ID
			WHERE 
				CR.PROCESS_TYPE = 120<!--- finansal kiralama sözleşmesi olanlar --->
				AND CR.CREDIT_CONTRACT_ID = C.CREDIT_CONTRACT_ID
				AND CR.IS_PAID = 1
				<cfif len(attributes.credit_type_id)>
					AND C.CREDIT_TYPE = #attributes.credit_type_id#
				</cfif>
				<cfif len(attributes.credit_limit_id)>
					AND C.CREDIT_LIMIT_ID = #attributes.credit_limit_id# 
				</cfif>
				<cfif len(attributes.company_id) and len(attributes.company)>
					AND C.COMPANY_ID = #attributes.company_id#
				</cfif>
				<cfif len(attributes.project_id) and len(attributes.project_name)>
					AND C.PROJECT_ID = #attributes.project_id#
				</cfif>
				<cfif len(attributes.pos_code) and len(attributes.pos_manager)>
					AND C.CREDIT_EMP_ID = #attributes.pos_code#
				</cfif>
				<cfif len(attributes.process_type)>
					AND C.PROCESS_TYPE = #attributes.process_type#
				</cfif>
				<!--- eger odeme satirlari odendi/odenmedi ise --->
				<cfif len(attributes.is_odendi) and attributes.is_odendi eq 1>
					AND CCP.EXPENSE_ID = CR.ACTION_ID
					AND CR.CREDIT_CONTRACT_TYPE = 1
				<cfelseif len(attributes.is_odendi) and attributes.is_odendi eq 0>	
					AND CCP.EXPENSE_ID <> CR.ACTION_ID
					AND CR.CREDIT_CONTRACT_TYPE = 1
				</cfif>
				<!--- eger tahsilat satirlari tahsil edildi/edilmedi ise --->
				<cfif len(attributes.is_tahsil_edildi) and attributes.is_tahsil_edildi eq 1>
					AND CCP.EXPENSE_ID = CR.ACTION_ID
					AND CR.CREDIT_CONTRACT_TYPE = 2
				<cfelseif len(attributes.is_tahsil_edildi) and attributes.is_tahsil_edildi eq 0>	
					AND CCP.EXPENSE_ID <> CR.ACTION_ID
					AND CR.CREDIT_CONTRACT_TYPE = 2
				</cfif>
				<!--- plan satırı olan/olmayan --->
				<cfif len(attributes.is_planlanan_row) and attributes.is_planlanan_row eq 1>
					AND CCP.CREDIT_CONTRACT_ROW_ID IS NOT NULL
				<cfelseif len(attributes.is_planlanan_row) and attributes.is_planlanan_row eq 0>	
					AND CCP.CREDIT_CONTRACT_ROW_ID IS NULL
				</cfif>
				<cfif len(attributes.is_all_credits)>
					AND CR.IS_PAID = #attributes.is_all_credits#
				</cfif>
				<cfif len(attributes.credit_contract_type)>
					AND CR.CREDIT_CONTRACT_TYPE = #attributes.credit_contract_type#
				</cfif>
				<cfif len(attributes.start_date)>
					AND CR.PROCESS_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
				</cfif>
				<cfif len(attributes.finish_date)>
					AND CR.PROCESS_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
				</cfif>
			</cfif>
	</cfquery>
	<cfif attributes.listing_type eq 2>
		<cfquery name="get_credit_contract_payments" dbtype="query">
			SELECT
				CREDIT_CONTRACT_ID,
				CREDIT_DATE,
				CREDIT_NO,
				COMP_NAME,
				CREDIT_TYPE,
				DOC_DETAIL,
				MONEY_TYPE,
				BANK_NAME,
				CREDIT_CONTRACT_ROW_ID,
				CREDIT_CONTRACT_TYPE,
				SUM(PLAN_TOTAL_PRICE) PLAN_TOTAL_PRICE, 
				SUM(PLAN_INTEREST_PRICE) PLAN_INTEREST_PRICE, 
				SUM(PLAN_TAX_PRICE) PLAN_TAX_PRICE,
				SUM(PLAN_DELAY_PRICE) PLAN_DELAY_PRICE,
				SUM(PLAN_CAPITAL_PRICE) PLAN_CAPITAL_PRICE, 
				SUM(PAID_TOTAL_PRICE) PAID_TOTAL_PRICE, 
				SUM(PAID_INTEREST_PRICE) PAID_INTEREST_PRICE, 
				SUM(PAID_TAX_PRICE) PAID_TAX_PRICE,
				SUM(PAID_DELAY_PRICE) PAID_DELAY_PRICE,
				SUM(PAID_CAPITAL_PRICE) PAID_CAPITAL_PRICE, 
				PLAN_PROCESS_DATE,
				PAID_PROCESS_DATE,
				OTHER_MONEY
			FROM
				get_credit_contract_payments
			GROUP BY
				CREDIT_CONTRACT_ID,
				CREDIT_DATE,
				CREDIT_NO,
				COMP_NAME,
				CREDIT_TYPE,
				DOC_DETAIL,
				MONEY_TYPE,
				BANK_NAME,
				CREDIT_CONTRACT_ROW_ID,
				CREDIT_CONTRACT_TYPE,
				PLAN_PROCESS_DATE,
				PAID_PROCESS_DATE,
				OTHER_MONEY
			ORDER BY
				PLAN_PROCESS_DATE
		</cfquery>
	</cfif>
	<cfif attributes.listing_type eq 1 and get_credit_contract_payments.recordcount>
		<cfquery name="get_prices" datasource="#dsn3#">
			SELECT
				ISNULL(CAPITAL_PRICE,0) CAPITAL_PRICE,
				ISNULL(INTEREST_PRICE,0) INTEREST_PRICE,
				ISNULL(TAX_PRICE,0) TAX_PRICE,
				ISNULL(DELAY_PRICE,0) DELAY_PRICE,
				ISNULL(TOTAL_PRICE,0) TOTAL_PRICE,
				CREDIT_CONTRACT_ID,
				CREDIT_CONTRACT_TYPE,
				IS_PAID,
				PROCESS_DATE,
				ISNULL(DATEDIFF(day,GETDATE()+1,PROCESS_DATE)*ISNULL(TOTAL_PRICE,0),0) DIFF_VALUE,
				CREDIT_CONTRACT_ROW_ID
			FROM
				CREDIT_CONTRACT_ROW
			WHERE
				CREDIT_CONTRACT_ID IN (#valuelist(get_credit_contract_payments.credit_contract_id)#)
		</cfquery>
	<cfelse>
		<cfset get_prices.recordcount = 0>
	</cfif>
	<cfparam name="attributes.totalrecords" default="#get_credit_contract_payments.recordcount#">
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">
</cfif>
<cfsavecontent variable="title"><cf_get_lang dictionary_id='40433.Detaylı Kredi Analizi'></cfsavecontent>
<cf_report_list_search title="#title#">
	<cf_report_list_search_area>
		<cfform name="form_" method="post" action="#request.self#?fuseaction=report.detail_credit_report">
				<div class="row">
					<div class="col col-12 col-xs-12">
						<div class="row formContent">
							<div class="row" type="row">
								<div class="col col-4 col-md-6 col-xs-12">
									<div class="col col-12 col-xs-12">	
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='57800.Islem Tipi'></label>
											<div class="col col-12 col-xs-12">
												<select name="process_type" id="process_type">
													<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
													<cfloop query="get_setup_process">
														<cfoutput><option value="#process_type#" <cfif attributes.process_type eq process_type>selected</cfif>>#process_cat#</option></cfoutput>
													</cfloop>
												</select>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58869.Planlanan'>/<cf_get_lang dictionary_id='39725.Gerçekleşen'></label>
											<div class="col col-12 col-xs-12">
												<select name="is_all_credits" id="is_all_credits">
													<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
													<option value="0" <cfif attributes.is_all_credits eq 0>selected</cfif>><cf_get_lang dictionary_id='58869.Planlanan'></option>
													<option value="1" <cfif attributes.is_all_credits eq 1>selected</cfif>><cf_get_lang dictionary_id='39725.Gerçekleşen'></option>
												</select>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='59174.Plan Satırı'></label>
											<div class="col col-12 col-xs-12">
												<select name="is_planlanan_row" id="is_planlanan_row">
													<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
													<option value="1" <cfif attributes.is_planlanan_row eq 1>selected</cfif>><cf_get_lang dictionary_id='59175.Plan Satırı Olanlar'></option>
													<option value="0" <cfif attributes.is_planlanan_row eq 0>selected</cfif>><cf_get_lang dictionary_id='59176.Plan Satırı Olmayanlar'></option>
												</select>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57845.Tahsilat'> <cf_get_lang dictionary_id='30111.Durumu'></label>
											<div class="col col-12 col-xs-12">
												<select name="is_tahsil_edildi" id="is_tahsil_edildi" style="width:110px;">
													<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
													<option value="1" <cfif attributes.is_tahsil_edildi eq 1>selected</cfif>><cf_get_lang dictionary_id='39650.Tahsil Edildi'></option>
													<option value="0" <cfif attributes.is_tahsil_edildi eq 0>selected</cfif>><cf_get_lang dictionary_id='59173.Tahsil Edilmedi'></option>
												</select>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58963.Kredi Limiti'></label>
											<div class="col col-12 col-xs-12">
												<select name="credit_limit_id" id="credit_limit_id" style="width:130px;">
													<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
													<cfoutput query="get_credit_limit">
														<option value="#credit_limit_id#" <cfif attributes.credit_limit_id eq credit_limit_id>selected</cfif>>#limit_head#</option>
													</cfoutput>
												</select>
											</div>
										</div>
									</div>
								</div>
								<div class="col col-4 col-md-6 col-xs-12">
									<div class="col col-12 col-xs-12">	
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57847.Ödeme'>/<cf_get_lang dictionary_id='57845.Tahsilat'></label>
											<div class="col col-12 col-xs-12">
												<select name="credit_contract_type" id="credit_contract_type" style="width:135px;">
													<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
													<option value="1" <cfif attributes.credit_contract_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57847.Ödeme'></option>
													<option value="2" <cfif attributes.credit_contract_type eq 2>selected</cfif>><cf_get_lang dictionary_id='57845.Tahsilat'></option>
												</select>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57847.Ödeme'> <cf_get_lang dictionary_id='30111.Durumu'></label>
											<div class="col col-12 col-xs-12">
												<select name="is_odendi" id="is_odendi" style="width:110px;">
													<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
													<option value="1" <cfif attributes.is_odendi eq 1>selected</cfif>><cf_get_lang dictionary_id='39136.Ödendi'></option>
													<option value="0" <cfif attributes.is_odendi eq 0>selected</cfif>><cf_get_lang dictionary_id='39139.Ödenmedi'></option>
												</select>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='59172.Kredi Türü'></label>
											<div class="col col-12 col-xs-12">
												<cfsavecontent variable="text"><cf_get_lang dictionary_id='57734.Seçiniz'></cfsavecontent>
												<cf_wrk_combo
												name="credit_type_id"
												query_name="GET_CREDIT_TYPE"
												option_name="credit_type"
												option_value="credit_type_id"
												option_text="#text#"
												value="#attributes.credit_type_id#"
												width="130">
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58960.Rapor Tipi'></label>
											<div class="col col-12 col-xs-12">
												<select name="listing_type" id="listing_type" style="width:175px;">
													<option value="1" <cfif attributes.listing_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57660.Belge Bazinda'></option>
													<option value="2" <cfif attributes.listing_type eq 2>selected</cfif>><cf_get_lang dictionary_id='29539.Satir Bazinda'></option>
												</select>
											</div>
										</div>
									</div>
								</div>
								<div class="col col-4 col-md-6 col-xs-12">
									<div class="col col-12 col-xs-12">	
										<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='59171.Kredi Kurumu'></label>
												<div class="col col-12 col-xs-12">
													<div class="input-group">
														<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
														<input type="text" name="company" id="company" onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\'','COMPANY_ID','company_id','','3','120');" autocomplete="off" value="<cfoutput>#attributes.company#</cfoutput>" style="width:120px;">	  
														<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_comp_id=form_.company_id&field_comp_name=form_.company&select_list=2','list');"></span>
													</div>
												</div>
										</div>
										<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57544.Sorumlu'></label>
												<div class="col col-12 col-xs-12">
													<div class="input-group">
														<input type="hidden" name="pos_code"  id="pos_code" value="<cfif len(attributes.pos_code)><cfoutput>#attributes.pos_code#</cfoutput></cfif>">
														<input type="text" name="pos_manager" id="pos_manager" value="<cfif len(attributes.pos_manager)><cfoutput>#attributes.pos_manager#</cfoutput></cfif>" style="width:160px;" onFocus="AutoComplete_Create('pos_manager','FULLNAME','FULLNAME','get_emp_pos','','POSITION_CODE','pos_code','','3','130');" maxlength="255" autocomplete="off">
														<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=form_.pos_code&field_name=form_.pos_manager','list','popup_list_positions');"></span>
													</div>
												</div>
										</div>
										<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
												<div class="col col-12 col-xs-12">
													<div class="input-group">
															<cf_wrk_projects form_name='form_' project_id='project_id' project_name='project_name'>
															<input type="hidden" name="project_id" id="project_id" value="<cfif len(attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
															<input type="text" name="project_name" id="project_name" value="<cfif len(attributes.project_name)><cfoutput>#attributes.project_name#</cfoutput></cfif>" style="width:120px;" onFocus="AutoComplete_Create('project_name','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
															<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_head=form_.project_name&project_id=form_.project_id');"></span>
													</div>
												</div>
										</div>
										<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
											<div class="col col-6">
												<div class="input-group">
													<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date, dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10">
													<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
												</div>
											</div>
											<div class="col col-6">
												<div class="input-group">
													<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date, dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10">
													<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="row ReportContentBorder">
							<div class="ReportContentFooter">
								<label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi Hatasi Mesaj'></cfsavecontent>
								<cfsavecontent variable="buttonMessage"><cf_get_lang dictionary_id='57911.Çalıştır'></cfsavecontent>
								<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" validate="integer" range="1,999" onKeyUp="isNumber(this)" required="yes" message="#message#" style="width:25px;">
								<input name="is_form" id="is_form" value="1" type="hidden">
								<cf_wrk_report_search_button  insert_info='#buttonMessage#' search_function='kontrol()' is_excel='1' button_type='1'>
							</div>
						</div>
					</div>
				</div>
		</cfform>
	</cf_report_list_search_area>
</cf_report_list_search>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
		<cfset filename = "detail_credit_report#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
		<cfheader name="Expires" value="#Now()#">
		<cfcontent type="application/vnd.msexcel;charset=utf-8">
		<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
		<meta http-equiv="content-type" content="text/plain; charset=utf-8">
	</cfif>
<cfif IsDefined("attributes.is_form")>
<cf_report_list >
	
	<cfsavecontent variable="excel_icerik">
	<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
		<!-- sil -->
		<cfset attributes.startrow=1>
		<cfset attributes.maxrows=get_credit_contract_payments.recordcount>
	</cfif>
	<!--- Satir Bazinda --->
	<cfif attributes.listing_type eq 2>
		<cfoutput query="get_money_rate">
			<!--- tahsilat planlanan/gerceklesen --->
			<!--- planlanan --->
			<cfset "tahsilat_plan_ana_para_#money#" = 0>
			<cfset "tahsilat_plan_faiz_#money#" = 0>
			<cfset "tahsilat_plan_vergi_masraf_#money#" = 0>
			<cfset "tahsilat_plan_delay_#money#" = 0>
			<cfset "tahsilat_plan_toplam_#money#" = 0>
			<cfset "tahsilat_plan_average_date_#money#" = 0>
			<!--- gerceklesen --->
			<cfset "tahsilat_gercek_ana_para_#money#" = 0>
			<cfset "tahsilat_gercek_faiz_#money#" = 0>
			<cfset "tahsilat_gercek_vergi_masraf_#money#" = 0>
			<cfset "tahsilat_gercek_delay_#money#" = 0>
			<cfset "tahsilat_gercek_toplam_#money#" = 0>
			<cfset "tahsilat_gercek_average_date_#money#" = 0>
			<!--- odeme planlanan/gerceklesen --->
			<!--- planlanan --->
			<cfset "odeme_plan_ana_para_#money#" = 0>
			<cfset "odeme_plan_faiz_#money#" = 0>
			<cfset "odeme_plan_vergi_masraf_#money#" = 0>
			<cfset "odeme_plan_delay_#money#" = 0>
			<cfset "odeme_plan_toplam_#money#" = 0>
			<cfset "odeme_plan_average_date_#money#" = 0>
			<!--- gerceklesen --->
			<cfset "odeme_gercek_ana_para_#money#" = 0>
			<cfset "odeme_gercek_faiz_#money#" = 0>
			<cfset "odeme_gercek_vergi_masraf_#money#" = 0>
			<cfset "odeme_gercek_delay_#money#" = 0>
			<cfset "odeme_gercek_toplam_#money#" = 0>
			<cfset "odeme_gercek_average_date_#money#" = 0>
		</cfoutput>
			<thead>
				<tr>
					<th colspan="8"></th>
					<cfif (attributes.is_all_credits eq 0 or attributes.is_all_credits eq "")>
						
						<th colspan="7" class="form-title" style="text-align:center;"><cf_get_lang dictionary_id='58869.Planlanan'></th>
					</cfif>
					<cfif (attributes.is_all_credits eq 1 or attributes.is_all_credits eq "")>
						
						<th colspan="7" class="form-title" style="text-align:center;"><cf_get_lang dictionary_id='39725.Gerçekleşen'></th>
					</cfif>
				</tr>
				<tr>
					<th><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='59177.Kredi Tarihi'></th>
					<th><cf_get_lang dictionary_id='59178.Kredi No'></th>
					<th><cf_get_lang dictionary_id='59172.Kredi Türü'></th>
					<th><cf_get_lang dictionary_id='59171.Kredi Kurumu'></th>
					<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<th><cf_get_lang dictionary_id='57521.Banka'></th>
					<th><cf_get_lang dictionary_id='57845.Tahsilat'>/<cf_get_lang dictionary_id='57847.Ödeme'></th>
					<cfif (attributes.is_all_credits eq 0 or attributes.is_all_credits eq "")>
						
						<th><cf_get_lang dictionary_id='57742.Tarih'></th> <!--- Planlanan --->
						<th><cf_get_lang dictionary_id='59179.Ana Para'></th>
						<th><cf_get_lang dictionary_id='59180.Faiz'></th>
						<th><cf_get_lang dictionary_id='59181.Vergi'>/<cf_get_lang dictionary_id='58930.Masraf'></th>
						<th><cf_get_lang dictionary_id='39657.Gecikme'></th>
						<th><cf_get_lang dictionary_id='57492.Toplam'></th>
						<th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
					</cfif>
					<cfif (attributes.is_all_credits eq 1 or attributes.is_all_credits eq "")>
						
						<th><cf_get_lang dictionary_id='57742.Tarih'></th> <!--- Gerceklesen --->
						<th><cf_get_lang dictionary_id='59179.Ana Para'></th>
						<th><cf_get_lang dictionary_id='59180.Faiz'></th>
						<th><cf_get_lang dictionary_id='59181.Vergi'>/<cf_get_lang dictionary_id='58930.Masraf'></th>
						<th><cf_get_lang dictionary_id='39657.Gecikme'></th>
						<th><cf_get_lang dictionary_id='57492.Toplam'></th>
						<th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
					</cfif>
				</tr>
			</thead>
			<tbody>
				<cfif isdefined("attributes.is_form") and get_credit_contract_payments.recordcount>
					<cfoutput query="get_credit_contract_payments" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td>#dateFormat(credit_date,dateformat_style)#</td>
							<td><a href="#request.self#?fuseaction=credit.list_credit_contract&event=det&credit_contract_id=#credit_contract_id#" target="_blank">#credit_no#</a></td>
							<td>#credit_type#</td>
							<td>#comp_name#</td>
							<td>#doc_detail#</td>
							<td>#bank_name#</td>
							<td><cfif credit_contract_type eq 2><cf_get_lang dictionary_id='57845.Tahsilat'><cfelse><cf_get_lang dictionary_id='57847.Ödeme'></cfif></td>
							<cfif credit_contract_type eq 2>
								<cfset "tahsilat_plan_ana_para_#other_money#" = evaluate("tahsilat_plan_ana_para_#other_money#") + plan_capital_price>
								<cfset "tahsilat_plan_faiz_#other_money#" = evaluate("tahsilat_plan_faiz_#other_money#") + plan_interest_price>
								<cfset "tahsilat_plan_vergi_masraf_#other_money#" = evaluate("tahsilat_plan_vergi_masraf_#other_money#") + plan_tax_price>
								<cfset "tahsilat_plan_delay_#other_money#" = evaluate("tahsilat_plan_delay_#other_money#") + plan_delay_price>
								<cfset "tahsilat_plan_toplam_#other_money#" = evaluate("tahsilat_plan_toplam_#other_money#") + plan_total_price>
								<cfset "tahsilat_plan_average_date_#other_money#" = evaluate("tahsilat_plan_average_date_#other_money#") + (dateDiff('d',now(),plan_process_date) * plan_total_price)>
								<cfset "tahsilat_gercek_ana_para_#other_money#" = evaluate("tahsilat_gercek_ana_para_#other_money#") + paid_capital_price>
								<cfset "tahsilat_gercek_faiz_#other_money#" = evaluate("tahsilat_gercek_faiz_#other_money#") + paid_interest_price>
								<cfset "tahsilat_gercek_vergi_masraf_#other_money#" = evaluate("tahsilat_gercek_vergi_masraf_#other_money#") + paid_tax_price>
								<cfset "tahsilat_gercek_delay_#other_money#" = evaluate("tahsilat_gercek_delay_#other_money#") + paid_delay_price>
								<cfset "tahsilat_gercek_toplam_#other_money#" = evaluate("tahsilat_gercek_toplam_#other_money#") + paid_total_price>
								<cfif dateFormat(paid_process_date,dateformat_style) neq '01/01/1900'><cfset "tahsilat_gercek_average_date_#other_money#" = evaluate("tahsilat_gercek_average_date_#other_money#") + (dateDiff('d',now(),paid_process_date) * paid_total_price)></cfif>
							<cfelse>
								<cfset "odeme_plan_ana_para_#other_money#" = evaluate("odeme_plan_ana_para_#other_money#") + plan_capital_price>
								<cfset "odeme_plan_faiz_#other_money#" = evaluate("odeme_plan_faiz_#other_money#") + plan_interest_price>
								<cfset "odeme_plan_vergi_masraf_#other_money#" = evaluate("odeme_plan_vergi_masraf_#other_money#") + plan_tax_price>
								<cfset "odeme_plan_toplam_#other_money#" = evaluate("odeme_plan_toplam_#other_money#") + plan_total_price>
								<cfset "odeme_plan_average_date_#other_money#" = evaluate("odeme_plan_average_date_#other_money#") + (dateDiff('d',now(),plan_process_date) * plan_total_price)>
								<cfset "odeme_gercek_ana_para_#other_money#" = evaluate("odeme_gercek_ana_para_#other_money#") + paid_capital_price>
								<cfset "odeme_gercek_faiz_#other_money#" = evaluate("odeme_gercek_faiz_#other_money#") + paid_interest_price>
								<cfset "odeme_gercek_vergi_masraf_#other_money#" = evaluate("odeme_gercek_vergi_masraf_#other_money#") + paid_delay_price>
								<cfset "odeme_gercek_toplam_#other_money#" = evaluate("odeme_gercek_toplam_#other_money#") + paid_total_price>
								<cfif dateFormat(paid_process_date,dateformat_style) neq '01/01/1900'><cfset "odeme_gercek_average_date_#other_money#" = evaluate("odeme_gercek_average_date_#other_money#") + (dateDiff('d',now(),paid_process_date) * paid_total_price)></cfif>
							</cfif>
							<cfif (attributes.is_all_credits eq 0 or attributes.is_all_credits eq "")>
								
								<td>#dateFormat(plan_process_date,dateformat_style)#</td>
								<td style="text-align:right;">#tlFormat(plan_capital_price,2)#</td>
								<td style="text-align:right;">#tlFormat(plan_interest_price,2)#</td>
								<td style="text-align:right;">#tlFormat(plan_tax_price,2)#</td>
								<td style="text-align:right;">#tlFormat(plan_delay_price,2)#</td>
								<td style="text-align:right;">#tlFormat(plan_total_price,2)#</td>
								<td>#other_money#</td>
							</cfif>
							<cfif (attributes.is_all_credits eq 1 or attributes.is_all_credits eq "")>
								
								<td><cfif dateFormat(paid_process_date,dateformat_style) neq '01/01/1900'>#dateFormat(paid_process_date,dateformat_style)#</cfif></td>
								<td style="text-align:right;"><cfif dateFormat(paid_process_date,dateformat_style) neq '01/01/1900'>#tlFormat(paid_capital_price,2)#</cfif></td>
								<td style="text-align:right;"><cfif dateFormat(paid_process_date,dateformat_style) neq '01/01/1900'>#tlFormat(paid_interest_price,2)#</cfif></td>
								<td style="text-align:right;"><cfif dateFormat(paid_process_date,dateformat_style) neq '01/01/1900'>#tlFormat(paid_tax_price,2)#</cfif></td>
								<td style="text-align:right;"><cfif dateFormat(paid_process_date,dateformat_style) neq '01/01/1900'>#tlFormat(paid_delay_price,2)#</cfif></td>
								<td style="text-align:right;"><cfif dateFormat(paid_process_date,dateformat_style) neq '01/01/1900'>#tlFormat(paid_total_price,2)#</cfif></td>
								<td><cfif dateFormat(paid_process_date,dateformat_style) neq '01/01/1900'>#other_money#</cfif></td>
							</cfif>
						</tr>	
					</cfoutput>
					<cfoutput>
					<tfoot>
						<tr>
							<td colspan="8" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57845.Tahsilat'></td>
							<cfif (attributes.is_all_credits eq 0 or attributes.is_all_credits eq "")>
								
								<td class="txtbold"><cfloop query="get_money_rate"><cfif evaluate('tahsilat_plan_toplam_#money#') gt 0>#dateFormat(date_add('d',evaluate('tahsilat_plan_average_date_#money#')/evaluate('tahsilat_plan_toplam_#money#'),now()),dateformat_style)#<br/></cfif></cfloop></td>
								<td class="txtbold" style="text-align:right;"><cfloop query="get_money_rate"><cfif evaluate('tahsilat_plan_ana_para_#money#') gt 0>#Tlformat(evaluate('tahsilat_plan_ana_para_#money#'),2)#<br/></cfif></cfloop></td>
								<td class="txtbold" style="text-align:right;"><cfloop query="get_money_rate"><cfif evaluate('tahsilat_plan_faiz_#money#') gt 0>#Tlformat(evaluate('tahsilat_plan_faiz_#money#'),2)#<br/></cfif></cfloop></td>
								<td class="txtbold" style="text-align:right;"><cfloop query="get_money_rate"><cfif evaluate('tahsilat_plan_vergi_masraf_#money#') gt 0>#Tlformat(evaluate('tahsilat_plan_vergi_masraf_#money#'),2)#<br/></cfif></cfloop></td>									
								<td></td>
								<td class="txtbold" style="text-align:right;"><cfloop query="get_money_rate"><cfif evaluate('tahsilat_plan_toplam_#money#') gt 0>#Tlformat(evaluate('tahsilat_plan_toplam_#money#'),2)#<br/></cfif></cfloop></td>
								<td class="txtbold"><cfloop query="get_money_rate"><cfif evaluate('tahsilat_plan_toplam_#money#') gt 0>&nbsp;#money#<br/></cfif></cfloop></td>
							</cfif>
							<cfif (attributes.is_all_credits eq 1 or attributes.is_all_credits eq "")>
								
								<td class="txtbold"><cfloop query="get_money_rate"><cfif evaluate('tahsilat_gercek_toplam_#money#') gt 0>#dateFormat(date_add('d',evaluate('tahsilat_gercek_average_date_#money#')/evaluate('tahsilat_gercek_toplam_#money#'),now()),dateformat_style)#<br/></cfif></cfloop></td>
								<td class="txtbold" style="text-align:right;"><cfloop query="get_money_rate"><cfif evaluate('tahsilat_gercek_ana_para_#money#') gt 0>#Tlformat(evaluate('tahsilat_gercek_ana_para_#money#'),2)#<br/></cfif></cfloop></td>
								<td class="txtbold" style="text-align:right;"><cfloop query="get_money_rate"><cfif evaluate('tahsilat_gercek_faiz_#money#') gt 0>#Tlformat(evaluate('tahsilat_gercek_faiz_#money#'),2)#<br/></cfif></cfloop></td>
								<td class="txtbold" style="text-align:right;"><cfloop query="get_money_rate"><cfif evaluate('tahsilat_gercek_vergi_masraf_#money#') gt 0>#Tlformat(evaluate('tahsilat_gercek_vergi_masraf_#money#'),2)#<br /></cfif></cfloop></td>									
								<td class="txtbold" style="text-align:right;"><cfloop query="get_money_rate"><cfif evaluate('tahsilat_gercek_delay_#money#') gt 0>#Tlformat(evaluate('tahsilat_gercek_delay_#money#'),2)#<br /></cfif></cfloop></td>									
								<td class="txtbold" style="text-align:right;"><cfloop query="get_money_rate"><cfif evaluate('tahsilat_gercek_toplam_#money#') gt 0>#Tlformat(evaluate('tahsilat_gercek_toplam_#money#'),2)#<br/></cfif></cfloop></td>
								<td class="txtbold"><cfloop query="get_money_rate"><cfif evaluate('tahsilat_gercek_toplam_#money#') gt 0>&nbsp;#money#<br/></cfif></cfloop></td>
							</cfif>
						</tr>
						</tfoot>
						<tfoot>
						<tr>
							<td colspan="8" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57847.Ödeme'></td>
							<cfif (attributes.is_all_credits eq 0 or attributes.is_all_credits eq "")>
								
								<td class="txtbold"><cfloop query="get_money_rate"><cfif evaluate('odeme_plan_toplam_#money#') gt 0>#dateFormat(date_add('d',evaluate('odeme_plan_average_date_#money#')/evaluate('odeme_plan_toplam_#money#'),now()),dateformat_style)#<br/></cfif></cfloop></td>
								<td class="txtbold" style="text-align:right;"><cfloop query="get_money_rate"><cfif evaluate('odeme_plan_ana_para_#money#') gt 0>#Tlformat(evaluate('odeme_plan_ana_para_#money#'),2)#<br/></cfif></cfloop></td>
								<td class="txtbold" style="text-align:right;"><cfloop query="get_money_rate"><cfif evaluate('odeme_plan_faiz_#money#') gt 0>#Tlformat(evaluate('odeme_plan_faiz_#money#'),2)#<br/></cfif></cfloop></td>
								<td class="txtbold" style="text-align:right;"><cfloop query="get_money_rate"><cfif evaluate('odeme_plan_vergi_masraf_#money#') gt 0>#Tlformat(evaluate('odeme_plan_vergi_masraf_#money#'),2)#<br/></cfif></cfloop></td>									
								<td></td>
								<td class="txtbold" style="text-align:right;"><cfloop query="get_money_rate"><cfif evaluate('odeme_plan_toplam_#money#') gt 0>#Tlformat(evaluate('odeme_plan_toplam_#money#'),2)#<br/></cfif></cfloop></td>
								<td class="txtbold"><cfloop query="get_money_rate"><cfif evaluate('odeme_plan_toplam_#money#') gt 0>&nbsp;#money#<br/></cfif></cfloop></td>
							</cfif>
							<cfif (attributes.is_all_credits eq 1 or attributes.is_all_credits eq "")> 
								
								<td class="txtbold"><cfloop query="get_money_rate"><cfif evaluate('odeme_gercek_toplam_#money#') gt 0>#dateFormat(date_add('d',evaluate('odeme_gercek_average_date_#money#')/evaluate('odeme_gercek_toplam_#money#'),now()),dateformat_style)#<br/></cfif></cfloop></td>
								<td class="txtbold" style="text-align:right;"><cfloop query="get_money_rate"><cfif evaluate('odeme_gercek_ana_para_#money#') gt 0>#Tlformat(evaluate('odeme_gercek_ana_para_#money#'),2)#<br/></cfif></cfloop></td>
								<td class="txtbold" style="text-align:right;"><cfloop query="get_money_rate"><cfif evaluate('odeme_gercek_faiz_#money#') gt 0>#Tlformat(evaluate('odeme_gercek_faiz_#money#'),2)#<br/></cfif></cfloop></td>
								<td class="txtbold" style="text-align:right;"><cfloop query="get_money_rate"><cfif evaluate('odeme_gercek_vergi_masraf_#money#') gt 0>#Tlformat(evaluate('odeme_gercek_vergi_masraf_#money#'),2)#<br/></cfif></cfloop></td>									
								<td></td>
								<td class="txtbold" style="text-align:right;"><cfloop query="get_money_rate"><cfif evaluate('odeme_gercek_toplam_#money#') gt 0>#Tlformat(evaluate('odeme_gercek_toplam_#money#'),2)#<br/></cfif></cfloop></td>
								<td class="txtbold"><cfloop query="get_money_rate"><cfif evaluate('odeme_gercek_toplam_#money#') gt 0>&nbsp;#money#<br/></cfif></cfloop></td>
							</cfif>
						</tr>
						</tfoot>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="24"><cfif not isdefined("attributes.is_form")><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		
	<cfelseif attributes.listing_type eq 1><!--- Belge Bazında --->
		<cfoutput query="get_money_rate">
			<cfset "plan_tah_ana_para_#money#" = 0>
			<cfset "plan_tah_faiz_#money#" = 0>
			<cfset "plan_tah_vergi_masraf_#money#" = 0>
			<cfset "plan_tah_delay_#money#" = 0>
			<cfset "plan_tah_toplam_#money#" = 0>
			<cfset "plan_tah_average_#money#" = 0>
			<cfset "plan_odeme_ana_para_#money#" = 0>
			<cfset "plan_odeme_faiz_#money#" = 0>
			<cfset "plan_odeme_vergi_masraf_#money#" = 0>
			<cfset "plan_odeme_delay_#money#" = 0>
			<cfset "plan_odeme_toplam_#money#" = 0>
			<cfset "plan_odeme_average_#money#" = 0>
			<cfset "gercek_tah_ana_para_#money#" = 0>
			<cfset "gercek_tah_faiz_#money#" = 0>
			<cfset "gercek_tah_vergi_masraf_#money#" = 0>
			<cfset "gercek_tah_delay_#money#" = 0>
			<cfset "gercek_tah_toplam_#money#" = 0>
			<cfset "gercek_tah_average_#money#" = 0>
			<cfset "gercek_odeme_ana_para_#money#" = 0>
			<cfset "gercek_odeme_faiz_#money#" = 0>
			<cfset "gercek_odeme_vergi_masraf_#money#" = 0>
			<cfset "gercek_odeme_delay_#money#" = 0>
			<cfset "gercek_odeme_toplam_#money#" = 0>
			<cfset "gercek_odeme_average_#money#" = 0>
            <!--- kalan tahsilat ve odeme --->
            <cfset "kalan_tahsilat_#money#" = 0>
            <cfset "kalan_odeme_#money#" = 0>
		</cfoutput>
		
			<thead>
				<tr>
					<th colspan="6"></th>
					<cfif attributes.is_all_credits eq 0 or attributes.is_all_credits eq "">
						
						<th colspan="<cfif attributes.credit_contract_type eq "">14<cfelse>7</cfif>" class="form-title" style="text-align:center;"><cf_get_lang dictionary_id='58869.Planlanan'></th>
					</cfif>
					<cfif attributes.is_all_credits eq 1 or attributes.is_all_credits eq "">
						
						<th colspan="<cfif attributes.credit_contract_type eq "">17<cfelse>9</cfif>" class="form-title" style="text-align:center;"><cf_get_lang dictionary_id='39725.Gerçekleşen'></th>
					</cfif>	
				</tr>
				<tr>
					<th colspan="6"></th>
					<cfif (attributes.is_all_credits eq 0 or attributes.is_all_credits eq "") and (attributes.credit_contract_type eq "" or attributes.credit_contract_type eq 2)>
						
						<th colspan="7" class="form-title" style="text-align:center;"><cf_get_lang dictionary_id='57845.Tahsilat'></th>
					</cfif>
					<cfif (attributes.is_all_credits eq 0 or attributes.is_all_credits eq "") and (attributes.credit_contract_type eq "" or attributes.credit_contract_type eq 1)>
					
						<th colspan="7" class="form-title" style="text-align:center;"><cf_get_lang dictionary_id='57847.Ödeme'></th>
					</cfif>
					<cfif (attributes.is_all_credits eq 1 or attributes.is_all_credits eq "") and (attributes.credit_contract_type eq "" or attributes.credit_contract_type eq 2)>
					
						<th colspan="8" class="form-title" style="text-align:center;"><cf_get_lang dictionary_id='57845.Tahsilat'></th>
					</cfif>
					<cfif (attributes.is_all_credits eq 1 or attributes.is_all_credits eq "") and (attributes.credit_contract_type eq "" or attributes.credit_contract_type eq 1)>						
						
						<th colspan="8" class="form-title" style="text-align:center;"><cf_get_lang dictionary_id='57847.Ödeme'></th>
					</cfif>
				</tr>
				<tr>
					<th><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='57742.Tarih'></th>
					<th><cf_get_lang dictionary_id='59178.Kredi No'></th>
					<th><cf_get_lang dictionary_id='59172.Kredi Türü'></th>
					<th><cf_get_lang dictionary_id='59171.Kredi Kurumu'></th>
					<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<cfif (attributes.is_all_credits eq 0 or attributes.is_all_credits eq "") and (attributes.credit_contract_type eq "" or attributes.credit_contract_type eq 2)>						
						<!--- Planlanan/Tahsilat --->
						
						<th><cf_get_lang dictionary_id='57742.Tarih'></th>
						<th><cf_get_lang dictionary_id='59179.Ana Para'></th>
						<th><cf_get_lang dictionary_id='59180.Faiz'></th>
						<th><cf_get_lang dictionary_id='59181.Vergi'>/<cf_get_lang dictionary_id='58930.Masraf'></th>
						<th><cf_get_lang dictionary_id='39657.Gecikme'></th>
						<th><cf_get_lang dictionary_id='57492.Toplam'></th>
						<th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
					</cfif>	
					<cfif (attributes.is_all_credits eq 0 or attributes.is_all_credits eq "") and (attributes.credit_contract_type eq "" or attributes.credit_contract_type eq 1)>						
						<!--- Planlanan/Odeme --->
						
						<th><cf_get_lang dictionary_id='57742.Tarih'></th>
						<th><cf_get_lang dictionary_id='59179.Ana Para'></th>
						<th><cf_get_lang dictionary_id='59180.Faiz'></th>
						<th><cf_get_lang dictionary_id='59181.Vergi'>/<cf_get_lang dictionary_id='58930.Masraf'></th>
						<th><cf_get_lang dictionary_id='39657.Gecikme'></th>
						<th><cf_get_lang dictionary_id='57492.Toplam'></th>
						<th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
					</cfif>
					<cfif (attributes.is_all_credits eq 1 or attributes.is_all_credits eq "") and (attributes.credit_contract_type eq "" or attributes.credit_contract_type eq 2)>						
						<!--- Gerceklesen/Tahsilat --->
						
						<th><cf_get_lang dictionary_id='57742.Tarih'></th>
						<th><cf_get_lang dictionary_id='59179.Ana Para'></th>
						<th><cf_get_lang dictionary_id='59180.Faiz'></th>
						<th><cf_get_lang dictionary_id='59181.Vergi'>/<cf_get_lang dictionary_id='58930.Masraf'></th>
						<th><cf_get_lang dictionary_id='39657.Gecikme'></th>
						<th><cf_get_lang dictionary_id='57492.Toplam'></th>
                        <th><cf_get_lang dictionary_id='58444.Kalan'> <cf_get_lang dictionary_id='57845.Tahsilat'></th>
						<th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
					</cfif>	
					<cfif (attributes.is_all_credits eq 1 or attributes.is_all_credits eq "") and (attributes.credit_contract_type eq "" or attributes.credit_contract_type eq 1)>
						<!--- Gerceklesen/Odeme --->
						
						<th><cf_get_lang dictionary_id='57742.Tarih'></th>
						<th><cf_get_lang dictionary_id='59179.Ana Para'></th>
						<th><cf_get_lang dictionary_id='59180.Faiz'></th>
						<th><cf_get_lang dictionary_id='59181.Vergi'>/<cf_get_lang dictionary_id='58930.Masraf'></th>
						<th><cf_get_lang dictionary_id='39657.Gecikme'></th>
						<th><cf_get_lang dictionary_id='57492.Toplam'></th>
                        <th><cf_get_lang dictionary_id='58444.Kalan'> <cf_get_lang dictionary_id='57847.Ödeme'></th>
						<th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
					</cfif>	
				</tr>
			</thead>
			<cfif isdefined("attributes.is_form") and get_credit_contract_payments.recordcount>
            <tbody>
                <cfoutput query="get_credit_contract_payments" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<!--- planlanan/tahsilat --->
                    <cfquery name="get_planlanan_tahsilat" dbtype="query">
                        SELECT
                            SUM(CAPITAL_PRICE) PLANLANAN_TAHSILAT_CAPITAL,
                            SUM(INTEREST_PRICE) PLANLANAN_TAHSILAT_INTEREST,
                            SUM(TAX_PRICE) PLANLANAN_TAHSILAT_TAX,
                            SUM(DELAY_PRICE) PLANLANAN_TAHSILAT_DELAY,
                            SUM(TOTAL_PRICE) PLANLANAN_TAHSILAT_TOTAL,
                            SUM(DIFF_VALUE)/SUM(TOTAL_PRICE) DIFF_
                        FROM
                            get_prices
                        WHERE
                            CREDIT_CONTRACT_TYPE = 2 AND
                            CREDIT_CONTRACT_ID = #credit_contract_id# AND
                            IS_PAID = 0
                        HAVING
                            SUM(TOTAL_PRICE)>0
                    </cfquery>
                    <!--- planlanan/odeme --->
                    <cfquery name="get_planlanan_odeme" dbtype="query">
                        SELECT
                            SUM(CAPITAL_PRICE) PLANLANAN_ODEME_CAPITAL,
                            SUM(INTEREST_PRICE) PLANLANAN_ODEME_INTEREST,
                            SUM(TAX_PRICE) PLANLANAN_ODEME_TAX,
                            SUM(DELAY_PRICE) PLANLANAN_ODEME_DELAY,
                            SUM(TOTAL_PRICE) PLANLANAN_ODEME_TOTAL,
                            SUM(DIFF_VALUE)/SUM(TOTAL_PRICE) DIFF_
                        FROM
                            get_prices
                        WHERE
                            CREDIT_CONTRACT_TYPE = 1 AND
                            CREDIT_CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#credit_contract_id#"> AND
                            IS_PAID = 0
                        HAVING
                            SUM(TOTAL_PRICE)>0
                    </cfquery>
                    <!--- gerceklesen/tahsilat --->
                    <cfquery name="get_gerceklesen_tahsilat" dbtype="query">
                        SELECT
                            SUM(CAPITAL_PRICE) GERCEKLESEN_TAHSILAT_CAPITAL,
                            SUM(INTEREST_PRICE) GERCEKLESEN_TAHSILAT_INTEREST,
                            SUM(TAX_PRICE) GERCEKLESEN_TAHSILAT_TAX,
                            SUM(DELAY_PRICE) GERCEKLESEN_TAHSILAT_DELAY,
                            SUM(TOTAL_PRICE) GERCEKLESEN_TAHSILAT_TOTAL,
                            SUM(DIFF_VALUE)/SUM(TOTAL_PRICE) DIFF_
                        FROM
                            get_prices
                        WHERE
                            CREDIT_CONTRACT_TYPE = 2 AND
                            CREDIT_CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#credit_contract_id#"> AND
                            IS_PAID = 1
                        HAVING
                            SUM(TOTAL_PRICE)>0
                    </cfquery>
                    <!--- gerceklesen/odeme --->
                    <cfquery name="get_gerceklesen_odeme" dbtype="query">
                        SELECT
                            SUM(CAPITAL_PRICE) GERCEKLESEN_ODEME_CAPITAL,
                            SUM(INTEREST_PRICE) GERCEKLESEN_ODEME_INTEREST,
                            SUM(TAX_PRICE) GERCEKLESEN_ODEME_TAX,
                            SUM(DELAY_PRICE) GERCEKLESEN_ODEME_DELAY,
                            SUM(TOTAL_PRICE) GERCEKLESEN_ODEME_TOTAL,
                            SUM(DIFF_VALUE)/SUM(TOTAL_PRICE) DIFF_
                        FROM
                            get_prices
                        WHERE
                            CREDIT_CONTRACT_TYPE = 1 AND
                            CREDIT_CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#credit_contract_id#"> AND
                            IS_PAID = 1
                        HAVING
                            SUM(TOTAL_PRICE)>0
                    </cfquery>
                    <!--- kalan tahsilat --->
                    <cfif len(get_planlanan_tahsilat.planlanan_tahsilat_total)>
						<cfset planlanan_tahsilat_ = get_planlanan_tahsilat.planlanan_tahsilat_total>
                        <cfset "kalan_tahsilat_#money_type#" = evaluate("kalan_tahsilat_#money_type#") + get_planlanan_tahsilat.planlanan_tahsilat_total>
                    <cfelse>
                        <cfset planlanan_tahsilat_ = 0>	
                    </cfif>
                    <cfif len(get_gerceklesen_tahsilat.gerceklesen_tahsilat_total)>
                        <cfset gerceklesen_tahsilat_ = get_gerceklesen_tahsilat.gerceklesen_tahsilat_total>
                        <cfset "kalan_tahsilat_#money_type#" = evaluate("kalan_tahsilat_#money_type#") - get_gerceklesen_tahsilat.gerceklesen_tahsilat_total>
                    <cfelse>
                        <cfset gerceklesen_tahsilat_ = 0>
                    </cfif>
                    <!--- kalan odeme ---> 
                    <cfif len(get_planlanan_odeme.planlanan_odeme_total)>
						<cfset planlanan_odeme_ = get_planlanan_odeme.planlanan_odeme_total>
                        <cfset "kalan_odeme_#money_type#" = evaluate("kalan_odeme_#money_type#") + get_planlanan_odeme.planlanan_odeme_total>
                    <cfelse>
                        <cfset planlanan_odeme_ = 0>	
                    </cfif>
                    <cfif len(get_gerceklesen_odeme.gerceklesen_odeme_total)>
                        <cfset gerceklesen_odeme_ = get_gerceklesen_odeme.gerceklesen_odeme_total>
                        <cfset "kalan_odeme_#money_type#" = evaluate("kalan_odeme_#money_type#") - get_gerceklesen_odeme.gerceklesen_odeme_total>
                    <cfelse>
                        <cfset gerceklesen_odeme_ = 0>
                    </cfif>
                    <tr>
                        <td>#currentrow#</td>
                        <td>#dateFormat(credit_date,dateformat_style)#</td>
                        <td><a href="#request.self#?fuseaction=credit.list_credit_contract&event=det&credit_contract_id=#credit_contract_id#" target="_blank">#credit_no#</a></td>
                        <td>#credit_type#</td>
                        <td>#comp_name#</td>
                        <td>#doc_detail#</td>
                        <cfif (attributes.is_all_credits eq 0 or attributes.is_all_credits eq "") and (attributes.credit_contract_type eq "" or attributes.credit_contract_type eq 2)>
                            <!--- planlanan/tahsilat --->
                            
                            <td><cfif len(get_planlanan_tahsilat.DIFF_) and isnumeric(get_planlanan_tahsilat.DIFF_)>#dateFormat(dateadd('d',get_planlanan_tahsilat.DIFF_,now()),dateformat_style)#</cfif></td>
                            <td style="text-align:right;"><cfif len(get_planlanan_tahsilat.planlanan_tahsilat_capital)>#tlFormat(get_planlanan_tahsilat.planlanan_tahsilat_capital,2)# <cfset "plan_tah_ana_para_#money_type#" = evaluate("plan_tah_ana_para_#money_type#") + get_planlanan_tahsilat.planlanan_tahsilat_capital><cfelse>0,00</cfif></td>
                            <td style="text-align:right;"><cfif len(get_planlanan_tahsilat.planlanan_tahsilat_interest)>#tlFormat(get_planlanan_tahsilat.planlanan_tahsilat_interest,2)# <cfset "plan_tah_faiz_#money_type#" = evaluate("plan_tah_faiz_#money_type#") + get_planlanan_tahsilat.planlanan_tahsilat_interest><cfelse>0,00</cfif></td>
                            <td style="text-align:right;"><cfif len(get_planlanan_tahsilat.planlanan_tahsilat_tax)>#tlFormat(get_planlanan_tahsilat.planlanan_tahsilat_tax,2)# <cfset "plan_tah_vergi_masraf_#money_type#" = evaluate("plan_tah_vergi_masraf_#money_type#") + get_planlanan_tahsilat.planlanan_tahsilat_tax><cfelse>0,00</cfif></td>
                            <td style="text-align:right;"><cfif len(get_planlanan_tahsilat.planlanan_tahsilat_delay)>#tlFormat(get_planlanan_tahsilat.planlanan_tahsilat_delay,2)# <cfset  "plan_tah_delay_#money_type#" = evaluate("plan_tah_delay_#money_type#") + get_planlanan_tahsilat.planlanan_tahsilat_delay><cfelse>0,00</cfif></td>
                            <td style="text-align:right;"><cfif len(get_planlanan_tahsilat.planlanan_tahsilat_total)>#tlFormat(get_planlanan_tahsilat.planlanan_tahsilat_total,2)# <cfset "plan_tah_toplam_#money_type#" = evaluate("plan_tah_toplam_#money_type#") + get_planlanan_tahsilat.planlanan_tahsilat_total><cfelse>0,00</cfif></td>
                            <td>#money_type#</td>
                            <cfif len(get_planlanan_tahsilat.planlanan_tahsilat_total)><cfset "plan_tah_average_#money_type#" = evaluate("plan_tah_average_#money_type#") + (datediff('d',now(),dateadd('d',get_planlanan_tahsilat.DIFF_,now()))*get_planlanan_tahsilat.planlanan_tahsilat_total)></cfif>
                        </cfif>
                        <cfif (attributes.is_all_credits eq 0 or attributes.is_all_credits eq "") and (attributes.credit_contract_type eq "" or attributes.credit_contract_type eq 1)>				
                            <!--- planlanan/odeme --->
                           
                            <td><cfif len(get_planlanan_odeme.DIFF_) and isnumeric(get_planlanan_odeme.DIFF_)>#dateFormat(dateadd('d',get_planlanan_odeme.DIFF_,now()),dateformat_style)#</cfif></td>
                            <td style="text-align:right;"><cfif len(get_planlanan_odeme.planlanan_odeme_capital)>#tlFormat(get_planlanan_odeme.planlanan_odeme_capital,2)# <cfset "plan_odeme_ana_para_#money_type#" = evaluate("plan_odeme_ana_para_#money_type#") + get_planlanan_odeme.planlanan_odeme_capital><cfelse>0,00</cfif></td>
                            <td style="text-align:right;"><cfif len(get_planlanan_odeme.planlanan_odeme_interest)>#tlFormat(get_planlanan_odeme.planlanan_odeme_interest,2)# <cfset "plan_odeme_faiz_#money_type#" = evaluate("plan_odeme_faiz_#money_type#") + get_planlanan_odeme.planlanan_odeme_interest><cfelse>0,00</cfif></td>
                            <td style="text-align:right;"><cfif len(get_planlanan_odeme.planlanan_odeme_tax)>#tlFormat(get_planlanan_odeme.planlanan_odeme_tax,2)# <cfset "plan_odeme_vergi_masraf_#money_type#" = evaluate("plan_odeme_vergi_masraf_#money_type#") + get_planlanan_odeme.planlanan_odeme_tax><cfelse>0,00</cfif></td>
                            <td style="text-align:right;"><cfif len(get_planlanan_odeme.planlanan_odeme_delay)>#tlFormat(get_planlanan_odeme.planlanan_odeme_delay,2)# <cfset "plan_odeme_delay_#money_type#" = evaluate("plan_odeme_delay_#money_type#") + get_planlanan_odeme.planlanan_odeme_delay><cfelse>0,00</cfif></td>
                            <td style="text-align:right;"><cfif len(get_planlanan_odeme.planlanan_odeme_total)>#tlFormat(get_planlanan_odeme.planlanan_odeme_total,2)# <cfset "plan_odeme_toplam_#money_type#" = evaluate("plan_odeme_toplam_#money_type#") + get_planlanan_odeme.planlanan_odeme_total><cfelse>0,00</cfif></td>
                            <td>#money_type#</td>
                            <cfif len(get_planlanan_odeme.planlanan_odeme_total)><cfset "plan_odeme_average_#money_type#" = evaluate("plan_odeme_average_#money_type#") + (datediff('d',now(),dateadd('d',get_planlanan_odeme.DIFF_,now()))*get_planlanan_odeme.planlanan_odeme_total)></cfif>
                        </cfif>
                        <cfif (attributes.is_all_credits eq 1 or attributes.is_all_credits eq "") and (attributes.credit_contract_type eq "" or attributes.credit_contract_type eq 2)>								
                            <!--- gerceklesen/tahsilat --->
                          
                            <td><cfif len(get_gerceklesen_tahsilat.DIFF_) and isnumeric(get_gerceklesen_tahsilat.DIFF_)>#dateFormat(dateadd('d',get_gerceklesen_tahsilat.DIFF_,now()),dateformat_style)#</cfif></td>
                            <td style="text-align:right;"><cfif len(get_gerceklesen_tahsilat.gerceklesen_tahsilat_capital)>#tlFormat(get_gerceklesen_tahsilat.gerceklesen_tahsilat_capital,2)# <cfset "gercek_tah_ana_para_#money_type#" = evaluate("gercek_tah_ana_para_#money_type#") + get_gerceklesen_tahsilat.gerceklesen_tahsilat_capital><cfelse>0,00</cfif></td>
                            <td style="text-align:right;"><cfif len(get_gerceklesen_tahsilat.gerceklesen_tahsilat_interest)>#tlFormat(get_gerceklesen_tahsilat.gerceklesen_tahsilat_interest,2)# <cfset "gercek_tah_faiz_#money_type#" = evaluate("gercek_tah_faiz_#money_type#") + get_gerceklesen_tahsilat.gerceklesen_tahsilat_interest><cfelse>0,00</cfif></td>
                            <td style="text-align:right;"><cfif len(get_gerceklesen_tahsilat.gerceklesen_tahsilat_tax)>#tlFormat(get_gerceklesen_tahsilat.gerceklesen_tahsilat_tax,2)# <cfset "gercek_tah_vergi_masraf_#money_type#" = evaluate("gercek_tah_vergi_masraf_#money_type#") + get_gerceklesen_tahsilat.gerceklesen_tahsilat_tax><cfelse>0,00</cfif></td>
                            <td style="text-align:right;"><cfif len(get_gerceklesen_tahsilat.gerceklesen_tahsilat_delay)>#tlFormat(get_gerceklesen_tahsilat.gerceklesen_tahsilat_delay,2)# <cfset "gercek_tah_delay_#money_type#" = evaluate("gercek_tah_delay_#money_type#") + get_gerceklesen_tahsilat.gerceklesen_tahsilat_delay><cfelse>0,00</cfif></td>
                            <td style="text-align:right;"><cfif len(get_gerceklesen_tahsilat.gerceklesen_tahsilat_total)>#tlFormat(get_gerceklesen_tahsilat.gerceklesen_tahsilat_total,2)# <cfset "gercek_tah_toplam_#money_type#" = evaluate("gercek_tah_toplam_#money_type#") + get_gerceklesen_tahsilat.gerceklesen_tahsilat_total><cfelse>0,00</cfif></td>
                            <td style="text-align:right;">#tlFormat(planlanan_tahsilat_-gerceklesen_tahsilat_,2)#</td>
                            <td>#money_type#</td>
                            <cfif len(get_gerceklesen_tahsilat.gerceklesen_tahsilat_total)><cfset "gercek_tah_average_#money_type#" = evaluate("gercek_tah_average_#money_type#") + (datediff('d',now(),dateadd('d',get_gerceklesen_tahsilat.DIFF_,now()))*get_gerceklesen_tahsilat.gerceklesen_tahsilat_total)></cfif>
                        </cfif>
                        <cfif (attributes.is_all_credits eq 1 or attributes.is_all_credits eq "") and (attributes.credit_contract_type eq "" or attributes.credit_contract_type eq 1)>								
                            <!--- gerceklesen/odeme --->
                        
                            <td><cfif len(get_gerceklesen_odeme.DIFF_) and isnumeric(get_gerceklesen_odeme.DIFF_)>#dateFormat(dateadd('d',get_gerceklesen_odeme.DIFF_,now()),dateformat_style)#</cfif></td>
                            <td style="text-align:right;"><cfif len(get_gerceklesen_odeme.gerceklesen_odeme_capital)>#tlFormat(get_gerceklesen_odeme.gerceklesen_odeme_capital,2)# <cfset "gercek_odeme_ana_para_#money_type#" = evaluate("gercek_odeme_ana_para_#money_type#") + get_gerceklesen_odeme.gerceklesen_odeme_capital><cfelse>0,00</cfif></td>
                            <td style="text-align:right;"><cfif len(get_gerceklesen_odeme.gerceklesen_odeme_interest)>#tlFormat(get_gerceklesen_odeme.gerceklesen_odeme_interest,2)# <cfset "gercek_odeme_faiz_#money_type#" = evaluate("gercek_odeme_faiz_#money_type#") + get_gerceklesen_odeme.gerceklesen_odeme_interest><cfelse>0,00</cfif></td>
                            <td style="text-align:right;"><cfif len(get_gerceklesen_odeme.gerceklesen_odeme_tax)>#tlFormat(get_gerceklesen_odeme.gerceklesen_odeme_tax,2)# <cfset "gercek_odeme_vergi_masraf_#money_type#" = evaluate("gercek_odeme_vergi_masraf_#money_type#") + get_gerceklesen_odeme.gerceklesen_odeme_tax><cfelse>0,00</cfif></td>
                            <td style="text-align:right;"><cfif len(get_gerceklesen_odeme.gerceklesen_odeme_delay)>#tlFormat(get_gerceklesen_odeme.gerceklesen_odeme_delay,2)# <cfset  "gercek_odeme_delay_#money_type#" = evaluate("gercek_odeme_delay_#money_type#") + get_gerceklesen_odeme.gerceklesen_odeme_delay><cfelse>0,00</cfif></td>
                            <td style="text-align:right;"><cfif len(get_gerceklesen_odeme.gerceklesen_odeme_total)>#tlFormat(get_gerceklesen_odeme.gerceklesen_odeme_total,2)# <cfset "gercek_odeme_toplam_#money_type#" = evaluate("gercek_odeme_toplam_#money_type#") + get_gerceklesen_odeme.gerceklesen_odeme_total><cfelse>0,00</cfif></td>
                            <td style="text-align:right;">#tlFormat(planlanan_odeme_-gerceklesen_odeme_,2)#</td>
                            <td>#money_type#</td>
                            <cfif len(get_gerceklesen_odeme.gerceklesen_odeme_total)><cfset "gercek_odeme_average_#money_type#" = evaluate("gercek_odeme_average_#money_type#") + (datediff('d',now(),dateadd('d',get_gerceklesen_odeme.DIFF_,now()))*get_gerceklesen_odeme.gerceklesen_odeme_total)></cfif>
                        </cfif>
                    </tr>	
                </cfoutput>
            </tbody>
            <tfoot>
                <cfoutput>
                    <tr>
                        <td colspan="6" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></td>
                        <cfif (attributes.is_all_credits eq 0 or attributes.is_all_credits eq "") and (attributes.credit_contract_type eq "" or attributes.credit_contract_type eq 2)>
                            
                            <td class="txtbold"><cfloop query="get_money_rate"><cfif evaluate('plan_tah_toplam_#money#') gt 0>#dateFormat(date_add('d',evaluate('plan_tah_average_#money#')/evaluate('plan_tah_toplam_#money#'),now()),dateformat_style)#<br/></cfif></cfloop></td>
                            <td class="txtbold" style="text-align:right;"><cfloop query="get_money_rate"><cfif evaluate('plan_tah_ana_para_#money#') gt 0>#Tlformat(evaluate('plan_tah_ana_para_#money#'),2)#<br/></cfif></cfloop></td>
                            <td class="txtbold" style="text-align:right;"><cfloop query="get_money_rate"><cfif evaluate('plan_tah_faiz_#money#') gt 0>#Tlformat(evaluate('plan_tah_faiz_#money#'),2)#<br/></cfif></cfloop></td>
                            <td class="txtbold" style="text-align:right;"><cfloop query="get_money_rate"><cfif evaluate('plan_tah_vergi_masraf_#money#') gt 0>#Tlformat(evaluate('plan_tah_vergi_masraf_#money#'),2)#<br/></cfif></cfloop></td>
                            <td class="txtbold" style="text-align:right;"><cfloop query="get_money_rate"><cfif evaluate('plan_tah_delay_#money#') gt 0>#Tlformat(evaluate('plan_tah_delay_#money#'),2)#<br/></cfif></cfloop></td>
                            <td class="txtbold" style="text-align:right;"><cfloop query="get_money_rate"><cfif evaluate('plan_tah_toplam_#money#') gt 0>#Tlformat(evaluate('plan_tah_toplam_#money#'),2)#<br/></cfif></cfloop></td>
                            <td class="txtbold"><cfloop query="get_money_rate"><cfif evaluate('plan_tah_toplam_#money#') gt 0>&nbsp;#money#<br/></cfif></cfloop></td>
                        </cfif>
                        <cfif (attributes.is_all_credits eq 0 or attributes.is_all_credits eq "") and (attributes.credit_contract_type eq "" or attributes.credit_contract_type eq 1)>								
                          
                            <td class="txtbold"><cfloop query="get_money_rate"><cfif evaluate('plan_odeme_toplam_#money#') gt 0>#dateFormat(date_add('d',evaluate('plan_odeme_average_#money#')/evaluate('plan_odeme_toplam_#money#'),now()),dateformat_style)#<br/></cfif></cfloop></td>
                            <td class="txtbold" style="text-align:right;"><cfloop query="get_money_rate"><cfif evaluate('plan_odeme_ana_para_#money#') gt 0>#Tlformat(evaluate('plan_odeme_ana_para_#money#'),2)#<br/></cfif></cfloop></td>
                            <td class="txtbold" style="text-align:right;"><cfloop query="get_money_rate"><cfif evaluate('plan_odeme_faiz_#money#') gt 0>#Tlformat(evaluate('plan_odeme_faiz_#money#'),2)#<br/></cfif></cfloop></td>
                            <td class="txtbold" style="text-align:right;"><cfloop query="get_money_rate"><cfif evaluate('plan_odeme_vergi_masraf_#money#') gt 0>#Tlformat(evaluate('plan_odeme_vergi_masraf_#money#'),2)#<br/></cfif></cfloop></td>
                            <td class="txtbold" style="text-align:right;"><cfloop query="get_money_rate"><cfif evaluate('plan_odeme_delay_#money#') gt 0>#Tlformat(evaluate('plan_odeme_delay_#money#'),2)#<br/></cfif></cfloop></td>
                            <td class="txtbold" style="text-align:right;"><cfloop query="get_money_rate"><cfif evaluate('plan_odeme_toplam_#money#') gt 0>#Tlformat(evaluate('plan_odeme_toplam_#money#'),2)#<br/></cfif></cfloop></td>
                            <td class="txtbold"><cfloop query="get_money_rate"><cfif evaluate('plan_odeme_toplam_#money#') gt 0>&nbsp;#money#<br/></cfif></cfloop></td>
                        </cfif>
                        <cfif (attributes.is_all_credits eq 1 or attributes.is_all_credits eq "") and (attributes.credit_contract_type eq "" or attributes.credit_contract_type eq 2)>								
                           
                            <td class="txtbold"><cfloop query="get_money_rate"><cfif evaluate('gercek_tah_toplam_#money#') gt 0>#dateFormat(date_add('d',evaluate('gercek_tah_average_#money#')/evaluate('gercek_tah_toplam_#money#'),now()),dateformat_style)#<br/></cfif></cfloop></td>
                            <td class="txtbold" style="text-align:right;"><cfloop query="get_money_rate"><cfif evaluate('gercek_tah_ana_para_#money#') gt 0>#Tlformat(evaluate('gercek_tah_ana_para_#money#'),2)#<br/></cfif></cfloop></td>
                            <td class="txtbold" style="text-align:right;"><cfloop query="get_money_rate"><cfif evaluate('gercek_tah_faiz_#money#') gt 0>#Tlformat(evaluate('gercek_tah_faiz_#money#'),2)#<br/></cfif></cfloop></td>
                            <td class="txtbold" style="text-align:right;"><cfloop query="get_money_rate"><cfif evaluate('gercek_tah_vergi_masraf_#money#') gt 0>#Tlformat(evaluate('gercek_tah_vergi_masraf_#money#'),2)#<br/></cfif></cfloop></td>
                            <td class="txtbold" style="text-align:right;"><cfloop query="get_money_rate"><cfif evaluate('gercek_tah_delay_#money#') gt 0>#Tlformat(evaluate('gercek_tah_delay_#money#'),2)#<br/></cfif></cfloop></td>
                            <td class="txtbold" style="text-align:right;"><cfloop query="get_money_rate"><cfif evaluate('gercek_tah_toplam_#money#') gt 0>#Tlformat(evaluate('gercek_tah_toplam_#money#'),2)#<br/></cfif></cfloop></td>
                            <td class="txtbold" style="text-align:right;"><cfloop query="get_money_rate"><cfif evaluate('kalan_tahsilat_#money#') NEQ 0>#Tlformat(evaluate('kalan_tahsilat_#money#'),2)#<br/></cfif></cfloop></td>
                            <td class="txtbold"><cfloop query="get_money_rate"><cfif evaluate('gercek_tah_toplam_#money#') gt 0>&nbsp;#money#<br/></cfif></cfloop></td>
                        </cfif>
                        <cfif (attributes.is_all_credits eq 1 or attributes.is_all_credits eq "") and (attributes.credit_contract_type eq "" or attributes.credit_contract_type eq 1)>								
                           
                            <td class="txtbold"><cfloop query="get_money_rate"><cfif evaluate('gercek_odeme_toplam_#money#') gt 0>#dateFormat(date_add('d',evaluate('gercek_odeme_average_#money#')/evaluate('gercek_odeme_toplam_#money#'),now()),dateformat_style)#<br/></cfif></cfloop></td>
                            <td class="txtbold" style="text-align:right;"><cfloop query="get_money_rate"><cfif evaluate('gercek_odeme_ana_para_#money#') gt 0>#Tlformat(evaluate('gercek_odeme_ana_para_#money#'),2)#<br/></cfif></cfloop></td>
                            <td class="txtbold" style="text-align:right;"><cfloop query="get_money_rate"><cfif evaluate('gercek_odeme_faiz_#money#') gt 0>#Tlformat(evaluate('gercek_odeme_faiz_#money#'),2)#<br/></cfif></cfloop></td>
                            <td class="txtbold" style="text-align:right;"><cfloop query="get_money_rate"><cfif evaluate('gercek_odeme_vergi_masraf_#money#') gt 0>#Tlformat(evaluate('gercek_odeme_vergi_masraf_#money#'),2)#<br/></cfif></cfloop></td>
                            <td class="txtbold" style="text-align:right;"><cfloop query="get_money_rate"><cfif evaluate('gercek_odeme_delay_#money#') gt 0>#Tlformat(evaluate('gercek_odeme_delay_#money#'),2)#<br/></cfif></cfloop></td>
                            <td class="txtbold" style="text-align:right;"><cfloop query="get_money_rate"><cfif evaluate('gercek_odeme_toplam_#money#') gt 0>#Tlformat(evaluate('gercek_odeme_toplam_#money#'),2)#<br/></cfif></cfloop></td>
                            <td class="txtbold" style="text-align:right;"><cfloop query="get_money_rate"><cfif evaluate('kalan_odeme_#money#') NEQ 0>#Tlformat(evaluate('kalan_odeme_#money#'),2)#<br/></cfif></cfloop></td>
                            <td class="txtbold"><cfloop query="get_money_rate"><cfif evaluate('gercek_odeme_toplam_#money#') gt 0>&nbsp;#money#<br/></cfif></cfloop></td>
                        </cfif>
                    </tr>
                </cfoutput>
            </tfoot>
            <cfelse>
                <tr>
                    <td class="color-row" colspan="40"><cfif not isdefined("attributes.is_form")><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</cfif></td>
                </tr>
            </cfif>
		
	</cfif>
	<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
			<!-- sil -->
		</cfif>
	</cfsavecontent>
	<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
		<cfoutput>#wrk_content_clear(excel_icerik)#</cfoutput>
	<cfelse>
		<cfoutput>#excel_icerik#</cfoutput>
	</cfif>
</cf_report_list>
</cfif>		
<cfif isdefined("attributes.is_form")> 
	<cfset url_str = "report.detail_credit_report&is_form=1">
	<cfif len(attributes.credit_type_id)>
		<cfset url_str = '#url_str#&credit_type_id=#attributes.credit_type_id#'>
	</cfif>
	<cfif len(attributes.credit_limit_id)>
		<cfset url_str = '#url_str#&credit_limit_id=#attributes.credit_limit_id#'>
	</cfif>
	<cfif len(attributes.process_type)>
		<cfset url_str = '#url_str#&process_type=#attributes.process_type#'>
	</cfif>
	<cfif len(attributes.company_id)>
		<cfset url_str = '#url_str#&company_id=#attributes.company_id#'>
	</cfif>
	<cfif len(attributes.company)>
		<cfset url_str = '#url_str#&company=#attributes.company#'>
	</cfif>
	<cfif len(attributes.is_all_credits)>
		<cfset url_str = '#url_str#&is_all_credits=#attributes.is_all_credits#'>
	</cfif>
	<cfif len(attributes.credit_contract_type)>
		<cfset url_str = '#url_str#&credit_contract_type=#attributes.credit_contract_type#'>
	</cfif>
	<cfif len(attributes.listing_type)>
		<cfset url_str = '#url_str#&listing_type=#attributes.listing_type#'>
	</cfif>
	<cfif len(attributes.project_id)>
		<cfset url_str = '#url_str#&project_id=#attributes.project_id#'>
	</cfif>
	<cfif len(attributes.project_name)>
		<cfset url_str = '#url_str#&project_name=#attributes.project_name#'>
	</cfif>
	<cfif len(attributes.pos_code)>
		<cfset url_str = '#url_str#&pos_code=#attributes.pos_code#'>
	</cfif>
	<cfif len(attributes.pos_manager)>
		<cfset url_str = '#url_str#&pos_manager=#attributes.pos_manager#'>
	</cfif>
	<cfif len(attributes.start_date)>
		<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
	</cfif>
	<cfif len(attributes.finish_date)>
		<cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
	</cfif>
	<cfif len(attributes.is_tahsil_edildi)>
		<cfset url_str = '#url_str#&is_tahsil_edildi=#attributes.is_tahsil_edildi#'>
	</cfif>
	<cfif len(attributes.is_odendi)>
		<cfset url_str = '#url_str#&is_odendi=#attributes.is_odendi#'>
	</cfif>
	<cfif len(attributes.is_planlanan_row)>
		<cfset url_str = '#url_str#&is_planlanan_row=#attributes.is_planlanan_row#'>
	</cfif>
	<cfif attributes.totalrecords gt attributes.maxrows>
		<cf_paging 
					page="#attributes.page#"
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="#url_str#"></td>
				
	 </cfif>
</cfif>

<script type="text/javascript">
	function kontrol()
	{
		if ((document.form_.start_date.value != '') && (document.form_.finish_date.value != '') &&
	    !date_check(form_.start_date,form_.finish_date,"<cf_get_lang dictionary_id ='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
	         return false;
		if((document.getElementById('is_odendi').value != '' || document.getElementById('is_tahsil_edildi').value != ''|| document.getElementById('is_planlanan_row').value != '') && document.getElementById('listing_type').value != 2)
		{
			alert ("<cf_get_lang dictionary_id='60671.Tahsilat, Ödeme Durumu ve Plan Satırı İçin Satır Bazında Listeleme Yapmalısınız'>!");
			return false;	
		}
		if(document.getElementById('is_excel').checked == false)
			if(document.getElementById('maxrows').value > 1000)
			{
				alert ("<cf_get_lang dictionary_id ='40286.Görüntüleme Sayısı 1000 den fazla olamaz'>!");
				return false;
			}
		if(document.getElementById('is_excel').checked==false)
		{
			document.form_.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.detail_credit_report</cfoutput>";
			return true;
		}
		else
			document.form_.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_detail_credit_report</cfoutput>";
	}
</script>

