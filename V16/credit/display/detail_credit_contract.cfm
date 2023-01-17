<!--- sözleşme detayları --->
<cfquery name="GET_CREDIT_CONTRACT" datasource="#dsn3#">
	SELECT * FROM CREDIT_CONTRACT WHERE CREDIT_CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.credit_contract_id#">
</cfquery>
<cfif len(GET_CREDIT_CONTRACT.PROJECT_ID)>
	<cfquery name="GET_PROJECT_HEAD" datasource="#DSN#">
	SELECT     
		PROJECT_HEAD
	FROM
		PRO_PROJECTS
	WHERE   
		PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CREDIT_CONTRACT.PROJECT_ID#">
	</cfquery>
</cfif>	
<cfquery name="GET_MONEY_RATE" datasource="#DSN#">
	SELECT
		*
	FROM
		SETUP_MONEY
	WHERE
		PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
		MONEY_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
</cfquery>
<!--- ödemeler --->
<cfquery name="GET_PAYMENTS" datasource="#dsn3#">
	SELECT
		CR.CREDIT_CONTRACT_ROW_ID,
		CR.PROCESS_DATE,
		CR.PROCESS_TYPE,
		CR.IS_PAID,
		CR.IS_PAID_ROW,
		CR.CAPITAL_PRICE,
		CR.INTEREST_PRICE,
		CR.TAX_PRICE,
		CR.DELAY_PRICE,
		CR.TOTAL_PRICE,
		CR.OTHER_MONEY,
		CR.ACTION_ID,
		CR.PERIOD_ID,
		CR.OUR_COMPANY_ID,
		CR.DETAIL
	FROM
		CREDIT_CONTRACT_ROW CR
	WHERE
		CR.CREDIT_CONTRACT_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="1"> AND
		CR.CREDIT_CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.credit_contract_id#"> AND
		CR.IS_PAID = <cfqueryparam cfsqltype="cf_sql_smallint" value="0">
	UNION ALL
	SELECT
		CR.CREDIT_CONTRACT_ROW_ID,
		CR.PROCESS_DATE,
		CR.PROCESS_TYPE,
		CR.IS_PAID,
		CR.IS_PAID_ROW,
		CR.CAPITAL_PRICE,
		CR.INTEREST_PRICE,
		CR.TAX_PRICE,
		CR.DELAY_PRICE,
		CR.TOTAL_PRICE,
		CR.OTHER_MONEY,
		CR.ACTION_ID,
		CR.PERIOD_ID,
		CR.OUR_COMPANY_ID,
		CR.DETAIL
	FROM
		CREDIT_CONTRACT_ROW CR
	WHERE
		CR.CREDIT_CONTRACT_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="1"> AND
		CR.CREDIT_CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.credit_contract_id#"> AND
		CR.IS_PAID = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
	ORDER BY
		PROCESS_DATE
</cfquery>
<!--- tahsilatlar --->
<cfquery name="GET_REVENUE" datasource="#dsn3#">
	SELECT
		CREDIT_CONTRACT_ROW_ID,
		PROCESS_DATE,
		IS_PAID,
		IS_PAID_ROW,
		CAPITAL_PRICE,
		INTEREST_PRICE,
		TAX_PRICE,
		DELAY_PRICE,
		TOTAL_PRICE,
		OTHER_MONEY,
		ACTION_ID,
		PERIOD_ID,
		OUR_COMPANY_ID,
		DETAIL
	FROM
		CREDIT_CONTRACT_ROW
	WHERE
		CREDIT_CONTRACT_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="2"> AND
		CREDIT_CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.credit_contract_id#"> AND
		IS_PAID = <cfqueryparam cfsqltype="cf_sql_smallint" value="0">
	UNION ALL
	SELECT
		CREDIT_CONTRACT_ROW_ID,
		PROCESS_DATE,
		IS_PAID,
		IS_PAID_ROW,
		CAPITAL_PRICE,
		INTEREST_PRICE,
		TAX_PRICE,
		DELAY_PRICE,
		TOTAL_PRICE,
		OTHER_MONEY,
		ACTION_ID,
		PERIOD_ID,
		OUR_COMPANY_ID,
		DETAIL
	FROM
		CREDIT_CONTRACT_ROW
	WHERE
		CREDIT_CONTRACT_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="2"> AND
		CREDIT_CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.credit_contract_id#"> AND
		IS_PAID = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
	ORDER BY
		PROCESS_DATE
</cfquery>

<cfif len(get_credit_contract.credit_type)>
	<cfquery name="get_type" datasource="#dsn#">
		SELECT * FROM SETUP_CREDIT_TYPE WHERE CREDIT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_credit_contract.credit_type#">
	</cfquery>
	<cfset credit_type = get_type.credit_type>
<cfelse>
	<cfset credit_type = ''>
</cfif>
<cfset credit_id_list = listsort(valuelist(get_payments.credit_contract_row_id),"numeric","ASC",',')>
<cfset expense_id_list = ''>
<cfset expense_id_list_2 = ''>
<cfif len(credit_id_list)>
	<cfquery name="get_all_cost_2" datasource="#dsn2#">
		SELECT EXPENSE_ID,CREDIT_CONTRACT_ROW_ID FROM EXPENSE_ITEM_PLANS WHERE CREDIT_CONTRACT_ROW_ID IN(#credit_id_list#) AND CREDIT_CONTRACT_ROW_ID IS NOT NULL
	</cfquery>
	<cfset expense_id_list_2 = listsort(valuelist(get_all_cost_2.credit_contract_row_id),"numeric","ASC",',')>
</cfif>
<cfoutput>
<cf_catalystHeader>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box>
            <cfform name="upd_credit_contract" method="post" action="">
                <input type="hidden" name="credit_contract_id" id="credit_contract_id" value="<cfoutput>#url.credit_contract_id#</cfoutput>">
                <div class="row">
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-survey_head">
                                <label class="col col-3 col-xs-12 bold"><cf_get_lang dictionary_id='61806.İşlem Tipi'></label>
                                <div class="col col-9 col-xs-12">
                                : <cfquery name="GET_PROCESS_TYPE" datasource="#dsn3#">
                                SELECT PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_credit_contract.process_cat#">
                                </cfquery>#GET_PROCESS_TYPE.PROCESS_CAT#
                                </div>
                        </div>
                        <div class="form-group" id="item-survey_head">
                                <label class="col col-3 col-xs-12 bold"><cf_get_lang dictionary_id='57742.Tarih'></label>
                                <div class="col col-9 col-xs-12">
                                : #dateformat(get_credit_contract.credit_date,dateformat_style)#
                                </div>
                        </div>
                        <div class="form-group" id="item-survey_head">
                                <label class="col col-3 col-xs-12 bold"><cf_get_lang dictionary_id='43280.Kredi No'></label>
                                <div class="col col-9 col-xs-12">
                                : #get_credit_contract.credit_no#
                                </div>
                        </div>
                        <div class="form-group" id="item-survey_head">
                                <label class="col col-3 col-xs-12 bold"><cf_get_lang dictionary_id='30044.Sözleşme No'></label>
                                <div class="col col-9 col-xs-12">
                                : #get_credit_contract.AGREEMENT_NO#
                                </div>
                        </div>
                        <div class="form-group" id="item-survey_head">
                                <label class="col col-3 col-xs-12 bold"><cf_get_lang dictionary_id='36199.Açıklama'></label>
                                <div class="col col-9 col-xs-12">
                                : #get_credit_contract.detail#
                                </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-survey_head">
                                <label class="col col-3 col-xs-12 bold"><cf_get_lang dictionary_id='51334.Kredi Kurumu'></label>
                                <div class="col col-9 col-xs-12">
                                : #get_par_info(get_credit_contract.company_id,1,1,0)#
                                </div>
                        </div>
                        <div class="form-group" id="item-survey_head">
                                <label class="col col-3 col-xs-12 bold"><cf_get_lang dictionary_id='34283.Kredi Türü'></label>
                                <div class="col col-9 col-xs-12">
                                : #credit_type#
                                </div>
                        </div>
                        <div class="form-group" id="item-survey_head">
                                <label class="col col-3 col-xs-12 bold"><cf_get_lang dictionary_id='58784.Referans'></label>
                                <div class="col col-9 col-xs-12">
                                : #get_credit_contract.reference#
                                </div>
                        </div>
                        <div class="form-group" id="item-survey_head">
                                <label class="col col-3 col-xs-12 bold"><cf_get_lang dictionary_id='57416.Proje'></label>
                                <div class="col col-9 col-xs-12">
                                : <cfif len(GET_CREDIT_CONTRACT.PROJECT_ID)>#GET_PROJECT_HEAD.PROJECT_HEAD#</cfif>
                                </div>
                        </div>
                    </div>
                </div>
                <cf_box_footer>
                    <cf_record_info query_name='get_credit_contract'>
                </cf_box_footer>
            </cfform>
        </cf_box> 
        </cfoutput>
        <cf_box title="#getLang('','Ödemeler',58658)#" uidrop="1" hide_table_column="1">
                <cfset money_list_1 = ''>
                <cfset money_list_2 = ''>
                <cfset money_list_5 = ''>
                <cfset payment_gerceklesen_top = 0>
                <cfset payment_sozlesme_top = 0>
                <cfset revenue_gerceklesen_top = 0>
                <cfset revenue_sozlesme_top = 0>
                <cfset delay_top = 0>
                <cfset delay_top_ = 0>
                <cfset money_type_ = ''>
                <cfset money_ = ''>
                <cfset money_rate2 = 1>
                <cfset money_rate2_ = 1>
                <!---Ödemeler--->
                <cf_grid_list>
                    <table class="ui-table-list" id="paymentsArea">
                        <thead>
                            <tr>
                                <th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
                                <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                                <th><cf_get_lang dictionary_id='57630.Tip'></th>
                                <th><cf_get_lang dictionary_id='36199.Açıklama'></th> 
                                <th><cf_get_lang dictionary_id='59179.Ana Para'></th>
                                <th><cf_get_lang dictionary_id='59180.Faiz'></th>
                                <th><cf_get_lang dictionary_id='62368.Vergi Masraf'></th>
                                <th><cf_get_lang dictionary_id='39657.Gecikme'></th>
                                <th><cf_get_lang dictionary_id='57492.Toplam'></th>
                                <th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
                                <th width="20"><a href="javascript:void(0)"><i class="fa fa-pencil"></i></a></th>
                                <th width="20"><a href="javascript:void(0)"><i class="fa fa-plus"></i></a></th>
                            </tr>
                        </thead>
                        <tbody>
                        <cfif GET_PAYMENTS.recordcount>
                            <cfoutput query="GET_PAYMENTS">
                                <cfquery name="get_money" datasource="#dsn3#">
                                    SELECT * FROM CREDIT_CONTRACT_MONEY WHERE MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_payments.other_money#"> AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.credit_contract_id#">
                                </cfquery>
                                <!--- 20130212 kredi sozlesmelerinde CREDIT_CONTRACT_PAYMENT_INCOME tablosundan, leasing'lerde ise EXPENSE_ITEM_PLANS tablosundan veriler alinir  --->
                                <cfif len(get_payments.action_id)and get_credit_contract.process_type neq 296>
                                    <cfquery name="GET_PERIOD" datasource="#DSN#">
                                        SELECT
                                            PERIOD_YEAR,
                                            OUR_COMPANY_ID
                                        FROM
                                            SETUP_PERIOD
                                        WHERE
                                            PERIOD_ID = #get_payments.period_id# AND
                                            OUR_COMPANY_ID = #get_payments.our_company_id#
                                    </cfquery>
                                    <cfset temp_dsn = '#dsn#_#get_period.period_year#_#get_period.our_company_id#'>
                                    <cfquery name="get_payment_income" datasource="#temp_dsn#">
                                        SELECT 
                                            ISNULL(OTHER_TOTAL_PRICE,0) OTHER_TOTAL_PRICE,
                                            OTHER_MONEY,
                                            CAPITAL_PRICE,
                                            INTEREST_PRICE,
                                            TAX_PRICE,
                                            DELAY_PRICE,
                                            ACTION_CURRENCY_ID,
                                            DETAIL
                                        FROM
                                            CREDIT_CONTRACT_PAYMENT_INCOME
                                        WHERE
                                            CREDIT_CONTRACT_PAYMENT_ID = #get_payments.action_id#
                                    </cfquery>
                                    <cfquery name="get_income_money_" datasource="#temp_dsn#">
                                        SELECT * FROM CREDIT_CONTRACT_PAYMENT_INCOME_MONEY WHERE ACTION_ID = #action_id# AND MONEY_TYPE = '#get_payment_income.OTHER_MONEY#'
                                    </cfquery>
                                    <cfquery name="get_income_money_2" datasource="#temp_dsn#">
                                        SELECT * FROM CREDIT_CONTRACT_PAYMENT_INCOME_MONEY WHERE ACTION_ID = #action_id# AND MONEY_TYPE = '#get_payment_income.ACTION_CURRENCY_ID#'
                                    </cfquery>
                                <cfelseif len(get_payments.action_id)>
                                    <cfquery name="GET_PERIOD" datasource="#DSN#">
                                        SELECT
                                            PERIOD_YEAR,
                                            OUR_COMPANY_ID
                                        FROM
                                            SETUP_PERIOD
                                        WHERE
                                            PERIOD_ID = #get_payments.period_id# AND
                                            OUR_COMPANY_ID = #get_payments.our_company_id#
                                    </cfquery>
                                    <cfset temp_dsn = '#dsn#_#get_period.period_year#_#get_period.our_company_id#'>
                                    <cfquery name="get_expense_" datasource="#temp_dsn#">
                                        SELECT 
                                            EXPENSE_ID
                                        FROM
                                            EXPENSE_ITEM_PLANS
                                        WHERE
                                            EXPENSE_ID = #get_payments.action_id#
                                    </cfquery>
                                    <cfif get_expense_.recordcount>
                                        <cfquery name="get_payment_income" datasource="#temp_dsn#">
                                            SELECT
                                                SUM(OTHER_TOTAL_PRICE) OTHER_TOTAL_PRICE,
                                                SUM(CAPITAL_PRICE) CAPITAL_PRICE,
                                                SUM(INTEREST_PRICE) INTEREST_PRICE,
                                                SUM(TAX_PRICE) TAX_PRICE,
                                                SUM(DELAY_PRICE) DELAY_PRICE,
                                                ACTION_CURRENCY_ID,
                                                OTHER_MONEY,
                                                DETAIL
                                            FROM
                                            (
                                                SELECT 
                                                    ISNULL(OTHER_MONEY_GROSS_TOTAL,0) OTHER_TOTAL_PRICE,
                                                    MONEY_CURRENCY_ID ACTION_CURRENCY_ID,
                                                    OTHER_MONEY_GROSS_TOTAL/(1+(CAST(KDV_RATE AS FLOAT)/100)) CAPITAL_PRICE,
                                                    0 INTEREST_PRICE,
                                                    0 TAX_PRICE,
                                                    0 DELAY_PRICE,
                                                    MONEY_CURRENCY_ID OTHER_MONEY,
                                                    (SELECT CAST(DETAIL AS NVARCHAR) FROM EXPENSE_ITEM_PLANS WHERE EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID) DETAIL
                                                FROM
                                                    EXPENSE_ITEMS_ROWS
                                                WHERE
                                                    EXPENSE_ID = #get_expense_.expense_id#
                                                    AND IS_INTEREST = 0
                                                UNION ALL
                                                SELECT 
                                                    ISNULL(OTHER_MONEY_GROSS_TOTAL,0) OTHER_TOTAL_PRICE,
                                                    MONEY_CURRENCY_ID ACTION_CURRENCY_ID,
                                                    0 CAPITAL_PRICE,
                                                    OTHER_MONEY_GROSS_TOTAL/(1+(CAST(KDV_RATE AS FLOAT)/100)) INTEREST_PRICE,
                                                    0 TAX_PRICE,
                                                    0 DELAY_PRICE,
                                                    MONEY_CURRENCY_ID OTHER_MONEY,
                                                    (SELECT CAST(DETAIL AS NVARCHAR) FROM EXPENSE_ITEM_PLANS WHERE EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID) DETAIL
                                                FROM
                                                    EXPENSE_ITEMS_ROWS
                                                WHERE
                                                    EXPENSE_ID = #get_expense_.expense_id#
                                                    AND IS_INTEREST = 1
                                            )T1
                                            GROUP BY
                                                ACTION_CURRENCY_ID,
                                                OTHER_MONEY,
                                                DETAIL
                                        </cfquery>
                                        <cfquery name="get_total_kdv" datasource="#temp_dsn#">
                                            SELECT OTHER_MONEY_KDV FROM EXPENSE_ITEM_PLANS WHERE EXPENSE_ID = #get_expense_.expense_id#
                                        </cfquery>
                                        <cfset get_payment_income.TAX_PRICE = get_total_kdv.OTHER_MONEY_KDV>
                                        <cfquery name="get_income_money_" datasource="#temp_dsn#">
                                            SELECT * FROM EXPENSE_ITEM_PLANS_MONEY WHERE ACTION_ID = #action_id# AND MONEY_TYPE = '#get_payment_income.OTHER_MONEY#'
                                        </cfquery>
                                        <cfquery name="get_income_money_2" datasource="#temp_dsn#">
                                            SELECT * FROM EXPENSE_ITEM_PLANS_MONEY WHERE ACTION_ID = #action_id# AND MONEY_TYPE = '#get_payment_income.ACTION_CURRENCY_ID#'
                                        </cfquery>
                                    <cfelse>
                                        <cfset get_payment_income.recordcount = 0>
                                    </cfif>
                                </cfif>
                                <cfif IS_PAID eq 0>
                                    <cfset sozlesme_bakiye = TOTAL_PRICE>
                                    <cfset money_ = OTHER_MONEY>
                                <cfelse>
                                    <cfif len(get_payments.action_id) and get_payment_income.recordcount neq 0>
                                        <cfif len(get_payment_income.OTHER_TOTAL_PRICE)><cfset gerceklesen_bakiye = get_payment_income.OTHER_TOTAL_PRICE * get_income_money_.rate2><cfelse><cfset gerceklesen_bakiye = 0></cfif>
                                        <cfset money_ = get_income_money_.MONEY_TYPE>
                                        <cfset money_rate2 = get_income_money_.rate2>
                                        <cfset rate = (get_income_money_2.rate2/get_income_money_2.rate1)>
                                        <cfset rate_2 = (get_income_money_.rate1/get_income_money_.rate2)>
                                        <!--- <cfset gerceklesen_capital_price = wrk_round((get_payment_income.CAPITAL_PRICE * rate) * rate_2,4)>
                                        <cfset gerceklesen_interest_price = wrk_round((get_payment_income.INTEREST_PRICE * rate) * rate_2,4)>
                                        <cfset gerceklesen_tax_price = wrk_round((get_payment_income.TAX_PRICE * rate) * rate_2,4)>
                                        <cfset gerceklesen_delay_price = wrk_round((get_payment_income.DELAY_PRICE * rate) * rate_2,4)> --->
                                        <cfset gerceklesen_capital_price = wrk_round(get_payment_income.CAPITAL_PRICE)>
                                        <cfset gerceklesen_interest_price = wrk_round(get_payment_income.INTEREST_PRICE)>
                                        <cfset gerceklesen_tax_price = wrk_round(get_payment_income.TAX_PRICE * rate)>
                                        <cfset gerceklesen_delay_price = wrk_round(get_payment_income.DELAY_PRICE * rate)>
                                        <cfset row_detail = get_payment_income.detail>
                                    <cfelse>
                                        <cfset gerceklesen_bakiye = 0>
                                        <cfset money_ = ''>
                                        <cfset money_rate2 = 1>
                                        <cfset rate = 1>
                                        <cfset rate_2 = 1>
                                        <cfset gerceklesen_capital_price = 0>
                                        <cfset gerceklesen_interest_price = 0>
                                        <cfset gerceklesen_tax_price = 0>
                                        <cfset gerceklesen_delay_price = 0>
                                        <cfset row_detail = ''>
                                    </cfif>
                                </cfif>
                                <cfif isDefined("sozlesme_bakiye") and sozlesme_bakiye gt 0 and IS_PAID eq 0>
                                    <cfset money_list_1 = listappend(money_list_1,'#sozlesme_bakiye#*#money_#*#money_rate2#',',')>
                                </cfif>	
                                <cfif isDefined("gerceklesen_bakiye") and  gerceklesen_bakiye gt 0 and IS_PAID neq 0>
                                    <cfset money_list_2 = listappend(money_list_2,'#gerceklesen_bakiye#*#money_#*#money_rate2#',',')>
                                </cfif>
                                <cfif isDefined("gerceklesen_delay_price") and  gerceklesen_delay_price gt 0 and IS_PAID neq 0>
                                    <cfset money_list_5 = listappend(money_list_5,'#gerceklesen_delay_price#*#money_#*#money_rate2#',',')>
                                </cfif>
                                    <tr>
                                    <td width="20" class="header_icn_text">#currentrow#</td>
                                    <td>#dateformat(PROCESS_DATE,dateformat_style)#</td>
                                    <td><cfif IS_PAID eq 0><cf_get_lang dictionary_id='29522.Sözleşme'><cfelse><cf_get_lang dictionary_id='31491.Gerçekleşen'></cfif></td>
                                    <td><cfif IS_PAID eq 0>#DETAIL#<cfelse>#row_detail#</cfif></td>
                                    <td style="text-align:right;"><cfif IS_PAID eq 0>#TLFormat(CAPITAL_PRICE,session.ep.our_company_info.rate_round_num)#<cfelse>#TLFormat(gerceklesen_capital_price,session.ep.our_company_info.rate_round_num)#</cfif></td>
                                    <td style="text-align:right;"><cfif IS_PAID eq 0>#TLFormat(INTEREST_PRICE,session.ep.our_company_info.rate_round_num)#<cfelse>#TLFormat(gerceklesen_interest_price,session.ep.our_company_info.rate_round_num)#</cfif></td>
                                    <td style="text-align:right;"><cfif IS_PAID eq 0>#TLFormat(TAX_PRICE,session.ep.our_company_info.rate_round_num)#<cfelse>#TLFormat(gerceklesen_tax_price,session.ep.our_company_info.rate_round_num)#</cfif></td>
                                    <td style="text-align:right;"><cfif IS_PAID eq 0>#TLFormat(DELAY_PRICE,session.ep.our_company_info.rate_round_num)#<cfelse>#TLFormat(gerceklesen_delay_price,session.ep.our_company_info.rate_round_num)#</cfif></td>
                                    <td style="text-align:right;"><cfif IS_PAID eq 0>#TLFormat(TOTAL_PRICE,session.ep.our_company_info.rate_round_num)#<cfelseif len(action_id) and get_payment_income.recordcount neq 0>#TLFormat(get_payment_income.other_total_price,session.ep.our_company_info.rate_round_num)#</cfif></td>
                                    <td><cfif IS_PAID eq 0>#OTHER_MONEY#<cfelseif len(action_id) and get_payment_income.recordcount neq 0>#get_payment_income.OTHER_MONEY#</cfif></td>
                                    <td style="text-align:center;"><!-- sil --><cfif IS_PAID eq 1 and process_type neq 120 and process_type neq 59><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=credit.list_credit_contract&event=updPayment&credit_contract_row_id=#ACTION_ID#&period_id=#PERIOD_ID#&our_company_id=#OUR_COMPANY_ID#&credit_contract_id=#attributes.credit_contract_id#&project_id=#get_credit_contract.project_id#','project');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id="57464.Güncelle">"></i></a></cfif><!-- sil --></td>
                                    <cfif get_credit_contract.process_type eq 296>
                                        <cfif IS_PAID eq 0>
                                            <td style="text-align:center;">
                                                <cfif (len(expense_id_list_2) and not listfind(expense_id_list_2,credit_contract_row_id,',')) or not len(expense_id_list_2)>
                                                    <!-- sil --><a href="#request.self#?fuseaction=credit.detail_credit_contract&event=add&is_from_credit=1&credit_contract_id=#url.credit_contract_id#&credit_contract_row_id=#credit_contract_row_id#"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='51345.Gider Ekle'>"></i></a><!-- sil -->
                                                </cfif>
                                            </td>
                                        <cfelse>						
                                            <cfif process_type eq 120>
                                                <td style="text-align:center;">
                                                    <!-- sil --><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=cost.form_add_expense_cost&event=upd&is_from_credit=1&expense_id=#action_id#','wwide')"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id="19.Gider Güncelle">"></i></a><!-- sil -->
                                                </td>
                                            <cfelse>
                                                <td></td>
                                            </cfif>
                                        </cfif>
                                    <cfelse>
                                        <cfif IS_PAID eq 0 and IS_PAID_ROW neq 1>
                                            <td style="text-align:center;"><!-- sil --><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=credit.list_credit_contract&event=addPayment&credit_contract_id=#get_credit_contract.credit_contract_id#&credit_contract_row_id=#credit_contract_row_id#&project_id=#get_credit_contract.project_id#','project');"><i class="icn-md fa fa-money" alt="<cf_get_lang dictionary_id='57847.Ödeme'>" border="0" title="<cf_get_lang dictionary_id='57847.Ödeme'>"></i></a><!-- sil --></td>
                                        <cfelse>
                                            <td></td>
                                        </cfif>
                                    </cfif>
                                </tr>
                            </cfoutput>
                        <cfelse>
                            <tr>
                            <td colspan="12"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!</td>
                            </tr>
                        </cfif>
                        </tbody>
                    </table> 
                </cf_grid_list>  
                <div class="ui-info-bottom">
                    <p><b><cf_get_lang dictionary_id='29522.Sözleşme'> <cf_get_lang dictionary_id='57492.Toplam'> : </b> 
                        <cfoutput query="get_money_rate">
                            <cfset toplam_ara = 0>
                            <cfloop list="#money_list_1#" index="i">
                                <cfset tutar_ = listfirst(i,'*')>
                                <cfset money_ = listgetat(i,2,'*')>
                            <cfif money_ eq money>
                                <cfset toplam_ara = toplam_ara + tutar_>
                            </cfif>
                            </cfloop>
                            <cfif toplam_ara neq 0>
                            #TLFormat(ABS(toplam_ara),session.ep.our_company_info.rate_round_num)# #money#<br/> 
                            <cfset payment_sozlesme_top = ABS(toplam_ara)>
                            </cfif>
                        </cfoutput>  
                    </p>
                    <p><b>&nbsp;&nbsp;<cf_get_lang dictionary_id='39657.Gecikme'> <cf_get_lang dictionary_id='57492.Toplam'> :</b> 
                        <cfoutput query="get_money_rate">
                            <cfset toplam_ara = 0>
                            <cfloop list="#money_list_5#" index="i">
                                <cfset tutar_ = listfirst(i,'*')>
                                <cfset money_ = listgetat(i,2,'*')>
                            <cfif money_ eq money>
                                <cfset toplam_ara = toplam_ara + tutar_>
                            </cfif>
                            </cfloop>
                            <cfif toplam_ara neq 0>
                            #TLFormat(ABS(toplam_ara),session.ep.our_company_info.rate_round_num)# #money#<br/> 
                            <cfset delay_top = ABS(toplam_ara)>
                            </cfif>
                        </cfoutput>
                        <cfif money_list_5 eq "">-</cfif>
                    </p>
                    <p><b>&nbsp;&nbsp;<cf_get_lang dictionary_id='39725.Gerçekleşen'> <cf_get_lang dictionary_id='57492.Toplam'> :</b> 
                        <cfoutput query="get_money_rate">
                            <cfset toplam_ara = 0>
                            <cfloop list="#money_list_1#" index="i">
                                <cfset money_ = listgetat(i,2,'*')>
                            </cfloop>
                            <cfloop list="#money_list_2#" index="i">
                                <cfset tutar_ = listfirst(i,'*')>
                                <cfset money_rate = listlast(i,'*')>
                                <cfif money_ eq money>
                                    <cfset toplam_ara = toplam_ara + (tutar_/money_rate)>
                                </cfif>
                            </cfloop>
                            <cfif toplam_ara neq 0>
                                #TLFormat(ABS(toplam_ara),session.ep.our_company_info.rate_round_num)# #money#<br/>
                                <cfset payment_gerceklesen_top = ABS(toplam_ara)>
                                <cfset money_type_ = money>
                            </cfif>
                        </cfoutput>  
                    </p>
                    <p><b> &nbsp;&nbsp; <cf_get_lang dictionary_id='58583.Fark'> :</b> <cfoutput>#TLFormat(payment_sozlesme_top+delay_top-payment_gerceklesen_top,session.ep.our_company_info.rate_round_num)# #money_type_#</cfoutput></p>
                </div> 
        </cf_box>
        <cf_box title="#getLang('','Tahsilatlar',34286)#" uidrop="1" hide_table_column="1">
                <cfset money_list_3 = ''>
                <cfset money_list_4 = ''>
                <cfset money_list_6 = ''>
                <!---Tahsilatlar--->
                <cf_grid_list>
                    <table class="ui-table-list" id="collectionsArea">
                        <thead>
                            <tr>
                                <th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
                                <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                                <th><cf_get_lang dictionary_id='57630.Tip'></th>
                                <th><cf_get_lang dictionary_id='36199.Açıklama'></th>
                                <th><cf_get_lang dictionary_id='59179.Ana Para'></th>
                                <th><cf_get_lang dictionary_id='51367.Faiz'></th>
                                <th><cf_get_lang dictionary_id='62368.Vergi Masraf'></th>
                                <th><cf_get_lang dictionary_id='39657.Gecikme'></th>
                                <th><cf_get_lang dictionary_id='57492.Toplam'></th>
                                <th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
                                <th width="20"><a href="javascript:void(0)"><i class="fa fa-pencil"></i></a></th>
                                <th width="20"><a href="javascript:void(0)"><i class="fa fa-money"></i></a></th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfif GET_REVENUE.recordcount>
                                <cfoutput query="GET_REVENUE">
                                    <cfquery name="get_money" datasource="#dsn3#">
                                        SELECT * FROM CREDIT_CONTRACT_MONEY WHERE MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_revenue.other_money#"> AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.credit_contract_id#">
                                    </cfquery>
                                    <cfif len(GET_REVENUE.action_id)>
                                        <cfquery name="GET_PERIOD" datasource="#DSN#">
                                            SELECT
                                                PERIOD_YEAR,
                                                OUR_COMPANY_ID
                                            FROM
                                                SETUP_PERIOD
                                            WHERE
                                                PERIOD_ID = #period_id# AND
                                                OUR_COMPANY_ID = #our_company_id#
                                        </cfquery>
                                        <cfset temp_dsn = '#dsn#_#get_period.period_year#_#get_period.our_company_id#'>
                                        <cfquery name="get_payment_revenue" datasource="#temp_dsn#">
                                            SELECT 
                                                ISNULL(OTHER_TOTAL_PRICE,0) OTHER_TOTAL_PRICE,
                                                OTHER_MONEY,
                                                CAPITAL_PRICE,
                                                INTEREST_PRICE,
                                                TAX_PRICE,
                                                DELAY_PRICE,
                                                ACTION_CURRENCY_ID,
                                                DETAIL
                                            FROM
                                                CREDIT_CONTRACT_PAYMENT_INCOME
                                            WHERE
                                                CREDIT_CONTRACT_PAYMENT_ID = #action_id#
                                        </cfquery>
                                        <cfquery name="get_payment_money" datasource="#temp_dsn#">
                                            SELECT * FROM CREDIT_CONTRACT_PAYMENT_INCOME_MONEY WHERE ACTION_ID = #GET_REVENUE.action_id# AND MONEY_TYPE = '#get_payment_revenue.OTHER_MONEY#'
                                        </cfquery>
                                        <cfquery name="get_payment_money_2_" datasource="#temp_dsn#">
                                            SELECT * FROM CREDIT_CONTRACT_PAYMENT_INCOME_MONEY WHERE ACTION_ID = #GET_REVENUE.action_id# AND MONEY_TYPE = '#get_payment_revenue.ACTION_CURRENCY_ID#'
                                        </cfquery>
                                    </cfif>
                                    <cfif IS_PAID eq 0>
                                        <cfset sozlesme_bakiye_ = TOTAL_PRICE>
                                        <cfset money_ = OTHER_MONEY>
                                    <cfelse>
                                        <cfif len(GET_REVENUE.action_id) and get_payment_revenue.recordcount>
                                            <cfset gerceklesen_bakiye_ = get_payment_revenue.OTHER_TOTAL_PRICE * get_payment_money.rate2>
                                            <cfset money_ = get_payment_money.MONEY_TYPE>
                                            <cfset money_rate2_ = get_payment_money.rate2>
                                            <cfset rate_ = (get_payment_money_2_.rate2/get_payment_money_2_.rate1)>
                                            <cfset rate_1 = (get_payment_money.rate1/get_payment_money.rate2)>
                                            <cfset gerceklesen_capital_price_ = wrk_round((get_payment_revenue.CAPITAL_PRICE * rate_) * rate_1,4)>
                                            <cfset gerceklesen_interest_price_ = wrk_round((get_payment_revenue.INTEREST_PRICE * rate_) * rate_1,4)>
                                            <cfset gerceklesen_tax_price_ = wrk_round((get_payment_revenue.TAX_PRICE * rate_) * rate_1,4)>
                                            <cfset gerceklesen_delay_price_ = wrk_round((get_payment_revenue.DELAY_PRICE * rate_) * rate_1,4)>
                                            <cfset detail_ = get_payment_revenue.detail>
                                        <cfelse>
                                            <cfset gerceklesen_bakiye_ = 0>
                                            <cfset money_ = ''>
                                            <cfset money_rate2_ = 1>
                                            <cfset rate_ = 1>
                                            <cfset rate_1 = 1>
                                            <cfset gerceklesen_capital_price_ = 0>
                                            <cfset gerceklesen_interest_price_ = 0>
                                            <cfset gerceklesen_tax_price_ = 0>
                                            <cfset gerceklesen_delay_price_ = 0>
                                            <cfset detail_ = ''>
                                        </cfif>
                                    </cfif>
                                    <cfif isDefined("sozlesme_bakiye_") and sozlesme_bakiye_ gt 0 and IS_PAID eq 0>
                                        <cfset money_list_3 = listappend(money_list_3,'#sozlesme_bakiye_#*#money_#*#money_rate2_#',',')>
                                    </cfif>	
                                    <cfif isDefined("gerceklesen_bakiye_") and  gerceklesen_bakiye_ gt 0 and IS_PAID neq 0>
                                        <cfset money_list_4 = listappend(money_list_4,'#gerceklesen_bakiye_#*#money_#*#money_rate2_#',',')>
                                    </cfif>
                                    <cfif isDefined("gerceklesen_delay_price_") and  gerceklesen_delay_price_ gt 0 and IS_PAID neq 0>
                                        <cfset money_list_6 = listappend(money_list_6,'#gerceklesen_delay_price_#*#money_#*#money_rate2_#',',')>
                                    </cfif>
                                    <tr>
                                        <td width="20"mclass="header_icn_text">#currentrow#</td>
                                        <td>#dateformat(PROCESS_DATE,dateformat_style)#</td>
                                        <td><cfif IS_PAID eq 0><cf_get_lang dictionary_id='29522.Sözleşme'><cfelse><cf_get_lang dictionary_id='31491.Gerçekleşen'></cfif></td>
                                        <td><cfif IS_PAID eq 0>#DETAIL#<cfelse>#detail_#</cfif></td>
                                        <td style="text-align:right;"><cfif IS_PAID eq 0>#TLFormat(CAPITAL_PRICE,session.ep.our_company_info.rate_round_num)#<cfelse>#TLFormat(gerceklesen_capital_price_,session.ep.our_company_info.rate_round_num)#</cfif></td>
                                        <td style="text-align:right;"><cfif IS_PAID eq 0>#TLFormat(INTEREST_PRICE,session.ep.our_company_info.rate_round_num)#<cfelse>#TLFormat(gerceklesen_interest_price_,session.ep.our_company_info.rate_round_num)#</cfif></td>
                                        <td style="text-align:right;"><cfif IS_PAID eq 0>#TLFormat(TAX_PRICE,session.ep.our_company_info.rate_round_num)#<cfelse>#TLFormat(gerceklesen_tax_price_,session.ep.our_company_info.rate_round_num)#</cfif></td>
                                        <td style="text-align:right;"><cfif IS_PAID eq 0>#TLFormat(DELAY_PRICE,session.ep.our_company_info.rate_round_num)#<cfelse>#TLFormat(gerceklesen_delay_price_,session.ep.our_company_info.rate_round_num)#</cfif></td>
                                        <td style="text-align:right;"><cfif IS_PAID eq 0>#TLFormat(TOTAL_PRICE,session.ep.our_company_info.rate_round_num)#<cfelseif len(action_id)>#TLFormat(get_payment_revenue.other_total_price,session.ep.our_company_info.rate_round_num)#</cfif></td>
                                        <td><cfif IS_PAID eq 0>#OTHER_MONEY#<cfelseif len(action_id)>#get_payment_revenue.OTHER_MONEY#</cfif></td>
                                        <td width="20" style="text-align:center;"><!-- sil --><cfif IS_PAID eq 1><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=credit.list_credit_contract&event=updRevenue&credit_contract_row_id=#ACTION_ID#&period_id=#PERIOD_ID#&our_company_id=#OUR_COMPANY_ID#&credit_contract_id=#attributes.credit_contract_id#&project_id=#get_credit_contract.project_id#','project');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id="19.Gider Güncelle">"></i></a></cfif><!-- sil --></td>
                                        <cfif IS_PAID eq 0 and IS_PAID_ROW neq 1>
                                            <td width="20" style="text-align:center;"><!-- sil --><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=credit.list_credit_contract&event=addRevenue&credit_contract_id=#get_credit_contract.credit_contract_id#&credit_contract_row_id=#credit_contract_row_id#&project_id=#get_credit_contract.project_id#','project');"><i class="fa fa-money" alt="<cf_get_lang dictionary_id='57845.Tahsilat'>" title="<cf_get_lang dictionary_id='57845.Tahsilat'>"></a><!-- sil --></td>
                                        <cfelse>
                                            <td></td>
                                        </cfif>
                                    </tr>
                                </cfoutput>
                            <cfelse>
                            <!-- sil -->
                                <tr>
                                <td colspan="12"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!</td>
                                </tr>
                            <!-- sil -->
                            </cfif>
                        </tbody>
                    </table>
                </cf_grid_list>
                <div class="ui-info-bottom">
                    <p><b><cf_get_lang dictionary_id='29522.Sözleşme'> <cf_get_lang dictionary_id='57492.Toplam'> :</b> 
                        <cfoutput query="get_money_rate">
                            <cfset toplam_ara = 0>
                            <cfloop list="#money_list_3#" index="i">
                                <cfset tutar_ = listfirst(i,'*')>
                                <cfset money_ = listgetat(i,2,'*')>
                                <cfif money_ eq money>
                                    <cfset toplam_ara = toplam_ara + tutar_>
                                </cfif>
                            </cfloop>
                            <cfif toplam_ara neq 0>
                                #TLFormat(ABS(toplam_ara),session.ep.our_company_info.rate_round_num)# #money#<br/>  
                                <cfset revenue_sozlesme_top = ABS(toplam_ara)>
                            </cfif>
                        </cfoutput>
                        <cfif money_list_3 eq "">-</cfif>
                    </p>
                    <p><b>&nbsp;&nbsp;<cf_get_lang dictionary_id='39657.Gecikme'> <cf_get_lang dictionary_id='57492.Toplam'> :</b> 
                        <cfoutput query="get_money_rate">
                            <cfset toplam_ara = 0>
                            <cfloop list="#money_list_6#" index="i">
                                <cfset tutar_ = listfirst(i,'*')>
                                <cfset money_ = listgetat(i,2,'*')>
                            <cfif money_ eq money>
                                <cfset toplam_ara = toplam_ara + tutar_>
                            </cfif>
                            </cfloop>
                            <cfif toplam_ara neq 0>
                            #TLFormat(ABS(toplam_ara),session.ep.our_company_info.rate_round_num)# #money#<br/> 
                            <cfset delay_top_ = ABS(toplam_ara)>
                            </cfif>
                        </cfoutput>
                        <cfif money_list_6 eq "">-</cfif>
                    </p>
                    <p><b>&nbsp;&nbsp;<cf_get_lang dictionary_id='39725.Gerçekleşen'> <cf_get_lang dictionary_id='57492.Toplam'> :</b> 
                        <cfoutput query="get_money_rate">
                            <cfset toplam_ara = 0>
                            <cfloop list="#money_list_3#" index="i">
                                <cfset money_ = listgetat(i,2,'*')>
                            </cfloop>
                            <cfloop list="#money_list_4#" index="i">
                                <cfset tutar_ = listfirst(i,'*')>
                                <cfset money_rate_ = listlast(i,'*')>
                                <cfif money_ eq money>
                                    <cfset toplam_ara = toplam_ara + (tutar_/money_rate_)>
                                </cfif>
                            </cfloop>
                            <cfif toplam_ara neq 0>
                                #TLFormat(ABS(toplam_ara),session.ep.our_company_info.rate_round_num)# #money#<br/> 
                                <cfset revenue_gerceklesen_top = ABS(toplam_ara)>
                                <cfset money_type_ = money>
                            </cfif>
                        </cfoutput>  
                        <cfif money_list_4 eq "">-</cfif>
                    </p>
                    <p><b>&nbsp;&nbsp;<cf_get_lang dictionary_id='58583.Fark'> :</b><cfoutput>#TLFormat(revenue_sozlesme_top+delay_top_-revenue_gerceklesen_top,session.ep.our_company_info.rate_round_num)# #money_type_#</cfoutput></p>
                </div> 
        </cf_box>
    </div>


